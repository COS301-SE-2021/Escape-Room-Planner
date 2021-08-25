import { Injectable } from '@angular/core';
import {Vertex} from "../models/vertex.model";
import {Clue} from "../models/clue.model";
import {Container} from "../models/container.model";
import {Key} from "../models/key.model";
import {Puzzle} from "../models/puzzle.model";

@Injectable({
  providedIn: 'root'
})
export class VertexService {
  private _local_id_count: number;
  private _vertices : Vertex[];

  constructor() {
    this._vertices = [];
    this._local_id_count = 0;
  }

  addVertex(inId:number, inType: string, inName: string, inGraphicID: string,
            inPos_y: number, inPos_x: number, inWidth: number,
            inHeight: number, inEstimated_time: Date, inDescription: string, inClue: string, z_index: number): number {
    let new_vertex = null;
    if (inType === "Clue") {
      new_vertex = new Clue(this._local_id_count++, inId, inName,
                            inPos_x, inPos_y, inWidth, inHeight,
                            inGraphicID, inClue, z_index);
    } else if (inType === "Container") {
      new_vertex = new Container(this._local_id_count++, inId, inName,
                                 inPos_x, inPos_y, inWidth, inHeight,
                                  inGraphicID, z_index);
    }  else if (inType === "Keys")  {
      new_vertex = new Key(this._local_id_count++, inId, inName,
                           inPos_x, inPos_y, inWidth, inHeight,
                           inGraphicID,  z_index);

    } else if(inType === "Puzzle"){
      new_vertex = new Puzzle(this._local_id_count++, inId, inName,
                              inPos_x, inPos_y, inWidth, inHeight,
                              inGraphicID, inDescription, inEstimated_time, z_index);
    }

    if (new_vertex != null) {
      this._vertices.push(new_vertex);
      return new_vertex.local_id;
    }
    return -1;
  }

  get vertices(): Vertex[] {
    return this._vertices;
  }

  public reset_array(){
    this._vertices = [];
    this._local_id_count = 0;
  }

  //adds connection to from vertex
  public addVertexConnection(from_vertex_id: number, to_vertex_id: number){
    this._vertices[from_vertex_id].addConnection(to_vertex_id);
  }

  //adds connected line to from vertex
  public addVertexConnectedLine(vertex_id:number, line_index: number){
    this._vertices[vertex_id].addConnectedLine(line_index);
  }

  //adds connected line to to vertex
  public addVertexResponsibleLine(vertex_id: number, line_index: number){
    this._vertices[vertex_id].addResponsibleLine(line_index);
  }

  //removes connection in vertex connections array and returns line_index
  // todo test
  public removeVertexConnection(from_vertex: number, to_vertex: number): number{
    let index = this._vertices[from_vertex].getConnections().indexOf(to_vertex);
    //checks if exists and if not will return -1
    if (index !== -1) {
      this._vertices[from_vertex].removeConnection(index);
      return this._vertices[from_vertex].getConnectedLines()[index];
    }
    return -1;
  }

  //removes connected line index in vertex connected line array
  public removeVertexConnectedLine(vertex_id:number, value_to_delete: number){
    let index_to_delete = this._vertices[vertex_id].getConnectedLines().indexOf(value_to_delete);
    if (index_to_delete !== -1) this._vertices[vertex_id].removeConnectedLine(index_to_delete);
  }

  //removes responsible line index in vertex responsible line array
  public removeVertexResponsibleLine(vertex_id: number, line_index: number){
    let index = this._vertices[vertex_id].getResponsibleLines().indexOf(line_index);
    if (index !== -1) this._vertices[vertex_id].removeResponsibleLine(index);
  }

  //returns what lines need to be updated in an array
  public getLineIndex(vertex_id: number){
    return this._vertices[vertex_id].getConnectedLines().concat(this._vertices[vertex_id].getResponsibleLines());
  }

  //returns what connections a vertex has in an array
  public getVertexConnections(vertex_id: number){
   return this._vertices[vertex_id].getConnections();
  }
}
