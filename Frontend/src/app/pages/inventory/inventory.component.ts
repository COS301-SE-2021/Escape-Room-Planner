import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";

@Component({
  selector: 'app-inventory',
  templateUrl: './inventory.component.html',
  styleUrls: ['./inventory.component.css']
})
export class InventoryComponent implements OnInit {
  private headers: HttpHeaders = new HttpHeaders();

  @Output() public afterClick: EventEmitter<inventoryObject> = new EventEmitter();

  constructor(private httpClient: HttpClient) {
    this.headers = this.headers.set('Authorization', 'Bearer ' + localStorage.getItem('token'));
  }

  ngOnInit(): void {

    this.httpClient.get<any>('http://127.0.0.1:3000/api/v1/inventory/',{"headers": this.headers}).subscribe(
      response =>{
        console.log(response);
      },
      error => {
        console.log(error);
      }
    );

  }

  public onClick(type:string, loc:string, pos:number): void{
    let data: inventoryObject = {
      type: type,
      loc: loc,
      pos: pos
    }

    this.afterClick.emit(data);
  }
}

interface inventoryObject{
  type: string,
  loc: string,
  pos: number
}
