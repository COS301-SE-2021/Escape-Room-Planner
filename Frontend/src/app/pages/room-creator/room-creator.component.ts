import {AfterViewInit, Component, ElementRef, OnInit, Renderer2, ViewChild} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {HttpHeaders} from "@angular/common/http";
import {VertexService} from "../../services/vertex.service";
import {Router} from "@angular/router";
// Leader Line JS library imports
import 'leader-line';
import {InventoryComponent} from "../inventory/inventory.component";
import {SolvabilityComponent} from "../solvability/solvability.component"
declare let LeaderLine: any;

@Component({
  selector: 'app-room-creator',
  templateUrl: './room-creator.component.html',
  styleUrls: ['./room-creator.component.css'],
})
export class RoomCreatorComponent implements OnInit, AfterViewInit {
  public lastPos : number = 0; // used to populate new objects in line
  // @ts-ignore
  public escapeRooms: EscapeRoomArray; // array of escape rooms used to populate drop down
  public currentRoomId: number = 0; // used to check currently selected room
  public newEscapeRoomName:string = ""; // used when submitting a new room creation
  public newEscapeRoomNameValid:boolean = false; // flag using regex
  public _target_vertex_z_index:number = 0; // stores a z-index of _target_vertex
  public vertex_type:string = "Object";
  public vertex_name_menu:string = "";
  public vertex_min_menu:number = 0;
  public vertex_sec_menu:number = 0;
  public vertex_clue_menu:string = "";
  public vertex_description_menu:string = "";
  public hasRooms:boolean = true;
  public hideClue:boolean = true;
  public hidePuzzle:boolean = true;

  private _room_count:number = 0;
  private _target_vertex: any;
  private _target_start: any;
  private _target_end: any;
  private _is_single_click: Boolean = true;
  private isConnection = false;
  private is_disconnect = false;
  private lines:any = []; // to store lines for update and deletion
  private headers: HttpHeaders = new HttpHeaders();

  @ViewChild("escapeRoomDiv") escapeRoomDivRef : ElementRef | undefined; // escape room canvas div block
  @ViewChild("EscapeRoomList") escapeRoomListRef : ElementRef | undefined; // escape room list element reference
  @ViewChild("alertElementError") alertElementErrorRef : ElementRef | undefined;
  @ViewChild("contextMenu") contextMenuRef : ElementRef | undefined;
  @ViewChild("attributeMenu") attributeMenuRef : ElementRef | undefined;
  @ViewChild(SolvabilityComponent) solveComponent: SolvabilityComponent | undefined;

  constructor(private el : ElementRef, private renderer: Renderer2, private httpClient: HttpClient,
              private vertexService: VertexService, private router:Router)
  {

    if(localStorage.getItem('token') ==  null) {
      this.router.navigate(['login']).then(r => console.log('no jwt stored'));
    }
      this.headers = this.headers.set('Authorization1', 'Bearer ' + localStorage.getItem('token'))
        .set("Authorization2",'Basic ' + localStorage.getItem('username'));
  }


  ngOnInit(): void {
    //set the currentRoomId to 1 by default, later to actual first room id?
    this.currentRoomId = -1;
    this.getEscapeRooms();
  }

  ngAfterViewInit(){
    //use for testing new functionality
    this.solveComponent?.setRoom(this.currentRoomId);
    this.solveComponent?.getInitialVertices();
  }



  // todo
  //updates all lines connected to this vertex
  updateLine(vertex_index: number):void{
    let update_lines = this.vertexService.getLineIndex(vertex_index);

    for (let line_index of update_lines){
      if(this.lines[line_index] !== null) this.lines[line_index].position();
    }
  }

  //all flags set to false
  resetFlag(): void{
    this.isConnection = false;
    this.is_disconnect = false;
  }

  // used to connect two vertices
  connectVertex(): void{
    this.resetFlag();
    this.isConnection = true;
  }

  // used to state in disconnect state
  disconnectVertex(): void{
    this.resetFlag();
    this.is_disconnect = true;
  }

  // todo
  // adds an object to drag on our 'canvas'
  addObjects(event:any): void{
    this.lastPos += event.pos;
    //MAKE API CALL BASED ON TYPE
    let name : string = "Object";       //default name
    let description : string = "Works";  //default description
    this.createVertex(event.type, name, event.loc, 0, this.lastPos, 75, 75, new Date(), description, this.currentRoomId, 'some clue', event.src, event.blob_id);
    //spawns object on plane
  }

