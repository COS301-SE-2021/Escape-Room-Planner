import { TestBed } from '@angular/core/testing';

import { VertexService } from './vertex.service';
import {Vertex} from "../models/vertex.model";

describe('VertexService', () => {
  let service: VertexService;

  // still don't know if this injects services
  beforeEach(() => {
    const spy = jasmine.createSpyObj('Vertex',['addConnection'])

    TestBed.configureTestingModule({
      providers: [
        VertexService
      ]
    });

    service = TestBed.inject(VertexService);
  });

  it('#addVertex should return a correct local_id after adding a vertex', () => {
    expect(service.addVertex(
      1,
      'type',
      'name',
      'graphicid',
      0,
      0,
      0,
      0,
      new Date(),
      'description',
      'clue')).toBe(0, 'returns wrong local_id on add');
  });

  it('#reset_array should reset an array', () => {
    service.reset_array();
    expect(service.vertices.length).toBe(0, 'didn\'t reset the array');
  });

  it('#addVertexConnection should create the connection', () => {
    service.vertices.push(new Vertex(0, 0, "name",
      'inType', 0, 0, 0, 0, "inGraphicID"));
    service.vertices.push(new Vertex(1, 0, "name",
      'inType', 0, 0, 0, 0, "inGraphicID"));
    service.addVertexConnection(0,1);

    expect(service.vertices[0].getConnections().length).toBe(1, 'didn\'t add the  connection')
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
