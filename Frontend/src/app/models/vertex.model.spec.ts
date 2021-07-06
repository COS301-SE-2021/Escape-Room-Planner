import { Vertex } from './vertex.model';

describe('Vertex', () => {
  it('should create an instance', () => {
    expect(new Vertex(0, 0, "", "", 0, 0, 0, 0, "", 0)).toBeTruthy();
  });
});
