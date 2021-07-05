import { Injectable } from '@angular/core';
import {Vertex} from "../models/vertex.model";
import {HttpClient} from "@angular/common/http";
import {Clue} from "../models/clue.model";

@Injectable({
  providedIn: 'root'
})
export class VertexService {
  private _local_id_count: number;
  private _vertices : Vertex[];

  constructor(private httpClient: HttpClient) {
    this._vertices = [];  //todo change this later
    this._local_id_count = 0;
  }

  addVertex(inType: string, inName: string, inGraphicID: string,
            inPos_y: number, inPos_x: number, inWidth: number,
            inHeight: number, inEstimated_time: Date, inDescription: string,
            inRoom_id: number, inClue: string): Vertex|null{

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

    //make post request for new vertex
    this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/vertex/", createVertexBody).subscribe(
      response => {
        // todo Fix this to instantiate proper class
        let new_vertex = new Vertex(this._local_id_count++, response.data.id, inName,
                                    inType, inPos_x, inPos_y, inWidth, inHeight, inGraphicID, inRoom_id);
        return new_vertex;
      },
      error => {
        console.error('There was an error while creating a vertex', error);
        return null;
      }
    );

    return null;
  }

  get vertices(): Vertex[] {
    return this._vertices;
  }
}
