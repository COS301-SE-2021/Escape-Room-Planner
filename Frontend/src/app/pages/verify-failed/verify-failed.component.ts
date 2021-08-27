import { Component, OnInit } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Router} from "@angular/router";

@Component({
  selector: 'app-verify-failed',
  templateUrl: './verify-failed.component.html',
  styleUrls: ['./verify-failed.component.css']
})
export class VerifyFailedComponent implements OnInit {

  constructor(private http:HttpClient, private router:Router) { }

  ngOnInit(): void {
  }

  onSubmit(data:any) {


    let extra_data = {
      email: data["email"],
      operation: 'Verify Account'
    };

    this.http.post<any>(' http://127.0.0.1:3000/api/v1/notification', extra_data)
      .subscribe((response) => {
          this.router.navigate(['/login']).then(r => alert("Success"));
        },
        error => {
          alert("Error sending the email please try again")
        })
  }

}
