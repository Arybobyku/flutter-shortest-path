import 'package:flutter/material.dart';
import 'package:flutter_mapbox_blog/helper/jhonson.dart';
import 'package:flutter_mapbox_blog/provider/calculation_provider.dart';
import 'package:flutter_mapbox_blog/routes.dart';
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
  List<MapMarker> mapMarkers = Get.arguments;

  List<bool> isExpandedBelmand = [];
  List<bool> isExpandedJhonson = [];
  List<MapMarker> mapResults = Get.arguments;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil"),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.resultMap, arguments: mapResults);
            },
            child: const Icon(Icons.map),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
            create: (context) =>
                CalculationProvider()..doCalculation(mapMarkers),
            child: Consumer<CalculationProvider>(
              builder: (context, value, _) {
                List<MapEntry<String, double>>? parent = value.belmanford
                    ?.where((element) => !element.key.contains('Node'))
                    .toList();

                parent?.forEach((element) {
                  isExpandedBelmand.add(false);
                });

                mapResults = [];

                mapResults.add(mapMarkers.first);
                parent?.forEach((element) {
                  var map = mapMarkers.firstWhere((map) => map.title == element.key);
                  mapResults.add(map);
                });

                List<JohnsonResult>? parentJhonson = value.jhonson
                    .where((element) =>
                        !element.key.contains('Node') &&
                        !element.key.contains("${mapMarkers.first.title}"))
                    .toList();

                parentJhonson.forEach((element) {
                  isExpandedJhonson.add(false);
                });

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
                              itemCount: parent?.length ?? 0,
                              itemBuilder: (context, parentIndex) {
                                List<MapEntry<String, double>>? child = value
                                    .belmanford
                                    ?.where((element) => element.key
                                        .contains(parent![parentIndex].key))
                                    .toList();
                                return Column(
                                  children: [
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              parent![parentIndex].key,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              "${parent[parentIndex].value} Meter",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(
                                        () {
                                          isExpandedBelmand[parentIndex] =
                                              !isExpandedBelmand[parentIndex];
                                        },
                                      ),
                                      child: const Text('Detail'),
                                    ),
                                    if (isExpandedBelmand[parentIndex])
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: child?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.only(
                                                    left: 40,
                                                    right: 5,
                                                    top: 5,
                                                    bottom: 5),
                                                color: Colors.green,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        child![index]
                                                            .key
                                                            .split(parent[
                                                                    parentIndex]
                                                                .key)
                                                            .first,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        "${child[index].value} Meter",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                  ],
                                );
                              },
                            ),
                            Text(
                              "${value.time1.elapsed}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "ALGORITMA JOHNSON",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: parentJhonson.length,
                              itemBuilder: (context, parentIndex) {
                                List<JohnsonResult>? child = value.jhonson
                                    .where((element) => element.key
                                        .contains(parent![parentIndex].key))
                                    .toList();

                                return Column(
                                  children: [
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${parentJhonson[parentIndex].key}",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              "${value.jhonson.where((element) => element.key == "Node ${parentJhonson[parentIndex].key} 0").first.value} Meter",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(
                                        () {
                                          isExpandedJhonson[parentIndex] =
                                              !isExpandedJhonson[parentIndex];
                                        },
                                      ),
                                      child: const Text('Detail'),
                                    ),
                                    if (isExpandedJhonson[parentIndex])
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: child.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.only(
                                                    left: 40,
                                                    right: 5,
                                                    top: 5,
                                                    bottom: 5),
                                                color: Colors.green,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        child[index]
                                                            .key
                                                            .split(parentJhonson[
                                                                    parentIndex]
                                                                .key)
                                                            .first,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        "${child[index].value} Meter",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                  ],
                                );
                              },
                            ),
                            Text(
                              "${value.time2.elapsed}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
