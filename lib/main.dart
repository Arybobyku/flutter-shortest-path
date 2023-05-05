import 'package:flutter/material.dart';
import 'package:flutter_mapbox_blog/helper/color_palette.dart';
import 'package:flutter_mapbox_blog/pages/home_page.dart';
import 'package:flutter_mapbox_blog/routes.dart';
import 'package:flutter_mapbox_blog/setup_locator.dart';
import 'package:get/get.dart';

import 'injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection();
  setupLocator().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      theme: ThemeData(
        scaffoldBackgroundColor: ColorPalette.generalBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorPalette.generalPrimaryColor
        )
      ),
      debugShowCheckedModeBanner: false,
      title: 'Shortest Path',
      initialRoute: Routes.dashboard,
      getPages: Routes.newRoutes,
    );
  }
}
