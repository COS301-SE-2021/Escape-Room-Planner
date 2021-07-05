/*
This is a model class for Vertex, many different vertices will extend this to add more fields, or none
 */
export class Vertex {
  private local_id: bigint;
  private id: bigint;
  private name: string;
  private type: string;
  private pos_x: number;
  private pos_y: number;
  private width: number;
  private height: number;
  private graphic_id: string;
  private room_id: bigint;

  constructor(local_id: bigint,
              id: bigint,
              name: string,
              type: string,
              pos_x: number,
              pos_y: number,
              width: number,
              height: number,
              graphic_id: string,
              room_id: bigint) {
      this.local_id = local_id;
      this.id = id;
      this.name = name;
      this.type = type;
      this.pos_x = pos_x;
      this.pos_y = pos_y;
      this.width = width;
      this.height = height;
      this.graphic_id = graphic_id;
      this.room_id = room_id;
  }
}
