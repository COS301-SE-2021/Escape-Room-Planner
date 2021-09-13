import {
  OnInit,
  Component,
  ElementRef,
  Input,
  HostListener,
  NgZone,
  OnDestroy,
  ViewChild,
  Renderer2
} from '@angular/core';
import { Application, Sprite, Container, AnimatedSprite, Rectangle, Texture } from 'pixi.js';
import { RoomService } from "../../services/room.service";
import {VertexService} from "../../services/vertex.service";
import { Inventory } from "../../models/simulation/inventory.model";
import { Vertex } from "../../models/vertex.model";
import {min} from "rxjs/operators";

@Component({
  selector: 'app-simulation',
  templateUrl: './simulation.component.html',
  styleUrls: ['./simulation.component.css']
})

export class SimulationComponent implements OnInit, OnDestroy {
  private app: Application | undefined;
  private character: AnimatedSprite | undefined;
  private readonly rooms: Container[] | undefined;
  private current_room_index: number | undefined;
  private character_inventory: Inventory | undefined;
  //locks character movement
  private character_lock: boolean = false;
  //movement represent array of key [a,w,d,s] that's boolean to toggle between
  private movement = {a: false,w: false, d: false, s: false};
  //sprites of all objects on canvas except character
  private objects = {};

  //timer variable used to calc current time
  private timer_id: any;
  private sec = 0;
  private min = 0;
  private hour = 0;

  // used by simulation algorithm
  private path_choice: number = 0;
  private current_path_index: number = 0;
  private simulate_toggle: boolean = false;

  @ViewChild("inventory") inventoryRef : ElementRef | undefined;

  public inventory_menu: boolean = true;
  public status_menu_show: boolean = true;
  public status_menu_text: string = "Preforming operation";
  public message_menu_show: boolean = true;
  public message_menu_text: string = "Need";
  //timer text to show end user
  public time_hour: string = '00';
  public time_min: string = '00';
  public time_sec: string = '00';

  constructor(private elementRef: ElementRef,  private renderer: Renderer2,
              private ngZone: NgZone, private  roomService: RoomService,private vertexService: VertexService ) {
    this.rooms = [];
    this.current_room_index = 0;
    this.character_inventory = new Inventory();
  }

  init() {
    this.ngZone.runOutsideAngular(() => {
      this.app = new Application({width: 500, height:500});
    });
    if (this.app !== undefined) {
      this.app.renderer.backgroundColor = 0x000000;
      //how you can resize the canvas for pixi
      this.app.renderer.resize(window.innerWidth, window.innerHeight-56);
      this.app.view.style.position = 'absolute';
      this.app.view.style.top =  '56px';
      // TODO : fix styles later to be dynamic
      this.elementRef.nativeElement.appendChild(this.app.view);
      this.loadAssets();
    }
  }

  ngOnInit(): void {
    this.init();
  }


  destroy() {
    if(this.rooms !== undefined)
      this.rooms.forEach(room => {
        room.destroy();
      });
    if (this.app !== undefined)
      this.app.destroy();
    if(this.timer_id)
      clearInterval(this.timer_id);
  }

  ngOnDestroy(): void {
    this.destroy();
  }

  @HostListener('window:keydown', ['$event'])
  handleKeyDown(event: KeyboardEvent) {
    if(event.code === 'KeyA'){
      this.movement.a = true;
    }
    else if(event.code === 'KeyW'){
      this.movement.w = true;
    }
    else if(event.code === 'KeyD'){
      this.movement.d = true;
    }
    else if(event.code === 'KeyS'){
      this.movement.s = true;
    }else if(event.code === 'KeyE'){
     // this checks objects interacting with character
      this.checkCharacterObjectCollision();
    }else if(event.code === 'KeyF'){
      // this.changeRoom();
      this.changeRoom();
    }else if(event.code === 'KeyI'){
      this.inventory_menu = !this.inventory_menu;
    }else if(event.code === 'KeyQ'){
      this.movement.a = false;
      this.movement.d = false;
      this.movement.w = false;
      this.movement.s = false;
      this.simulate_toggle = !this.simulate_toggle;
    }
  }

