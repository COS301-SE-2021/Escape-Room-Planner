import { Component, OnInit, AfterViewInit, ElementRef, ViewChild } from '@angular/core';
import { VertexService } from 'src/app/services/vertex.service';
declare var mxGraph: any;
declare var mxHierarchicalLayout: any;

@Component({
  selector: 'app-dependency-diagram',
  templateUrl: './dependency-diagram.component.html',
  styleUrls: ['./dependency-diagram.component.css']
})

export class DependencyDiagramComponent implements AfterViewInit {
   constructor(private vertexService: VertexService) {}

  //Get the vertex of the graph

  @ViewChild('graphContainer') graphContainer!: ElementRef;
  ngAfterViewInit() {
    const graph = new mxGraph(this.graphContainer.nativeElement);
    try {
      const parent = graph.getDefaultParent();
      graph.getModel().beginUpdate();
      const vertex1 = graph.insertVertex(parent, '1', 'Vertex 1', 0, 0, 200, 80);
      const vertex2 = graph.insertVertex(parent, '2', 'Vertex 2', 0, 0, 200, 80);
      const vertex3 = graph.insertVertex(parent, '3', 'Vertex 3', 0, 0, 200, 80);
      const vertex4 = graph.insertVertex(parent, '4', 'Vertex 4', 0, 0, 200, 80);
      graph.insertEdge(parent, '', '', vertex1, vertex2);
      graph.insertEdge(parent, '', '', vertex1, vertex4);
      graph.insertEdge(parent, '', '', vertex2, vertex3);
    } finally {
      graph.getModel().endUpdate();
      new mxHierarchicalLayout(graph).execute(graph.getDefaultParent());
    }
  }
}
