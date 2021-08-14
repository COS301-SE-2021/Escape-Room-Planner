import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ResetPasswordNotComponent } from './reset-password-not.component';

describe('ResetPasswordNotComponent', () => {
  let component: ResetPasswordNotComponent;
  let fixture: ComponentFixture<ResetPasswordNotComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ResetPasswordNotComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ResetPasswordNotComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
