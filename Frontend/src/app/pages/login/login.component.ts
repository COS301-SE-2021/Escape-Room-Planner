import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(private http:HttpClient) { }

  ngOnInit() {
  }

  onSubmit(data) {
    this.http.post(' http://127.0.0.1:3035/api/v1/login', data)
      .subscribe(
        res => {
            console.log(res)
            // localStorage.setItem('token',);
        })
  }

}
