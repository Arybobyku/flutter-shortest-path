import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final LatLng source = LatLng(37.7749, -122.4194); // Source coordinates
  final LatLng destination = LatLng(34.0522, -118.2437); // Destination coordinates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Maps'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: source, // Center the map on the source coordinates
          zoom: 6.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayerOptions(
            polylines: [
              Polyline(
                points: [source, destination], // List of LatLng points
                color: Colors.blue, // Polyline color
                strokeWidth: 3.0,   // Polyline width
              ),
            ],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: source,
                builder: (ctx) => const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: destination,
                builder: (ctx) => const Icon(
                  Icons.location_pin,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}