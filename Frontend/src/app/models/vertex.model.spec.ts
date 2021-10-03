import { Vertex } from './vertex.model';

describe('Vertex', () => {
  let vertex: Vertex;

  beforeEach(() => {
    vertex = new Vertex(0, 0, "", "", 0, 0, 0, 0, "", 0, 0);
  });

  it('should create an instance', () => {
    expect(new Vertex(0, 0, "", "", 0, 0, 0, 0, "", 0, 0)).toBeTruthy();
  });

  it('should get local_id', () => {
    expect(vertex.local_id).toBe(0);
  });

  it('should set local_id', () => {
    vertex.local_id = 5;
    expect(vertex.local_id).toBe(5);
  });

  it('should get id', () => {
    expect(vertex.id).toBe(0);
  });

  it('should set id', () => {
    vertex.local_id = 5;
    expect(vertex.local_id).toBe(5);
  });

  it('should get name', () => {
    expect(vertex.name).toBe('');
  });

  it('should set name', () => {
    vertex.name = 'name';
    expect(vertex.name).toBe('name');
  });

  it('should get type', () => {
    expect(vertex.type).toBe('');
  });

  it('should set type', () => {
    vertex.type = 'type';
    expect(vertex.type).toBe('type');
  });

  it('should get pos_x', () => {
    expect(vertex.pos_x).toBe(0);
  });

  it('should set pos_x', () => {
    vertex.pos_x = 5;
    expect(vertex.pos_x).toBe(5);
  });

  it('should get pos_y', () => {
    expect(vertex.pos_y).toBe(0);
  });

  it('should set pos_y', () => {
    vertex.pos_y = 5;
    expect(vertex.pos_y).toBe(5);
  });

  it('should get width', () => {
    expect(vertex.width).toBe(0);
  });

  it('should set width', () => {
    vertex.width = 5;
    expect(vertex.width).toBe(5);
  });

  it('should get height', () => {
    expect(vertex.height).toBe(0);
  });

  it('should set height', () => {
    vertex.height = 5;
    expect(vertex.height).toBe(5);
  });

  it('should get graphic_id', () => {
    expect(vertex.graphic_id).toBe('');
  });

  it('should set graphic_id', () => {
    vertex.graphic_id = 'graphic';
    expect(vertex.graphic_id).toBe('graphic');
  });

  it('should get estimated_time', () => {
    expect(vertex.estimated_time).toBe(0);
  });

  it('should set estimated_time', () => {
    vertex.estimated_time = 5;
    expect(vertex.estimated_time).toBe(5);
  });

  it('should get z_index', () => {
    expect(vertex.z_index).toBe(0);
  });

  it('should set z_index', () => {
    vertex.z_index = 5;
    expect(vertex.z_index).toBe(5);
  });

  it('should toggle_delete', () => {
    vertex.toggle_delete();
    expect(vertex.exists()).toBeFalse();
  });

  it('should addConnection', () => {
    vertex.addConnection(1);
    expect(vertex.getConnections()[0]).toBe(1);
  });

  it('should addPreviousConnection', () => {
    vertex.addPreviousConnection(1);
    expect(vertex.getPreviousConnections()[0]).toBe(1);
  });

  it('should addConnectedLine', () => {
    vertex.addConnectedLine(1);
    expect(vertex.getConnectedLines()[0]).toBe(1);
  });

  it('should addResponsibleLine', () => {
    vertex.addResponsibleLine(1);
    expect(vertex.getResponsibleLines()[0]).toBe(1);
  });

  it('should remove Connection', () => {
    vertex.addConnection(1);
    vertex.removeConnection(0);
    expect(vertex.getConnections()).toEqual([]);
  });

  it('should remove PreviousConnection', () => {
    vertex.addPreviousConnection(1);
    vertex.removePreviousConnection(0);
    expect(vertex.getPreviousConnections()).toEqual([]);
  });

  it('should remove ConnectedLine', () => {
    vertex.addConnectedLine(1);
    vertex.removeConnectedLine(0);
    expect(vertex.getConnectedLines()).toEqual([]);
  });

  it('should remove ResponsibleLine', () => {
    vertex.addResponsibleLine(1);
    vertex.removeResponsibleLine(0);
    expect(vertex.getResponsibleLines()).toEqual([]);
  });

  it('should toggle between completed', () => {
    vertex.toggleCompleted();
    expect(vertex.isCompleted()).toBeTruthy();
    vertex.resetCompleted();
    expect(vertex.isCompleted()).toBeFalse();
  });
});
