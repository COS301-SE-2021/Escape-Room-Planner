/*
This is a model class for Vertex, many different vertices will extend this to add more fields, or none
 */
export class Vertex {
  private _local_id: number;
  private _id: number;
  private _name: string;
  private _type: string;
  private _pos_x: number;
  private _pos_y: number;
  private _width: number;
  private _height: number;
  private _graphic_id: string;
  private _room_id: number;

  constructor(local_id: number,
              id: number,
              name: string,
              type: string,
              pos_x: number,
              pos_y: number,
              width: number,
              height: number,
              graphic_id: string,
              room_id: number) {
      this._local_id = local_id;
      this._id = id;
      this._name = name;
      this._type = type;
      this._pos_x = pos_x;
      this._pos_y = pos_y;
      this._width = width;
      this._height = height;
      this._graphic_id = graphic_id;
      this._room_id = room_id;
  }


  get local_id(): number {
    return this._local_id;
  }

  set local_id(value: number) {
    this._local_id = value;
  }

  get id(): number {
    return this._id;
  }

  set id(value: number) {
    this._id = value;
  }

  get name(): string {
    return this._name;
  }

  set name(value: string) {
    this._name = value;
  }

  get type(): string {
    return this._type;
  }

  set type(value: string) {
    this._type = value;
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

  get graphic_id(): string {
    return this._graphic_id;
  }

  set graphic_id(value: string) {
    this._graphic_id = value;
  }

  get room_id(): number {
    return this._room_id;
  }

  set room_id(value: number) {
    this._room_id = value;
  }
}
