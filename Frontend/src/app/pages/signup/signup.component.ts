import {Component, OnInit, Renderer2, ViewChild} from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent implements OnInit {

  constructor(private http:HttpClient) { }

  ngOnInit(): void {}

  onSubmit(data) {
    this.http.post(' http://127.0.0.1:3035/api/v1/user', data)
      .subscribe((response)=> {
        // response.token
        alert('Success');
      })
  }
}

