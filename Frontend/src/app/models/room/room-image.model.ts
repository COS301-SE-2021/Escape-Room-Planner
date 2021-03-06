export class RoomImage {
  private _id: number;
  private _pos_x: number;
  private _pos_y: number;
  private _width: number;
  private _height: number;
  private _src: string;
  private _unlocked: Boolean;
  private contains_objects: number[];

  constructor(id: number, pos_x: number, pos_y: number, width: number, height: number, src: string) {
    this._id = id;
    this._pos_x = pos_x;
    this._pos_y = pos_y;
    this._width = width;
    this._height = height;
    this._src = src;
    this.contains_objects = [];
    this._unlocked = false;
  }


  get id(): number {
    return this._id;
  }

  set id(value: number) {
    this._id = value;
  }

  get pos_x(): number {
    return this._pos_x;
  }

  set pos_x(value: number) {
    this._pos_x = value;
  }

  get pos_y(): number {
    return this._pos_y;
  }

  set pos_y(value: number) {
    this._pos_y = value;
  }

  get width(): number {
    return this._width;
  }

  set width(value: number) {
    this._width = value;
  }

  get height(): number {
    return this._height;
  }

  set height(value: number) {
    this._height = value;
  }

  get src(): string {
    return this._src;
  }

  set src(value: string) {
    this._src = value;
  }

  get unlocked(): Boolean {
    return this._unlocked;
  }

  set unlocked(value: Boolean) {
    this._unlocked = value;
  }

  addObject(vertex_id: number){
    this.contains_objects.push(vertex_id);
  }

  getContainedObjects(){
    return this.contains_objects;
  }

  resetContainedObjects(){
    this.contains_objects = [];
  }
}
