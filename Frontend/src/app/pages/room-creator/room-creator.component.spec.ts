import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RoomCreatorComponent } from './room-creator.component';
import {HttpClientTestingModule} from "@angular/common/http/testing";
import {RouterTestingModule} from "@angular/router/testing";
import {VertexService} from "../../services/vertex.service";
import 'leader-line';
import {By} from "@angular/platform-browser";

describe('RoomCreatorComponent', () => {
  let component: RoomCreatorComponent;
  let fixture: ComponentFixture<RoomCreatorComponent>;
  let mockVertexService: jasmine.SpyObj<VertexService>;
  let mockLeaderLine: jasmine.SpyObj<any>;

  beforeEach(async () => {
    // mockVertexService = jasmine.createSpyObj(['getLineIndex']);
    mockVertexService = jasmine.createSpyObj('VertexService',[
      'getLineIndex',
      'reset_array'
    ]);
    mockVertexService.reset_array.and.returnValue();

    await TestBed.configureTestingModule({
      imports:[
        HttpClientTestingModule,
        RouterTestingModule
      ],
      declarations: [
        RoomCreatorComponent
      ],
      providers:[
        { provide: VertexService, useValue: mockVertexService }
      ]
    })
    .compileComponents();

    // mockVertexService = TestBed.inject(VertexService) as jasmine.SpyObj<VertexService>;
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RoomCreatorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should have false for both flags initially', function () {
    expect(component['isConnection']).toBe(false);
    expect(component['is_disconnect']).toBe(false);
  });

  it('#resetFlag should reset the flags', function () {
    component['isConnection'] = true;
    component['is_disconnect'] = true;

    component.resetFlag();

    expect(component['isConnection']).toBe(false);
    expect(component['is_disconnect']).toBe(false);
  });

  it('#connectVertex should set a connection flag', function () {
    component.connectVertex();

    expect(component['isConnection']).toBe(true);
  });

  it('#connectVertex should not set a disconnect flag', function () {
    component.connectVertex();

    expect(component['is_disconnect']).toBe(false);
  });

  it('#connectVertex should set a connect flag and reset a disconnect flag', function () {
    component['isConnection'] = true;
    component['is_disconnect'] = true;

    component.connectVertex();

    expect(component['isConnection']).toBe(true);
    expect(component['is_disconnect']).toBe(false);
  });

  it('#disconnectVertex should set a disconnect flag', function () {
    component.disconnectVertex();

    expect(component['is_disconnect']).toBe(true);
  });

  it('#disconnectVertex should not set a connect flag', function () {
    component.disconnectVertex();

    expect(component['isConnection']).toBe(false);
  });

  it('#disconnectVertex should set a disconnect flag and reset a connect flag', function () {
    component['isConnection'] = true;
    component['is_disconnect'] = true;

    component.disconnectVertex();

    expect(component['isConnection']).toBe(false);
    expect(component['is_disconnect']).toBe(true);
  });

  it('#renderAlertError should render an alert with correct text', function () {
    component.renderAlertError('testMessage');
    expect(document.getElementsByClassName('alert')[0].textContent).toBe('testMessage');
  });

  it('#hideContextMenu should hide a context  when clicked outside the menu', function () {
    fixture.debugElement.nativeElement.querySelector('#context_menu').hidden = false;

    fixture.debugElement.nativeElement.querySelector('#room-plan').click()

    expect(fixture.debugElement.nativeElement.querySelector('#context_menu').hidden).toBe(true);
  });

  it('#hideContextMenu should not hide a context  when clicked inside the menu', function () {
    fixture.debugElement.nativeElement.querySelector('#context_menu').hidden = false;

    fixture.debugElement.nativeElement.querySelector('#context_menu').click()

    expect(fixture.debugElement.nativeElement.querySelector('#context_menu').hidden).toBe(false);
  });

  it('#showContextMenu should show a context menu at vertex position', function () {

  });

  it('#showContextMenu should show a context menu at a correct position', function () {

  });

  it('#vertexOperations should choose #makeConnection if the connection flag is set', function () {
    // somehow need to create two divs here
  });

  it('#updateLine should call vertex service', function () {

  });

  it('#updateLine should not update if line is null', function () {

  });

  it('#updateLine should call position if line is not null', function () {

  });

  it('should create',  () => {
    expect(component).toBeTruthy();
  });
});
