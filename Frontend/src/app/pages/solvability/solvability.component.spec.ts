import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SolvabilityComponent } from './solvability.component';

describe('SolvabilityComponent', () => {
  let component: SolvabilityComponent;
  let fixture: ComponentFixture<SolvabilityComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SolvabilityComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SolvabilityComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
