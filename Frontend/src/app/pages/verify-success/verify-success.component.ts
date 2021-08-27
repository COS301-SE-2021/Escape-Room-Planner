import { Component, OnInit } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {ActivatedRoute, Router} from "@angular/router";

@Component({
  selector: 'app-verify-success',
  templateUrl: './verify-success.component.html',
  styleUrls: ['./verify-success.component.css']
})
export class VerifySuccessComponent implements OnInit {

  token: string | undefined;

  constructor(private http:HttpClient, private router:Router, private route: ActivatedRoute) { }

  ngOnInit(): void {
    this.route.queryParams.subscribe(params => {
      this.token = params.token;
    });

    let extra_data = {
      encoded_token: this.token,
      operation: 'check_expiration'
    }

    //This sends the encoded token to a controller in notification that checks if the token is expired
    this.http.post<any>(' http://127.0.0.1:3000/api/v1/notification', extra_data)
      .subscribe((response) => {
        console.log("token not expired")
        //  basically allow reset password to continue if the token has not expired
      },error => {
        //for now i redirect to login
        console.log(this.token);
        this.router.navigate(['/verify-failure'], {state: { token: this.token}}).then(r => alert("Expired"));
      })

    let verify_data = {
      verify_token: this.token,
      operation: 'verify_account'
    }

    this.http.post<any>(' http://127.0.0.1:3000/api/v1/user', verify_data)
      .subscribe((response) => {
        console.log('Verification successful')
        },
        error => {
          this.router.navigate(['/verify-failure'], {state: { token: this.token}}).then(r => alert("oops"));
        })
  }
}
