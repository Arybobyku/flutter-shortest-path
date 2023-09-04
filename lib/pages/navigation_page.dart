import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mapbox_blog/constants/restaurants.dart';
import 'package:flutter_mapbox_blog/helper/shared_prefs.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../helper/commons.dart';
import '../widgets/carousel_card.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  // Mapbox related]
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  List<MapMarker> mapMarkers = Get.arguments;

  @override
  void initState() {
    super.initState();
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

  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item

    // Add a polyLine between source and destination
    // var geometry = {
    //   "coordinates": [
    //     [lon, lat],
    //     [lon, lat],
    //     [lon, lat],
    //     [lon, lat],
    //     [lon, lat],
    //     [lon, lat],
    //     [lon, lat]
    //   ],
    //   "type": "LineString"
    // };

    var geometry = {
      "coordinates": mapMarkers.map((e) => [e.location!.latitude,e.location!.longitude]).toList(),
      "type": "LineString"
    };

    final _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ]
    };

    // Remove lineLayer and source if it exists
    if (removeLayer == true) {
      await controller.removeLayer("lines");
      await controller.removeSource("fills");
    }

    // Add new source and lineLayer
    await controller.addSource("fills", GeojsonSourceProperties(data: _fills));
    await controller.addLineLayer(
      "fills",
      "lines",

      LineLayerProperties(
        lineColor: Colors.green.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 2,
      ),
    );
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    // for (CameraPosition _kRestaurant in _kRestaurantsList) {
    //   await controller.addSymbol(SymbolOptions(
    //     geometry: _kRestaurant.target,
    //     iconSize: 0.2,
    //     iconImage: "assets/icon/food.png",
    //   ));
    // }
    // _addSourceAndLineLayer(0, false);
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
          minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
        ),
      ),
    );
  }
}
