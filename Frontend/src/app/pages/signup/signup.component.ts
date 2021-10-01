import {Component, OnInit, Renderer2, ViewChild} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import {delay} from "rxjs/operators";
import {environment} from "../../../environments/environment";

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent implements OnInit {
  public usernameEmpty: boolean = false;
  public passwordEmpty: boolean = false;
  public emailEmpty: boolean = false;
  public confirmEmpty: boolean = false;

  constructor(private http:HttpClient, private router:Router) { }
  ngOnInit(): void {}
  display = 'none';
  errorMessage = "";

  checkSomething(pass: string, cpassword: string) {
    if (pass != cpassword) {
      this.errorMessage = "Password does not match.";
    } else this.errorMessage = "";
  }


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

    this.http.post<any>(environment.api + '/api/v1/user', extra_data)
      .subscribe((response)=> {
          sessionStorage.setItem("email", data["email"]);
          this.router.navigate(['/verify']).then(r => {
            console.log("Success");
          });
      },
          error => {

            if(data["username"] === "")
            {
              this.usernameEmpty = true
            }
            if(!data["password"])
            {
              this.passwordEmpty = true
            }
            if(data["email"] === "")
            {
              this.emailEmpty = true
            }
            if(data["confirm"] === "")
            {
              this.confirmEmpty = true
            }
            if (error["message"] == "User already exists")
              this.display = 'block';
        })
  }
}

