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

  constructor(private http:HttpClient, private router:Router) { }

  ngOnInit(): void {
    // intentionally empty
  }

  onSubmit(data:any) {

    let extra_data = {
      email: data["email"],
      operation: 'Reset Password'
    };

    this.http.post<any>(environment.api + '/api/v1/notification', extra_data)
      .subscribe((response) => {
          this.router.navigate(['/login']).then(r => alert("Success"));
        })
  }
}
