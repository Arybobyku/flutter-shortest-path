import 'package:flutter_mapbox_blog/pages/dashboard_page.dart';
import 'package:flutter_mapbox_blog/pages/home_page.dart';
import 'package:flutter_mapbox_blog/pages/search_page.dart';
import 'package:get/get.dart';

class Routes{
  Routes._();

  static const String search = "/search";
  static const String home = "/home";
  static const String dashboard = "/dashboard";

  static final newRoutes = <GetPage>[
    GetPage(name: search, page:(){return const SearchPage();}),
    GetPage(name: home, page:(){return const HomePage();}),
    GetPage(name: dashboard, page:(){return const DashBoardPage();}),
  ];
}