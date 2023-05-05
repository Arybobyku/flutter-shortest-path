import 'package:flutter_mapbox_blog/helper/belmandford.dart';
import 'package:flutter_mapbox_blog/helper/get_distance.dart';
import 'package:latlong2/latlong.dart';


// NEW
void main() {
  Graph graph = Graph();
  graph.addEdge("A", "B",
      calculateDistance( LatLng(40.6892, -74.0445),  LatLng(37.7749, -122.4194)));
  graph.addEdge("A", "C",
      calculateDistance( LatLng(40.6892, -74.0445),  LatLng(41.8781, -87.6298)));
  graph.addEdge("B", "D",
      calculateDistance(LatLng(37.7749, -122.4194), LatLng(39.9526, -75.1652)));
  graph.addEdge("C", "D",
      calculateDistance(LatLng(41.8781, -87.6298), LatLng(39.9526, -75.1652)));

  Map<String, double> distances = graph.bellmanFord("A");
  distances.forEach((key, value) {
    print("Distance from A to $key: $value");
  });
}

//OLD
// void main() {
//   Graph graph = Graph(5, 8);
//   graph.addEdge(0, 1, -1);
//   graph.addEdge(0, 2, 4);
//   graph.addEdge(1, 2, 3);
//   graph.addEdge(1, 3, 2);
//   graph.addEdge(1, 4, 2);
//   graph.addEdge(3, 2, 5);
//   graph.addEdge(3, 1, 1);
//   graph.addEdge(4, 3, -3);
//
//   BellmanFord bellmanFord = BellmanFord();
//   bellmanFord.shortestPath(graph, 0);
// }
