import {RoomImage} from './room-image.model';

describe('RoomImage', () => {
  let room_image: RoomImage;

  beforeEach(() => {
    room_image = new RoomImage(0, 0, 0, 0, 0, "");
  });

  it('should create an instance', () => {
    expect(new RoomImage(0, 0, 0, 0, 0, "")).toBeTruthy();
  });

  it('should set id', () => {
    room_image.id = 5;
    expect(room_image.id).toBe(5);
  });

  it('should set pos_x', () => {
    room_image.pos_x = 5;
    expect(room_image.pos_x).toBe(5);
  });

  it('should set pos_y', () => {
    room_image.pos_y = 5;
    expect(room_image.pos_y).toBe(5);
  });

  it('should set width', () => {
    room_image.width = 5;
    expect(room_image.width).toBe(5);
  });

  it('should set height', () => {
    room_image.height = 5;
    expect(room_image.height).toBe(5);
  });

  it('should set src', () => {
    room_image.src = 'src';
    expect(room_image.src).toBe('src');
  });

  it('should set unlocked', () => {
    room_image.unlocked = true;
    expect(room_image.unlocked).toBe(true);
  });

  it('should set height', () => {
    room_image.height = 5;
    expect(room_image.height).toBe(5);
  });

  it('should reset contained object', () => {
    room_image.addObject(5);
    expect(room_image.getContainedObjects()[0]).toEqual(5);
    room_image.resetContainedObjects();
    expect(room_image.getContainedObjects()).toEqual([]);
  });
});
