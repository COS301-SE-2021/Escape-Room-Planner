import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RoomCreatorComponent } from './room-creator.component';
import {HttpClientTestingModule} from "@angular/common/http/testing";
import {RouterTestingModule} from "@angular/router/testing";
import {VertexService} from "../../services/vertex.service";

describe('RoomCreatorComponent', () => {
  let component: RoomCreatorComponent;
  let fixture: ComponentFixture<RoomCreatorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports:[
        HttpClientTestingModule,
        RouterTestingModule
      ],
      declarations: [
        RoomCreatorComponent
      ],
      providers:[
        VertexService
      ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RoomCreatorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
