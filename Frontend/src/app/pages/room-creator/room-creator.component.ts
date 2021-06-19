import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-room-creator',
  templateUrl: './room-creator.component.html',
  styleUrls: ['./room-creator.component.css']
})
export class RoomCreatorComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

  objects: string = "";

  addObjects(type: string, loc: string){
    this.objects+= "<img src='./assets/images/"+loc+"' style='width: 20px; height: 20px;' alt='NOT FOUND' class='resize-drag' appDraggable>";
  }

}
