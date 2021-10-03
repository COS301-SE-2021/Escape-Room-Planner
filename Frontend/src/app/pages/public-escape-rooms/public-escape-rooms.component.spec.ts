import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PublicEscapeRoomsComponent } from './public-escape-rooms.component';
import {HttpClientTestingModule} from "@angular/common/http/testing";
import {RouterTestingModule} from "@angular/router/testing";

describe('PublicEscapeRoomsComponent', () => {
  let component: PublicEscapeRoomsComponent;
  let fixture: ComponentFixture<PublicEscapeRoomsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ],
      declarations: [
        PublicEscapeRoomsComponent
      ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PublicEscapeRoomsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
