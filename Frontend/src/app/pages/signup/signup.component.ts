import { Component, OnInit } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent implements OnInit {

  constructor() { http:HttpClientModule}

  ngOnInit(): void {

  }

  onSubmit(data) {
    console.warn(data)
  }
}

