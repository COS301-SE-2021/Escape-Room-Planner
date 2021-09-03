import { OnInit, Component, ElementRef, Input, HostListener, NgZone, OnDestroy } from '@angular/core';
import { Application, IApplicationOptions } from 'pixi.js';

@Component({
  selector: 'app-simulation',
  templateUrl: './simulation.component.html',
  styleUrls: ['./simulation.component.css']
})
export class SimulationComponent implements OnInit, OnDestroy {
  private app: Application | undefined;

  @Input()
  public devicePixelRatio = window.devicePixelRatio || 1;

  @Input()
  public applicationOptions: IApplicationOptions = {};

  constructor(private elementRef: ElementRef, private ngZone: NgZone) {}

  init() {
    this.ngZone.runOutsideAngular(() => {
      this.app = new Application(this.applicationOptions);
    });
    if (this.app !== undefined) {
      this.elementRef.nativeElement.appendChild(this.app.view);
      this.resize();
    }
  }

  ngOnInit(): void {
    this.init();
  }

  @HostListener('window:resize')
  public resize() {
    const width = this.elementRef.nativeElement.offsetWidth;
    const height = this.elementRef.nativeElement.offsetHeight;
    const viewportScale = 1 / this.devicePixelRatio;
    if (this.app !== undefined) {
      this.app.renderer.resize(width * this.devicePixelRatio, height * this.devicePixelRatio);
      this.app.view.style.transform = `scale(${viewportScale})`;
      this.app.view.style.transformOrigin = `top left`;
    }
  }

  destroy() {
    if(this.app !== undefined)
      this.app.destroy();
  }

  ngOnDestroy(): void {
    this.destroy();
  }
}
