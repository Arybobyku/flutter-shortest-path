import 'dart:convert';

import 'package:flutter_mapbox_blog/helper/get_distance.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

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

Future<List<MapEntry<String, double>>> calculationBellmanFord(
    List<MapMarker> markers, int indexSrc) async {
  Graph graph = Graph();

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
      if (step == steps.length - 1) {
        graph.addEdge(
          markers[0].title!,
          "Node ${step - 1} ${markers[i].title}",
          steps[step]['distance'].toDouble(),
        );
      } else {
        graph.addEdge(
          markers[i].title!,
          "Node $step ${markers[i].title}",
          steps[step]['distance'].toDouble(),
        );

        if (step - 1 >= 0) {
          graph.addEdge(
            "Node $step ${markers[i].title}",
            "Node ${step - 1} ${markers[i].title}",
            steps[step]['distance'].toDouble(),
          );
        } else {
          graph.addEdge(
            "Node $step ${markers[i].title}",
            markers[i].title!,
            steps[step]['distance'].toDouble(),
          );
        }
      }
    }
  }

  graph.currentGraph.forEach((key, value) {
    print("Graph TEST ${key}: \n  ${value} `\n\n");
  });

  var src = markers[indexSrc].title!;

  Map<String, double> distances = graph.bellmanFord(src);
  List<MapEntry<String, double>> results = distances.entries.toList()
    ..sort((e1, e2) => e1.value.compareTo(e2.value));

  // results.removeWhere((element) => element.key.contains('Node'));
  results.removeWhere((element) => element.value == 0.0);

  results.forEach((element) {
    print("RESULTS ${element.key} => ${element.value}");
  });

  return results;
}