  @HostListener('window:keyup', ['$event'])
  handleKeyUp(event: KeyboardEvent) {
    if(event.code === 'KeyA'){
      this.movement.a = false;
    }
    else if(event.code === 'KeyW'){
      this.movement.w = false;
    }
    else if(event.code === 'KeyD'){
      this.movement.d = false;
    }
    else if(event.code === 'KeyS'){
      this.movement.s = false;
    }
  }

  moveCharacter(delta: any){
    if(this.character !== undefined && !this.character_lock) {
      // @ts-ignore
      let room = this.roomService.room_images[this.current_room_index];

      // @ts-ignore
      const bounds1 = this.character.getBounds();
      // @ts-ignore
      const bounds2 = this.objects['room' + room.id].getBounds();
      //move character
      if (this.movement.a) {
        if(bounds1.x - bounds1.width/2 <= bounds2.x)
          this.character.x -= 0;
        else
        this.character.x -= 5;

      }
      if (this.movement.w) {
        if (bounds1.y - bounds1.height/2 <= bounds2.y)
          this.character.y -= 0;
        else
          this.character.y -= 5;

      }
      if (this.movement.d) {
        if ( bounds1.x + bounds1.width*1.5 >= bounds2.x + bounds2.width)
          this.character.x += 0;
        else
          this.character.x += 5;
      }
      if (this.movement.s) {
        if ( bounds1.y + bounds1.height*1.5 >= bounds2.y + bounds2.height)
          this.character.y += 0;
        else
          this.character.y += 5;

      }
    }
   if(this.simulate_toggle)
    this.simulate();
  }

  simulate(){
    let vertex_id = this.vertexService.possible_paths[this.path_choice][this.current_path_index];
    let room_index = this.findRoomHoldsVertex(vertex_id);
    // @ts-ignore
    if(room_index !== this.current_room_index && this.roomService.room_images[room_index].unlocked){
        // @ts-ignore
        this.showRoom(room_index);
    }
    if(this.character !== undefined && !this.character_lock && vertex_id !== undefined) {
      let character_bounds = this.character.getBounds();
      let flag = {x: false, y: false};
      // @ts-ignore
      let object_bounds = this.objects['vertex'+vertex_id].getBounds();

      // move on x axis
      if((Math.abs(character_bounds.x-object_bounds.x) <= 5 )) {
        flag.x = true;
        this.movement.a = false;
        this.movement.d = false;
      }else if(object_bounds.x > character_bounds.x){
        this.movement.a = false;
        this.movement.d = true;
      }else if(object_bounds.x < character_bounds.x){
        this.movement.d = false;
        this.movement.a = true;
      }

      // move on y axis
      if((Math.abs(character_bounds.y-object_bounds.y) <= 5 )) {
        flag.y = true;
        this.movement.w = false;
        this.movement.s = false;
      }else if(object_bounds.y > character_bounds.y){
        this.movement.w = false;
        this.movement.s = true;
      }else if(object_bounds.y < character_bounds.y){
        this.movement.s = false;
        this.movement.w = true;
      }

      // at object position
      if(flag.x && flag.y) {
        this.checkCharacterObjectCollision();
      }
    }
  }

  // TODO : fix loader to not load cached object
  loadAssets(){
    if(this.app !== undefined){
      //load all room sprites from azure
      for (let room_image of this.roomService.room_images)
        this.app.loader.add('room'+room_image.id, room_image.src);

      for(let vertex_image of this.vertexService.vertices)
        this.app.loader.add('vertex'+vertex_image.local_id, vertex_image.graphic_id);

      //load character sprite
      this.app.loader.add('character', '/assets/sprite/character1.png')

      this.app.loader.onProgress.add((e)=>{
        console.log(e.progress);
      });
      //shows when load complete
      this.app.loader.onComplete.add(()=>{
      //  this.messageMenu("Room loaded");
        this.loadRooms();
      });
      //shows error when loading
      this.app.loader.onError.add((e) => {
        console.log(e.message);
      });
      this.app.loader.load();
    }
  }

