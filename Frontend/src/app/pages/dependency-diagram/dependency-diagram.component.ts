import { Component, OnInit, AfterViewInit, ElementRef, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { Vertex } from 'src/app/models/vertex.model';
import { VertexService } from 'src/app/services/vertex.service';
// import { mxGraph} from 'mxgraph';
declare var mxGraph: any;
declare var mxHierarchicalLayout: any;

@Component({
  selector: 'app-dependency-diagram',
  templateUrl: './dependency-diagram.component.html',
  styleUrls: ['./dependency-diagram.component.css']
})

export class DependencyDiagramComponent implements OnInit {

  public showDependency = true;

  constructor(private vertexService: VertexService, private router: Router) {}

  ngOnInit() {}

  @ViewChild('graphContainer') graphContainer!: ElementRef;

  // @ts-ignore
  generate() {
    console.log('In Generate');
    this.showDependency = false;
    const graph = new mxGraph(this.graphContainer.nativeElement);
    try {
      const parent = graph.getDefaultParent();
      graph.getModel().beginUpdate();

      let graphVertices = [];
      // Create and store all the graph vertices
      for (let vertex of this.vertexService.vertices)
        graphVertices.push(graph.insertVertex(parent, vertex.local_id, vertex.type, 0, 0, 60, 80));

      // Loop through all the graph vertices
      for (let vertex1 of graphVertices) {
        // For each graph vertex, find it's connections
        let connections = this.vertexService.getVertexConnections((vertex1.id-2));
        // Loop through all the connections
        for (let index of connections) {
          // Now loop through the graph vertices again to find a vertex that is connected
          // the first one you found
          for (let vertex2 of graphVertices) {
            // Check for the vertex id and compare it with the index, (I think the id is the index) been missing this
            if ((vertex2.id-2) == index) {
              // Finally just connect the two vertices
              graph.insertEdge(parent, '', '', vertex2, vertex1);
              break;
            }
          }
        }
      }
    } finally {
      graph.getModel().endUpdate();
      const layout = new mxHierarchicalLayout(graph);
      layout.horizontal = true;
      layout.edgeStyle=4;
      layout.intraCellSpacing=20;
      layout.interRankCellSpacing=55;
      layout.execute(graph.getDefaultParent());
    }
  }
}
