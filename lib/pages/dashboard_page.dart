import 'package:flutter/material.dart';
import 'package:flutter_mapbox_blog/helper/extension.dart';
import 'package:flutter_mapbox_blog/models/map_marker_model.dart';
import 'package:flutter_mapbox_blog/routes.dart';
import 'package:flutter_mapbox_blog/widgets/button_rounded.dart';
import 'package:get/get.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:latlong2/latlong.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  List<MapBoxPlace> places = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shortest Path"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          var result = await Get.toNamed(Routes.search);
                          if (result != null) {
                            setState(() {
                              places.add(result);
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text("Cari Alamat"),
                              ),
                              Icon(Icons.search),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Row(
                              children: [
                                const Icon(Icons.location_pin),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    places[index].placeName ?? "-",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      places.remove(places[index]);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.restore_from_trash,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ButtonRounded(
                text: "Lihat Route",
                onPressed: () async {
                  List<MapMarker> mapMarkers = [];
                  for (var element in places) {
                    List<double> result =
                        await placeNameToLocation(element.placeName!);
                    mapMarkers.add(
                      MapMarker(
                        image: 'assets/images/restaurant_1.jpg',
                        title: element.placeName,
                        address: element.placeName,
                        location: LatLng(result[0], result[1]),
                        rating: 5,
                      ),
                    );
                  }
                  Get.toNamed(Routes.home, arguments: mapMarkers);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
