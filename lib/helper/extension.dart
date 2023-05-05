import 'package:geocoding/geocoding.dart';

Future<List<double>> placeNameToLocation(String placeName)async{
  final locations = await locationFromAddress(placeName);
  final latLng = [locations.first.latitude,locations.first.longitude];
  return latLng;
}
