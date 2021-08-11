import {Component, ElementRef, OnInit, ViewChild} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {Router} from "@angular/router";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(private http:HttpClient, private router:Router) { }

  display = 'none';
  ngOnInit() {
  }

  onSubmit(data) {
    let extra_data = {
      username: data["username"],
      password_digest: data["password_digest"],
      operation: 'Login'
    };

    this.http.post(' http://127.0.0.1:3000/api/v1/user', extra_data)
      .subscribe(
        res => {
            localStorage.setItem('token', res["auth_token"]);
            this.router.navigate(['/']).then(r => alert("login test"));
        },
        error => {
            console.log(error["message"])
            this.display = 'block';
        })
  }

}
