import {Vertex} from "./vertex.model";

export class Clue extends Vertex{
  private _clue: string;

  constructor(local_id: number,
              id: number,
              name: string,
              pos_x: number,
              pos_y: number,
              width: number,
              height: number,
              graphic_id: string,
              room_id: number,
              clue:string) {
    super( local_id, id, name, 'Clue', pos_x, pos_y, width, height, graphic_id, room_id );
    this._clue = clue;
  }


  get clue(): string {
    return this._clue;
  }

  set clue(value: string) {
    this._clue = value;
  }
}
