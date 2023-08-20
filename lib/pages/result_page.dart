import 'package:flutter/material.dart';
import 'package:flutter_mapbox_blog/helper/jhonson.dart';
import 'package:flutter_mapbox_blog/provider/calculation_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../helper/belmandford.dart';
import '../models/map_marker_model.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<MapMarker> mapMarkers = Get.arguments;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
            create:(context)=> CalculationProvider()..doCalculation(mapMarkers),
            child: Consumer<CalculationProvider>(
              builder: (context,value,_) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: value.isLoadingJhonson || value.isLoadingBelmandFord
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            const Text(
                              "BELLMAND FORD",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: value.belmanford?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              value.belmanford![index].key,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              "${value.belmanford![index].value} KM",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                     Text("Lihat Node"),
                                  ],
                                );
                              },
                            ),
                            Text(
                              "${value.time1.elapsed}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "ALGORITMA JOHNSON",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: value.jhonson.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${value.jhonson[index].key} KM",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          "${value.jhonson[index].value} KM",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Text(
                              "${value.time2.elapsed}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
