import {Component, OnInit, ElementRef, ViewChild} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {HttpHeaders} from "@angular/common/http";
import {environment} from "../../../environments/environment";
import {DependencyDiagramComponent} from "../dependency-diagram/dependency-diagram.component";
import {VertexService} from "../../services/vertex.service";

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
  @ViewChild(DependencyDiagramComponent) diagramComponent: DependencyDiagramComponent | undefined;

  public error_message = "";
  public start_vertex_name = "none";
  public end_vertex_name = "none";
  public estimated_time = "none";

  constructor(private el: ElementRef, private httpClient: HttpClient, private vertexService: VertexService) {
    this.headers = this.headers.set('Authorization1', 'Bearer ' + localStorage.getItem('token'))
      .set("Authorization2", 'Basic ' + localStorage.getItem('username'));
  }

  ngOnInit(): void {
    this._current_room_id = -1;
  }

  setRoom(room_id: number) {
    this._current_room_id = room_id;
  }

  getInitialVertices(): void {
    if (this._current_room_id !== -1) {
      let start_vertex = this.vertexService.vertices[this.vertexService.start_vertex_id];
      let end_vertex = this.vertexService.vertices[this.vertexService.end_vertex_id];

      this._target_start = start_vertex.id;
      this.start_vertex_name = start_vertex.name;
      this._target_end = end_vertex.id;
      this.end_vertex_name = end_vertex.name;
    }
  }

  checkSolvable(target_start: HTMLElement, target_end: HTMLElement, current_room_id: Number) {
    this.getInitialVertices();
    this._target_start = target_start;
    this._target_end = target_end;
    this._current_room_id = current_room_id
    this.checkStartEndVertex();


    let SolvableCheck = {
      operation: "Solvable",
      startVertex: target_start,
      endVertex: target_end,
      roomid: this._current_room_id
    };

    // @ts-ignore
    this.solve_div?.nativeElement.hidden = false;

    this.httpClient.post<any>(environment.api + "/api/v1/solvability/", SolvableCheck, {"headers": this.headers}).subscribe(
      response => {
        //rendering <li> elements by using render function
        this.setSolvability(response.data.solvable);
        this.error_message = "";
        if (response.data.solvable == false) {
          if (response.data.reason === "No reason given")
            this.error_message = "Could not find connection between objects";
          else
            this.error_message = response.data.reason;
        }
      },
      error => console.error('', error)
    );
  }

  setSolvability(input: any): void {
    this.checkPaths()
    this.checkUnnecessary()
    this.checkEstimatedTime()
    if (input) {
      // @ts-ignore
      this.solve_div?.nativeElement.setAttribute('class', 'modal-body rounded border border-4 border-success bg-dark');
      // @ts-ignore
      document.getElementById("Solvable").innerHTML = "Solvable: True"
    } else {
      // @ts-ignore
      this.solve_div?.nativeElement.setAttribute('class', 'modal-body rounded border border-4 border-danger bg-dark');
      // @ts-ignore
      document.getElementById("Solvable").innerHTML = "Solvable: False"
    }
  }

  display(Parameters: any, reason: any) {
    let final = ''
    this.httpClient.post<any>(environment.api + "/api/v1/solvability/", Parameters, {"headers": this.headers}).subscribe(
      response => {
        //rendering <li> elements by using render function
        if (reason == "Paths") {
          let i = 1;
          response.data.vertices.forEach(
            (value: any) => {
              if (reason == "Paths") {
                let int_array = this.vertexService.convertToLocalID(value.split(","));
                final += i + ": ";
                for (let vertex_id of int_array) {
                  final += this.vertexService.vertices[vertex_id].name + ", ";
                }
                // @ts-ignore
                final += "<br>";
                i++;
              }
            }
          )
          // @ts-ignore
          document.getElementById("possible_paths").innerHTML = "Possible Paths: <br>" + final;
        }

        if (reason == "Time") {
          // @ts-ignore
          this.estimated_time = Math.round(response.data.time / 60) + " min";
        }
      },
      error => console.error('', error)
    );
  }

  checkUnnecessary() {
    if (this.checkStartEndVertex()) {

      let FindUnnecessary = {
        operation: "FindUnnecessary",
        roomid: this._current_room_id
      };

      this.display(FindUnnecessary, "Unnecessary")
    }
  }

  checkEstimatedTime() {
    if (this.checkStartEndVertex()) {
      let PathsCheck = {
        operation: "EstimatedTime",
        roomid: this._current_room_id
      };
      this.display(PathsCheck, "Time")
    }
  }

  checkPaths() {
    if (this.checkStartEndVertex()) {

      let PathsCheck = {
        operation: "ReturnPaths",
        roomid: this._current_room_id
      };

      this.display(PathsCheck, "Paths")
    }
  }

  generateDiagram(): void {
    this.diagramComponent?.generate();
  }

  checkStartEndVertex(): boolean {
    this.error_message = "";
    if (this._target_start == null) {
      this.setSolvability(false);
      this.error_message = "set a start vertex first";
      return false;
    }

    if (this._target_end == null) {
      this.setSolvability(false);
      this.error_message = "set an end vertex first";
      return false;
    }
    return true;
  }

}
