import {Component, ElementRef, OnInit, Renderer2, ViewChild} from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {VertexService} from "../../services/vertex.service";
import {RoomService} from "../../services/room.service";
import {Router} from "@angular/router";
import {environment} from "../../../environments/environment";

@Component({
  selector: 'app-public-escape-rooms',
  templateUrl: './public-escape-rooms.component.html',
  styleUrls: ['./public-escape-rooms.component.css']
})
export class PublicEscapeRoomsComponent implements OnInit {

  private headers: HttpHeaders = new HttpHeaders();
  private card_number: number = 0;
  private col_div: Element[] = [];

  @ViewChild("escape_room_cards") escapeRoomCardsRef : ElementRef | undefined;

  constructor(private renderer: Renderer2, private httpClient: HttpClient,
              private vertexService: VertexService, private roomService: RoomService,
              private router: Router) {
    this.headers = this.headers.set('Authorization1', 'Bearer ' + localStorage.getItem('token'))
      .set("Authorization2",'Basic ' + localStorage.getItem('username'));
    this.getPublicEscapeRooms();
  }

  ngOnInit(): void {
  }

  getPublicEscapeRooms(){
    this.httpClient.get<any>(environment.api + "/api/v1/room/", {"headers": this.headers}).subscribe(
      response => {
        for (let er of response.data){
          this.renderPublicEscapeRooms(er.id, er.name);
        }
      },
      //Render error if bad request
      error => {
        console.log(error);
      }
    );
  }


  // renders all cards on page
  renderPublicEscapeRooms(id: number, name: string, ){
    if(this.card_number % 4 == 0){
      let row = this.renderer.createElement('div');
      this.renderer.addClass(row, 'row');
      this.renderer.addClass(row, 'justify-content-evenly');
      this.renderer.addClass(row, 'text-center');
      this.renderer.addClass(row, 'mt-3');
      this.renderer.appendChild(this.escapeRoomCardsRef?.nativeElement, row);
      for(let i = 0; i < 4; i++){
        this.col_div[i] = this.renderer.createElement('div');
        this.renderer.addClass(this.col_div[i], 'col-2');
        this.renderer.appendChild(row, this.col_div[i]);
      }
    }

    // set outer col bootstrap


    let card = this.renderer.createElement('div');
    // set card bootstrap
    this.renderer.addClass(card, 'card');
    this.renderer.addClass(card, 'text-white');
    this.renderer.addClass(card, 'bg-secondary');
    this.renderer.addClass(card, 'mb-3');
    this.renderer.addClass(card, 'h-100');

    let card_header = this.renderer.createElement('div');
    // set card-header bootstrap
    this.renderer.addClass(card_header, 'card-header');
    this.renderer.addClass(card_header, 'bg-dark');
    this.renderer.appendChild(card_header, this.renderer.createText(name));

    let card_body = this.renderer.createElement('div');
    // set card-body bootstrap
    this.renderer.addClass(card_body, 'card-body');

    let card_title = this.renderer.createElement('h5');
    // set title bootstrap
    this.renderer.addClass(card_title, 'card-title');
    this.renderer.addClass(card_title, 'mt-1');
    // @ts-ignore
    this.renderer.appendChild(card_title, this.renderer.createText(localStorage.getItem('username')));

    let inner_row = [];
    for(let i = 0; i < 2; i++){
      inner_row.push(this.renderer.createElement('div'));
      // set row bootstrap
      this.renderer.addClass(inner_row[i], 'row');
      this.renderer.addClass(inner_row[i], 'justify-content-evenly');
      this.renderer.addClass(inner_row[i], 'text-center');
      this.renderer.addClass(inner_row[i], 'mt-2');
    }

    let inner_col = [];
    for(let i = 0; i < 4; i++){
      inner_col.push(this.renderer.createElement('div'));
      // add class to each col
      this.renderer.addClass(inner_col[i], 'col-5');
    }
    // add col values
    this.renderer.appendChild(inner_col[0], this.renderer.createText('10:20'));
    this.renderer.appendChild(inner_col[1], this.renderer.createText('3.5'));
    this.renderer.appendChild(inner_col[2], this.renderer.createText('Best Time'));
    this.renderer.appendChild(inner_col[3], this.renderer.createText('Rating'));

    let button = this.renderer.createElement('button');
    // add button bootstrap
    this.renderer.addClass(button, 'btn');
    this.renderer.addClass(button, 'btn-dark');
    this.renderer.addClass(button, 'text-success');
    this.renderer.addClass(button, 'm-1');
    this.renderer.appendChild(button, this.renderer.createText('Play'));
    this.renderer.setAttribute(button, 'escape-room-id', id.toString());

    // append all children together

    this.renderer.appendChild(inner_row[0], inner_col[0]);
    this.renderer.appendChild(inner_row[0], inner_col[1]);
    this.renderer.appendChild(inner_row[1], inner_col[2]);
    this.renderer.appendChild(inner_row[1], inner_col[3]);

    this.renderer.appendChild(card_body, card_title);
    this.renderer.appendChild(card_body, inner_row[0]);
    this.renderer.appendChild(card_body, inner_row[1]);

    this.renderer.appendChild(card, card_header);
    this.renderer.appendChild(card, card_body);
    this.renderer.appendChild(card, button);

    this.renderer.appendChild(this.col_div[this.card_number%4], card);
    this.card_number++;
  }

}
