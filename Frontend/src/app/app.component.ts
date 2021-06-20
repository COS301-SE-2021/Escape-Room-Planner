import { Component } from '@angular/core';
import {HttpClient} from "@angular/common/http";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {

  constructor(private http: HttpClient) {

  }

  async ngOnInit(){
    let resp= this.http.get('http://127.0.0.1:3000/api/v1/vertex/');
    resp.subscribe((response)=>console.log(response));
  }

  title = 'NewEscapeRoomPlanner';
}
