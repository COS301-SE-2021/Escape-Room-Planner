import { Injectable } from '@angular/core';
import {Vertex} from "../models/vertex.model";

@Injectable({
  providedIn: 'root'
})
export class VertexService {
  private _local_id_count: number;
  private _vertices : Vertex[];

  constructor() {
    this._vertices = [];  //todo change this later
    this._local_id_count = 0;
  }

  addVertex(inType: string, inName: string, inGraphicID: string,
            inPos_y: number, inPos_x: number, inWidth: number,
            inHeight: number, inEstimated_time: Date, inDescription: string,
            inRoom_id: number, inClue: string): Vertex {

    let createVertexBody = {type: inType,
      name: inName,
      graphicid: inGraphicID,
      posy: inPos_y,
      posx: inPos_x,
      width: inWidth,
      height: inHeight,
      estimated_time: inEstimated_time,
      description: inDescription,
      roomid: inRoom_id,
      clue: inClue
    };

    if(inType != "Puzzle"){
      // @ts-ignore
      delete  createVertexBody.description;
      // @ts-ignore
      delete  createVertexBody.estimated_time;
    }
    // removes parameters for clue
    if (inType != 'Clue'){
      // @ts-ignore
      delete createVertexBody.clue;
    }

  }

  get vertices(): Vertex[] {
    return this._vertices;
  }
}
