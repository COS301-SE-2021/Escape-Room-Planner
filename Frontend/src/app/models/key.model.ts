import {Vertex} from "./vertex.model";

export class Key extends Vertex{
  constructor(local_id: number,
              id: number,
              name: string,
              pos_x: number,
              pos_y: number,
              width: number,
              height: number,
              graphic_id: string,
              z_index: number) {
    super(local_id, id, name, 'Key', pos_x, pos_y, width, height, graphic_id, z_index);
  }
}
