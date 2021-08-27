import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DependecyDiagramComponent } from './dependecy-diagram.component';

describe('DependecyDiagramComponent', () => {
  let component: DependecyDiagramComponent;
  let fixture: ComponentFixture<DependecyDiagramComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DependecyDiagramComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DependecyDiagramComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
