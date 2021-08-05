import {AfterViewInit, Component, ElementRef, OnInit, Renderer2, ViewChild} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {HttpHeaders} from "@angular/common/http";
import {VertexService} from "../../services/vertex.service";
import {Router} from "@angular/router";
// Leader Line JS library imports
import 'leader-line';
declare let LeaderLine: any;

@Component({
  selector: 'app-room-creator',
  templateUrl: './room-creator.component.html',
  styleUrls: ['./room-creator.component.css']
})
export class RoomCreatorComponent implements OnInit, AfterViewInit {
  public lastPos : number = 0; // used to populate new objects in line
  // @ts-ignore
  public escapeRooms: EscapeRoomArray; // array of escape rooms used to populate drop down
  //todo fix this to be a session?
  public currentRoomId: number = 0; // used to check currently selected room
  public newEscapeRoomName:string = ""; // used when submitting a new room creation
  public newEscapeRoomNameValid:boolean = false; // flag using regex

  private _target_vertex: any;
  private isConnection = false;
  private is_disconnect = false;
  private lines:any = []; // to store lines for update and deletion
  private headers: HttpHeaders = new HttpHeaders();

  @ViewChild("escapeRoomDiv") escapeRoomDivRef : ElementRef | undefined; // escape room canvas div block
  @ViewChild("EscapeRoomList") escapeRoomListRef : ElementRef | undefined; // escape room list element reference
  @ViewChild("alertElementError") alertElementErrorRef : ElementRef | undefined;
  @ViewChild("contextMenu") contextMenuRef : ElementRef | undefined;

  constructor(private el : ElementRef, private renderer: Renderer2, private httpClient: HttpClient,
              private vertexService: VertexService, private router:Router)
  {
    // todo change to work with login token and not test token

    localStorage.setItem('token', "test");
    //localStorage.clear();
    if(localStorage.getItem('token') ==  null) {
      this.router.navigate(['login']).then(r => alert("login test"));
    }
      this.headers = this.headers.set('Authorization', 'Bearer ' + localStorage.getItem('token'));
  }


  ngOnInit(): void {
    //set the currentRoomId to 1 by default, later to actual first room id?
    this.currentRoomId = 3;
    this.getEscapeRooms();
    this.getVertexFromRoom();
  }

  ngAfterViewInit(){
    //use for testing new functionality
  }

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

  //adds an object to drag on our 'canvas'
  addObjects(type: string, loc: string, pos: number): void{
    this.lastPos += pos;
    //MAKE API CALL BASED ON TYPE
    let name : string = "Object";       //default name
    let description : string = "Works";  //default description
    this.createVertex(type, name, loc, 0, this.lastPos, 75, 75, new Date(), description, this.currentRoomId, 'some clue');

    //spawns object on plane
  }

