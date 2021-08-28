import { Component, OnInit } from '@angular/core';
import * as go from 'gojs';
import { VertexService } from 'src/app/services/vertex.service';

@Component({
  selector: 'app-dependency-diagram',
  templateUrl: './dependency-diagram.component.html',
  styleUrls: ['./dependency-diagram.component.css']
})
export class DependencyDiagramComponent implements OnInit {

  constructor(vertexService: VertexService) { }

  ngOnInit(): void {
  }



}
