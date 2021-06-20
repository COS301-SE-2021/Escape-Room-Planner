import {Component, ElementRef, OnInit, Renderer2, ViewChild} from '@angular/core';
import {BigInteger} from '@angular/compiler/src/i18n/big_integer';
import {HttpClient} from '@angular/common/http';
import {Time} from "@angular/common";

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

  //  if()

    this.lastPos += pos;
    // @ts-ignore
    let newImage = this.renderer.createElement("img"); // create image
    this.renderer.addClass(newImage, "resize-drag");
    this.renderer.setStyle(newImage,"width", "75px");
    this.renderer.setStyle(newImage,"height", "75px");
    this.renderer.setStyle(newImage,"position", "absolute");
    this.renderer.setStyle(newImage,"user-select", "none");
    this.renderer.setStyle(newImage,"transform",'translate('+ this.lastPos +'px, 0px)');
    this.renderer.setAttribute(newImage,"src", "./assets/images/"+loc);
    this.renderer.setAttribute(newImage,"data-x", this.lastPos + "px");
    this.renderer.setAttribute(newImage,"data-y", "0px");
    this.renderer.appendChild(this.escapeRoomDivRef?.nativeElement, newImage);
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
  createVertex(inType: string, inName: string, inGraphicID: string, inPosy: number, inPosx: number, inWidth: number, inHeight: number, inEstimated_time: Time, inDescription: string, inRoomid: number): void{

    //set initial json array for body
    let createVertexBody = {type: inType, name: inName, graphicid: inGraphicID, posy: inPosy, posx: inPosx, width: inWidth, height: inHeight,estimated_time: inEstimated_time, description: inDescription, roomid: inRoomid};

    //make post request for new vertex
    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/vertex/", createVertexBody).subscribe(
      response => {
        //will update vertex ID in html here
        console.log(response);
      },
      error => console.error('There was an error retrieving your rooms', error)
    );

  }

}

interface EscapeRoomArray {
  data: Array<EscapeRoom>;
  status: string;
}

interface EscapeRoom{
  id: number;
}
