import {ChangeDetectorRef, Component, ElementRef, ViewChild} from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {NavigationEnd, Router} from "@angular/router";

// TODO: just render the list at this point, idk how else to fix this, need to time reload to happen exactly once after login, at least quit is working

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  private headers: HttpHeaders = new HttpHeaders();
  private is_valid_user = false;

  //todo

  constructor(private httpClient: HttpClient, private router: Router, private cdr: ChangeDetectorRef) {

  }

  ngOnInit(){
    this.verifyJWT();

    this.router.events.subscribe(event =>{
      if (event instanceof NavigationEnd){
        this.cdr.detectChanges();
      }
    });
  }

  isUserValid(): boolean{
    return this.is_valid_user;
  }

  verifyJWT(): void{
    this.headers = this.headers.set("Authorization1",'Bearer ' + localStorage.getItem('token'))
      .set("Authorization2",'Basic ' + localStorage.getItem('username'));

    let request_body = {
      operation: 'Verify'
    };

    this.httpClient.post<any>('http://127.0.0.1:3000/api/v1/user', request_body, {"headers": this.headers}).subscribe(
      response => {
        this.cdr.detectChanges();
        // response so go to escape room planner
        this.is_valid_user = true;
        this.router.navigate(['escape-room']).then(r => console.log('already logged in'));
      },
      error => {
        if (error.status === 401){
          this.is_valid_user = false;
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !=='/reset-not' &&
            this.router.routerState.snapshot.url !=='/escape' &&
            this.router.routerState.snapshot.url !=='/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        }else alert("Something went wrong");
      }
    );
  }

  quit(): void{
    this.is_valid_user = false;
    localStorage.clear();
    location.reload();
    this.router.navigate(['login']).then(r => console.log('user quit'));
  }

  title = 'EscapeRoomPlanner';
}
