import { Clue } from './clue.model';

describe('Clue', () => {
  it('should create an instance', () => {
    expect(new Clue(0,0,"name", 0, 0, 0, 0, "clue", 0, "h", 0)).toBeTruthy();
  });

  it('get method for clue model', () => {
    let temp = new Clue(0,0,"name", 0, 0, 0, 0, "clue", 0, "h", 0);
    expect(temp.clue).toEqual('h');
  });

  it('set method for clue model', () => {
    let temp = new Clue(0,0,"name", 0, 0, 0, 0, "clue", 0, "h", 0);
    temp.clue = "pop";
    expect(temp.clue).toEqual('pop');
  });
});
