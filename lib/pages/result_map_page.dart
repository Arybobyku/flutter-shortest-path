import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mapbox_blog/constants/app_constants.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ResultMapPage extends StatefulWidget {
  const ResultMapPage({Key? key}) : super(key: key);

  @override
  State<ResultMapPage> createState() => _ResultMapPageState();
}

class _ResultMapPageState extends State<ResultMapPage> {
  final List<MapMarker> mapMarkers = Get.arguments;
  List<LatLng> latlngList = [];

  @override
  void initState() {
    mapMarkers.forEach((element) {
      latlngList.add(element.location!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Map"),
      ),
      body: Center(
        child: FlutterMap(
          options: MapOptions(
            center: mapMarkers.first.location,
            zoom: 12.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/rambemanis29/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
              additionalOptions: {
                'mapStyleId': AppConstants.mapBoxStyleId,
                'accessToken': AppConstants.mapBoxAccessToken,
              },
            ),
            MarkerLayerOptions(
              markers: [
                for (int i = 0; i < mapMarkers.length; i++)
                  Marker(
                    height: 40,
                    width: 40,
                    point: mapMarkers[i].location!,
                    builder: (_) {
                      return SvgPicture.asset(
                        'assets/icons/map_marker.svg',
                      );
                    },
                  ),
              ],
            ),
            PolylineLayerOptions(polylines: [
              Polyline(
                points: latlngList,
                // isDotted: true,
                color: Color(0xFF669DF6),
                strokeWidth: 3.0,
                borderColor: Color(0xFF1967D2),
                borderStrokeWidth: 0.1,
              )
            ])
          ],
        ),
      ),
    );
  }
}
