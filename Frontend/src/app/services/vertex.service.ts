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
    this._vertices = [];
    this._local_id_count = 0;
  }

  addVertex(inId:number, inType: string, inName: string, inGraphicID: string,
            inPos_y: number, inPos_x: number, inWidth: number,
            inHeight: number, inEstimated_time: Date, inDescription: string, inClue: string): number
  {
    // todo Fix this to instantiate proper class
    let new_vertex = new Vertex(this._local_id_count++, inId, inName,
      inType, inPos_x, inPos_y, inWidth, inHeight, inGraphicID);

    this._vertices.push(new_vertex);

    return new_vertex.local_id;
  }

  get vertices(): Vertex[] {
    return this._vertices;
  }
}
