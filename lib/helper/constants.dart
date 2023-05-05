import 'package:flutter/material.dart';
import 'package:flutter_mapbox_blog/helper/color_palette.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:geocoding/geocoding.dart';
import '../constants/app_constants.dart';

class Constants{
  static const String userName = 'userName';
  static const String role = 'role';
  static const String userModel = 'userModel';
}

var myColor = Colors.redAccent; //Flutter's Color class
var mapBoxColor = Colors.blueAccent;

var placesSearch = PlacesSearch(
  apiKey: AppConstants.mapBoxAccessToken,
  limit: 5,
);



String parseDate(String dateString) {
  var parsedDate = DateTime.parse(dateString);
  return  DateFormat.yMMMMd("en_US").format(parsedDate);
}

String checkStatus(int status){
  switch(status){
    case 0:
      return "Booking";
    case 1:
      return "Pengambilan";
    case 2:
      return "Peminjaman";
    case 3:
      return "Selesai";
    case 4:
      return "Dibatalkan";
    default:
      return "-";
  }
}

String getDurationDifference(DateTime startTime, DateTime endTime){
  final difference = endTime.difference(startTime);

  var sDuration = '';
  sDuration = "${difference.inDays} Hari";
  return sDuration;
}

int getDurationDifferenceInt(DateTime startTime, DateTime endTime){
  final difference = endTime.difference(startTime);
  return difference.inDays;
}

Color backgroundStatus(int status){
  switch(status){
    case 0:
      return ColorPalette.generalSoftOrange;
    case 1:
      return ColorPalette.generalSoftGreen;
    case 2:
      return ColorPalette.generalSoftPurple;
    case 3:
      return ColorPalette.generalSoftYellow;
    case 4:
      return ColorPalette.generalSoftRed;
    default:
      return ColorPalette.generalSoftYellow;
  }
}

final kRoundedContainer = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  border: Border.all(color: ColorPalette.generalPrimaryColor,width: 2),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 7,
      offset: const Offset(0, 1), // changes position of shadow
    ),
  ],
);