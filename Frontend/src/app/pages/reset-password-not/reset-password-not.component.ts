import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import {environment} from "../../../environments/environment";

@Component({
  selector: 'app-reset-password-not',
  templateUrl: './reset-password-not.component.html',
  styleUrls: ['./reset-password-not.component.css']
})
export class ResetPasswordNotComponent implements OnInit {

  public emailError: boolean = false;

  constructor(private http:HttpClient, private router:Router) { }

  ngOnInit(): void {
  }

  onSubmit(data:any) {
    this.resetBool();

    let extra_data = {
      email: data["email"],
      operation: 'Reset Password'
    };

    this.http.post<any>(environment.api + '/api/v1/notification', extra_data)
      .subscribe((response) => {
          this.router.navigate(['/login']).then(r => console.log("success"));
        }, error => {

          if(error["error"]["message"] === "Email does not exist")
            this.emailError = true
          else
            console.log(error)
      })
  }

  private resetBool()
  {
    this.emailError = false;

  }
}
