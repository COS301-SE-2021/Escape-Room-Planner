import {Component, ElementRef, OnInit, Renderer2, ViewChild} from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent implements OnInit {

  display = 'none';
  constructor(private http:HttpClient) { }
  ngOnInit(): void {}

  onSubmit(data) {

    // if (data["password_digest"] != data["confirm"]){
    //   this.display = 'block';
    //   // userForm.reset();
    // }

    let extra_data = {
      username: data["username"],
      email: data["email"],
      password_digest: data["password_digest"],
      new_password: data["confirm"],
      operation: 'Register'
    };

    this.http.post(' http://127.0.0.1:3000/api/v1/user', extra_data)
      .subscribe((response)=> {
        console.log(response["message"]);
        alert('Success');
      }, error => {
        this.display = 'block';
      })
  }
}

