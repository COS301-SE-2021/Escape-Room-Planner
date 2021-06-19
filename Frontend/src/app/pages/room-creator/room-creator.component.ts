import {Component, ElementRef, OnInit, Renderer2, ViewChild} from '@angular/core';

@Component({
  selector: 'app-room-creator',
  templateUrl: './room-creator.component.html',
  styleUrls: ['./room-creator.component.css']
})
export class RoomCreatorComponent implements OnInit {
  @ViewChild("escapeRoomDiv") escapeRoomDivRef : ElementRef | undefined;

  constructor(private el : ElementRef, private renderer: Renderer2) { }

  ngOnInit(): void {
  }

  // objects: string = "";

  addObjects(type: string, loc: string){
    // @ts-ignore
    this.escapeRoomDivRef?.nativeElement.innerHTML += "<img src='./assets/images/"+loc+"' style='width: 50px; height: 50px;' alt='NOT FOUND' class='resize-drag'>";
    // this.objects+= "<img src='./assets/images/"+loc+"' style='width: 20px; height: 20px;' alt='NOT FOUND' class='resize-drag' appDraggable>";
    // let newImage = this.renderer.createElement("<img src='./assets/images/room1.png' style='width: 20px; height: 20px;' alt='NOT FOUND' class='img-thumbnail w-10' appDraggable>");
    // console.log(newImage);
    // this.renderer.appendChild(this.escapeRoomDivRef?.nativeElement, newImage);
  }

}
