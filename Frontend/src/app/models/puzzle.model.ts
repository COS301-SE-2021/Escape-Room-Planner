import {Vertex} from "./vertex.model";

export class Puzzle extends  Vertex{
  private _description: string;
  private _estimated_time: Date;

  constructor(local_id: number,
              id: number,
              name: string,
              pos_x: number,
              pos_y: number,
              width: number,
              height: number,
              graphic_id: string,
              room_id: number,
              description: string,
              estimated_time: Date) {
    super(local_id, id, name, 'Puzzle', pos_x, pos_y, width, height, graphic_id, room_id);
    this._description = description;
    this._estimated_time = estimated_time;
  }


  get description(): string {
    return this._description;
  }

  set description(value: string) {
    this._description = value;
  }

  get estimated_time(): Date {
    return this._estimated_time;
  }

  set estimated_time(value: Date) {
    this._estimated_time = value;
  }
}
