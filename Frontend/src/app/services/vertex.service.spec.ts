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

  it('#addVertexConnectedLines should create the connection', () => {
    service.vertices.push(new Vertex(0, 0, "name",
      'inType', 0, 0, 0, 0, "inGraphicID"));
    service.addVertexConnectedLine(0,1);

    expect(service.vertices[0].getConnectedLines().length).toBe(1, 'didn\'t add the  connection')
  });

  it('#addVertexResponsibleLines should create the connection', () => {
    service.vertices.push(new Vertex(0, 0, "name",
      'inType', 0, 0, 0, 0, "inGraphicID"));
    service.addVertexResponsibleLine(0,1);

    expect(service.vertices[0].getResponsibleLines().length).toBe(1, 'didn\'t add the  connection')
  });

  it('#getVertexConnections should create the connection', () => {
    service.vertices.push(new Vertex(0, 0, "name",
      'inType', 0, 0, 0, 0, "inGraphicID"));
    service.vertices[0].addConnection(1);

    expect(service.getVertexConnections(0).length).toBe(1, 'didn\'t add the  connection')
  });

  it('#removeVertexConnectedLines should delete the connected line when it exists', () => {
    service.vertices.push(new Vertex(0, 0, "name",
      'inType', 0, 0, 0, 0, "inGraphicID"));
    service.vertices[0].addConnectedLine(1);
    // it does
    service.removeVertexConnectedLine(0,1);
    // it checks
    expect(service.vertices[0].getConnectedLines().length).toBe(0, 'didn\'t remove connected lines')
  });

  it('#removeVertexConnectedLines should delete the connected line when it does not exists', () => {
    service.vertices.push(new Vertex(0, 0, "name",
      'inType', 0, 0, 0, 0, "inGraphicID"));
    service.vertices[0].addConnectedLine(1);
    // it does
    service.removeVertexConnectedLine(0,2);
    // it checks
    expect(service.vertices[0].getConnectedLines().length).toBeGreaterThan(0, 'remove connected lines')
  });

  it('#removeVertexResponsibleLine should delete the connected line when it exists', () => {
    service.vertices.push(new Vertex(0, 0, "name",
      'inType', 0, 0, 0, 0, "inGraphicID"));
    service.vertices[0].addResponsibleLine(1);
    // it does
    service.removeVertexResponsibleLine(0,1);
    // it checks
    expect(service.vertices[0].getResponsibleLines().length).toBe(0, 'didn\'t remove responsible lines')
  });

  it('#removeVertexResponsibleLine should delete the connected line when it does not exists', () => {
    service.vertices.push(new Vertex(0, 0, "name",
      'inType', 0, 0, 0, 0, "inGraphicID"));
    service.vertices[0].addResponsibleLine(1);
    // it does
    service.removeVertexResponsibleLine(0,2);
    // it checks
    expect(service.vertices[0].getResponsibleLines().length).toBeGreaterThan(0, 'remove responsible lines')
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
