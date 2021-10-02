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
  private logged_in: boolean = true;
  private headers: HttpHeaders = new HttpHeaders();
  private card_number: number = 0;
  private col_div: Element[] = [];
  private query_search = '';
  private query_filter = '';

  @ViewChild("escape_room_cards") escapeRoomCardsRef: ElementRef | undefined;

  constructor(private renderer: Renderer2, private httpClient: HttpClient,
              private vertexService: VertexService, private roomService: RoomService,
              private router: Router) {
    this.headers = this.headers.set('Authorization1', 'Bearer ' + localStorage.getItem('token'))
      .set("Authorization2", 'Basic ' + localStorage.getItem('username'));
    this.getPublicEscapeRooms({});
  }

  ngOnInit(): void {
    if (localStorage.getItem('token') == null) {
      this.logged_in = false;
    }
  }

  getPublicEscapeRooms(query: any) {
    this.httpClient.get<any>(environment.api + "/api/v1/room_sharing/", {
      "headers": this.headers,
      "params": query
    }).subscribe(
      response => {
        for (let er of response.data) {
          if (er != null)
            this.renderPublicEscapeRooms(er.room_name, er.username, er.best_time, er.rating, er.escape_room_id, er.public_room_id, er.user_rating);
        }
      },
      //Render error if bad request
      error => {
        console.log(error);
      }
    );
  }

  searchRooms(value: any) {
    // @ts-ignore
    this.escapeRoomCardsRef.nativeElement?.innerHTML = "";
    this.col_div = [];
    this.card_number = 0;
    this.query_search = value;
    if (value != '') {
      let searchQuery = {
        search: this.query_search,
        filter: this.query_filter
      }
      this.getPublicEscapeRooms(searchQuery);
    } else {
      this.getPublicEscapeRooms({});
    }
  }

  filterRooms(value: any, tag: HTMLAnchorElement, from_tag: HTMLAnchorElement) {
    // @ts-ignore
    this.escapeRoomCardsRef.nativeElement?.innerHTML = "";
    this.col_div = [];
    this.card_number = 0;

    if (this.query_filter == value) {
      if (value === 'rating')
        tag.innerText = 'Rating';
      else
        tag.innerText = 'Best Time';
      this.query_filter = '';
      this.getPublicEscapeRooms({});
      return
    }

    tag.innerHTML += '<img src="./assets/svg/check2.svg" style="float: right">';
    if (value === 'rating')
      from_tag.innerText = 'Best Time';
    else
      from_tag.innerText = 'Rating';

    this.query_filter = value;
    if (this.query_search == '') {
      let filterQuery = {
        filter: this.query_filter
      }
      this.getPublicEscapeRooms(filterQuery);
    } else {
      let filterQuery = {
        search: this.query_search,
        filter: this.query_filter
      }
      this.getPublicEscapeRooms(filterQuery);
    }
  }

  // renders all cards on page
  renderPublicEscapeRooms(room_name: string, username: string, best_time: number,
                          rating: number, escape_room_id: number, public_room_id: number, user_rating: number | undefined) {

    if (this.card_number % 4 == 0) {
      let row = this.renderer.createElement('div');
      this.renderer.addClass(row, 'row');
      this.renderer.addClass(row, 'justify-content-evenly');
      this.renderer.addClass(row, 'text-center');
      this.renderer.addClass(row, 'mt-3');
      this.renderer.appendChild(this.escapeRoomCardsRef?.nativeElement, row);
      for (let i = 0; i < 4; i++) {
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
    this.renderer.addClass(card, 'the-background');
    this.renderer.addClass(card, 'mb-3');
    this.renderer.addClass(card, 'h-100');

    let card_header = this.renderer.createElement('div');
    // <input type="range" class="form-range" min="1.0" max="5.0" step="0.5" value="1">
    let rating_slider = this.renderer.createElement('input');
    //
    let rating_p = this.renderer.createElement('p');
    // set card-header bootstrap
    this.renderer.addClass(card_header, 'card-header');
    this.renderer.addClass(card_header, 'bg-dark');
    this.renderer.appendChild(card_header, this.renderer.createText(room_name));

    // rating slider
    this.renderer.setAttribute(rating_slider, 'type', 'range');
    this.renderer.setAttribute(rating_slider, 'min', '1.0');
    this.renderer.setAttribute(rating_slider, 'max', '5.0');
    this.renderer.setAttribute(rating_slider, 'step', '1');
    this.renderer.setAttribute(rating_slider, 'value', String(user_rating));
    this.renderer.addClass(rating_slider, 'form-range');
    this.renderer.addClass(rating_slider, 'px-md-3');
    this.renderer.listen(rating_slider, 'change', () => this.changeRating(public_room_id, rating_slider.value));
    this.renderer.listen(rating_slider, 'input', () => this.updateRatingValue(rating_p, rating_slider.value));

    let card_body = this.renderer.createElement('div');
    // set card-body bootstrap
    this.renderer.addClass(card_body, 'card-body');

    let card_title = this.renderer.createElement('h5');
    // set title bootstrap
    this.renderer.addClass(card_title, 'card-title');
    this.renderer.addClass(card_title, 'mt-1');
    this.renderer.appendChild(card_title, this.renderer.createText(username));

    let inner_row = [];
    for (let i = 0; i < 2; i++) {
      inner_row.push(this.renderer.createElement('div'));
      // set row bootstrap
      this.renderer.addClass(inner_row[i], 'row');
      this.renderer.addClass(inner_row[i], 'justify-content-evenly');
      this.renderer.addClass(inner_row[i], 'text-center');
      this.renderer.addClass(inner_row[i], 'mt-2');
    }

    let inner_col = [];
    for (let i = 0; i < 4; i++) {
      inner_col.push(this.renderer.createElement('div'));
      // add class to each col
      this.renderer.addClass(inner_col[i], 'col-5');
    }
    // add col values
    let min = ~~(best_time/60);
    let sec = best_time%60;
    if(sec < 10)
      this.renderer.appendChild(inner_col[0], this.renderer.createText(String(min)+":0"+String(sec)));
    else
      this.renderer.appendChild(inner_col[0], this.renderer.createText(String(min)+":"+String(sec)));
    this.renderer.appendChild(inner_col[1], this.renderer.createText(String(rating)));
    this.renderer.appendChild(inner_col[2], this.renderer.createText('Best Time'));
    this.renderer.appendChild(inner_col[3], this.renderer.createText('Rating'));

    let button = this.renderer.createElement('button');
    // add button bootstrap
    this.renderer.addClass(button, 'btn');
    this.renderer.addClass(button, 'play-button');
    // this.renderer.addClass(button, 'text-success');
    this.renderer.addClass(button, 'm-1');
    this.renderer.appendChild(button, this.renderer.createText('Play'));
    this.renderer.listen(button, 'click', (event) => this.getRoomObjects(escape_room_id));

    // append all children together

    this.renderer.appendChild(inner_row[0], inner_col[0]);
    this.renderer.appendChild(inner_row[0], inner_col[1]);
    this.renderer.appendChild(inner_row[1], inner_col[2]);
    this.renderer.appendChild(inner_row[1], inner_col[3]);

    this.renderer.appendChild(card_body, card_title);
    this.renderer.appendChild(card_body, inner_row[0]);
    this.renderer.appendChild(card_body, inner_row[1]);
    if (this.logged_in) {
      this.renderer.appendChild(rating_p, this.renderer.createText('Your rating: ' + String(user_rating)));
      this.renderer.appendChild(card_body, rating_p);
      this.renderer.appendChild(card_body, rating_slider);
    }
    this.renderer.appendChild(card, card_header);
    this.renderer.appendChild(card, card_body);
    this.renderer.appendChild(card, button);

    this.renderer.appendChild(this.col_div[this.card_number % 4], card);
    this.card_number++;
  }

  updateRatingValue(rating_p: HTMLParagraphElement, rating: number) {
    rating_p.innerText = 'Your rating: ' + String(rating);
  }

  changeRating(public_room_id: number, rating: number): void {
    // use this to update the ratings
    let rateRoomBody = {
      operation: 'add_rating',
      roomID: public_room_id,
      rating: rating
    }
    this.httpClient.post<any>(environment.api + "/api/v1/room_sharing/", rateRoomBody, {"headers": this.headers}).subscribe(
      response => {
        console.info('ratting has been registered');
      },
      error => {
        if (error.status === 401) {
          if (this.router.routerState.snapshot.url !== '/login' &&
            this.router.routerState.snapshot.url !== '/signup') this.router.navigate(['login']).then(r => console.log('login redirect'));
        } else console.error('rating failed to update');
      });
  }

  getRoomObjects(id: number) {
    this.httpClient.get<any>(environment.api + '/api/v1/room_image/' + id, {"headers": this.headers}).subscribe(
      response => {
        this.roomService.resetRoom();
        for (let room_image of response.data) {
          this.roomService.addRoomImage(
            room_image.room_image.id,
            room_image.room_image.pos_x,
            room_image.room_image.pos_y,
            room_image.room_image.width,
            room_image.room_image.height,
            room_image.src
          );
        }

        //http request to rails api
        this.httpClient.get<any>(environment.api + "/api/v1/vertex/" + id, {"headers": this.headers}).subscribe(
          response => {
            this.vertexService.reset_array();
            for (let vertex_t of response.data) {
              //spawn objects out;
              let vertex = vertex_t.vertex
              let vertex_type = vertex_t.type;
              let vertex_connections = vertex_t.connections;
              let current_id = this.vertexService.addVertex(vertex.id, vertex_type, vertex.name, vertex.graphicid,
                vertex.posy, vertex.posx, vertex.width, vertex.height, vertex.estimatedTime,
                vertex.description, vertex.clue, vertex.z_index);
              if (vertex_t.position === "start") {
                this.vertexService.start_vertex_id = current_id;
              } else if (vertex_t.position === "end") {
                this.vertexService.end_vertex_id = current_id;
              }
              // @ts-ignore
              for (let vertex_connection of vertex_connections)
                this.vertexService.addVertexConnection(current_id, vertex_connection);

            }

            // converts real connection to local connection
            for (let vertex of this.vertexService.vertices) {
              let vertex_connections = vertex.getConnections();

              for (let vertex_connection of vertex_connections) {
                // go through all the connections
                // for each location locate the vertex with that real id and use its local id in place of real one
                for (let vertex_to of this.vertexService.vertices) {
                  if (vertex_to.id === vertex_connection) {
                    this.vertexService.removeVertexConnection(vertex.local_id, vertex_connection);
                    this.addLocalConnection(vertex.local_id, vertex_to.local_id);
                    break; // so that not the whole array is traversed
                  }
                }
              }
            }
            this.play(id);
          },
          //Error retrieving vertices message
          error => {
            console.log(error);
          }
        );
      },
      error => {
        console.log(error);
      }
    );
  }

  addLocalConnection(from_vertex_id: number, to_vertex_id: number) {
    this.vertexService.addVertexConnection(from_vertex_id, to_vertex_id);
    this.vertexService.addVertexPreviousConnection(to_vertex_id, from_vertex_id);
  }

  play(id: number) {
    let paths = {
      operation: "ReturnPaths",
      roomid: id
    };
    this.roomService.RoomImageContainsVertex(this.vertexService.vertices);
    if (this.roomService.outOfBounds.length === 0) {
      this.router.navigate(['/simulation'], {
        state: {
          isPublic: true,
          roomID: id
        }
      }).then(r => console.log('simulate redirect' + r));
    } else
      alert('It seems like a room is not ready');
  }
}
