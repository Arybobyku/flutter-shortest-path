import 'dart:convert';
import 'dart:io';

import 'package:flutter_mapbox_blog/helper/get_distance.dart';
import 'package:flutter_mapbox_blog/helper/jhonson.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

void main() {
  List<MapMarker> markers = [
    MapMarker(
      image: 'assets/images/restaurant_1.jpg',
      title: 'Amplas',
      address: 'Amplas',
      location: MapMarker.toLatLng(3.5424722435789127, 98.71752402741794),
      rating: 4,
    ),
    MapMarker(
      image: 'assets/images/restaurant_1.jpg',
      title: 'Denai',
      address: 'Denai',
      location: MapMarker.toLatLng(3.5835181755924177, 98.71531157048504),
      rating: 4,
    ),
    MapMarker(
      image: 'assets/images/restaurant_1.jpg',
      title: 'Menteng',
      address: 'Menteng',
      location: MapMarker.toLatLng(3.560779788289889, 98.72003659616716),
      rating: 4,
    ),
    // MapMarker(
    //     image: 'assets/images/restaurant_1.jpg',
    //     title: 'Medan',
    //     address: '8 Plender St, London NW1 0JT, United Kingdom',
    //     location: MapMarker.toLatLng(3.407539653091186, 98.35273677975381),
    //     rating: 4),
    // MapMarker(
    //     image: 'assets/images/restaurant_2.jpg',
    //     title: 'Aceh',
    //     address: '103 Hampstead Rd, London NW1 3EL, United Kingdom',
    //     location: MapMarker.toLatLng(4.906497303037172, 96.27943128787668),
    //     rating: 5),
    // MapMarker(
    //     image: 'assets/images/restaurant_3.jpg',
    //     title: 'Pekan Baru',
    //     address: '122 Palace Gardens Terrace, London W8 4RT, United Kingdom',
    //     location: MapMarker.toLatLng(0.44752096452711254, 101.31109758186207),
    //     rating: 2),
    // MapMarker(
    //     image: 'assets/images/restaurant_4.jpg',
    //     title: 'Padang',
    //     address: '2 More London Riverside, London SE1 2AP, United Kingdom',
    //     location: MapMarker.toLatLng(-0.9465288553484569, 100.48548742688283),
    //     rating: 3),
    // MapMarker(
    //   image: 'assets/images/restaurant_5.jpg',
    //   title: 'Sidikalang',
    //   address: '42 Kingsway, London WC2B 6EY, United Kingdom',
    //   location: MapMarker.toLatLng(2.7522784482164693, 98.21330773632826),
    //   rating: 4,
    // ),
  ];

  test('TEST JHONSON', () async {
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


      for (int step = steps.length - 1; step > 0; step--) {
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

    var distance = johnson(graph);

    var testDsitance = johnson(graph);

    Map<String, double> shortestPath = {};
    //
    // graph.vertices.forEach((key, value) {
    //   print("DISTANCE ${key.key} ${value}");
    // });

    distance.values.first.forEach((key, value) {
        shortestPath[key.key] = value;
    });

    // var fromMedan = distance.keys
    //     .firstWhere((element) => element.key == markers.first.title);


    // fromMedan.pointsTo.forEach((key, value) {
    //   shortestPath[key.key] = value;
    // });

    shortestPath.forEach((key, value) {
      print("${key} : $value");
    });
  });
}
