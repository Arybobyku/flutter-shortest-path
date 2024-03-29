import 'dart:convert';
import 'dart:math';
import 'package:latlong2/latlong.dart';

import 'package:http/http.dart' as http;
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

Future<List<JohnsonResult>> calculationJhonson(
    List<MapMarker> markers, int indexSrc) async {
  Graph graph = Graph();

  for (var element in markers) {
    graph.addVertex(element.title!);
  }

  for (int i = 1; i < markers.length; i++) {
    final srcLat = markers[0].location!.latitude;
    final srcLng = markers[0].location!.longitude;

    final desLat = markers[i].location!.latitude;
    final desLng = markers[i].location!.longitude;

    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/$srcLng,$srcLat;$desLng,$desLat?access_token=pk.eyJ1IjoicmFtYmVtYW5pczI5IiwiYSI6ImNsZjVpeXZmMDFjcGEzdGxjNnVnNThtc28ifQ.7CwNZzs3T5WmqjOiYYrjGA&steps=true&language=IDN';
    final http.Response response = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(response.body);

    final steps = data['routes'][0]['legs'][0]['steps'];

    for (int step = steps.length - 1; step >= 0; step--) {
      graph.addVertex("Node ${markers[i].title} ${step - 1}");
      if (step == steps.length - 1) {
        graph.addEdge(
          markers[0].title!,
          "Node ${markers[i].title} ${step - 1}",
          steps[step]['distance'].toDouble(),
        );
      } else {
        graph.addEdge(
          markers[i].title!,
          "Node ${markers[i].title} $step",
          steps[step]['distance'].toDouble(),
        );

        if (step - 1 >= 0) {
          graph.addEdge(
            "Node ${markers[i].title} $step",
            "Node ${markers[i].title} ${step - 1}",
            steps[step]['distance'].toDouble(),
          );
        } else {
          graph.addEdge(
            "Node ${markers[i].title} $step",
            markers[i].title!,
            steps[step]['distance'].toDouble(),
          );
        }
      }
    }
  }

  graph.vertices.forEach((key, value) {
    print("JHONSON GRAPH ${key} ");
    value.pointsTo.forEach((key, value) {
      print("/n ${key} : $value");
    });
  });
  var distance = johnson(graph);

  List<JohnsonResult> shortestPath = [];
  distance.values.first.forEach((key, value) {
    shortestPath.add(JohnsonResult(key.key, value));
  });

  shortestPath.removeWhere((element) => element.value == 0.0);
  shortestPath.removeWhere((element) => element.value == double.infinity);
  // shortestPath.sort((e1, e2) => e2.value.compareTo(e1.value));

  return shortestPath;
}

class JohnsonResult {
  final String key;
  final double value;

  JohnsonResult(this.key, this.value);
}
