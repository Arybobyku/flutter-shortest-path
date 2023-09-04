import 'package:flutter/material.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  // Mapbox related]
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  Map arguments = Get.arguments;
  List<MapMarker> mapMarkers = [];

  @override
  void initState() {
    super.initState();
    mapMarkers = arguments['Markers'];
    final latitude = mapMarkers.first.location!.latitude;
    final longitude = mapMarkers.first.location!.longitude;
    _initialCameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 17,
    );



    // Calculate the distance and time from data in SharedPreferences
    // for (int index = 0; index < restaurants.length; index++) {
    //   num distance = getDistanceFromSharedPrefs(index) / 1000;
    //   num duration = getDurationFromSharedPrefs(index) / 60;
    //   carouselData
    //       .add({'index': index, 'distance': distance, 'duration': duration});
    // }
    // carouselData.sort((a, b) => a['duration'] < b['duration'] ? 0 : 1);
    //
    // // Generate the list of carousel widgets
    // carouselItems = List<Widget>.generate(
    //     restaurants.length,
    //         (index) => carouselCard(carouselData[index]['index'],
    //         carouselData[index]['distance'], carouselData[index]['duration']));
    //
    // // initialize map symbols in the same order as carousel widgets
    // _kRestaurantsList = List<CameraPosition>.generate(
    //     restaurants.length,
    //         (index) => CameraPosition(
    //         target: getLatLngFromRestaurantData(carouselData[index]['index']),
    //         zoom: 15));
  }

  _addSourceAndLineLayer() async {

    final latitude = mapMarkers.first.location!.latitude;
    final longitude = mapMarkers.first.location!.longitude;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:LatLng(latitude,longitude) ,
        zoom: 15)));

    var geometry = {
      "coordinates":arguments['geometry'],
      "type": "LineString"
    };

    final _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": arguments['geometry']
        },
      ]
    };
    // Add new source and lineLayer
    await controller.addSource("fills", GeojsonSourceProperties(data: _fills));
    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.green.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 4,
      ),
    );
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    print("_onStyleLoadedCallback FLUTTER");
    mapMarkers.forEach((e)async {
      await controller.addSymbol(SymbolOptions(
        geometry: LatLng(e.location!.latitude,e.location!.longitude),
        iconSize: 0.2,
        iconImage: "assets/icons/map-mark.png",
      ));
    });

    _addSourceAndLineLayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Result'),
      ),
      body: SafeArea(
        child: MapboxMap(
          accessToken:
              "pk.eyJ1IjoicmFtYmVtYW5pczI5IiwiYSI6ImNsZjVpeXZmMDFjcGEzdGxjNnVnNThtc28ifQ.7CwNZzs3T5WmqjOiYYrjGA",
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: _onMapCreated,
          onStyleLoadedCallback: _onStyleLoadedCallback,
          myLocationEnabled: true,
          myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
        ),
      ),
    );
  }
}
