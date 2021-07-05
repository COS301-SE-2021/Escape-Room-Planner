import { Injectable } from '@angular/core';
import {Vertex} from "../models/vertex.model";

@Injectable({
  providedIn: 'root'
})
export class VertexService {
  private vertices : Vertex[]

  constructor() {
    this.vertices = [];  //todo change this later
  }
}
