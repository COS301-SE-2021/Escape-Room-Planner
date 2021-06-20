import {Component, ElementRef, OnInit, Renderer2, ViewChild} from '@angular/core';
import {HttpClient} from '@angular/common/http';

@Component({
  selector: 'app-room-creator',
  templateUrl: './room-creator.component.html',
  styleUrls: ['./room-creator.component.css']
})
export class RoomCreatorComponent implements OnInit {
  public lastPos : number = 0;
  // @ts-ignore
  public escapeRooms: EscapeRoomArray;

  @ViewChild("escapeRoomDiv") escapeRoomDivRef : ElementRef | undefined;
  @ViewChild("EscapeRoomList") escapeRoomListRef : ElementRef | undefined;

  constructor(private el : ElementRef, private renderer: Renderer2, private httpClient: HttpClient) { }

  ngOnInit(): void {
    this.getEscapeRooms();
  }

  //adds an object to drag on our 'canvas'
  addObjects(type: string, loc: string, pos: number): void{
    this.lastPos += pos;

    //MAKE API CALL BASED ON TYPE
    let name : string = "Object";       //default name
    let description : string = "Works";  //default description
    this.createVertex(type, name, loc, 0, this.lastPos, 75, 75, new Date(), description, 1);

    //spawns object on plane
    this.spawnObjects(type, loc, this.lastPos, 0, 75, 75);
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
            this.renderNewRoom(er.id);
          }
      },
      error => console.error('There was an error retrieving your rooms', error)
    );
  }

  // POST to create new room for a user
  createEscapeRoom(): void{
    let createRoomBody = {};
    //http request to rails api
    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/room/", createRoomBody).subscribe(
      response => {
        //rendering <li> elements by using render function
        this.renderNewRoom(response.data);
      },
      error => console.error('There was an error retrieving your rooms', error)
    );
  }

  //just renders new room text
  renderNewRoom(id:number): void{
    // <li><a class="dropdown-item">ROOM 1</a></li>-->
    let newRoom = this.renderer.createElement('li');
    let newTag = this.renderer.createElement('a');
    // add bootstrap class to <a>
    this.renderer.addClass(newTag,'dropdown-item');
    this.renderer.appendChild(newTag, this.renderer.createText("Room " + id));
    // make it <li><a>
    this.renderer.appendChild(newRoom,newTag);
    // append to the dropdown menu
    this.renderer.appendChild(this.escapeRoomListRef?.nativeElement, newRoom);
  }

  //creates Vertex of type with scale at position
  createVertex(inType: string, inName: string, inGraphicID: string, inPosy: number, inPosx: number, inWidth: number, inHeight: number, inEstimated_time: Date, inDescription: string, inRoomid: number): void{

    //set initial json array for body
    let createVertexBody = {type: inType, name: inName, graphicid: inGraphicID, posy: inPosy, posx: inPosx, width: inWidth, height: inHeight,estimated_time: inEstimated_time, description: inDescription, roomid: inRoomid};

    if(inType != "Puzzle"){
      // @ts-ignore
      delete  createVertexBody.description;
      // @ts-ignore
      delete  createVertexBody.estimated_time;
    }


    //make post request for new vertex
    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/vertex/", createVertexBody).subscribe(
      response => {
        //will update vertex ID in html here
        console.log(response);
      },
      error => console.error('There was an error retrieving your rooms', error)
    );

  }

  //used to spawn objects onto plane
  spawnObjects(type: string, loc: string, posx: number, posy: number, width: number, height: number): void{

    let newObject = this.renderer.createElement("img"); // create image
    this.renderer.addClass(newObject, "resize-drag");
    this.renderer.setStyle(newObject,"width", width + "px");
    this.renderer.setStyle(newObject,"height", height + "px");
    this.renderer.setStyle(newObject,"position", "absolute");
    this.renderer.setStyle(newObject,"user-select", "none");
    this.renderer.setStyle(newObject,"transform",'translate('+ posx +'px, '+ posy +'px)');
    this.renderer.setAttribute(newObject,"src", "./assets/images/" + loc);
    this.renderer.setAttribute(newObject,"data-x", posx + "px");
    this.renderer.setAttribute(newObject,"data-y", posy + "px");
    this.renderer.appendChild(this.escapeRoomDivRef?.nativeElement, newObject);
  }


}

interface EscapeRoomArray {
  data: Array<EscapeRoom>;
  status: string;
}

interface EscapeRoom{
  id: number;
}
