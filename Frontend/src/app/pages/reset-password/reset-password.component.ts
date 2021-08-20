import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import {ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-reset-password',
  templateUrl: './reset-password.component.html',
  styleUrls: ['./reset-password.component.css']
})
export class ResetPasswordComponent implements OnInit {

  constructor(private http:HttpClient, private router:Router, private route: ActivatedRoute) { }

  display = 'none';

  errorMessage = "";

  checkSomething(pass: string, cpassword: string) {
    if (pass != cpassword) {
      this.errorMessage = "Password does not match.";
    } else this.errorMessage = "";
  }

  ngOnInit(): void {
    let token = null;
    //This fetches and stores the encoded token from the url
    this.route.queryParams.subscribe(params => {
      token = params.token;
    });

    let extra_data = {
      encoded_token: token,
      operation: 'check_expiration'
    }

    //This sends the encoded token to a controller in notification that checks if the token is expired
    this.http.post<any>(' http://127.0.0.1:3000/api/v1/notification', extra_data)
      .subscribe((response) => {
        console.log("token not expired")
      //  basically allow reset password to continue if the token has not expired
      },error => {
        //for now i redirect to login
        this.router.navigate(['/login']).then(r => alert("Expired"));
      })
  }

  onSubmit(data:any) {

    let extra_data = {
      username: data["username"],
      new_password: data["password_digest"],
      operation: 'reset_password'
    };

    this.http.post<any>(' http://127.0.0.1:3000/api/v1/user', extra_data)
      .subscribe((response) => {
          this.router.navigate(['/login']).then(r => alert("Success"));
        },
        error => {
          this.display = 'block';
        })
  }

}
