import 'package:flutter/cupertino.dart';
import 'package:flutter_mapbox_blog/helper/belmandford.dart';
import 'package:flutter_mapbox_blog/helper/jhonson.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';

class CalculationProvider extends ChangeNotifier {
  List<MapEntry<String, double>>? belmanford;
  List<JohnsonResult> jhonson = [];
  Stopwatch time1 = Stopwatch();
  Stopwatch time2 = Stopwatch();
  bool isLoadingBelmandFord = true;
  bool isLoadingJhonson = true;


  doCalculation(List<MapMarker> mapMarkers){
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
