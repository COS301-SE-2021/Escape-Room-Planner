import { Puzzle } from './puzzle.model';
import {Clue} from "./clue.model";

describe('Puzzle', () => {
  it('should create an instance', () => {
    expect(new Puzzle(0, 0, "", 0, 0, 0, 0, "", "", 0, 1)).toBeTruthy();
  });

  it('get method for puzzle model', () => {
    let temp = new Puzzle(0,0,"name", 0, 0, 0, 0, "puzzle", "h", 1, 0);
    expect(temp.description).toEqual('h');
  });

  it('set method for puzzle model', () => {
    let temp = new Puzzle(0,0,"name", 0, 0, 0, 0, "puzzle", "h", 1, 0);
    temp.description = "pop";
    expect(temp.description).toEqual('pop');
  });
});
