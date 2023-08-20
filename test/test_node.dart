import 'package:flutter_mapbox_blog/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final String apiKey = AppConstants.mapBoxAccessToken;
  final String destination = '-122.4064,37.7858';
  final List<List<double>> nodes = [
    [-122.4194, 37.7749],  // Node 1
    [-122.4184, 37.7755],  // Node 2
    [-122.4120, 37.7800],  // Node 3
  ];

  for (var node in nodes) {
    final String origin = '${node[0]},${node[1]}';
    final String url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/$origin;$destination.json?access_token=$apiKey';

    print(url);
    // final http.Response response = await http.get(Uri.parse(url));
    // final Map<String, dynamic> data = json.decode(response.body);
    // print(data);
    // final double distance = data['routes'][0]['legs'][0]['distance'];
    //
    // print('From Node $origin to Destination: Distance: $distance meters');
    // for (var step in data['routes'][0]['legs'][0]['steps']) {
    //   final String instruction = step['maneuver']['instruction'];
    //   final String roadName = step['name'];
    //   print('$instruction on $roadName');
    // }
  }
}
