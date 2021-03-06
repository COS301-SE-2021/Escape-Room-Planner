import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import {environment} from "../../../environments/environment";

@Component({
  selector: 'app-verify',
  templateUrl: './verify.component.html',
  styleUrls: ['./verify.component.css']
})
export class VerifyComponent implements OnInit {

  constructor(private http:HttpClient, private router:Router) { }

  display = 'none';

  ngOnInit(): void {
  }

  onSubmit(data:any) {
    this.display = 'none';

    let extra_data = {
      username: data["username"],
      operation: 'Verify'
    };

    this.http.post<any>(environment.api + '/api/v1/user', extra_data)
      .subscribe((response) => {
          this.router.navigate(['/']).then(r => alert("Success"));
        },
        error => {
          this.display = 'block';
        })
  }

  resendVerifyEmail()
  {
    let extra_data = {
      email: sessionStorage.getItem("email"),
      operation: 'Verify Account'
    };

    this.http.post<any>(environment.api + '/api/v1/notification', extra_data)
      .subscribe((response) => {
          console.log("successful");
        },
        error => {
          alert("Error sending the email please try again")
        })
  }
}
