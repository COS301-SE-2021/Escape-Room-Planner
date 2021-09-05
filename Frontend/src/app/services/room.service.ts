import { Injectable } from '@angular/core';
import { RoomImage } from '../models/room/room-image.model'
@Injectable({
  providedIn: 'root'
})
export class RoomService {
  private _counter: number;
  private _room_images : RoomImage[];

  constructor() {
    this._counter = 0;
    this._room_images = [];
  }

  addRoomImage(id: number, pos_x: number, pos_y: number, width: number, height: number, src: string){
    let room = new RoomImage(id, pos_x, pos_y, width, height, src);
    this._room_images.push(room);
    this._counter++;
  }

  get room_images(): RoomImage[] {
    return this._room_images;
  }

  resetRoom(){
    this._counter = 0;
    this._room_images = [];
  }
}