  loadRooms(){
    if(this.app !== undefined){
      //create character sprite
      if(this.character === undefined){
        const loader = this.app.loader.resources.character;
        let textureC: Texture[];
        textureC = [];
        for(let i = 0; i < 6; i++){
          // @ts-ignore
          const textureLoad = new Texture(loader.texture);
          textureLoad.frame = new Rectangle((32*i),0,32,32);
          textureC.push(textureLoad);
        }
        this.character = new AnimatedSprite(textureC);
        this.character.scale.set(2,2);
        if(this.character !== undefined) {
          this.character.anchor.set(0.5);
          //spawn in middle of page
          this.character.x = 0;
          this.character.y = 0;
        }
      }

      let i = 0;
      //create room containers
      for (let room_images of this.roomService.room_images) {
        let room = new Container();
        room.x = this.app.view.width/2;
        room.y = this.app.view.height/2;
        //hide room containers so it is not shown straight away
        room.visible = false;

        //calculate scaling value while maintaining aspect ratio
        let changeX = this.app.view.width/room_images.width;
        let changeY = this.app.view.height/room_images.height;

        // choose the lesser of the two

        let scale = Math.min(changeX, changeY)
        // @ts-ignore
        let sprite = new Sprite.from(this.app.loader.resources['room'+room_images.id].texture);
        // @ts-ignore
        this.objects['room'+room_images.id] = sprite;
        sprite.anchor.set(0.5);
        // sprite.x = this.app.view.width/2;
        // sprite.y = this.app.view.height/2;
        sprite.x = 0;
        sprite.y = 0;
        sprite.width = room_images.width*scale;
        sprite.height = room_images.height*scale;
        room.addChild(sprite);

        if(room_images.getContainedObjects() !== undefined) {
          for(let vertex_images of room_images.getContainedObjects()){
            // @ts-ignore
            let vertex_sprite = new Sprite.from(this.app.loader.resources['vertex'+vertex_images].texture);
            // @ts-ignore
            this.objects['vertex'+vertex_images] = vertex_sprite;
            vertex_sprite.anchor.set(0);
            let vertices = this.vertexService.vertices;

            //set start room here
            if(parseInt(String(vertex_images)) === parseInt(String(this.vertexService.start_vertex_id))){
              this.current_room_index = i;
            }

            //if an object is inside a container. Hide it
            if((vertices[vertex_images].type === "Key" && vertex_images != this.vertexService.start_vertex_id) || (vertices[vertex_images].type ==="Clue" && vertex_images != this.vertexService.start_vertex_id))
            {
              for(let current_previous_vertices of vertices[vertex_images].getPreviousConnections())
              {
                let previous_vertex = vertices[current_previous_vertices]
                if(previous_vertex.type === "Container")
                {
                  vertex_sprite.visible = false
                }
              }
            }
            vertex_sprite.x =  (vertices[vertex_images].pos_x - room_images.pos_x - room_images.width/2)*scale;
            vertex_sprite.y = (vertices[vertex_images].pos_y - room_images.pos_y  - room_images.height/2)*scale;
            vertex_sprite.width = vertices[vertex_images].width*scale;
            vertex_sprite.height = vertices[vertex_images].height*scale;
            vertex_sprite.name = vertex_images;
            // vertex_sprite.x = this.app.view.width/2 - vertices[vertex_images].pos_x - room_images.pos_x;
            // vertex_sprite.y = this.app.view.height/2 - vertices[vertex_images].pos_y - room_images.pos_y;
            room.addChild(vertex_sprite);

          }
        }
        if(this.rooms)
          this.rooms.push(room);
        i++;
      }
      if(this.rooms){
       this.rooms.forEach(room =>{
         // @ts-ignore
         this.app.stage.addChild(room);
       });
      }
      // @ts-ignore
      this.showRoom(this.current_room_index);
      // @ts-ignore
      this.roomService.room_images[this.current_room_index].unlocked = true;
      // start timer for simulation
      this.timer(1000);
      this.app.ticker.add(delta => this.moveCharacter(delta));
    }
  }

