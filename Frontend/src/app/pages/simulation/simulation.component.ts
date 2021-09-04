import { OnInit, Component, ElementRef, Input, HostListener, NgZone, OnDestroy } from '@angular/core';
import { Application, Sprite, Ticker } from 'pixi.js';

@Component({
  selector: 'app-simulation',
  templateUrl: './simulation.component.html',
  styleUrls: ['./simulation.component.css']
})
export class SimulationComponent implements OnInit, OnDestroy {
  private app: Application | undefined;
  private character: Sprite | undefined;
  //movement represent array of key [a,w,d,s] that's boolean to toggle between
  private movement = {a: false,w: false, d: false, s: false};

  constructor(private elementRef: ElementRef, private ngZone: NgZone) {}

  init() {
    this.ngZone.runOutsideAngular(() => {
      this.app = new Application({width: 500, height:500});
    });
    if (this.app !== undefined) {
      this.app.renderer.backgroundColor = 0x23395D;
      //how you can resize the canvas for pixi
      this.app.renderer.resize(window.innerWidth, window.innerHeight-56);
      this.app.view.style.position = 'absolute';
      this.app.view.style.top =  '56px';
      // TODO : fix styles later to be dynamic
      this.elementRef.nativeElement.appendChild(this.app.view);
      //create character
      // @ts-ignore
      this.character = new Sprite.from('/assets/sprite/character1.png');
      if (this.character !== undefined){
        this.character.anchor.set(0.5);
        //spawn in middle of page
        this.character.x = this.app.view.width/2;
        this.character.y = this.app.view.height/2;
        this.app.stage.addChild(this.character);
        // @ts-ignore
        this.app.ticker.add(delta => this.simulate(delta));
        this.app.ticker.start();
        console.log(this.app.ticker.deltaTime+ "ticker");
      }
    }
  }

  ngOnInit(): void {
    this.init();
  }


  destroy() {
    if(this.app !== undefined)
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

}
