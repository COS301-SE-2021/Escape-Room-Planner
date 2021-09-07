import { OnInit, Component, ElementRef, Input, HostListener, NgZone, OnDestroy } from '@angular/core';
import { Application, Sprite, Container, AnimatedSprite, Rectangle, Texture } from 'pixi.js';
import { RoomService } from "../../services/room.service";
import {VertexService} from "../../services/vertex.service";
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
  //movement represent array of key [a,w,d,s] that's boolean to toggle between
  private movement = {a: false,w: false, d: false, s: false};

  constructor(private elementRef: ElementRef, private ngZone: NgZone, private  roomService: RoomService,private vertexService: VertexService ) {
    this.rooms = [];
    this.current_room_index = 0;
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
      this.app.ticker.add(delta => this.simulate(delta));
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
      this.changeRoom();
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

  simulate(delta: any){
    if(this.character !== undefined) {
      //move character
      if (this.movement.a) {
        this.character.x -= 5;
      }
      if (this.movement.w) {
        this.character.y -= 5;
      }
      if (this.movement.d) {
        this.character.x += 5;
      }
      if (this.movement.s) {
        this.character.y += 5;
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
        console.log('COMPLETED LOAD');
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
        console.log("scale: " + scale);
        console.log("room size: "+ room_images.width + " , " + room_images.height)
        console.log("room size after scale: "+ room_images.width*scale + " , " + room_images.height*scale)

        console.log("room: "+ room_images.pos_x + " , " + room_images.pos_y);

        // @ts-ignore
        let sprite = new Sprite.from(this.app.loader.resources['room'+room_images.id].texture);
        sprite.anchor.set(0.5);
        // sprite.x = this.app.view.width/2;
        // sprite.y = this.app.view.height/2;
        sprite.x = 0;
        sprite.y = 0;
        sprite.width = room_images.width*scale;
        sprite.height = room_images.height*scale;
        room.addChild(sprite);


        console.log("hello" +  room_images.getContainedObjects())
        if(room_images.getContainedObjects() !== undefined)
        {
          for(let vertex_images of room_images.getContainedObjects())
          {
            // @ts-ignore
            let vertex_sprite = new Sprite.from(this.app.loader.resources['vertex'+vertex_images].texture);
            vertex_sprite.anchor.set(0);
            let vertices = this.vertexService.vertices;
            console.log(vertex_images + ": " + vertices[vertex_images].pos_x + " , " + vertices[vertex_images].pos_y);
            console.log(vertex_images + ": " + room_images.pos_x + ", " + room_images.pos_y);
            vertex_sprite.x =  (vertices[vertex_images].pos_x - room_images.pos_x - room_images.width/2)*scale;
            vertex_sprite.y = (vertices[vertex_images].pos_y - room_images.pos_y  - room_images.height/2)*scale;
            vertex_sprite.width = vertices[vertex_images].width*scale;
            vertex_sprite.height = vertices[vertex_images].height*scale;

            // vertex_sprite.x = this.app.view.width/2 - vertices[vertex_images].pos_x - room_images.pos_x;
            // vertex_sprite.y = this.app.view.height/2 - vertices[vertex_images].pos_y - room_images.pos_y;
            room.addChild(vertex_sprite);

          }
        }


        if(this.rooms)
          this.rooms.push(room);
      }
      if(this.rooms){
       this.rooms.forEach(room =>{
         // @ts-ignore
         this.app.stage.addChild(room);
       });
      }
      // @ts-ignore
      this.showRoom(this.current_room_index);
    }
  }

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
        }
        this.rooms[room_index].visible = true;
        this.current_room_index = room_index;
      }
    }
  }

  // TODO : change this function such that it works once rooms been solved
  changeRoom(){
    if(this.current_room_index !== undefined && this.rooms) {
      if (this.current_room_index >= this.rooms.length-1)
        this.showRoom(0);
      else
        this.showRoom(this.current_room_index + 1);
    }
  }
}
