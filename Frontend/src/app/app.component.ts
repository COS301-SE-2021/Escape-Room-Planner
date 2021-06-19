import { Component } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import * as cors from 'cors';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  constructor(private http: HttpClient) {
  }

  ngOnInit(){

    let resp=this.http.get('http://127.0.0.1:3000/api/v1/room')
    resp.subscribe(()=>console.log(
      'received the response'
    ))
  }

  title = 'app';
}
