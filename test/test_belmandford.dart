import 'dart:convert';

import 'package:flutter_mapbox_blog/helper/belmandford.dart';
import 'package:flutter_mapbox_blog/helper/get_distance.dart';
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
      location: MapMarker.toLatLng(3.553579,98.719958),
      rating: 4,
    ),
    MapMarker(
      image: 'assets/images/restaurant_1.jpg',
      title: 'Denai',
      address: 'Denai',
      location: MapMarker.toLatLng(3.552311,98.716971),
      rating: 4,
    ),
    // MapMarker(
    //   image: 'assets/images/restaurant_1.jpg',
    //   title: 'Menteng',
    //   address: 'Menteng',
    //   location: MapMarker.toLatLng(3.560779788289889, 98.72003659616716),
    //   rating: 4,
    // ),
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
    // MapMarker(
    //     image: 'assets/images/restaurant_2.jpg',
    //     title: 'Aceh',
    //     address: '103 Hampstead Rd, London NW1 3EL, United Kingdom',
    //     location: MapMarker.toLatLng(4.906497303037172, 96.27943128787668),
    //     rating: 5),
  ];

  test("Test Belmandord", () async {
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

      print("STEPS $steps");

      for (int step = steps.length - 1; step >= 0; step--) {
        if (step == steps.length - 1) {
          graph.addEdge(
            markers[0].title!,
            "Node ${markers[i].title} ${step-1}",
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

    graph.currentGraph.forEach((key, value) {
      print("Graph TEST ${key}: \n  ${value} `\n\n");
    });

    Map<String, double> distances = graph.bellmanFord(markers[0].title!);

    List<MapEntry<String, double>> results = distances.entries.toList()..sort((e1,e2)=>e1.value.compareTo(e2.value));

    results.removeWhere((element) => element.key.contains('Node'));

    results.forEach((element) {
      print("Setelah perhitungan ${element}");
    });

    // distances.forEach((key, value) {
    //   print("Distance $key: $value");
    // });

    // for (int i = 0; i < markers.length; i++) {
    //   for (int j = 0; j < markers.length; j++) {
    //     if(markers[j].title != markers[0].title){
    //       graph.addEdge(
    //         markers[i].title!,
    //         markers[j].title!,
    //         calculateDistance(
    //           LatLng(
    //             markers[i].location!.latitude,
    //             markers[i].location!.longitude,
    //           ),
    //           LatLng(
    //             markers[j].location!.latitude,
    //             markers[j].location!.longitude,
    //           ),
    //         ),
    //       );
    //     }
    //   }
    // }

    // graph.currentGraph.forEach((key, value) {
    //   print("Graph ${key}: \n  ${value} `\n\n");
    // });
    //
    // Map<String, double> distances = graph.bellmanFord(markers[0].title!);
    // distances.forEach((key, value) {
    //   print("Distance $key: $value");
    // });
    //
    // var src = markers[0].title!;
    // var listJarak = [];
    // var result = [];
    //
    // var currentSource = markers[0].title!;
    // markers.forEach((element) {
    //   print("Current Source: " + currentSource);
    //   Map<String, double> distances = graph.bellmanFord(currentSource);
    //   distances.forEach((key, value) {
    //     print("Distance $key: $value");
    //   });
    //
    //   listJarak = distances.entries.toList()
    //     ..sort((e1, e2) => e1.value.compareTo(e2.value));
    //   currentSource = listJarak[1].key;
    //   print("NEXT Source: " + currentSource);
    //
    //   result.add(currentSource);
    //   print("\n");
    // });
    //
    // print("RESULTS");
    // listJarak.forEach((element) {
    //   print(element);
    // });

    // var src = markers[0].title!;
    //
    // Map<String, double> distances = graph.bellmanFord(src);
    // distances.forEach((key, value) {
    //   print("Distance $key: $value");
    // });
  });

  test("Test Jhonson", () {});
}
