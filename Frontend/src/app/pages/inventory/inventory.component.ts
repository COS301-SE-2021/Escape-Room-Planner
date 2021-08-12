import {Component, EventEmitter, OnInit, Output} from '@angular/core';

@Component({
  selector: 'app-inventory',
  templateUrl: './inventory.component.html',
  styleUrls: ['./inventory.component.css']
})
export class InventoryComponent implements OnInit {
  @Output() public afterClick: EventEmitter<inventoryObject> = new EventEmitter();

  constructor() { }

  ngOnInit(): void {
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
