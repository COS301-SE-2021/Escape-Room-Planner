import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SimulationComponent } from './simulation.component';
import {VertexService} from "../../services/vertex.service";
import {RoomService} from "../../services/room.service";
import {Inventory} from "../../models/simulation/inventory.model";
import {RouterTestingModule} from "@angular/router/testing";
import {HttpClientTestingModule} from "@angular/common/http/testing";

describe('SimulationComponent', () => {
  let component: SimulationComponent;
  let fixture: ComponentFixture<SimulationComponent>;
  let mockVertexService: jasmine.SpyObj<VertexService>;
  let mockRoomService: jasmine.SpyObj<RoomService>;
  let mockInventory: jasmine.SpyObj<Inventory>

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports:[
        HttpClientTestingModule,
        RouterTestingModule
      ],
      declarations: [ SimulationComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SimulationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('#should make canvas of window size', () =>{
    expect(component['app']).toBeTruthy();
    if(component['app']) {
      expect(component['app'].view.width).toBe(window.innerWidth);
      expect(component['app'].view.height).toBe((window.innerHeight-56));
    }
  });

  it('#keydown a must make movement.a true', () =>{
    let e = new KeyboardEvent('keydown', {
      code: 'KeyA'
    });
    component['movement'].a = false;
    component.handleKeyDown(e);
    expect(component['movement'].a).toBe(true);
  });

  it('#keydown s must make movement.s true', () =>{
    let e = new KeyboardEvent('keydown', {
      code: 'KeyS'
    });
    component['movement'].s = false;
    component.handleKeyDown(e);
    expect(component['movement'].s).toBe(true);
  });

  it('#keydown w must make movement.w true', () =>{
    let e = new KeyboardEvent('keydown', {
      code: 'KeyW'
    });
    component['movement'].w = false;
    component.handleKeyDown(e);
    expect(component['movement'].w).toBe(true);
  });

  it('#keydown d must make movement.d true', () =>{
    let e = new KeyboardEvent('keydown', {
      code: 'KeyD'
    });
    component['movement'].d = false;
    component.handleKeyDown(e);
    expect(component['movement'].d).toBe(true);
  });

  it('#keyup a must make movement.a false', () =>{
    let e = new KeyboardEvent('keydown', {
      code: 'KeyA'
    });
    component['movement'].a = true;
    component.handleKeyUp(e);
    expect(component['movement'].a).toBe(false);
  });

  it('#keyup s must make movement.s false', () =>{
    let e = new KeyboardEvent('keyup', {
      code: 'KeyS'
    });
    component['movement'].s = true;
    component.handleKeyUp(e);
    expect(component['movement'].s).toBe(false);
  });

  it('#keyup w must make movement.w false', () =>{
    let e = new KeyboardEvent('keyup', {
      code: 'KeyW'
    });
    component['movement'].w = true;
    component.handleKeyUp(e);
    expect(component['movement'].w).toBe(false);
  });

  it('#keyup d must make movement.d false', () =>{
    let e = new KeyboardEvent('keyup', {
      code: 'KeyD'
    });
    component['movement'].d = true;
    component.handleKeyUp(e);
    expect(component['movement'].d).toBe(false);
  });
});
