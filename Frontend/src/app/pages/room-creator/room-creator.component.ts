import {Component, ElementRef, OnInit, Renderer2, ViewChild} from '@angular/core';
import {BigInteger} from '@angular/compiler/src/i18n/big_integer';

@Component({
  selector: 'app-room-creator',
  templateUrl: './room-creator.component.html',
  styleUrls: ['./room-creator.component.css']
})
export class RoomCreatorComponent implements OnInit {
  public lastPos : number = 0;

  @ViewChild("escapeRoomDiv") escapeRoomDivRef : ElementRef | undefined;

  constructor(private el : ElementRef, private renderer: Renderer2) { }

  ngOnInit(): void {
  }

  // objects: string = "";

  addObjects(type: string, loc: string, pos: number){
    this.lastPos += pos;
    // @ts-ignore
    // this.escapeRoomDivRef?.nativeElement.innerHTML += "<img src='./assets/images/"+loc+"' style='width: 50px; height: 50px;' alt='NOT FOUND' appDraggable>";
    // this.objects+= "<img src='./assets/images/"+loc+"' style='width: 20px; height: 20px;' alt='NOT FOUND' class='resize-drag' appDraggable>";
    //"<img src='./assets/images/room1.png' style='width: 20px; height: 20px;' alt='NOT FOUND' class='img-thumbnail w-10' appDraggable>"
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

}
