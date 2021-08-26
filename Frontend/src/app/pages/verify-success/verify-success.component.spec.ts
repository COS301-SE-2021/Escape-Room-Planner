import { ComponentFixture, TestBed } from '@angular/core/testing';

import { VerifySuccessComponent } from './verify-success.component';

describe('VerifySuccessComponent', () => {
  let component: VerifySuccessComponent;
  let fixture: ComponentFixture<VerifySuccessComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ VerifySuccessComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(VerifySuccessComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
