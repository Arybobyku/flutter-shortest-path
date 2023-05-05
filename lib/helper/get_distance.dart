import 'package:latlong2/latlong.dart';

import 'dart:math' as math;

double calculateDistance(LatLng start, LatLng end) {
  const radius = 6371; // Earth's radius in km
  var latDiff = (end.latitude - start.latitude) * math.pi / 180;
  var lngDiff = (end.longitude - start.longitude) * math.pi / 180;
  var a = math.sin(latDiff / 2) * math.sin(latDiff / 2) +
      math.cos(start.latitude * math.pi / 180) *
          math.cos(end.latitude * math.pi / 180) *
          math.sin(lngDiff / 2) *
          math.sin(lngDiff / 2);
  var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  var distance = radius * c;
  return distance;
}

