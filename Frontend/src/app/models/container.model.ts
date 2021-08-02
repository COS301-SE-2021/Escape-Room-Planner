import {Vertex} from "./vertex.model";

export class Container extends Vertex{
  constructor(local_id: number,
              id: number,
              name: string,
              pos_x: number,
              pos_y: number,
              width: number,
              height: number,
              graphic_id: string) {
    super(local_id, id, name, 'Container', pos_x, pos_y, width, height, graphic_id);
  }
}
