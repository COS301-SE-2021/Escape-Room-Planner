import { Component, OnInit, AfterViewInit, ElementRef, ViewChild } from '@angular/core';
import { Vertex } from 'src/app/models/vertex.model';
import { VertexService } from 'src/app/services/vertex.service';
declare var mxGraph: any;
declare var mxHierarchicalLayout: any;

@Component({
  selector: 'app-dependency-diagram',
  templateUrl: './dependency-diagram.component.html',
  styleUrls: ['./dependency-diagram.component.css']
})

export class DependencyDiagramComponent implements OnInit {

  constructor(private vertexService: VertexService) {}

  ngOnInit() {

  }

  //Get the vertex of the graph


  @ViewChild('graphContainer') graphContainer!: ElementRef;
  generate() {
    console.log("What Up What Up");
    const graph = new mxGraph(this.graphContainer.nativeElement);
    try {
      const parent = graph.getDefaultParent();
      graph.getModel().beginUpdate();
      // if (this.vertexService.vertices == null)
      // let vertex = this.vertexService.vertices[0];


        // console.log("Can we access the vertex: "+vertex.name);
      for (let vertex of this.vertexService.vertices){
        const vert1 = graph.insertVertex(parent, vertex.id, vertex.type, 0, 0, 80, 80);
        for (let edge of this.vertexService.getVertexConnections(1 )) {
          // console.log("The connectionss: "+vertex.getConnections());
          const vert2 = graph.insertVertex(parent, edge.id, edge.type, 0, 0, 80, 80);
          graph.insertVertex(parent, '', '', vert2, vert1);
          console.log(edge.type+"  yyyy");
        }
      }

      // const vertex1 = graph.insertVertex(parent, '1', 'Start', 0, 0, 80, 80);
      // const vertex2 = graph.insertVertex(parent, '2', 'Container', 0, 0, 80, 80);
      // const vertex3 = graph.insertVertex(parent, '3', 'Puzzle', 0, 0, 80, 80);
      // const vertex4 = graph.insertVertex(parent, '4', 'Clue', 0, 0, 80, 80);
      // const vertex5 = graph.insertVertex(parent, '5', 'End', 0, 0, 80, 80);
      // graph.insertEdge(parent, '', '', vertex1, vertex2);
      // graph.insertEdge(parent, '', '', vertex1, vertex4);
      // graph.insertEdge(parent, '', '', vertex2, vertex3);
      // graph.insertEdge(parent, '', '', vertex4, vertex5);
      // graph.insertEdge(parent, '', '', vertex3, vertex5);
    } finally {
      graph.getModel().endUpdate();
      new mxHierarchicalLayout(graph).execute(graph.getDefaultParent());
    }
  }
}
