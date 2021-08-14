import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-reset-password-not',
  templateUrl: './reset-password-not.component.html',
  styleUrls: ['./reset-password-not.component.css']
})
export class ResetPasswordNotComponent implements OnInit {

  constructor(private http:HttpClient, private router:Router) { }

  ngOnInit(): void {
  }

  onSubmit(data:any) {

    let extra_data = {
      email: data["email"],
      operation: 'reset_password_notification'
    };

    this.http.post<any>(' http://127.0.0.1:3000/api/v1/user', extra_data)
      .subscribe((response) => {
          // this.router.navigate(['/']).then(r => alert("Success"));
        })
  }
}
