import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-reset-password',
  templateUrl: './reset-password.component.html',
  styleUrls: ['./reset-password.component.css']
})
export class ResetPasswordComponent implements OnInit {

  constructor(private http:HttpClient, private router:Router) { }

  display = 'none';

  errorMessage = "";

  checkSomething(pass: string, cpassword: string) {
    if (pass != cpassword) {
      this.errorMessage = "Password does not match.";
    } else this.errorMessage = "";
  }

  ngOnInit(): void {
  }

  onSubmit(data:any) {
    this.display = 'none';

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
