import {Component, OnInit} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import {environment} from "../../../environments/environment";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(private http:HttpClient, private router:Router) { }

  ngOnInit() {
    // intentionally empty
  }

  display = 'none';
  onSubmit(data:any) {
    this.display = 'none';
    let extra_data = {
      username: data["username"],
      password: data["password_digest"],
      operation: 'Login'
    };

    this.http.post<any>(environment.api + '/api/v1/user', extra_data)
      .subscribe(
        res => {
            localStorage.setItem('username', extra_data.username);
            localStorage.setItem('token', res["auth_token"]);
            this.router.navigate(['/escape-room']).then(r => location.reload());
        },
          error => {
            this.display = 'block';
          }
        )
  }

}
