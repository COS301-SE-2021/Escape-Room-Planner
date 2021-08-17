import {Component, OnInit, ElementRef, ViewChild} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {HttpHeaders} from "@angular/common/http";

@Component({
  selector: 'app-solvability',
  templateUrl: './solvability.component.html',
  styleUrls: ['./solvability.component.css']
})

export class SolvabilityComponent implements OnInit {

  private headers: HttpHeaders = new HttpHeaders();
  private _target_end: any;
  private _target_start: any;
  private _current_room_id: any;

  @ViewChild("solve_div") solve_div: ElementRef | undefined;

  constructor(private el : ElementRef, private httpClient: HttpClient) {
    this.headers = this.headers.set('Authorization1', 'Bearer ' + localStorage.getItem('token'))
      .set("Authorization2",'Basic ' + localStorage.getItem('username'));
  }

  ngOnInit(): void {
  }

  checkSolvable(target_start: HTMLElement, target_end: HTMLElement, current_room_id: Number){
    this._target_start = target_start;
    this._target_end = target_end;
    this._current_room_id = current_room_id
    if(this._target_start==null){
      this.setSolvability(false);
      window.alert('set a start vertex first');
      return;
    }

    if(this._target_end==null){
      this.setSolvability(false);
      window.alert('set an end vertex first');
      return;
    }

    let SolvableCheck = {
      operation: "Solvable",
      startVertex: target_start,
      endVertex: target_end,
      roomid: this._current_room_id
    };

    // @ts-ignore
    this.solve_div?.nativeElement.hidden = false;

    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/solvability/", SolvableCheck, {"headers": this.headers}).subscribe(
      response => {
        //rendering <li> elements by using render function
        this.setSolvability(response.data.solvable);
      },
      error => console.error('', error)
    );
  }

  setSolvability(input: any): void{
    if(input){
      // @ts-ignore
      document.getElementById("Solvability-panel").style.backgroundColor="green"
      // @ts-ignore
      document.getElementById("Solvable").innerHTML="Solvable: True"
    }else{
      // @ts-ignore
      document.getElementById("Solvability-panel").style.backgroundColor="red"
      // @ts-ignore
      document.getElementById("Solvable").innerHTML="Solvable: False"
    }
  }

  checkSetupOrder() {
    if(this._target_start==null){
      window.alert('set a start vertex first')
      return
    }

    if(this._target_end==null){
      window.alert('set an end vertex first')
      return
    }

    let SolvableCheck = {
      operation: "Solvable",
      startVertex: this._target_start,
      endVertex: this._target_end,
      roomid: this._current_room_id
    };

    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/solvability/", SolvableCheck, {"headers": this.headers}).subscribe(
      response => {
        //rendering <li> elements by using render function
        console.log(response)
        if (response.data.solvable==true){
        }else {
          this.setSolvability(false);
        }


      },
      error => console.error('', error)
    );

    let setUpOrderCheck = {
      operation: "Setup",
      startVertex: this._target_start,
      endVertex: this._target_end,
      roomid: this._current_room_id
    };

    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/solvability/", setUpOrderCheck, {"headers": this.headers}).subscribe(
      resp => {
        console.log(resp)
      //  let order =[]
      //  let i=0


        if(resp.data.status=="Success"){
          // @ts-ignore
          document.getElementById("SetupOrder").innerHTML="Set up order: "+resp.data.order;
          /* resp.data.order.forEach(
             (value: any) => {
              this.httpClient.get<any>("http://127.0.0.1:3000/api/v1/vertex/"+value).subscribe(
                 resp => {
                   console.log(resp)
                 }
             )
             } )*/
        }else {
          window.alert('Unknown failure')
        }
      },
      error => console.error('', error)
    );


  }

}
