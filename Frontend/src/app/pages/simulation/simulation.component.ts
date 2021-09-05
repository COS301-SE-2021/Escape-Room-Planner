import { OnInit, Component, ElementRef, Input, HostListener, NgZone, OnDestroy } from '@angular/core';
import { Application, Sprite, Container } from 'pixi.js';
import { RoomService } from "../../services/room.service";

@Component({
  selector: 'app-simulation',
  templateUrl: './simulation.component.html',
  styleUrls: ['./simulation.component.css']
})
export class SimulationComponent implements OnInit, OnDestroy {
  private app: Application | undefined;
  private character: Sprite | undefined;
  private rooms: Container[] | undefined;
  private current_room_index: number | undefined;
  //movement represent array of key [a,w,d,s] that's boolean to toggle between
  private movement = {a: false,w: false, d: false, s: false};

  constructor(private elementRef: ElementRef, private ngZone: NgZone, private  roomService: RoomService) {
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
      } else if (this.movement.w) {
        this.character.y -= 5;
      } else if (this.movement.d) {
        this.character.x += 5;
      } else if (this.movement.s) {
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
        // @ts-ignore
        this.character = new Sprite.from(this.app.loader.resources.character.texture);
        if(this.character !== undefined) {
          this.character.anchor.set(0.5);
          //spawn in middle of page
          this.character.x = this.app.view.width / 2;
          this.character.y = this.app.view.height / 2;
        }
      }

      //create room containers
      for (let room_images of this.roomService.room_images) {
        let room = new Container();
        //hide room containers so it is not shown straight away
        room.visible = false;

        // @ts-ignore
        let sprite = new Sprite.from(this.app.loader.resources['room'+room_images.id].texture);
        sprite.anchor.set(0.5);
        sprite.x = this.app.view.width/2;
        sprite.y = this.app.view.height/2;
        room.addChild(sprite);
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
          this.rooms[this.current_room_index].removeChild(this.character);
          this.rooms[room_index].addChild(this.character);
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
