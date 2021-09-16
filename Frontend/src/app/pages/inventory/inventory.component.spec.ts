import {ComponentFixture, TestBed} from '@angular/core/testing';

import {InventoryComponent} from './inventory.component';
import {HttpClientTestingModule, HttpTestingController} from "@angular/common/http/testing";
import {environment} from "../../../environments/environment";

describe('InventoryComponent', () => {
  let component: InventoryComponent;
  let fixture: ComponentFixture<InventoryComponent>;
  let URl = environment.api + '/api/v1/inventory/';
  let image_clue: image_object = {blob_id: 0, src: './assets/images/clue1.png', type: 'clue'};
  let image_puzzle: image_object = {blob_id: 1, src: './assets/images/puzzle1.png', type: 'puzzle'};
  let image_key: image_object = {blob_id: 2, src: './assets/images/key1.png', type: 'key'};
  let image_container: image_object = {blob_id: 3, src: './assets/images/con1.png', type: 'container'};
  let image_room: image_object = {blob_id: 4, src: './assets/images/room1.png', type: 'room'};
  let room_images_get = {
    image: [image_clue, image_puzzle, image_key, image_container, image_room],
  };

  let httpTestingController: HttpTestingController;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        HttpClientTestingModule,
      ],
      declarations: [InventoryComponent],
    })
      .compileComponents();
    httpTestingController = TestBed.inject(HttpTestingController);
    localStorage.clear();
    localStorage.setItem('token', '1234');
    localStorage.setItem('username', 'Test');
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(InventoryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('#should set header on construction', () => {
    expect(component['headers'].get('Authorization1')).toBe('Bearer 1234');
    expect(component['headers'].get('Authorization2')).toBe('Basic Test');
  });

  it('#should get inventory items and load on construction', () => {
    const req = httpTestingController.expectOne(URl);
    expect(req.request.method).toEqual('GET');
    spyOn(component, 'loadInventory');
    req.flush(room_images_get);
    expect(component.loadInventory).toHaveBeenCalled();
    httpTestingController.verify();
  });

  it('#when load network error should emit', () => {
    const req = httpTestingController.expectOne(URl);
    spyOn(component.error, 'emit');
    req.error(new ErrorEvent('network error'));
    expect(component.error.emit).toHaveBeenCalled();
  });

  it('#when loadInventory called correctly should call render Image', () => {
    let image: image_object[] = [{blob_id: 0, src: 'test', type: 'clue'}];
    spyOn<any>(component, 'renderInventoryObject');
    component.loadInventory(image);
    expect(component['inventory'][image[0].blob_id]).toEqual('test');
    expect(component['renderInventoryObject']).toHaveBeenCalled();
  });

  it('#render clue on renderInventoryObject request', () => {
    component['inventory'][image_clue.blob_id] = image_clue.src;
    component['renderInventoryObject'](image_clue.blob_id.toString(), image_clue.type);
    expect(component['clue_div']?.nativeElement.children[1].getAttribute('blob-id'))
      .toBe(image_clue.blob_id.toString());
  });

  it('#render puzzle on renderInventoryObject request', () => {
    component['inventory'][image_puzzle.blob_id] = image_puzzle.src;
    component['renderInventoryObject'](image_puzzle.blob_id.toString(), image_puzzle.type);
    expect(component['puzzle_div']?.nativeElement.children[1].getAttribute('blob-id'))
      .toBe(image_puzzle.blob_id.toString());
  });

  it('#render key on renderInventoryObject request', () => {
    component['inventory'][image_key.blob_id] = image_key.src;
    component['renderInventoryObject'](image_key.blob_id.toString(), image_key.type);
    expect(component['key_div']?.nativeElement.children[1].getAttribute('blob-id'))
      .toBe(image_key.blob_id.toString());
  });

  it('#render container on renderInventoryObject request', () => {
    component['inventory'][image_container.blob_id] = image_container.src;
    component['renderInventoryObject'](image_container.blob_id.toString(), image_container.type);
    expect(component['container_div']?.nativeElement.children[1].getAttribute('blob-id'))
      .toBe(image_container.blob_id.toString());
  });

  it('#render room on renderInventoryObject request', () => {
    component['inventory'][image_room.blob_id] = image_room.src;
    component['renderInventoryObject'](image_room.blob_id.toString(), image_room.type);
    expect(component['room_div']?.nativeElement.children[1].getAttribute('blob-id'))
      .toBe(image_room.blob_id.toString());
  });

});

interface image_object {
  blob_id: number,
  src: string,
  type: string
}
