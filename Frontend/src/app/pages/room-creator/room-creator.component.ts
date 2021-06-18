import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-room-creator',
  templateUrl: './room-creator.component.html',
  styleUrls: ['./room-creator.component.css']
})
export class RoomCreatorComponent implements OnInit {
  canvasHeight = 100;
  canvasWidth = 100;

  constructor() { }

  ngOnInit() {
    console.log(window.innerHeight);
    console.log(window.outerHeight);

    // this.canvasHeight = window.innerHeight;
    // this.canvasWidth = window.innerWidth;
  }

}
