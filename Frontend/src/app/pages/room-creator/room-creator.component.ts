import {Component, ElementRef, OnInit, Renderer2, ViewChild} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {tsCreateElement} from '@angular/compiler-cli/src/ngtsc/typecheck/src/ts_util';
import {getLocaleFirstDayOfWeek} from "@angular/common";

// TODO: DO CHECKS IN CASE SOMETHING FAILS TO BE STORED IN RAILS


@Component({
  selector: 'app-room-creator',
  templateUrl: './room-creator.component.html',
  styleUrls: ['./room-creator.component.css']
})
export class RoomCreatorComponent implements OnInit {
  public lastPos : number = 0;
  // @ts-ignore
  public escapeRooms: EscapeRoomArray;
  //todo fix this to be a session?
  public currentRoomId: number = 0;
  public newEscapeRoomName:string = "";

  @ViewChild("escapeRoomDiv") escapeRoomDivRef : ElementRef | undefined;
  @ViewChild("EscapeRoomList") escapeRoomListRef : ElementRef | undefined;

  constructor(private el : ElementRef, private renderer: Renderer2, private httpClient: HttpClient) { }

  ngOnInit(): void {
    //set the currentRoomId to 1 by default, later to actual first room id?
    this.currentRoomId = 3;
    this.getEscapeRooms();
    this.getVertexFromRoom();
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
    this.httpClient.get<EscapeRoomArray>("http://127.0.0.1:3000/api/v1/room/").subscribe(
      response => {
          //rendering <li> elements by using response
          this.escapeRooms = response;
          //render all the rooms
          for (let er of response.data){
            //todo fix this
            this.renderNewRoom(er.id, "fake name for now");
          }
      },
      error => console.error('There was an error retrieving your rooms', error)
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
    //http request to rails api
    this.httpClient.get<VertexArray>("http://127.0.0.1:3000/api/v1/vertex/" + this.currentRoomId).subscribe(
      response => {
       //console.log(response);
        //render all the vertices
        for (let vertex of response.data){
          //spawn objects out;
          this.spawnObjects(vertex.id,vertex.graphicid,vertex.posx,vertex.posy,vertex.width,vertex.height);
        }
      },
      error => console.error('There was an error retrieving vertices for the room', error)
    );
  }

  // POST to create new room for a user
  createEscapeRoom(): void{
    if (this.newEscapeRoomName === "") {
      // todo need to remove all initial spaces here
      alert("Provide name for a room please");
      return; // needs to have a name
    }

    // console.log('created');

    let createRoomBody = {name: this.newEscapeRoomName};
    //http request to rails api
    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/room/", createRoomBody).subscribe(
      response => {
        //rendering <li> elements by using render function
        // console.log(response.data)
        this.renderNewRoom(response.data.id, response.data.name);

      },
      error => console.error('There was an error creating your rooms', error)
    );
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

  //creates Vertex of type with scale at position
  createVertex(inType: string, inName: string, inGraphicID: string, inPosy: number, inPosx: number, inWidth: number, inHeight: number, inEstimated_time: Date, inDescription: string, inRoomid: number, inClue: string): void{

    //set initial json array for body
    let createVertexBody = {type: inType,
                            name: inName,
                            graphicid: inGraphicID,
                            posy: inPosy,
                            posx: inPosx,
                            width: inWidth,
                            height: inHeight,
                            estimated_time: inEstimated_time,
                            description: inDescription,
                            roomid: inRoomid,
                            clue: inClue
    };
    // removes params for puzzle
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
    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/vertex/", createVertexBody).subscribe(
      response => {
        //will update vertex ID in html here
        this.spawnObjects(response.data.id, inGraphicID, this.lastPos, 0, 75, 75);
      },
      error => console.error('There was an error while creating a vertex', error)
    );

  }

  //used to spawn objects onto plane
  spawnObjects(id: number, loc: string, posx: number, posy: number, width: number, height: number): void{

    let newObject = this.renderer.createElement("img"); // create image
    this.renderer.addClass(newObject, "resize-drag");
    // All the styles
    this.renderer.setStyle(newObject,"width", width + "px");
    this.renderer.setStyle(newObject,"height", height + "px");
    this.renderer.setStyle(newObject,"position", "absolute");
    this.renderer.setStyle(newObject,"user-select", "none");
    this.renderer.setStyle(newObject,"transform",'translate('+ posx +'px, '+ posy +'px)');
    // Setting all needed attributes
    this.renderer.setAttribute(newObject,'vertex-id', id.toString());
    this.renderer.setAttribute(newObject,"src", "./assets/images/" + loc);
    this.renderer.setAttribute(newObject,"data-x", posx + "px");
    this.renderer.setAttribute(newObject,"data-y", posy + "px");
    this.renderer.appendChild(this.escapeRoomDivRef?.nativeElement, newObject);
    // Event listener
    this.renderer.listen(newObject,"mouseup", (event) => this.updateVertex(event));
  }

  updateVertex(event: any): void{
    let targetVertex = event.target;

    // console.log(targetVertex.getAttribute('vertex-id'));

    let updateVertexBody = {
      id: targetVertex.getAttribute('vertex-id'),
      posy: targetVertex.getAttribute('data-y'),
      posx: targetVertex.getAttribute('data-x'),
      height: targetVertex.style.height.match(/\d+/)[0],
      width: targetVertex.style.width.match(/\d+/)[0]
    };
    // updates all the data of vertex
    this.httpClient.put<any>("http://127.0.0.1:3000/api/v1/vertex/"+targetVertex.getAttribute('vertex-id'), updateVertexBody).subscribe(
      response => {
        //will update vertex ID in html here
        // console.log(response);
        // console.log('bug');
      },
      error => console.error('There was an error while updating the vertex', error)
    );
  }
}

// For Vertex Response
interface VertexArray {
  data: Array<Vertex>;
  status: string;
}

interface Vertex{
  id: number;
  graphicid: string;
  height: number;
  width: number;
  posx: number;
  posy: number;
}

//for Escape Room Response
interface EscapeRoomArray {
  data: Array<EscapeRoom>;
  status: string;
}

interface EscapeRoom{
  id: number;
}
