import 'dart:io';

import 'package:flutter_mapbox_blog/helper/get_distance.dart';
import 'package:flutter_mapbox_blog/helper/jhonson.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:latlong2/latlong.dart';

void main(){

  List<MapMarker> markers = [
    MapMarker(
        image: 'assets/images/restaurant_1.jpg',
        title: 'Medan',
        address: '8 Plender St, London NW1 0JT, United Kingdom',
        location: MapMarker.toLatLng(3.407539653091186, 98.35273677975381),
        rating: 4),
    MapMarker(
        image: 'assets/images/restaurant_2.jpg',
        title: 'Aceh',
        address: '103 Hampstead Rd, London NW1 3EL, United Kingdom',
        location: MapMarker.toLatLng(4.906497303037172, 96.27943128787668),
        rating: 5),
    MapMarker(
        image: 'assets/images/restaurant_3.jpg',
        title: 'Pekan Baru',
        address: '122 Palace Gardens Terrace, London W8 4RT, United Kingdom',
        location: MapMarker.toLatLng(0.44752096452711254, 101.31109758186207),
        rating: 2),
    MapMarker(
        image: 'assets/images/restaurant_4.jpg',
        title: 'Padang',
        address: '2 More London Riverside, London SE1 2AP, United Kingdom',
        location: MapMarker.toLatLng(-0.9465288553484569, 100.48548742688283),
        rating: 3),
    MapMarker(
      image: 'assets/images/restaurant_5.jpg',
      title: 'Sidikalang',
      address: '42 Kingsway, London WC2B 6EY, United Kingdom',
      location: MapMarker.toLatLng(2.7522784482164693, 98.21330773632826),
      rating: 4,
    ),
  ];

  test('TEST JHONSON', (){

    Graph graph = Graph();

    for (var element in markers) {
      graph.addVertex(element.title!);
    }

    for (int i = 0; i < markers.length; i++) {
      for (int j = 0; j < markers.length; j++) {
        if(markers[j].title != markers[0].title){
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
    }

    var distance = johnson(graph);


    Map<String, double> shortestPath = {};

   var fromMedan =  distance.keys.firstWhere((element) => element.key == markers.first.title);
   fromMedan.pointsTo.forEach((key, value) {

     shortestPath[key.key] = value;
   });

   shortestPath.forEach((key, value) {
     print("${key} : $value");
   });

  });
}