  //use get to get all the rooms stored in db
  getEscapeRooms(): void{
    //http request to rails api
    this.httpClient.get<EscapeRoomArray>("http://127.0.0.1:3000/api/v1/room/", {"headers": this.headers}).subscribe(
      response => {
          //rendering <li> elements by using response
          this.escapeRooms = response;
          //render all the rooms
          for (let er of response.data){
            this.renderNewRoom(er.id, er.name);
          }
      },
        //Render error if bad request
        error => this.renderAlertError('There was an error retrieving your rooms')
    );
  }

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
  }

  //Get to get all vertex for room
  getVertexFromRoom(): void{
    this.vertexService.reset_array();
    //http request to rails api
    this.httpClient.get<VertexArray>("http://127.0.0.1:3000/api/v1/vertex/" + this.currentRoomId, {"headers": this.headers}).subscribe(
      response => {
        //render all the vertices

        for (let vertex_t of response.data){
          //spawn objects out;
          let vertex = vertex_t.vertex
          let vertex_type = vertex_t.type;
          let vertex_connections = vertex_t.connections;

          let current_id = this.vertexService.addVertex(vertex.id, vertex_type, vertex.name, vertex.graphicid,
                                       vertex.posy, vertex.posx, vertex.width, vertex.height, vertex.estimatedTime,
                                       vertex.description, vertex.clue);

          // @ts-ignore
          for (let vertex_connection of vertex_connections)
            this.vertexService.addVertexConnection(current_id, vertex_connection);

          this.spawnObjects(current_id);
        }

        // TODO consider using some other method to locate these, cause triple for loop is not pog
        // converts real connection to local connection
        for (let vertex of this.vertexService.vertices){
          let vertex_connections = vertex.getConnections();

          for (let vertex_connection of vertex_connections){
            // go through all the connections
            // for each location locate the vertex with that real id and use its local id in place of real one
            console.log(vertex_connection);

            for (let vertex_to of this.vertexService.vertices){

              if (vertex_to.id === vertex_connection){
                this.vertexService.removeVertexConnection(vertex.local_id ,vertex_connection);
                vertex.addConnection(vertex_to.local_id); // appends to the end of the list

                let from_vertex = document.querySelectorAll('[vertex-id="'+vertex.local_id+'"]')[0];
                let to_vertex = document.querySelectorAll('[vertex-id="'+vertex_to.local_id+'"]')[0];

                this.renderLines(vertex.local_id, from_vertex, vertex_to.local_id, to_vertex);
                break; // so that not the whole array is traversed
              }
            }
          }

          console.log(vertex.getConnections());
        }
      },
      //Error retrieving vertices message
      error => this.renderAlertError("There was an error retrieving vertices for the room")
    );
  }

  // POST to create new room for a user
  createEscapeRoom(NewEscapeRoomForm:any): void{
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
          // console.log(response.data)
          this.renderNewRoom(response.data.id, response.data.name);
        },
        error => console.error('There was an error creating your rooms', error)
      );
    }

    this.newEscapeRoomNameValid = false;
    this.newEscapeRoomName = ""; // resets the input box text
  }

  isNewEscapeRoomNameValid():void{
    let patternRegEx: RegExp = new RegExp("([\\w\\d!@#$%^&\\*\\(\\)_\\+\\-=;'\"?>/\\\\|<,\\[\\].:{}`~]+( )?)+",'g');
    let regexResult = patternRegEx.exec(this.newEscapeRoomName);

    this.newEscapeRoomNameValid = regexResult !== null;
  }

  //just renders new room text in the list
  renderNewRoom(id:number, name:string): void{
    // <li><a class="dropdown-item">ROOM 1</a></li>-->
    let newRoom = this.renderer.createElement('li');
    let newTag = this.renderer.createElement('a');
    // add bootstrap class to <a>
    this.renderer.addClass(newTag,'dropdown-item');
    this.renderer.addClass(newTag,'text-white');
    this.renderer.appendChild(newTag, this.renderer.createText(name));
    this.renderer.setAttribute(newTag,'escape-room-id',id.toString());
    this.renderer.listen(newTag,'click',(event) => this.changeRoom(event))
    // make it <li><a>
    this.renderer.appendChild(newRoom,newTag);
    // append to the dropdown menu
    this.renderer.appendChild(this.escapeRoomListRef?.nativeElement, newRoom);
  }

  //creates Vertex of type with scale at position x,y
  createVertex(inType: string, inName: string, inGraphicID: string, inPos_y: number,
               inPos_x: number, inWidth: number, inHeight: number, inEstimated_time: Date,
               inDescription: string, inRoom_id: number, inClue: string): void
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
      clue: inClue
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
        let current_id = this.vertexService.addVertex(response.data.id,
          inType, inName, inGraphicID, inPos_y, inPos_x, inWidth, inHeight,
          inEstimated_time, inDescription, inClue
        );
        this.spawnObjects(current_id);
      },
      error => {
        console.error('There was an error while creating a vertex', error);
        this.renderAlertError("Couldn't create a vertex");
      }
    );
  }

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
    // Setting all needed attributes
    this.renderer.setAttribute(newObject,'vertex-id', local_id.toString());
    this.renderer.setAttribute(newObject,"src", "./assets/images/" + vertex.graphic_id);
    this.renderer.setAttribute(newObject,"data-x", vertex.pos_x.toString());
    this.renderer.setAttribute(newObject,"data-y", vertex.pos_y.toString());

    this.renderer.appendChild(this.escapeRoomDivRef?.nativeElement, newObject);
    // Event listener
    this.renderer.listen(newObject,"mouseup", (event) => this.updateVertex(event));
    this.renderer.listen(newObject,"click", (event) => this.vertexOperation(event));
    // RIGHT CLICK EVENT FOR OBJECTS
    this.renderer.listen(newObject,"contextmenu", (event) => {
      this.showContextMenu(event);
      return false;
    });
  }

  //checks if in a operation for a vertex
  vertexOperation(event: any): void{
    if (this.isConnection)
      this.makeConnection(event);
    if(this.is_disconnect)
      this.disconnectConnection(event);
  }

  //disconnects two vertex logically and visually
  disconnectConnection(event: any):void {
    let to_vertex_id = event.target.getAttribute('vertex-id');
    let from_vertex_id = this._target_vertex.getAttribute('vertex-id');

    //disconnect vertex from screen here
    let line_index = this.vertexService.removeVertexConnection(from_vertex_id, to_vertex_id);
    //checks if there is a connection to remove from from_vertex to to_vertex
    if (line_index !== -1) {
      this.disconnectLines(line_index, from_vertex_id, to_vertex_id);
    } else {
      //checks if its being called the other way around
      line_index = this.vertexService.removeVertexConnection(to_vertex_id, from_vertex_id);
      //checks if there is a connection to remove from to_vertex to from_vertex
      if (line_index !== -1) this.disconnectLines(line_index, to_vertex_id, from_vertex_id);
    }
    this.is_disconnect = false;
  }

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
      error => this.renderAlertError("Unable to remove vertex")
      //console.error('There was an error while updating the vertex', error)
    );
  }

  //makes a connection between two vertices
  makeConnection(event: any): void{
    let to_vertex = event.target;
    this.isConnection = false;
    let from_vertex_id = this._target_vertex.getAttribute('vertex-id');
    let to_vertex_id = to_vertex.getAttribute('vertex-id');

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
          this.renderLines(from_vertex_id, this._target_vertex, to_vertex_id, to_vertex);
        }
      },
      error => this.renderAlertError("There was an Error Updating Vertex Position")
      //console.error('There was an error while updating the vertex', error)
    );

  }

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
  // shows a context menu when right button clicked over the vertex
  showContextMenu(event: any): void{
    this._target_vertex = event.target;

    let x_pos = this._target_vertex.width + Number(this._target_vertex.getAttribute("data-x"));
    let y_pos = this._target_vertex.getAttribute("data-y");

    // moves the context menu where needed based on the vertex
    this.contextMenuRef?.nativeElement.style.setProperty("transform",'translate('+ x_pos +'px, '+ y_pos +'px)');
    // @ts-ignore
    this.contextMenuRef?.nativeElement.hidden = false;
  }

  // hides the context menu
  hideContextMenu(event:any): void{
    if (event.target !== this.contextMenuRef?.nativeElement){
      // @ts-ignore
      this.contextMenuRef?.nativeElement.hidden = true;
    }
  }

  // updates the position on db from user moving it
  updateVertex(event: any): void{
    let targetVertex = event.target;
    let local_target_id = targetVertex.getAttribute('vertex-id');
    let real_target_id = this.vertexService.vertices[local_target_id].id;
    // console.log(targetVertex.getAttribute('vertex-id'));
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
      width: new_width
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
      error => this.renderAlertError("There was an Error Updating Vertex Position") // todo also try to reset the old position
      //console.error('There was an error while updating the vertex', error)
    );
  }

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
      error => this.renderAlertError("Unable to remove vertex")
      //console.error('There was an error while updating the vertex', error)
    );
  }

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
