import { Container } from './container.model';

describe('Container', () => {
  it('should create an instance', () => {
    expect(new Container(0, 0, "", 0, 0, 0, 0, "", 0, 0)).toBeTruthy();
  });
});
