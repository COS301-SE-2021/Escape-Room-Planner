import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DependencyDiagramComponent } from './dependency-diagram.component';
import {RouterTestingModule} from "@angular/router/testing";

describe('DependencyDiagramComponent', () => {
  let component: DependencyDiagramComponent;
  let fixture: ComponentFixture<DependencyDiagramComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        RouterTestingModule
      ],
      declarations: [
        DependencyDiagramComponent
      ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DependencyDiagramComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
