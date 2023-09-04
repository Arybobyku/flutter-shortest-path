import 'package:flutter_mapbox_blog/pages/dashboard_page.dart';
import 'package:flutter_mapbox_blog/pages/home_page.dart';
import 'package:flutter_mapbox_blog/pages/navigation_page.dart';
import 'package:flutter_mapbox_blog/pages/result_map_page.dart';
import 'package:flutter_mapbox_blog/pages/result_page.dart';
import 'package:flutter_mapbox_blog/pages/search_page.dart';
import 'package:get/get.dart';

class Routes {
  Routes._();

  static const String search = "/search";
  static const String home = "/home";
  static const String dashboard = "/dashboard";
  static const String result = "/result";
  static const String resultMap = "/resultMap";
  static const String navigation = "/navigationPage";

  static final newRoutes = <GetPage>[
    GetPage(
        name: search,
        page: () {
          return const SearchPage();
        }),
    GetPage(
        name: home,
        page: () {
          return const HomePage();
        }),
    GetPage(
        name: dashboard,
        page: () {
          return const DashBoardPage();
        }),
    GetPage(
        name: result,
        page: () {
          return const ResultPage();
        }),
    GetPage(
        name: resultMap,
        page: () {
          return const ResultMapPage();
        }),
    GetPage(
        name: navigation,
        page: () {
          return const NavigationPage();
        }),
  ];
}
