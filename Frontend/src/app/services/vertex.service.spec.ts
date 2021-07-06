import { TestBed } from '@angular/core/testing';

import { VertexService } from './vertex.service';

describe('VertexService', () => {
  let service: VertexService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(VertexService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
