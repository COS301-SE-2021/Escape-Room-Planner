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

  ngOnInit(){
    // todo make a verification of jwt here and make redirect based on that
  }

  title = 'EscapeRoomPlanner';
}
