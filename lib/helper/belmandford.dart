import 'package:latlong2/latlong.dart';

import 'package:flutter_mapbox_blog/helper/get_distance.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';

class Graph {
  Map<String, Map<String, double>> currentGraph = {};

  void addEdge(String start, String end, double distance) {
    currentGraph.putIfAbsent(start, () => {});
    currentGraph[start]![end] = distance;
  }

  Map<String, double> bellmanFord(String start) {
    Map<String, double> distances = {};
    Map<String, String> predecessors = {};
    currentGraph.forEach((key, value) {
      distances[key] = double.infinity;
    });
    distances[start] = 0;

    for (int i = 0; i < currentGraph.length - 1; i++) {
      currentGraph.forEach((u, edges) {
        edges.forEach((v, weight) {
          double distance = distances[u]! + weight;
          if (distance < distances[v]!) {
            distances[v] = distance;
            predecessors[v] = u;
          }
        });
      });
    }

    // Check for negative-weight cycles
    currentGraph.forEach((u, edges) {
      edges.forEach((v, weight) {
        double distance = distances[u]! + weight;
        if (distance < distances[v]!) {
          throw Exception("Graph contains a negative-weight cycle");
        }
      });
    });

    return distances;
  }

}

List<MapEntry<String, double>> calculationBellmanFord(List<MapMarker> markers,int indexSrc) {
  Graph graph = Graph();

  for (int i = 0; i < markers.length; i++) {
    for (int j = 0; j < markers.length; j++) {
      graph.addEdge(
        markers[i].title!,
        markers[j].title!,
        calculateDistance(
          LatLng(
            markers[i].location!.latitude,
            markers[i].location!.longitude,
          ),
          LatLng(
            markers[j].location!.latitude,
            markers[j].location!.longitude,
          ),
        ),
      );
    }
  }
  //
  // graph.currentGraph.forEach((key, value) {
  //   print("Graph ${key}: \n  ${value} \n\n");
  // });

  var src = markers[indexSrc].title!;

  Map<String, double> distances = graph.bellmanFord(src);
  // distances.forEach((key, value) {
  //   print("Distance from ${src} to $key: $value");
  // });

  return distances.entries.toList()..sort((e1,e2)=>e1.value.compareTo(e2.value));
}