  // shows new room
  showRoom(room_index: number){
    if (this.app && this.current_room_index !== undefined){
      if(this.rooms && this.rooms.length > 0 && this.rooms.length > room_index){
        //hide old room
        this.rooms[this.current_room_index].visible = false;
        //remove character from old room and place in new
        if(this.character) {
          this.character.stop();
          this.rooms[this.current_room_index].removeChild(this.character);
          this.rooms[room_index].addChild(this.character);
          this.character.play();
          this.character.animationSpeed = 0.1;
          this.character.x = 0;
          this.character.y = 0;
        }
        this.messageMenu('Room '+(room_index+1));
        this.rooms[room_index].visible = true;
        this.current_room_index = room_index;
      }
    }
  }

  // TODO : change this function such that it works once rooms been solved
  changeRoom(){
    if(this.current_room_index !== undefined && this.rooms) {
      let i = this.current_room_index;
      while(true){
        i++;
        if(i > this.rooms.length-1)
          i = 0;
        if(this.roomService.room_images[i].unlocked){
          this.showRoom(i);
          return;
        }
      }
    }
  }

  // unlocks new room if next connection in new room
  checkUnlockRoom(vertices: number[]){
    for(let local_id of vertices){
      for(let i = 0; i < this.roomService.room_images.length; i++){
        for(let vertex of this.roomService.room_images[i].getContainedObjects()){
          if(vertex === local_id && this.current_room_index !== i){
            this.roomService.room_images[i].unlocked = true;
            this.messageMenu("Room unlocked");
          }
        }
      }
    }
  }

  // unlocks new room if next connection in new room
  findRoomHoldsVertex(vertex_id: number){
    for(let i = 0; i < this.roomService.room_images.length; i++){
      for(let vertices_id of this.roomService.room_images[i].getContainedObjects()){
        if(vertices_id === vertex_id && this.current_room_index !== i) {
          return i;
        }
      }
    }
    return this.current_room_index;
  }

  // checks objects colliding in rooms with character
  checkCharacterObjectCollision(): boolean{
    // @ts-ignore
    let room = this.roomService.room_images[this.current_room_index];
    for(let vertex_id of room.getContainedObjects()){
      // @ts-ignore
      if(this.checkCollision(this.character, this.objects['vertex'+vertex_id])){
        this.characterObjectInteraction(vertex_id);
        return true;
      }
    }
    return false;
  }

  //check object 1 colliding with object 2 border
  checkCollision(object1: any, object2: any):boolean{
    const bounds1 = object1.getBounds();
    const bounds2 = object2.getBounds();

    return bounds1.x < bounds2.x + bounds2.width
      && bounds1.x + bounds1.width > bounds2.x
      && bounds1.y < bounds2.y + bounds2.height
      && bounds1.y + bounds1.height > bounds2.y;
  }

  characterObjectInteraction(vertex_id: number){
    let vertex_type = this.vertexService.vertices[vertex_id].type;
    let vertex = this.vertexService.vertices[vertex_id]
    if(vertex_type === 'Key' || vertex_type === 'Clue') {
      // @ts-ignore
      if(this.objects['vertex' + vertex_id].visible) {
        // @ts-ignore
        this.character_inventory.addItem(this.objects['vertex'+vertex_id]);
        // @ts-ignore
        this.rooms[this.current_room_index].removeChild(this.objects['vertex'+vertex_id]);
        // @ts-ignore
        this.updateInventoryMenu(this.character_inventory.items.length-1);
        this.vertexStatus(vertex, 'Obtaining:');
      }
    }else if(vertex_type === 'Puzzle'){
      //if has previous connections at least one must be completed
      if(vertex.getPreviousConnections().length > 0){
        for(let local_id of vertex.getPreviousConnections()) {
          // @ts-ignore
          let previous_vertex = this.vertexService.vertices[local_id];
          if (previous_vertex.isCompleted()) {
            this.vertexStatus(vertex, 'Solving:');
            return;
          }
        }
        this.messageMenu('Need item first');
      }else
        this.vertexStatus(vertex, 'Solving:');
    }else if((vertex_type === 'Container')){
        // make items visible
       if(vertex.getPreviousConnections().length > 0) {
         for (let previous_connections of vertex.getPreviousConnections()) {
           // @ts-ignore
           let previous_vertex = this.vertexService.vertices[previous_connections];
           if(previous_vertex.isCompleted()) {
             this.vertexStatus(vertex, 'Opening:');
           } else {
             this.messageMenu('Need To Solve puzzle');
           }
         }
       } else {
         this.vertexStatus(vertex, 'Opening:');
       }
    }
  }

