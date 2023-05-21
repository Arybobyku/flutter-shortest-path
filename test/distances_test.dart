import 'package:flutter_mapbox_blog/helper/belmandford.dart';
import 'package:flutter_mapbox_blog/helper/get_distance.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  List<LatLng> points = [
    LatLng(40.7128, -74.0060), // New York City
    LatLng(51.5074, -0.1278), // London
    LatLng(35.6895, 139.6917), // Tokyo
    LatLng(37.7749, -122.4194), // San Francisco
    LatLng(-33.8688, 151.2093), // Sydney sydney
  ];

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

  test("Test Each distance", () {
    List<double> distances = [];
    for (int i = 0; i < markers.length; i++) {
      for (int j = i; j < markers.length; j++) {
        distances.add(
          calculateDistance(
            LatLng(
              markers[i].location!.latitude,
              markers[i].location!.longitude,
            ),
            LatLng(
              markers[i + 1].location!.latitude,
              markers[i + 1].location!.longitude,
            ),
          ),
        );
      }
    }
    print(distances);
  });

  test("Test Belmandord", () {
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

    graph.currentGraph.forEach((key, value) {
      print("Graph ${key}: \n  ${value} \n\n");
    });

    var src = markers[0].title!;

    Map<String, double> distances = graph.bellmanFord(src);
    distances.forEach((key, value) {
      print("Distance from ${src} to $key: $value");
    });
  });

  test("Test Jhonson", (){

  });
}
