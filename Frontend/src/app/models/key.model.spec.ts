import { Key } from './key.model';

describe('Key', () => {
  it('should create an instance', () => {
    expect(new Key(0, 0, "", 0, 0, 0, 0, "", 0)).toBeTruthy();
  });
});
