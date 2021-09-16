import { Sprite } from 'pixi.js'

export class Inventory {
  private _items: Sprite[] | undefined;

  constructor() {
    this.resetItems();
  }

  resetItems(){
    this._items = [];
  }

  addItem(item: Sprite){
    this._items?.push(item);
  }

  get items(){
    return this._items;
  }
}

