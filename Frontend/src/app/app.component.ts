import { Component } from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {Router} from "@angular/router";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  private headers: HttpHeaders = new HttpHeaders();
  private  is_valid_user = false;

  constructor(private httpClient: HttpClient, private router: Router) {

  }

  ngOnInit(){
    this.verifyJWT();
  }

  verifyJWT(): void{
    this.headers = this.headers.set("Authorization",'Bearer ' + localStorage.getItem('token') as string);

    let request_body = {
      operation: 'Verify'
    };

    this.httpClient.post<any>('http://127.0.0.1:3000/api/v1/user', request_body, {"headers": this.headers}).subscribe(
      response => {
        // response so go to escape room planner
        this.is_valid_user = true;
        this.router.navigate(['escape-room']).then(r => console.log('already logged in'));
      },
      error => {
        if (error.status === 401){
          this.is_valid_user = false;
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        }else alert("Something went wrong");
      }
    );
  }

  isUserValid(): boolean{
    return this.is_valid_user;
  }

  quit(): void{
    this.is_valid_user = false;
    localStorage.clear();
    this.router.navigate(['login']).then(r => console.log('user quit'));
  }

  title = 'EscapeRoomPlanner';
}
