import {Vertex} from "./vertex.model";

export class Clue extends Vertex{
  private clue: string;

  constructor(local_id: bigint,
              id: bigint,
              name: string,
              pos_x: number,
              pos_y: number,
              width: number,
              height: number,
              graphic_id: string,
              room_id: bigint,
              clue:string) {
    super( local_id, id, name, 'Clue', pos_x, pos_y, width, height, graphic_id, room_id );
    this.clue = clue;
  }
}
