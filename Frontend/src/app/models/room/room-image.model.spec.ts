import { RoomImage } from './room-image.model';

describe('RoomImage', () => {
  it('should create an instance', () => {
    expect(new RoomImage(0, 0, 0, 0, 0, "")).toBeTruthy();
  });
});
