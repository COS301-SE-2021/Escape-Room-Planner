import { DroppableDirective } from './droppable.directive';
import {ElementRef} from '@angular/core';

describe('DroppableDirective', () => {
  it('should create an instance', () => {
    const directive = new DroppableDirective();
    expect(directive).toBeTruthy();
  });
});