  // todo
  //use get to get all the rooms stored in db
  getEscapeRooms(): void{
    //http request to rails api
    this.httpClient.get<EscapeRoomArray>("http://127.0.0.1:3000/api/v1/room/", {"headers": this.headers}).subscribe(
      response => {
          //rendering <li> elements by using response
          this.escapeRooms = response;
          //render all the rooms
          if(response.data[0] !== undefined) {
            this.currentRoomId = response.data[0].id;
            this.getVertexFromRoom();
          }else{
            this.currentRoomId = -1;
            this._room_count = 0;
            this.hasRooms = false;
          }
          for (let er of response.data){
            this.renderNewRoom(er.id, er.name);
            this._room_count++;
          }
      },
        //Render error if bad request
        error => {
          if (error.status === 401){
            if (this.router.routerState.snapshot.url !== '/login' &&
              this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect 1'));
          }else{
            this.renderAlertError('There was an error retrieving your rooms');
          }
        }
    );
  }

  // todo
  deleteRoom(event: any): void{
    //confirmation box on deleting room
    let confirmation = confirm("Are you sure you want to delete this room?");
    let room_id = event.target.getAttribute("escape-room-id");
    if(confirmation){
      this.httpClient.delete<any>("http://127.0.0.1:3000/api/v1/room/"+room_id,
        {"headers": this.headers}).subscribe(
        response => {
          //remove Room From screen here
          if(response.status == "SUCCESS"){
            //checks if no more rooms
            this._room_count--;
            if(this._room_count === 0)
              this.hasRooms = false;
            document.querySelectorAll('[room-id="'+room_id+'"]')[0].remove();
          }else
            this.renderAlertError("Unable To Delete Room");
        },
        error => {
          if (error.status === 401){
            if (this.router.routerState.snapshot.url !== '/login' &&
              this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
          }else{
            this.renderAlertError("Unable To Delete Room");
          }
        }
        //console.error('There was an error while updating the vertex', error)
      );
    }
  }

  // todo
  changeRoom(event: any): void{
    let clickedEscapeRoom = event.target;
    //check if the selected room is not the one shown
    if(clickedEscapeRoom.getAttribute("escape-room-id") === this.currentRoomId )
      return; // do not reload the vertices again

    // update room id
    this.currentRoomId = clickedEscapeRoom.getAttribute('escape-room-id');
    // @ts-ignore
    this.escapeRoomDivRef?.nativeElement.textContent = ""; // textContent is faster that innerHTML since doesn't invoke browser HTML parser
    //load the vertices for the newly selected room
    this.getVertexFromRoom();
    this.solveComponent?.getInitialVertices();
  }

  // todo
  //Get to get all vertex for room
  getVertexFromRoom(): void{
    if(this.currentRoomId !== -1) {
      // resets the vertices on room switch
      this.vertexService.reset_array();
      // resets the lines array
      for (let line of this.lines) {
        if (line !== null)
          line.remove();
      }
      this.lines = [];

      //http request to rails api
      this.httpClient.get<any>("http://127.0.0.1:3000/api/v1/vertex/" + this.currentRoomId, {"headers": this.headers}).subscribe(
        response => {
          //render all the vertices
          for (let vertex_t of response.data) {
            //spawn objects out;
            let vertex = vertex_t.vertex
            let vertex_type = vertex_t.type;
            let vertex_connections = vertex_t.connections;

            let current_id = this.vertexService.addVertex(vertex.id, vertex_type, vertex.name, vertex.graphicid,
              vertex.posy, vertex.posx, vertex.width, vertex.height, vertex.estimatedTime,
              vertex.description, vertex.clue, vertex.z_index);

            // @ts-ignore
            for (let vertex_connection of vertex_connections)
              this.vertexService.addVertexConnection(current_id, vertex_connection);

            this.spawnObjects(current_id);
          }

          // TODO consider using some other method to locate these, cause triple for loop is not pog
          // converts real connection to local connection
          for (let vertex of this.vertexService.vertices) {
            let vertex_connections = vertex.getConnections();

            for (let vertex_connection of vertex_connections) {
              // go through all the connections
              // for each location locate the vertex with that real id and use its local id in place of real one

              for (let vertex_to of this.vertexService.vertices) {

                if (vertex_to.id === vertex_connection) {
                  this.vertexService.removeVertexConnection(vertex.local_id, vertex_connection);

                  let from_vertex = document.querySelectorAll('[vertex-id="' + vertex.local_id + '"]')[0];
                  let to_vertex = document.querySelectorAll('[vertex-id="' + vertex_to.local_id + '"]')[0];

                  this.renderLines(vertex.local_id, from_vertex, vertex_to.local_id, to_vertex);
                  break; // so that not the whole array is traversed
                }
              }
            }
          }
        },
        //Error retrieving vertices message
        error => {
          if (error.status === 401) {
            if (this.router.routerState.snapshot.url !== '/login' &&
              this.router.routerState.snapshot.url !== '/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
          } else {
            this.renderAlertError("There was an error retrieving vertices for the room");
          }
        }
      );
    }
  }

  // todo
  // POST to create new room for a user
  createEscapeRoom(): void{
    // regex to extract valid strings, removes all the spaces and allows any character
    let patternRegEx: RegExp = new RegExp("([\\w\\d!@#$%^&\\*\\(\\)_\\+\\-=;'\"?>/\\\\|<,\\[\\].:{}`~]+( )?)+",'g');
    let regexResult = patternRegEx.exec(this.newEscapeRoomName);

    if (regexResult === null) {
      alert("cant send empty string");
      // needs to have a name
    }else {
      let createRoomBody = {name: regexResult[0]};
      //http request to rails api
      this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/room/", createRoomBody, {"headers": this.headers}).subscribe(
        response => {
          //rendering <li> elements by using render function
          this.renderNewRoom(response.data.id, response.data.name);
          this.hasRooms = true;
          this.vertexService.reset_array();
          // @ts-ignore
          this.escapeRoomDivRef?.nativeElement.textContent = "";
          this._room_count++;
          this.currentRoomId = response.data.id;
        },
        error => {
          if (error.status === 401){
            if (this.router.routerState.snapshot.url !== '/login' &&
              this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
          }else {
            console.error('There was an error creating your rooms', error);
          }
        }
      );
    }

    this.newEscapeRoomNameValid = false;
    this.newEscapeRoomName = ""; // resets the input box text
  }

  // todo
  isNewEscapeRoomNameValid():void{
    let patternRegEx: RegExp = new RegExp("([\\w\\d!@#$%^&\\*\\(\\)_\\+\\-=;'\"?>/\\\\|<,\\[\\].:{}`~]+( )?)+",'g');
    let regexResult = patternRegEx.exec(this.newEscapeRoomName);

    this.newEscapeRoomNameValid = regexResult !== null;
  }

  // todo
  //just renders new room text in the list
  renderNewRoom(id:number, name:string): void{
    // <li><div><div> class="dropdown-item">ROOM 1</div><div><button></button><img></div></div></li>-->
    let newRoom = this.renderer.createElement('li');
    let newDivRow = this.renderer.createElement('div');
    let newDivCol1 = this.renderer.createElement('div');
    let newDivCol2 = this.renderer.createElement('div');
    let newButton = this.renderer.createElement('button');
    let newImage = this.renderer.createElement('img');

    //add src to <img>
    this.renderer.setAttribute(newImage, 'src', './assets/svg/trash-fill.svg');
    this.renderer.setAttribute(newImage,'escape-room-id',id.toString());

    //add boostrap class to <button>
    this.renderer.addClass(newButton, 'btn');
    this.renderer.addClass(newButton, 'btn-dark');
    this.renderer.appendChild(newButton, newImage);
    this.renderer.listen(newButton,'click',(event) => this.deleteRoom(event))

    //add bootstrap class to <div col2>
    this.renderer.addClass(newDivCol2, 'col-1');
    this.renderer.addClass(newDivCol2, 'text-end');
    this.renderer.appendChild(newDivCol2, newButton);

    //add bootstrap class to <div col1>
    this.renderer.addClass(newDivCol1, 'col-11');
    this.renderer.addClass(newDivCol1, 'text-white');
    this.renderer.appendChild(newDivCol1, this.renderer.createText(name));
    this.renderer.setAttribute(newDivCol1,'escape-room-id',id.toString());
    this.renderer.listen(newDivCol1,'click',(event) => this.changeRoom(event))

    // add bootstrap class to <div row>
    this.renderer.addClass(newDivRow, 'row');
    this.renderer.addClass(newDivRow,'dropdown-item');
    this.renderer.addClass(newDivRow, 'd-flex');
    this.renderer.appendChild(newDivRow, newDivCol1);
    this.renderer.appendChild(newDivRow, newDivCol2);

    // make it <li><a>
    this.renderer.appendChild(newRoom,newDivRow);
    this.renderer.setAttribute(newRoom,'room-id',id.toString());
    // append to the dropdown menu
    this.renderer.appendChild(this.escapeRoomListRef?.nativeElement, newRoom);
  }

  // todo
  //creates Vertex of type with scale at position x,y
  createVertex(inType: string, inName: string, inGraphicID: string, inPos_y: number,
               inPos_x: number, inWidth: number, inHeight: number, inEstimated_time: Date,
               inDescription: string, inRoom_id: number, inClue: string, src:string, blob_id: number): void
  {
    let createVertexBody = {type: inType,
      name: inName,
      graphicid: inGraphicID,
      posy: inPos_y,
      posx: inPos_x,
      width: inWidth,
      height: inHeight,
      estimated_time: inEstimated_time,
      description: inDescription,
      roomid: inRoom_id,
      clue: inClue,
      blob_id: blob_id
    };

    if(inType != "Puzzle"){
      // @ts-ignore
      delete  createVertexBody.description;
      // @ts-ignore
      delete  createVertexBody.estimated_time;
    }
    // removes parameters for clue
    if (inType != 'Clue'){
      // @ts-ignore
      delete createVertexBody.clue;
    }

    //make post request for new vertex
    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/vertex/", createVertexBody, {"headers": this.headers}).subscribe(
      response => {
        //get the latest local id for a vertex
        let current_id;

        if (src){
          current_id = this.vertexService.addVertex(response.data.id,
            inType, inName, src, inPos_y, inPos_x, inWidth, inHeight,
            inEstimated_time, inDescription, inClue, 5
          );
        }else {
          current_id = this.vertexService.addVertex(response.data.id,
            inType, inName, inGraphicID, inPos_y, inPos_x, inWidth, inHeight,
            inEstimated_time, inDescription, inClue, 5
          );
        }

        this.spawnObjects(current_id);
      },
      error => {
        if (error.status === 401){
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        }else {
          console.error('There was an error while creating a vertex', error);
          this.renderAlertError("Couldn't create a vertex");
        }
      }
    );
  }

  // todo
  //used to spawn objects onto plane
  spawnObjects(local_id: number): void{
    let newObject = this.renderer.createElement("img"); // create image
    this.renderer.addClass(newObject, "resize-drag");
    // All the styles
    let vertex = this.vertexService.vertices[local_id];
    this.renderer.setStyle(newObject,"width", vertex.width + "px");
    this.renderer.setStyle(newObject,"height", vertex.height + "px");
    this.renderer.setStyle(newObject,"position", "absolute");
    this.renderer.setStyle(newObject,"user-select", "none");
    this.renderer.setStyle(newObject,"transform",'translate('+ vertex.pos_x +'px, '+ vertex.pos_y +'px)');
    this.renderer.setStyle(newObject,"z-index",vertex.z_index);
    // Setting all needed attributes
    this.renderer.setAttribute(newObject,'vertex-id', local_id.toString());
    this.renderer.setAttribute(newObject,"src", vertex.graphic_id);
    this.renderer.setAttribute(newObject,"data-x", vertex.pos_x.toString());
    this.renderer.setAttribute(newObject,"data-y", vertex.pos_y.toString());

    this.renderer.appendChild(this.escapeRoomDivRef?.nativeElement, newObject);
    // Event listener
    this.renderer.listen(newObject,"mouseup", (event) => this.updateVertex(event));
    this.renderer.listen(newObject,"click", (event) => this.vertexOperation(event));
    // double click to show Attribute Menu
    this.renderer.listen(newObject,"dblclick", (event) => {
      this._is_single_click = false;
      this.showAttributeMenu(event);
      return false;
    });
    // RIGHT CLICK EVENT FOR OBJECTS
    this.renderer.listen(newObject,"contextmenu", (event) => {
      this.showContextMenu(event);
      return false;
    });
  }
  // todo
  //checks if in a operation for a vertex
  vertexOperation(event: any): void{
    this._is_single_click = true;
    setTimeout(()=>{
      if(this._is_single_click){
         if (this.isConnection)
           this.makeConnection(event);
        if(this.is_disconnect)
          this.disconnectConnection(event);
      }
    },250);
  }

  // todo
  //disconnects two vertex logically and visually
  disconnectConnection(event: any):void {
    let to_vertex_id = event.target.getAttribute('vertex-id');
    let from_vertex_id = this._target_vertex.getAttribute('vertex-id');

    //disconnect vertex from screen here
    let line_index = this.vertexService.removeVertexConnection(from_vertex_id, +to_vertex_id);
    //checks if there is a connection to remove from from_vertex to to_vertex
    if (line_index !== -1) {
      this.disconnectLines(line_index, from_vertex_id, to_vertex_id);
    } else {
      //checks if its being called the other way around
      line_index = this.vertexService.removeVertexConnection(to_vertex_id, +from_vertex_id);
      //checks if there is a connection to remove from to_vertex to from_vertex
      if (line_index !== -1) this.disconnectLines(line_index, to_vertex_id, from_vertex_id);
    }
    this.is_disconnect = false;
  }

  // todo
  disconnectLines(line_index: number, from_vertex: number, to_vertex: number): void{
    let real_from_id = this.vertexService.vertices[from_vertex].id;
    let remove_connection = {
      operation: "disconnect_vertex",
      from_vertex_id: real_from_id,
      to_vertex_id: this.vertexService.vertices[to_vertex].id
    };

    this.httpClient.delete<any>("http://127.0.0.1:3000/api/v1/vertex/"+real_from_id,
      {"headers": this.headers, "params": remove_connection}).subscribe(
      response => {
        if (response.status == "SUCCESS") {
          //removes from vertex connected line in array
          this.vertexService.removeVertexConnectedLine(from_vertex, line_index);
          //removes to vertex responsible line in array
          this.vertexService.removeVertexResponsibleLine(to_vertex, line_index);
          //removes visual line on html in array
          this.lines[line_index].remove();
          this.lines[line_index] = null;
        }else{
          this.renderAlertError("Unable to remove vertex")
        }
      },
      error => {
        if (error.status === 401){
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        }else {
          this.renderAlertError("Unable to remove vertex");
          console.error('There was an error while updating the vertex', error);
        }
      }
    );
  }

  // todo
  //makes a connection between two vertices
  makeConnection(event: any): void{
    let to_vertex = event.target;
    this.isConnection = false;
    let from_vertex_id = this._target_vertex.getAttribute('vertex-id');
    let to_vertex_id = to_vertex.getAttribute('vertex-id');

    if(!this.vertexService.getVertexConnections(from_vertex_id).includes(+to_vertex_id)){
      console.log("added a connection");
      let connection = {
        operation: 'connection',
        from_vertex_id: this.vertexService.vertices[from_vertex_id].id, //convert local to real id
        to_vertex_id: this.vertexService.vertices[to_vertex_id].id
      };
      this.httpClient.put<any>("http://127.0.0.1:3000/api/v1/vertex/"+this.vertexService.vertices[from_vertex_id].id, connection, {"headers": this.headers}).subscribe(
        response => {
          // updates the local array here only after storing on db
          if(response.status == "FAILED"){
            this.renderAlertError(response.message);
          }else {
            // this.lines.push(new LeaderLine(this._target_vertex, to_vertex, {dash: {animation: true}}));
            // this.lines[this.lines.length - 1].color = 'rgba(0,0,0,1.0)';
            //
            // this.vertexService.addVertexConnection(from_vertex_id, to_vertex_id);
            // this.vertexService.addVertexConnectedLine(from_vertex_id, this.lines.length - 1);
            // this.vertexService.addVertexResponsibleLine(to_vertex_id, this.lines.length - 1);
            // //add event to listen to mouse event of only connected vertices
            // to_vertex.addEventListener("mousemove", () => this.updateLine(from_vertex_id));
            // this._target_vertex.addEventListener("mousemove", () => this.updateLine(to_vertex_id));
            // // store on array
            this.renderLines(from_vertex_id, this._target_vertex, +to_vertex_id, to_vertex);
          }
        },
        error => {
          if (error.status === 401){
            if (this.router.routerState.snapshot.url !== '/login' &&
              this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
          }else {
            this.renderAlertError("There was an Error Updating Vertex Position");
          }
        }
      );
    }

  }

  // todo, test by rendering a function and clicking on a make connections
  private renderLines(from_vertex_id:number, from_vertex:any, to_vertex_id:number, to_vertex:any):void{
    this.lines.push(new LeaderLine(from_vertex, to_vertex, {dash: {animation: true}}));
    this.lines[this.lines.length - 1].color = 'rgba(0,0,0,1.0)';

    this.vertexService.addVertexConnection(from_vertex_id, to_vertex_id);
    this.vertexService.addVertexConnectedLine(from_vertex_id, this.lines.length - 1);
    this.vertexService.addVertexResponsibleLine(to_vertex_id, this.lines.length - 1);
    //add event to listen to mouse event of only connected vertices
    to_vertex.addEventListener("mousemove", () => this.updateLine(from_vertex_id));
    from_vertex.addEventListener("mousemove", () => this.updateLine(to_vertex_id));
    // store on array
  }

  // todo
  // shows a context menu when right button clicked over the vertex
  showContextMenu(event: any): void{
    this._target_vertex = event.target;

    let x_pos = this._target_vertex.width + Number(this._target_vertex.getAttribute("data-x"));
    let y_pos = this._target_vertex.getAttribute("data-y");

    // moves the context menu where needed based on the vertex
    this.contextMenuRef?.nativeElement.style.setProperty("transform",'translate('+ x_pos +'px, '+ y_pos +'px)');
    this.changeCurrentZ(0);
    // @ts-ignore
    this.attributeMenuRef?.nativeElement.hidden = true;
    // @ts-ignore
    this.contextMenuRef?.nativeElement.hidden = false;
  }

  showAttributeMenu(event: any): void{
    this._target_vertex = event.target;
    this.hidePuzzle = true;
    this.hideClue = true;
    let vertex = this.vertexService.vertices[this._target_vertex.getAttribute('vertex-id')];
    this.vertex_type = vertex.type;
    let x_pos = this._target_vertex.width + Number(this._target_vertex.getAttribute("data-x"));
    let y_pos = this._target_vertex.getAttribute("data-y");

    this.vertex_name_menu = vertex.name;
    if(this.vertex_type === "Clue") {
      // @ts-ignore
      this.vertex_clue_menu = vertex.clue;
      this.hideClue = false;
    }
    if(this.vertex_type === "Puzzle") {
      // @ts-ignore
      this.vertex_description_menu = vertex.description;
      this.hidePuzzle = false;
    }
    // moves the context menu where needed based on the vertex
    this.attributeMenuRef?.nativeElement.style.setProperty("transform",'translate('+ x_pos +'px, '+ y_pos +'px)');
    // @ts-ignore
    this.contextMenuRef?.nativeElement.hidden = true;
    // @ts-ignore
    this.attributeMenuRef?.nativeElement.hidden = false;
  }

  // hides the context menu
  hideContextMenu(event:any): void{
    if (!event.target.getAttribute('data-close')){
      // @ts-ignore
      this.contextMenuRef?.nativeElement.hidden = true;
      // @ts-ignore
      //this.attributeMenuRef?.nativeElement.hidden = true;
    }
  }

  // todo
  // updates the position on db from user moving it
  updateVertex(event: any): void{
    let targetVertex = event.target;
    let local_target_id = targetVertex.getAttribute('vertex-id');
    let real_target_id = this.vertexService.vertices[local_target_id].id;
    let new_y_pos = targetVertex.getAttribute('data-y');
    let new_x_pos = targetVertex.getAttribute('data-x');
    let new_height = targetVertex.style.height.match(/\d+/)[0];
    let new_width = targetVertex.style.width.match(/\d+/)[0];

    let updateVertexBody = {
      operation: 'transformation',
      id: real_target_id, //convert local to real id
      pos_y: new_y_pos,
      pos_x: new_x_pos,
      height: new_height,
      width: new_width,
      z_index: this.vertexService.vertices[local_target_id].z_index
    };
    // updates all the data of vertex
    this.httpClient.put<any>("http://127.0.0.1:3000/api/v1/vertex/"+real_target_id, updateVertexBody, {"headers": this.headers}).subscribe(
      response => {
        // updates the local array here only after storing on db
        this.vertexService.vertices[local_target_id].pos_x = new_x_pos;
        this.vertexService.vertices[local_target_id].pos_y = new_y_pos;
        this.vertexService.vertices[local_target_id].width = new_width;
        this.vertexService.vertices[local_target_id].height = new_height;
      },
      error => {
        if (error.status === 401){
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        }else {
          this.renderAlertError("There was an Error Updating Vertex Position"); // todo also try to reset the old position
        }
      }
      //console.error('There was an error while updating the vertex', error)
    );
  }

  // todo
  //DELETES VERTEX FROM BACKEND AND REMOVES ON SCREEN
  removeVertex(): void{
    let local_target_id = this._target_vertex.getAttribute('vertex-id');
    let real_target_id = this.vertexService.vertices[local_target_id].id;
    //call to backend to delete vertex by id

    let remove_vertex = {
      operation: "remove_vertex",
      id: real_target_id
    };

    this.httpClient.delete<any>("http://127.0.0.1:3000/api/v1/vertex/"+real_target_id, {"headers": this.headers, "params": remove_vertex}).subscribe(
      response => {
        //remove vertex from screen here
        this.vertexService.vertices[local_target_id].toggle_delete(); // marks a vertex as deleted
        this.removeLines(local_target_id);
        this._target_vertex.remove();
      },
      error => {
        if (error.status === 401){
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        }else {
          this.renderAlertError("Unable to remove vertex");
        }
      }
      //console.error('There was an error while updating the vertex', error)
    );
  }

  checkSolvable(): void{
    this.solveComponent?.checkSolvable(this._target_start, this._target_end, this.currentRoomId);
  }

  setStart() :void{
    this._target_start= this._target_vertex;
    let id=this.vertexService.vertices[this._target_start.getAttribute("vertex-id")].id
    this._target_start=id
    let connection = {
      operation: 'setStart',
      startVertex: id , //convert local to real id
    };

    this.httpClient.put<any>("http://127.0.0.1:3000/api/v1/room/"+this.currentRoomId, connection, {"headers": this.headers}).subscribe(
      response => {
        // updates the local array here only after storing on db
        console.log(response);
      },
      error => this.renderAlertError("Vertex could not update") // todo also try to reset the old position
      //console.error('There was an error while updating the vertex', error)
    );
  }

  setEnd() :void{
    this._target_end= this._target_vertex;
    var id=this.vertexService.vertices[this._target_end.getAttribute("vertex-id")].id
    this._target_end=id
    let connection = {
      operation: 'setEnd',
      endVertex: id , //convert local to real id
    };

    this.httpClient.put<any>("http://127.0.0.1:3000/api/v1/room/"+this.currentRoomId, connection, {"headers": this.headers}).subscribe(
      response => {
        // updates the local array here only after storing on db
        console.log(response);
      },
      error => this.renderAlertError("Vertex could not update") // todo also try to reset the old position
      //console.error('There was an error while updating the vertex', error)
    );

  }

  // todo
  removeLines(vertex_id: number): void{
    let all_the_lines = this.vertexService.getLineIndex(vertex_id);
    let incoming_lines = this.vertexService.vertices[vertex_id].getResponsibleLines();

    // only do this if there are some connections
    for( let line_index of all_the_lines){
      if (incoming_lines.indexOf(line_index) !== -1){
        // means that this is an incoming line
        // so capture start and get the id from its attribute
        let start_id = this.lines[line_index].start.getAttribute("vertex-id");
        // change starts connection and connected lines arrays
        this.vertexService.removeVertexConnection(start_id, vertex_id);
        this.vertexService.removeVertexConnectedLine(start_id, line_index);
      }else{
        // capture end vertex local id
        let end_id = this.lines[line_index].end.getAttribute("vertex-id");
        // change the responsible array of end vertex
        this.vertexService.removeVertexResponsibleLine(end_id, line_index);
        // don't need to remove the connection or connection of current, for ease in ctrl-z
      }

      // remove the line
      this.lines[line_index].remove();
      this.lines[line_index] = null;
    }
  }

  //Spawn Alert Error with Message
  renderAlertError(message: string):void{
    //create element for alert
    let newDiv = this.renderer.createElement('div');
    let newStrong = this.renderer.createElement('strong');
    let newButton = this.renderer.createElement('button');

    // add bootstrap to <div>
    this.renderer.addClass(newDiv,'alert');
    this.renderer.addClass(newDiv,'alert-warning');
    this.renderer.addClass(newDiv,'alert-dismissible');
    this.renderer.addClass(newDiv,'fade');
    this.renderer.addClass(newDiv,'show');
    this.renderer.setStyle(newDiv, 'margin','0');
    this.renderer.setAttribute(newDiv, 'role', 'alert');
    //add text to <strong>
    this.renderer.appendChild(newStrong, this.renderer.createText(message));
    //add bootstrap to <button>
    this.renderer.addClass(newButton, 'btn-close');
    this.renderer.setAttribute(newButton, 'type', 'button');
    this.renderer.setAttribute(newButton, 'data-bs-dismiss', 'alert');
    this.renderer.setAttribute(newButton, 'aria-label', 'Close');

    // make it <div><strong><button>
    this.renderer.appendChild(newDiv,newButton);
    this.renderer.appendChild(newDiv, newStrong);
    // append to div alertElementError
    this.renderer.appendChild(this.alertElementErrorRef?.nativeElement, newDiv);
  }

  changeCurrentZ(i : number): void{
    if (i === 0) {
      this._target_vertex_z_index = this._target_vertex.style.zIndex;
      return;
    }

    if ((this._target_vertex_z_index + i) < 5) return;

    let old_z = this._target_vertex_z_index;
    let local_id = this._target_vertex.getAttribute('vertex-id');

    this._target_vertex_z_index = +this._target_vertex.style.zIndex + i;

    let vertex = this.vertexService.vertices[local_id];

    let updateVertexZ = {
      operation: 'transformation',
      id: vertex.id, //convert local to real id
      pos_y: vertex.pos_y,
      pos_x: vertex.pos_x,
      height: vertex.height,
      width: vertex.width,
      z_index: this._target_vertex_z_index
    };

    this.httpClient.put<any>("http://127.0.0.1:3000/api/v1/vertex/"+vertex.id, updateVertexZ, {"headers": this.headers}).subscribe(
      response => {
        this.vertexService.vertices[local_id].z_index = this._target_vertex_z_index; // saves in service
        this._target_vertex.style.zIndex = this._target_vertex_z_index; // update view
      },
      error => {
        if (error.status === 401){
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        }else {
          this._target_vertex_z_index = old_z;
          this.renderAlertError("There was an Error Updating Vertex Z position");
        }
      }
      //console.error('There was an error while updating the vertex', error)
    );
  }

  // ZOOM test
  test(): void{
    let multiplier = 1.0;
    let multiplier2 = 2.0;

    let child = this.escapeRoomDivRef?.nativeElement.children[1];

    child.style.height = child.height*multiplier2 + 'px';
    child.style.width = child.width*multiplier2 + 'px';
    console.log(child.getAttribute('data-x'));
    console.log(child.getAttribute('data-y'));
    child.style.transform = 'translate('+(child.getAttribute('data-x')*multiplier2)+'px,'+(child.getAttribute('data-y')*multiplier2)+'px)';
    child.setAttribute('data-x',child.getAttribute('data-x')*multiplier2);
    child.setAttribute('data-y',child.getAttribute('data-y')*multiplier2);

    this.delay(10000).then(r => {
      child.style.height = child.height/multiplier2 + 'px';
      child.style.width = child.width/multiplier2 + 'px';
      child.style.transform = 'translate('+(child.getAttribute('data-x')/multiplier2)+'px,'+(child.getAttribute('data-y')/multiplier2)+'px)';
      child.setAttribute('data-x',child.getAttribute('data-x')/multiplier2);
      child.setAttribute('data-y',child.getAttribute('data-y')/multiplier2);
    });
  }

  private async delay(ms: number)
  {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  updateAttribute(data: any){

    console.log(data);
  }

}

// For Vertex Response
interface VertexArray {
  data: Array<VertexArrayData>;
  status: string;
}

interface VertexArrayData{
  vertex: Vertex;
  connections: number;
  type: string;
}

interface Vertex{
  id: number;
  name: string;
  graphicid: string;
  height: number;
  width: number;
  posx: number;
  posy: number;
  clue: string;
  description: string;
  estimatedTime: Date;
  z_index: number;
}

//for Escape Room Response
interface EscapeRoomArray {
  data: Array<EscapeRoom>;
  status: string;
}

interface EscapeRoom{
  id: number;
  name: string;
}
