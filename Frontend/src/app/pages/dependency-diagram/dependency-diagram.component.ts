import { Component, OnInit } from '@angular/core';
import {VertexService} from "../../services/vertex.service";
import {HttpClient, HttpHeaders} from "@angular/common/http";
import any = jasmine.any;

@Component({
  selector: 'app-dependency-diagram',
  templateUrl: './dependency-diagram.component.html',
  styleUrls: ['./dependency-diagram.component.css']
})
export class DependencyDiagramComponent implements OnInit {

  ngOnInit(): void {}

  private _current_room_id: any;
  private _target_start: any;
  private _target_end: any;
  private headers: HttpHeaders = new HttpHeaders();

  constructor(private httpClient: HttpClient) {
    this.headers = this.headers.set('Authorization1', 'Bearer ' + localStorage.getItem('token'))
      .set("Authorization2",'Basic ' + localStorage.getItem('username'));
  }

  setRoom(room_id: number){
    this._current_room_id = room_id;
  }

  getVertices():void {
    this.httpClient.get<any>("http://127.0.0.1:3000/api/v1/room/"+this._current_room_id, {"headers": this.headers}).subscribe(
      response => {
        this._target_start = response.data.startVertex;
        this._target_end = response.data.startVertex;
      });
  }

  checkSetUp(): void {
    let setUpOrderCheck = {
      operation: "Setup",
      startVertex: this._target_start,
      endVertex: this._target_end,
      roomid: this._current_room_id
    };

    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/solvability/", setUpOrderCheck, {"headers": this.headers}).subscribe(
      resp => {

      });
  }

}
