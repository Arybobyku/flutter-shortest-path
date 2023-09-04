import 'package:flutter/cupertino.dart';
import 'package:flutter_mapbox_blog/helper/belmandford.dart';
import 'package:flutter_mapbox_blog/helper/directions_handler.dart';
import 'package:flutter_mapbox_blog/helper/jhonson.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
class CalculationProvider extends ChangeNotifier {
  List<MapEntry<String, double>>? belmanford;
  List<JohnsonResult> jhonson = [];
  Stopwatch time1 = Stopwatch();
  Stopwatch time2 = Stopwatch();
  bool isLoadingBelmandFord = true;
  bool isLoadingJhonson = true;
  bool isLoadingMap = false;


  Future<Map> getDirectionsMap(List<MapMarker> markers)async{
    isLoadingMap = true;
    notifyListeners();
    //
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // print("${position.latitude} ${position.longitude}");
    // markers.insert(0, MapMarker(image:"" , title: "Current Position", address: "Current Position", location: LatLng(position.latitude,position.longitude), rating: 0));

    final result = await getDirectionsAPIResponse(markers);
    isLoadingMap = false;
    notifyListeners();
    return result;
  }

  doCalculation(List<MapMarker> mapMarkers)async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    mapMarkers.insert(0, MapMarker(image:"" , title: "Current Position", address: "Current Position", location: LatLng(position.latitude,position.longitude), rating: 0));
    doCalculationBelmandFord(mapMarkers);
    doCalculationJhonson(mapMarkers);
  }

  Future<void> doCalculationBelmandFord(List<MapMarker> mapMarkers) async{
    time1.start();
    belmanford = await calculationBellmanFord(mapMarkers, 0);
    time1.stop();
    isLoadingBelmandFord = false;
    notifyListeners();
  }

  Future<void> doCalculationJhonson(List<MapMarker> mapMarkers) async{
    time2.start();
    jhonson = await calculationJhonson(mapMarkers, 0);
    time2.stop();
    isLoadingJhonson = false;
    notifyListeners();
  }
}
