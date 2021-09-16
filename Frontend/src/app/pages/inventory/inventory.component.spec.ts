import { ComponentFixture, TestBed } from '@angular/core/testing';

import { InventoryComponent } from './inventory.component';
//import {HttpClient} from "@angular/common/http";
import {HttpClientTestingModule, HttpTestingController} from "@angular/common/http/testing";
import {environment} from "../../../environments/environment";


describe('InventoryComponent', () => {
  let component: InventoryComponent;
  let fixture: ComponentFixture<InventoryComponent>;
  let URl = environment.api + '/api/v1/inventory/';
  let responseGet = { image: [{
      blob_id: 0,
      src: './assets/images/key1.png',
      type: 'clue'
    }],
  };
  let httpTestingController: HttpTestingController;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        HttpClientTestingModule
      ],
      declarations: [ InventoryComponent ],
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

  it('should set header on construction', () => {
    expect(component['headers'].get('Authorization1')).toBe('Bearer 1234');
    expect(component['headers'].get('Authorization2')).toBe('Basic Test');
  });

  it('should get inventory items and load on construction', () => {
    const req = httpTestingController.expectOne(URl);
    expect(req.request.method).toEqual('GET');
    req.flush(responseGet);
    console.log(component['inventory']);
    expect(component['inventory'][responseGet.image[0].blob_id]).toEqual(responseGet.image[0].src);
    httpTestingController.verify();
  });

  // it('on load if request error should emit', () => {
  //   const req = httpTestingController.expectOne(URl);
  //   expect(req.request.method).toEqual('GET');
  //   req.flush(responseGet);
  //   console.log(component['inventory']);
  //   expect(component['inventory'][responseGet.image[0].blob_id]).toEqual(responseGet.image[0].src);
  //   httpTestingController.verify();
  // });
});
