import {Component, OnInit} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(private http:HttpClient, private router:Router) { }

  ngOnInit() {
  }

  display = 'none';
  onSubmit(data:any) {
    this.display = 'none';
    let extra_data = {
      username: data["username"],
      password: data["password_digest"],
      operation: 'Login'
    };

    this.http.post<any>(' http://127.0.0.1:3000/api/v1/user', extra_data)
      .subscribe(
        res => {
            localStorage.setItem('username', extra_data.username);
            localStorage.setItem('token', res["auth_token"]);
            this.router.navigate(['/escape-room']).then(r => console.log("Success"));
        },
          error => {
            this.display = 'block';
          }
        )
  }

}
