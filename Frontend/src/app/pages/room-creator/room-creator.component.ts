import {AfterViewInit, Component, ElementRef, HostListener, OnInit, Renderer2, ViewChild} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {HttpHeaders} from "@angular/common/http";
import {VertexService} from "../../services/vertex.service";
import {Router} from "@angular/router";
// Leader Line JS library imports
import 'leader-line';
import {InventoryComponent} from "../inventory/inventory.component";
import {SolvabilityComponent} from "../solvability/solvability.component"
import { DependencyDiagramComponent } from '../dependency-diagram/dependency-diagram.component';
import {environment} from "../../../environments/environment";
import {getLocaleFirstDayOfWeek} from "@angular/common";
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
  public vertex_min_menu:string = "min";
  public vertex_sec_menu:string = "sec";
  public vertex_clue_menu:string = "";
  public vertex_description_menu:string = "";
  public room_context_menu:boolean = true;
  public hasRooms:boolean = true;
  public hideClue:boolean = true;
  public hidePuzzle:boolean = true;
  public zoomValue: number = 1.0;
  public _room_count:number = 0;
  public showNames: boolean = false;
  public number_of_containers:number = 1;
  public number_of_puzzles:number = 1;
  public number_of_keys:number = 1;
  public number_of_clues:number = 1;
  public linearity_value:string = "low";
  public complexity_value:string = "low";

  private _target_room: any;
  private _target_vertex: any;
  private _target_start: any;
  private _target_end: any;
  private _is_single_click: Boolean = true;
  private isConnection = false;
  private is_disconnect = false;
  private lines:any = []; // to store lines for update and deletion
  private headers: HttpHeaders = new HttpHeaders();

  @ViewChild("zoom") zoomRef: ElementRef | undefined;
  @ViewChild("escapeRoomDiv") escapeRoomDivRef : ElementRef | undefined; // escape room canvas div block
  @ViewChild("EscapeRoomList") escapeRoomListRef : ElementRef | undefined; // escape room list element reference
  @ViewChild("alertElementError") alertElementErrorRef : ElementRef | undefined;
  @ViewChild("contextMenu") contextMenuRef : ElementRef | undefined;
  @ViewChild("roomContextMenu") roomContextMenuRef : ElementRef | undefined;
  @ViewChild("attributeMenu") attributeMenuRef : ElementRef | undefined;
  @ViewChild(SolvabilityComponent) solveComponent: SolvabilityComponent | undefined;
  @ViewChild(DependencyDiagramComponent) diagramComponent: DependencyDiagramComponent | undefined;

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
    this.test();
  }



  // todo
  //updates all lines connected to this vertex
  updateLine(vertex_index: number):void{
    //TODO: only do this if the position changed ?
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
    if (event.type === 'Room'){
      this.createRoom(event.pos, 0, 50, 125, event.blob_id, event.src);
      return;
    }

    this.lastPos += event.pos;
    //MAKE API CALL BASED ON TYPE
    let name : string = "Object";       //default name
    let description : string = "Works";  //default description
    this.createVertex(event.type, name, event.loc, 0, this.lastPos, 75, 75, 0, description, this.currentRoomId, 'some clue', event.src, event.blob_id);
    //spawns object on plane
  }

  // todo
  //use get to get all the rooms stored in db
  getEscapeRooms(): void{
    //http request to rails api
    this.httpClient.get<EscapeRoomArray>(environment.api + "/api/v1/room/", {"headers": this.headers}).subscribe(
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
      this.httpClient.delete<any>(environment.api + "/api/v1/room/"+room_id,
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
    //reset the zoom values
    // @ts-ignore
    this.zoomRef?.nativeElement.value = 1;
    this.zoomValue = 1;

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
    this._target_start = undefined;
    this._target_end = undefined;
    if(this.currentRoomId !== -1) {
      // resets the vertices on room switch
      this.vertexService.reset_array();
      // resets the lines array
      for (let line of this.lines) {
        if (line !== null)
          line.remove();
      }
      this.lines = [];

      // gets room images
      this.httpClient.get<any>(environment.api + '/api/v1/room_image/'+this.currentRoomId, {"headers": this.headers}).subscribe(
        response =>{
          for ( let room_image of response.data){

            this.spawnRoom(
              room_image.room_image.pos_x,
              room_image.room_image.pos_y,
              room_image.room_image.width,
              room_image.room_image.height,
              room_image.room_image.id,
              room_image.src
            );
          }
        },
        error => {
          if (error.status === 401) {
            if (this.router.routerState.snapshot.url !== '/login' &&
              this.router.routerState.snapshot.url !== '/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
          } else {
            this.renderAlertError("There was an error retrieving room images for the room");
          }
        }
      );

      //http request to rails api
      this.httpClient.get<any>(environment.api + "/api/v1/vertex/" + this.currentRoomId, {"headers": this.headers}).subscribe(
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
            if(vertex_t.position === "start")
              this._target_start = current_id;
            else if (vertex_t.position === "end")
              this._target_end = current_id;
            // @ts-ignore
            for (let vertex_connection of vertex_connections)
              this.vertexService.addVertexConnection(current_id, vertex_connection);

            this.spawnObjects(current_id);
          }

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
  createEscapeRoom(ai_enabled:boolean): void{
    if (ai_enabled){
      this.createEscapeRoomWithAI();
      return;
    }
    // regex to extract valid strings, removes all the spaces and allows any character
    let patternRegEx: RegExp = new RegExp("([\\w\\d!@#$%^&\\*\\(\\)_\\+\\-=;'\"?>/\\\\|<,\\[\\].:{}`~]+( )?)+",'g');
    let regexResult = patternRegEx.exec(this.newEscapeRoomName);

    if (regexResult === null) {
      alert("cant send empty string");
      // needs to have a name
    }else {
      let createRoomBody = {name: regexResult[0]};
      //http request to rails api
      this.httpClient.post<any>(environment.api + "/api/v1/room/", createRoomBody, {"headers": this.headers}).subscribe(
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

  // this will create a room using AI
  public createEscapeRoomWithAI():void{
    //Patric use these values for the form stuff, also environment.api/path/to/resource for api calls
    console.log('linearity', this.linearity_value);
    console.log('complexity', this.complexity_value);
    console.log('num containers', this.number_of_containers);
    console.log('num puzzles', this.number_of_puzzles);
    console.log('num keys', this.number_of_keys);
    console.log('num clues', this.number_of_clues);

    //TODO: make a room like in function above
    // todo: then make api call
    // todo: then switch to that room
    // todo: if you want to, you can reset the default values of the create room modal
    // make sure that the number values  are not null
    // defaults:
    // check box is unchecked
    // all the values are 1 or low
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
               inPos_x: number, inWidth: number, inHeight: number, inEstimated_time: number,
               inDescription: string, inRoom_id: number, inClue: string, src:string, blob_id: number): void
  {
    // scale to 1.0 zoom for storing
    inPos_x /= this.zoomValue;
    inPos_x /= this.zoomValue;
    inWidth /= this.zoomValue;
    inHeight /= this.zoomValue;


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
    }
    // removes parameters for clue
    if (inType != 'Clue'){
      // @ts-ignore
      delete createVertexBody.clue;
    }

    //make post request for new vertex
    this.httpClient.post<any>(environment.api + "/api/v1/vertex/", createVertexBody, {"headers": this.headers}).subscribe(
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
    let newP = this.renderer.createElement("p");
    let newObject = this.renderer.createElement("img"); // create image
    // * zoomValue to get the zoomed representation
    if(local_id === this._target_start) {
      this.renderer.addClass(newObject, "resize-drag");
      this.renderer.addClass(newObject, "border");
      this.renderer.addClass(newObject, "border-3");
      this.renderer.addClass(newObject, "border-primary");
    }else if(local_id === this._target_end) {
      this.renderer.addClass(newObject, "resize-drag");
      this.renderer.addClass(newObject, "border");
      this.renderer.addClass(newObject, "border-3");
      this.renderer.addClass(newObject, "border-info");
    }else
      this.renderer.addClass(newObject, "resize-drag");

    this.renderer.addClass(newP, 'vertex-tag');
    // All the styles
    let vertex = this.vertexService.vertices[local_id];
    this.renderer.setStyle(newObject,"width", vertex.width*this.zoomValue + "px");
    this.renderer.setStyle(newObject,"height", vertex.height*this.zoomValue + "px");
    this.renderer.setStyle(newObject,"position", "absolute");
    this.renderer.setStyle(newObject,"user-select", "none");
    this.renderer.setStyle(newObject,"transform",'translate('+ vertex.pos_x*this.zoomValue +'px, '+ vertex.pos_y*this.zoomValue +'px)');
    this.renderer.setStyle(newObject,"z-index",vertex.z_index);
    this.renderer.setStyle(newP,"transform",'translate('+ vertex.pos_x*this.zoomValue +'px, '+ vertex.pos_y*this.zoomValue +'px)');
    this.renderer.setStyle(newP,"z-index",vertex.z_index);
    this.renderer.setStyle(newP,"width", vertex.width*this.zoomValue+"px");
    this.renderer.setStyle(newP,"margin-top",(vertex.height/2)*this.zoomValue + "px ");
    // Setting all needed attributes
    this.renderer.setAttribute(newObject,'vertex-id', local_id.toString());
    this.renderer.setAttribute(newObject,"src", vertex.graphic_id);
    this.renderer.setAttribute(newObject,"data-x", (vertex.pos_x*this.zoomValue).toString());
    this.renderer.setAttribute(newObject,"data-y", (vertex.pos_y*this.zoomValue).toString());
    if (!this.showNames)
      this.renderer.setAttribute(newP, 'hidden','');
    //set ids
    this.renderer.setAttribute(newP,'id', 'tag-'+local_id); // tag-VERTEX_ID for every tag
    //append children
    this.renderer.appendChild(newP, this.renderer.createText(vertex.name));
    this.renderer.appendChild(this.escapeRoomDivRef?.nativeElement, newObject);
    this.renderer.appendChild(this.escapeRoomDivRef?.nativeElement, newP);
    // Event listener
    this.renderer.listen(newObject,"mouseup", (event) => this.updateVertex(event));
    this.renderer.listen(newObject,"mouseup", (event) => this.updateVertex(event));
    this.renderer.listen(newObject,"click", (event) => this.vertexOperation(event));
    this.renderer.listen(newObject,"mousemove", (event) => this.updateTag(newP, newObject));
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

  //updates position of tag when vertex is dragged
  updateTag(tag: HTMLParagraphElement, image: HTMLImageElement){
    let x = image.getAttribute('data-x');
    let y = image.getAttribute('data-y');
    let w = image.style.width;
    // @ts-ignore
    let h = Number.parseFloat(image.style.height.match(/\d+/)[0]);

    tag.style.transform = "translate("+ x +"px,"+ y +"px)";
    tag.style.width = w;
    tag.style.marginTop = h/2 + "px";
  }

  displayNames(): void{
    this.showNames = !this.showNames; // toggle flag

    let p_tags:any = document.getElementsByClassName('vertex-tag');

    for(let p_tag of p_tags){
      p_tag.hidden = !this.showNames;
    }
  }

  // used to create and spawn a room-image when clicking inventory image
  createRoom(x: number, y:number, width: number, height:number, blob_id: number, src: string): void{

    let createRoomImageBody = {
      pos_x: x,
      pos_y: y,
      width: width,
      height: height,
      escape_room_id: this.currentRoomId,
      blob_id: blob_id
    }

    this.httpClient.post<any>(environment.api + "/api/v1/room_image/", createRoomImageBody, {"headers": this.headers}).subscribe(
      response => {
        this.spawnRoom(x, y, width, height, response.data.id, src);
      },
      error => {
        if (error.status === 401){
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        }else {
          console.error('There was an error while creating a room image', error);
          this.renderAlertError("Couldn't create a room image");
        }
      }
    );
  }

  // just spawns the room image on canvas with params given
  spawnRoom(x: number, y:number, width: number, height:number, id: number, src: string): void{
    let newRoomImage = this.renderer.createElement('img');
    this.renderer.addClass(newRoomImage,'resize-drag');
    this.renderer.addClass(newRoomImage,'border');
    this.renderer.addClass(newRoomImage,'border-dark');
    // All the styles
    this.renderer.setStyle(newRoomImage,"width", width + "px");
    this.renderer.setStyle(newRoomImage,"height", height + "px");
    this.renderer.setStyle(newRoomImage,"position", "absolute");
    this.renderer.setStyle(newRoomImage,"user-select", "none");
    this.renderer.setStyle(newRoomImage,"transform",'translate('+ x +'px, '+ y +'px)');
    this.renderer.setStyle(newRoomImage,"z-index",0);
    // Setting all needed attributes
    this.renderer.setAttribute(newRoomImage,'room-image-id', id.toString());
    this.renderer.setAttribute(newRoomImage,"src", src);
    this.renderer.setAttribute(newRoomImage,"data-x", x.toString());
    this.renderer.setAttribute(newRoomImage,"data-y", y.toString());
    //attrs for zoom
    this.renderer.setAttribute(newRoomImage,"data-norm-x",(x/this.zoomValue).toString());
    this.renderer.setAttribute(newRoomImage,"data-norm-y",(y/this.zoomValue).toString());
    this.renderer.setAttribute(newRoomImage,"data-norm-width",(width/this.zoomValue).toString());
    this.renderer.setAttribute(newRoomImage,"data-norm-height",(height/this.zoomValue).toString());
    // event listeners
    this.renderer.listen(newRoomImage,"mouseup", (event) => this.updateRoomImage(event));
    this.renderer.listen(newRoomImage,"contextmenu", (event) => {
      this.showRoomContextMenu(event);
      return false;
    });
    // spawn
    this.renderer.appendChild(this.escapeRoomDivRef?.nativeElement, newRoomImage);
  }

  updateRoomImage(event: any): void{
    let roomImage = event.target;

    let new_pos_x = roomImage.getAttribute('data-x') / this.zoomValue;
    let new_pos_y = roomImage.getAttribute('data-y') / this.zoomValue;
    let new_height = roomImage.style.height.match(/\d+/)[0] / this.zoomValue;
    let new_width = roomImage.style.width.match(/\d+/)[0] / this.zoomValue;

    let updateRoomImageBody = {
      pos_x: new_pos_x,
      pos_y: new_pos_y,
      height: new_height,
      width: new_width
    }

    this.httpClient.put<any>(environment.api + "/api/v1/room_image/"+roomImage.getAttribute('room-image-id'), updateRoomImageBody, {"headers": this.headers}).subscribe(
      response => {
        // update the norm attributes
        roomImage.setAttribute('data-norm-x', new_pos_x);
        roomImage.setAttribute('data-norm-y', new_pos_y);
        roomImage.setAttribute('data-norm-width', new_width);
        roomImage.setAttribute('data-norm-height', new_height);
      },
      error => {
        if (error.status === 401){
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        }else {
          this.renderAlertError("There was an Error Updating Room Image Position");
        }
      }
    );
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

    this.httpClient.delete<any>(environment.api + "/api/v1/vertex/"+real_from_id,
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
      this.httpClient.put<any>(environment.api + "/api/v1/vertex/"+this.vertexService.vertices[from_vertex_id].id, connection, {"headers": this.headers}).subscribe(
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
    this.roomContextMenuRef?.nativeElement.hidden = true;
    // @ts-ignore
    this.attributeMenuRef?.nativeElement.hidden = true;
    // @ts-ignore
    this.contextMenuRef?.nativeElement.hidden = false;
  }

  showRoomContextMenu(event: any): void{
    this._target_room = event.target;

    let x_pos = this._target_room.width + Number(this._target_room.getAttribute("data-x"));
    let y_pos = this._target_room.getAttribute("data-y");
    // moves the context menu where needed based on room location
    this.roomContextMenuRef?.nativeElement.style.setProperty("transform",'translate('+ x_pos +'px, '+ y_pos +'px)');
    // @ts-ignore
    this.attributeMenuRef?.nativeElement.hidden = true;
    // @ts-ignore
    this.contextMenuRef?.nativeElement.hidden = true;
    // @ts-ignore
    this.roomContextMenuRef?.nativeElement.hidden = false;
  }

  showAttributeMenu(event: any): void{
    this._target_vertex = event.target;
    this.hidePuzzle = true;
    this.hideClue = true;
    let vertex = this.vertexService.vertices[this._target_vertex.getAttribute('vertex-id')];
    this.vertex_type = vertex.type;
    let x_pos = this._target_vertex.width + Number(this._target_vertex.getAttribute("data-x"));
    let y_pos = this._target_vertex.getAttribute("data-y");

    this.resetAttributeMenuValue();
    this.vertex_name_menu = vertex.name;
    let min = ~~(vertex.estimated_time/60);
    let sec = vertex.estimated_time%60;
    if (min === 0)
      this.vertex_min_menu = "min";
    else
      this.vertex_min_menu = "" + min;
    if (sec === 0)
      this.vertex_sec_menu = "sec";
    else
      this.vertex_sec_menu = "" + sec;

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
  hideMenus(event:any): void{
    if (!event.target.getAttribute('data-close')){
      // @ts-ignore
      this.contextMenuRef?.nativeElement.hidden = true;
      // @ts-ignore
      this.attributeMenuRef?.nativeElement.hidden = true;
      // @ts-ignore
      this.roomContextMenuRef?.nativeElement.hidden = true;
    }
  }

  // todo
  // updates the position on db from user moving it
  updateVertex(event: any): void{
    let targetVertex = event.target;
    let local_target_id = targetVertex.getAttribute('vertex-id');
    let real_target_id = this.vertexService.vertices[local_target_id].id;
    let new_y_pos = targetVertex.getAttribute('data-y') / this.zoomValue;
    let new_x_pos = targetVertex.getAttribute('data-x') / this.zoomValue;
    let new_height = targetVertex.style.height.match(/\d+/)[0] / this.zoomValue;
    let new_width = targetVertex.style.width.match(/\d+/)[0] / this.zoomValue;

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
    this.httpClient.put<any>(environment.api + "/api/v1/vertex/"+real_target_id, updateVertexBody, {"headers": this.headers}).subscribe(
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

    this.httpClient.delete<any>(environment.api + "/api/v1/vertex/"+real_target_id, {"headers": this.headers, "params": remove_vertex}).subscribe(
      response => {
        //remove vertex from screen here
        this.vertexService.vertices[local_target_id].toggle_delete(); // marks a vertex as deleted
        this.removeLines(local_target_id);
        this._target_vertex.remove();
        // @ts-ignore
        document.getElementById('tag-'+local_target_id).remove();
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
    if(this._target_start !== undefined && this._target_end !== undefined) {
      // TODO: check if vertex been deleted
      // @ts-ignore
      this.solveComponent?.checkSolvable(this.vertexService.vertices[this._target_start].id,
        this.vertexService.vertices[this._target_end].id, this.currentRoomId);
    }else{
      this.renderAlertError("Please set start and end vertex");
    }
  }

  generateDiagram(): void {
    this.diagramComponent?.generate();
  }

  setStart() :void{
    if(this._target_start !== undefined)
      document.querySelectorAll('[vertex-id="' + this._target_start + '"]')[0]
        .setAttribute('class', 'resize-drag');
    let local_id = this._target_vertex.getAttribute("vertex-id");
    let connection = {
      operation: 'setStart',
      startVertex: this.vertexService.vertices[local_id].id, //convert local to real id
    };
    this.httpClient.put<any>(environment.api + "/api/v1/room/"+this.currentRoomId, connection, {"headers": this.headers}).subscribe(
      response => {
        // updates the local array here only after storing on db
        this._target_start = local_id;
        this._target_vertex.setAttribute('class', 'resize-drag border border-3 border-primary')
      },
      error => this.renderAlertError("Vertex could not update") // todo also try to reset the old position
      //console.error('There was an error while updating the vertex', error)
    );
  }

  setEnd() :void{
    if(this._target_end !== undefined)
      document.querySelectorAll('[vertex-id="' + this._target_end + '"]')[0]
        .setAttribute('class', 'resize-drag');
    let local_id = this._target_vertex.getAttribute("vertex-id");
    let connection = {
      operation: 'setEnd',
      endVertex: this.vertexService.vertices[local_id].id, //convert local to real id
    };
    this.httpClient.put<any>(environment.api + "/api/v1/room/"+this.currentRoomId, connection, {"headers": this.headers}).subscribe(
      response => {
        // updates the local array here only after storing on db
        this._target_end = local_id;
        this._target_vertex.setAttribute('class', 'resize-drag border border-3 border-info');
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

    this.httpClient.put<any>(environment.api + "/api/v1/vertex/"+vertex.id, updateVertexZ, {"headers": this.headers}).subscribe(
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

  updateAttribute(data: any){
    let local_id = this._target_vertex.getAttribute('vertex-id');
    let vertex = this.vertexService.vertices[local_id];
    let update_vertex_attribute = {
      operation: 'attribute',
    };
    if(data['attribute_name'] !== ''){
      // @ts-ignore
      update_vertex_attribute['name'] = data['attribute_name'];
      this.vertex_name_menu = data['attribute_name'];
      vertex.name = this.vertex_name_menu;
      // @ts-ignore
      document.getElementById('tag-'+vertex.local_id).textContent = vertex.name;
    }
    if(data['attribute_min'] !== ''){
      // @ts-ignore
      update_vertex_attribute['estimated_time'] = data['attribute_min']*60 + data['attribute_sec'];
      this.vertex_min_menu = data['attribute_min'];
      this.vertex_sec_menu = data['attribute_sec'];
      vertex.estimated_time = data['attribute_min']*60 + data['attribute_sec'];
    }
    if(data['attribute_clue'] !== ''){
      // @ts-ignore
      update_vertex_attribute['clue'] = data['attribute_clue'];
      this.vertex_clue_menu = data['attribute_clue'];
      // @ts-ignore
      vertex.clue = this.vertex_clue_menu;
    }
    if(data['attribute_description'] !== ''){
      // @ts-ignore
      update_vertex_attribute['description'] = data['attribute_description'];
      this.vertex_description_menu = data['attribute_description'];
      // @ts-ignore
      vertex.description = this.vertex_description_menu;
    }

    this.httpClient.put<any>(environment.api + "/api/v1/vertex/"+vertex.id, update_vertex_attribute, {"headers": this.headers}).subscribe(
      response => {
        if (response.success){
          this.resetAttributeMenuValue();
        }else{
          this.renderAlertError(response.message);
        }
      },
      error => {
        if (error.status === 401){
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        }else {
          this.renderAlertError("There was an Error Updating Vertex Z position");
        }
      }
      //console.error('There was an error while updating the vertex', error)
    );
  }

  updateZoomValue(zoom_val: string, elem2: HTMLLabelElement):void{
    this.zoomValue = Number.parseFloat(zoom_val);
  }

  // ZOOM test
  // TODO: remove from prod
  scale(): void{
    let children = this.escapeRoomDivRef?.nativeElement.childNodes;
    //  go through every html element inside canvas
    for(let child of children){
      // child.getAttribute('')
      // check if room or vertex
      let vertex_id = child.getAttribute('vertex-id');
      if (vertex_id){
        // use vertex_id in service
        let vertex = this.vertexService.vertices[vertex_id];
        let zoomed_x_pos = vertex.pos_x * this.zoomValue;
        let zoomed_y_pos = vertex.pos_y * this.zoomValue;

        child.style.width = (vertex.width * this.zoomValue) + 'px';
        child.style.height = (vertex.height * this.zoomValue) + 'px';
        child.setAttribute('data-x', zoomed_x_pos);
        child.setAttribute('data-y', zoomed_y_pos);
        child.style.transform = 'translate('+ zoomed_x_pos +'px,'+ zoomed_y_pos +'px)';
        // update every line that is connected ez

        this.updateLine(vertex_id);
        // @ts-ignore
        this.updateTag(document.getElementById('tag-'+vertex_id), child);
      }else {
        // check if not a tag
        if (child.id.includes('tag-')) continue;
        // only storing the default on db but no need to call
        // so need to store defaults on element itself, then updating defaults like with a call
        let norm_x = child.getAttribute('data-norm-x');
        let norm_y = child.getAttribute('data-norm-y');
        let norm_width = child.getAttribute('data-norm-width');
        let norm_height = child.getAttribute('data-norm-height');

        child.style.width = (norm_width*this.zoomValue) + 'px';
        child.style.height = (norm_height*this.zoomValue) + 'px';
        child.setAttribute('data-x', norm_x*this.zoomValue);
        child.setAttribute('data-y', norm_y*this.zoomValue);
        child.style.transform = 'translate('+ norm_x*this.zoomValue +'px,'+ norm_y*this.zoomValue +'px)';
      }
    }
  }

  private async delay(ms: number)
  {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  resetAttributeMenuValue(){
    // @ts-ignore
    document.getElementsByName("attribute_name")[0].value = "";
    // @ts-ignore
    document.getElementsByName("attribute_min")[0].value = "";
    // @ts-ignore
    document.getElementsByName("attribute_sec")[0].value = "";
    // @ts-ignore
    document.getElementsByName("attribute_clue")[0].value = "";
    // @ts-ignore
    document.getElementsByName("attribute_description")[0].value = "";
  }

  removeRoom(){
    let room_target_id = this._target_room.getAttribute('room-image-id');
    this.httpClient.delete<any>(environment.api + "/api/v1/room_image/"+room_target_id, {"headers": this.headers}).subscribe(
      response => {
        //remove room image from canvas
        this._target_room.remove();
      },
      error => {
        if (error.status === 401){
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        }else {
          this.renderAlertError("Unable to remove Room");
        }
      }
    );
  }

  // used to change value of linearity for AI
  public changeLinearityValue(elem:HTMLInputElement):void{
    if (elem.checked)
      this.linearity_value = elem.value;
  }

  // used to change value of complexity for AI
  public changeComplexityValue(elem:HTMLInputElement):void{
    if (elem.checked)
      this.complexity_value = elem.value;
  }

  //todo: add host listener here
  public test():void{
    console.log('reere')
    let x = window.innerWidth;
    let y = window.innerHeight;
    let inv_elem = document.getElementById('app-inv');
    let room_list = document.getElementById('escape-room-list');

    console.log(this.escapeRoomDivRef?.nativeElement);
    // @ts-ignore
    this.escapeRoomDivRef?.nativeElement.style.marginLeft = inv_elem.clientWidth + 'px';
    // @ts-ignore
    this.escapeRoomDivRef?.nativeElement.style.width = x - inv_elem.clientWidth + 'px';
    // @ts-ignore
    this.escapeRoomDivRef?.nativeElement.style.height = x - inv_elem.clientHeight + 'px';
    // @ts-ignore
    room_list.style.marginLeft = inv_elem.clientWidth + 'px';
    // @ts-ignore
    room_list.style.width = x - inv_elem.clientWidth + 'px';
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
