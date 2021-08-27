import { Puzzle } from './puzzle.model';

describe('Puzzle', () => {
  it('should create an instance', () => {
    expect(new Puzzle(0, 0, "", 0, 0, 0, 0, "", "", new Date(), 1)).toBeTruthy();
  });
});
