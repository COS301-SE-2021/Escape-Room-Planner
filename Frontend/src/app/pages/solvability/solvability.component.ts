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

  setRoom(room_id: number){
    this._current_room_id = room_id;
  }

  getInitialVertices():void{
    this.httpClient.get<any>("http://127.0.0.1:3000/api/v1/room/"+this._current_room_id, {"headers": this.headers}).subscribe(
      response => {

        // @ts-ignore
        document.getElementById("Start-Vertex-label").innerHTML = "Start Vertex: "+ response.data.startVertex;
        this._target_start=response.data.startVertex;

        // @ts-ignore
        document.getElementById("End-Vertex-label").innerHTML = "End Vertex: "+response.data.endVertex;
        this._target_end=response.data.endVertex
      },
      //Render error if bad request
      error => alert('There was an error retrieving the start vertices')
    );
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

        if(response.data.solvable==false){
         if(response.data.reason === "No reason given")
           window.alert('Could not find connection between objects')
          else
          window.alert(response.data.reason)
        }
      },
      error => console.error('', error)
    );
  }

  setSolvability(input: any): void{
    this.checkPaths()
    if(input){
      // @ts-ignore
      this.solve_div?.nativeElement.setAttribute('class', 'modal-body rounded border border-4 border-success bg-dark');
      // @ts-ignore
      document.getElementById("Start-Vertex-label").innerText="Start Vertex: "+this._target_start
      // @ts-ignore
      document.getElementById("End-Vertex-label").innerText="End Vertex: "+this._target_end
      // @ts-ignore
      document.getElementById("Solvable").innerHTML="Solvable: True"
    }else{
      // @ts-ignore
      this.solve_div?.nativeElement.setAttribute('class', 'modal-body rounded border border-4 border-danger bg-dark');
      // @ts-ignore
      document.getElementById("Solvable").innerHTML="Solvable: False"
      // @ts-ignore
      document.getElementById("Start-Vertex-label").innerText="Start Vertex: "+this._target_start
      // @ts-ignore
      document.getElementById("End-Vertex-label").innerText="End Vertex: "+this._target_end
    }
  }

  checkPaths(){
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

    let PathsCheck = {
      operation: "ReturnPaths",
      roomid: this._current_room_id
    };

    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/solvability/", PathsCheck, {"headers": this.headers}).subscribe(
      response => {
        //rendering <li> elements by using render function
        response.data.vertices.forEach(
          (value: any) => {
            window.alert(value)
          }
        )
      },
      error => console.error('', error)
    );


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
