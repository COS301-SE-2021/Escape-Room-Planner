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
    let extra_data = {
      username: data["username"],
      email: data["email"],
      password_digest: data["password_digest"],
      operation: 'Register'
    };

    this.http.post(' http://127.0.0.1:3000/api/v1/user', extra_data)
      .subscribe((response)=> {
        // response.token
        alert('Success');
      })
  }
}

