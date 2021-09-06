import { Injectable } from '@angular/core';
import { RoomImage } from '../models/room/room-image.model'
import {Vertex} from "../models/vertex.model";
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

  //well set the vertex to room image
  RoomImageContainsVertex(vertices: Vertex[]){
    //deep copy of array
    let vertexArray = [...vertices];
    for(let room_image of this._room_images){
      room_image.resetContainedObjects();
      for(let i = 0; i < vertexArray.length; i++){
        //check x coordinates
        if((room_image.pos_x <= vertexArray[i].pos_x) &&
          ((room_image.width+room_image.pos_x) >= vertexArray[i].pos_x)){
          //check y coordinates
          if((room_image.pos_y <= vertexArray[i].pos_y) &&
            ((room_image.height+room_image.pos_y) >= vertexArray[i].pos_y)){
            room_image.addObject(vertexArray[i].local_id);
            vertexArray.splice(i,1);
            i--;
          }
        }
      }
    }
    //TODO: check if array is empty and if not say what needs to be placed
  }
}
