import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'dio_exceptions.dart';


String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
String accessToken = 'pk.eyJ1IjoicmFtYmVtYW5pczI5IiwiYSI6ImNsZjVpeXZmMDFjcGEzdGxjNnVnNThtc28ifQ.7CwNZzs3T5WmqjOiYYrjGA';
String navType = 'driving';

Dio _dio = Dio();

Future getCyclingRouteUsingMapbox(List<MapMarker> markers) async {
  var path = '';
  for (var element in markers) {
    path += "${element.location!.longitude},${element.location!.latitude};";
  }
  path = path.substring(0, path.length - 1);
  String url =
      '$baseUrl/$navType/$path?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
    debugPrint(errorMessage);
  }
}
