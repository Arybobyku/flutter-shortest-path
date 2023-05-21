import 'dart:math';
import 'package:latlong2/latlong.dart';

import 'package:flutter_mapbox_blog/models/map_marker_model.dart';

import 'get_distance.dart';

class Graph {
  Map<String, Vertex> vertices = {};

  void addVertex(String key) {
    Vertex vertex = Vertex(key);
    vertices[key] = vertex;
  }

  Vertex getVertex(String key) {
    return vertices[key]!;
  }

  bool contains(String key) {
    return vertices.containsKey(key);
  }

  Set<Vertex> toSet() {
    List vertex = vertices.values.toList();
    return Set<Vertex>.from(vertex);
  }

  void addEdge(String srcKey, String destKey, [double weight = 1]) {
    vertices[srcKey]!.addNeighbour(vertices[destKey]!, weight);
  }

  bool doesEdgeExist(String srcKey, String destKey) {
    return vertices[srcKey]!.doesItPointTo(vertices[destKey]!);
  }

  int get length {
    return vertices.length;
  }

  Iterable<Vertex> get iterator {
    return vertices.values;
  }
}

class Vertex {
  String key;
  Map<Vertex, double> pointsTo = {};

  Vertex(this.key);

  String get keyVal {
    return key;
  }

  void addNeighbour(Vertex dest, double weight) {
    pointsTo[dest] = weight;
  }

  Iterable<Vertex> getNeighbours() {
    return pointsTo.keys;
  }

  double getWeight(Vertex dest) {
    return pointsTo[dest]!;
  }

  void setWeight(Vertex dest, double weight) {
    pointsTo[dest] = weight;
  }

  bool doesItPointTo(Vertex dest) {
    return pointsTo.containsKey(dest);
  }
}

Map<Vertex, double> bellmanFord(Graph g, Vertex source) {
  Map<Vertex, double> distance = {};
  g.vertices.forEach((_, v) => distance[v] = double.infinity);
  distance[source] = 0;

  for (int i = 0; i < g.vertices.length - 1; i++) {
    g.vertices.forEach((_, v) {
      for (Vertex n in v.pointsTo.keys) {
        distance[n] =
            distance[n] = min(distance[n]!, distance[v]! + v.pointsTo[n]!);
      }
    });
  }
  return distance;
}

Map<Vertex, Map<Vertex, double>> johnson(Graph g) {
  // add new vertex q
  g.addVertex('q');

  // let q point to all other vertices in g with zero-weight edges
  g.vertices.forEach((_, v) {
    g.addEdge('q', v.keyVal, 0);
  });

  // compute shortest distance from vertex q to all other vertices
  Map<Vertex, double> bellDist = bellmanFord(g, g.getVertex('q'));

  // set weight(u, v) = weight(u, v) + bellDist(u) - bellDist(v) for each edge (u, v)
  g.vertices.forEach((_, v) {
    for (Vertex n in v.getNeighbours()) {
      double w = v.getWeight(n).toDouble();
      v.setWeight(n, w + bellDist[v]! - bellDist[n]!);
    }
  });

  // remove vertex q
  g.vertices.remove('q');

  // distance[u][v] will hold smallest distance from vertex u to v
  Map<Vertex, Map<Vertex, double>> distance = {};

  // run Dijkstra's algorithm on each source vertex
  g.vertices.forEach((_, v) {
    distance[v] = dijkstra(g, v);
  });

  // correct distances
  g.vertices.forEach((_, v) {
    g.vertices.forEach((_, w) {
      distance[v]![w] = distance[v]![w]! + (bellDist[w]! - bellDist[v]!);
    });
  });

  // correct weights in original graph
  g.vertices.forEach((_, v) {
    for (Vertex n in v.getNeighbours()) {
      double w = v.getWeight(n);
      v.setWeight(n, w + bellDist[n]! - bellDist[v]!);
    }
  });
  return distance;
}

Map<Vertex, double> dijkstra(Graph g, Vertex source) {
  // Return distance where distance[v] is min distance from source to v.
  // This will return a dictionary distance.
  Set<Vertex> unvisited = g.toSet();
  Map<Vertex, double> distance = {};
  g.vertices.forEach((_, v) {
    distance[v] = double.infinity;
  });

  distance[source] = 0;

  while (unvisited.isNotEmpty) {
    // find vertex with minimum distance
    Vertex closest =
        unvisited.reduce((v1, v2) => distance[v1]! < distance[v2]! ? v1 : v2);

    // mark as visited
    unvisited.remove(closest);

    // update distances
    for (Vertex neighbour in closest.getNeighbours()) {
      if (unvisited.contains(neighbour)) {
        double newDistance = distance[closest]! + closest.getWeight(neighbour);
        if (distance[neighbour]! > newDistance) {
          distance[neighbour] = newDistance;
        }
      }
    }
  }

  return distance;
}

List<JohnsonResult> calculationJhonson(List<MapMarker> markers, int indexSrc) {
  Graph graph = Graph();

  for (var element in markers) {
    graph.addVertex(element.title!);
  }

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

  var distance = johnson(graph);

  List<JohnsonResult> shortestPath = [];
  var fromSource = distance.keys
      .firstWhere((element) => element.key == markers[indexSrc].title);
  fromSource.pointsTo.forEach((key, value) {
    shortestPath.add(JohnsonResult(key.key, value));
  });

  return shortestPath;
}


class JohnsonResult {
  final String key;
  final double value;

  JohnsonResult(this.key,this.value);
}