import { Clue } from './clue.model';

describe('Clue', () => {
  it('should create an instance', () => {
    expect(new Clue(0,0,"name", 0, 0, 0, 0, "clue", 0, "h", 0)).toBeTruthy();
  });
});
