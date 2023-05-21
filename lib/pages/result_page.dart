import 'package:flutter/material.dart';
import 'package:flutter_mapbox_blog/helper/jhonson.dart';
import 'package:get/get.dart';

import '../helper/belmandford.dart';
import '../models/map_marker_model.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<MapMarker> mapMarkers = Get.arguments;
  List<MapEntry<String, double>>? belmanford;
  List<JohnsonResult> jhonson = [];
  Stopwatch time1 = Stopwatch();
  Stopwatch time2 = Stopwatch();

  @override
  void initState() {
    super.initState();

    time1.start();
    belmanford = calculationBellmanFord(mapMarkers, 0);
    time1.stop();
    time2.start();
    jhonson = calculationJhonson(mapMarkers, 0);
    time2.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Text(
                  "BELLMAND FORD",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: belmanford?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${belmanford![index].key}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              "${belmanford![index].value} KM",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  "${time1.elapsed}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  "ALGORITMA JOHNSON",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: jhonson.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${jhonson[index].key} KM",
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              "${jhonson[index].value} KM",
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  "${time2.elapsed}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