  //render image in inventory menu
  updateInventoryMenu(index: number){
    //need to render new row once full
    if(index%5 === 0 && index !== 0){
      let newRow = this.renderer.createElement('div');
      this.renderer.addClass(newRow, 'row');
      this.renderer.addClass(newRow, 'justify-content-evenly');
      this.renderer.addClass(newRow, 'mb-2');
      for(let i = 0; i < 5; i++){
        let newCol = this.renderer.createElement('div');
        this.renderer.addClass(newCol, 'col-2');
        this.renderer.setAttribute(newCol, 'name', 'inventory_menu')
        this.renderer.appendChild(newRow, newCol);
      }
      this.renderer.appendChild(this.inventoryRef?.nativeElement, newRow);
    }
    //name house local id for vertex sprites
    // @ts-ignore
    let vertex = this.vertexService.vertices[this.character_inventory.items[index].name];
    document.getElementsByName('inventory_menu')[index].innerHTML = '<img src="'+vertex.graphic_id
      +'" title="'+vertex.name+'"  alt="NOT FOUND" class="img-thumbnail">';
  }

  vertexStatus(vertex: Vertex, pre_message: String){
    if(!vertex.isCompleted() && !this.character_lock) {
      this.status_menu_show = false;
      this.character_lock = true;
      this.status_menu_text =  pre_message + ' ' + vertex.name;
      // speed up clock for simulation
      if(vertex.estimated_time != 0) {
        clearInterval(this.timer_id);
        this.timer(Math.ceil(1000/60));
      }
      setTimeout(() => {
        // slow down clock for simulation
        clearInterval(this.timer_id);
        this.timer(1000);
        this.messageMenu('Completed Task');
        this.status_menu_show = true;
        this.character_lock = false;
        if(vertex.type === 'Container') {
          for (let connections of vertex.getConnections()) {
            // @ts-ignore
            this.objects['vertex' + connections].visible = true
          }
        }
        if(this.vertexService.possible_paths[this.path_choice][this.current_path_index] === vertex.local_id)
          this.current_path_index++;
        vertex.toggleCompleted();
        this.checkUnlockRoom(vertex.getConnections());
        if(vertex.local_id === this.vertexService.end_vertex_id){
          clearInterval(this.timer_id);
          this.messageMenu("Escaped Escape Room!");
          this.character_lock = true;
        }
        //update time values
      }, (vertex.estimated_time / 60) * 1000);
    }
  }

  messageMenu(message: string){
      this.message_menu_show = false;
      this.message_menu_text =  message;
      setTimeout(() => {
        this.message_menu_show = true;
      }, 1500);
  }

  // timer for how long simulation takes
  timer(interval: number){
    this.timer_id = setInterval( () =>{
      this.sec++;
      if(this.sec >= 60){
        this.min++;
        this.sec = 0;
      }
      if(this.min >= 60){
        this.hour++;
        this.min = 0;
      }
      let string_sec = String(this.sec);
      let string_min = String(this.min);
      let string_hour = String(this.hour);
      if(string_sec.length === 1)
        string_sec = "0"+string_sec;
      if(string_min.length === 1)
        string_min = "0"+string_min;
      if(string_hour.length === 1)
        string_hour = "0"+string_hour;

      this.time_sec = string_sec;
      this.time_min = string_min;
      this.time_hour = string_hour;
    }, interval);
  }

}
