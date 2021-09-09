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
  private _estimated_time: number;
  private _z_index: number;
  private _deleted: boolean; // a flag to see if the vertex was deleted in the current session
  private _completed: boolean;
  private _connections: any[] = [];
  private previous_connections: any[] = [];
  private _connected_lines: any[] = [];
  private _responsible_lines: any[] = [];

  constructor(local_id: number,
              id: number,
              name: string,
              type: string,
              pos_x: number,
              pos_y: number,
              width: number,
              height: number,
              graphic_id: string,
              estimated_time: number,
              z_index: number) {
      this._local_id = local_id;
      this._id = id;
      this._name = name;
      this._type = type;
      this._pos_x = pos_x;
      this._pos_y = pos_y;
      this._width = width;
      this._height = height;
      this._graphic_id = graphic_id;
      this._estimated_time = estimated_time;
      this._deleted = false; // default is false since user would need to create the vertex or it comes from db
      this._completed = false;
      this._z_index = z_index;
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

  get estimated_time(): number {
    return this._estimated_time;
  }

  set estimated_time(value: number) {
    this._estimated_time = value;
  }

  set z_index(value: number) {
    this._z_index = value;
  }
  get z_index(): number {
    return this._z_index;
  }

  /*
    returns true is deleted flag is not set
  */
  public exists(){
    return !this._deleted;
  }

  /*
    toggles the deleted flag
  */
  public toggle_delete(){
    this._deleted = !this._deleted;
  }

  //add connections to vertex
  public addConnection(to_vertex: number){
    this._connections.unshift(to_vertex);
  }

  //add connections to vertex
  public addPreviousConnection(to_vertex: number){
    this.previous_connections.push(to_vertex);
  }

  //add connected lines from this vertex
  public addConnectedLine(line_index: number){
    this._connected_lines.unshift(line_index);
  }

  //add connected lines from another vertex to this vertex
  public addResponsibleLine(line_index: number){
    this._responsible_lines.push(line_index);
  }

  //gets all connections from this vertex
  public getConnections(){
    return this._connections;
  }

  //gets all previous connections from this vertex
  public getPreviousConnections(){
    return this.previous_connections;
  }

  //gets all line indices from this vertex
  public getConnectedLines(){
    return this._connected_lines;
  }

  //gets all line indices to this vertex
  public getResponsibleLines(){
    return this._responsible_lines;
  }

  //removes a connection from this vertex to next
  public removeConnection(index: number){
    if(this._connections.length > index)  this._connections.splice(index, 1);
  }

  //removes a connection from previous vertex to this vertex
  public removePreviousConnection(index: number){
    if(this.previous_connections.length > index)  this.previous_connections.splice(index, 1);
  }

  //removes connected lines from this vertex to next
  public removeConnectedLine(index: number){
    if(this._connected_lines.length > index)  this._connected_lines.splice(index, 1);
  }

  //removes responsible line entry
  public removeResponsibleLine(index: number){
    if(this._responsible_lines.length > index) this._responsible_lines.splice(index, 1);
  }

  public isCompleted(){
    return this._completed;
  }

  public toggleCompleted(){
    this._completed = !this._completed;
  }

}
