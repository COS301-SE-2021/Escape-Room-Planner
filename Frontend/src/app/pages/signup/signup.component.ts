import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent implements OnInit {

  constructor(private http:HttpClient) { }

  ngOnInit(): void {
    console.warn("Wassup Bitches");
  }

  onSubmit(data) {
    this.http.post(' http://127.0.0.1:3035/api/v1/user', data)
      .subscribe((result)=> {
        console.warn("Results: ", result);
      })
    console.warn(data);
  }
}

