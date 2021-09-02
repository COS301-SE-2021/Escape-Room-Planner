import {Vertex} from "./vertex.model";

export class Puzzle extends  Vertex{
  private _description: string;

  constructor(local_id: number,
              id: number,
              name: string,
              pos_x: number,
              pos_y: number,
              width: number,
              height: number,
              graphic_id: string,
              description: string,
              estimated_time: number,
              z_index: number) {
    super(local_id, id, name, 'Puzzle', pos_x, pos_y, width, height, graphic_id, estimated_time, z_index);
    this._description = description;
  }

  get description(): string {
    return this._description;
  }

  set description(value: string) {
    this._description = value;
  }
}
