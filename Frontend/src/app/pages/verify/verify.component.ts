import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

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

    this.http.post<any>(' http://127.0.0.1:3000/api/v1/user', extra_data)
      .subscribe((response) => {
          this.router.navigate(['/']).then(r => alert("Success"));
        },
        error => {
          this.display = 'block';
        })
  }
}
