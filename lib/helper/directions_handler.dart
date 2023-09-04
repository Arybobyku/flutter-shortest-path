import 'package:flutter_mapbox_blog/helper/mapbox_requests.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';

Future<Map> getDirectionsAPIResponse(List<MapMarker> markers) async {
  final response = await getCyclingRouteUsingMapbox(markers);
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];
  print(distance);
  print(duration);

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
    "Markers": markers,
  };
  return modifiedResponse;
}
