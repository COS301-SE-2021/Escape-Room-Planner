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
    this.objects+= "<img src='./assets/images/room1.png' style='width: 20px; height: 20px;' alt='NOT FOUND' class='img-thumbnail w-10' appDraggable>";
  }

}
