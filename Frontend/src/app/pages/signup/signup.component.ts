import {Component, OnInit, Renderer2, ViewChild} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent implements OnInit {

  constructor(private http:HttpClient, private router:Router) { }
  display = ' none'
  ngOnInit(): void {}

  onSubmit(data:any) {
    this.display = 'none';
    let extra_data = {
      username: data["username"],
      email: data["email"],
      password: data["password_digest"],
      new_password: data["confirm"],
      operation: 'Register'
    };
    console.log(extra_data);

    this.http.post<any>(' http://127.0.0.1:3000/api/v1/user', extra_data)
      .subscribe((response)=> {
          this.router.navigate(['/login']).then(r => alert("Success"));
      },
          error => {
            this.display = 'block';
        })
  }
}

