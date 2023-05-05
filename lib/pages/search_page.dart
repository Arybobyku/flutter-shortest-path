import 'package:flutter/material.dart';
import 'package:flutter_mapbox_blog/widgets/input_field_rounded.dart';
import 'package:get/get.dart';
import 'package:mapbox_search/mapbox_search.dart';

import '../helper/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<MapBoxPlace> places = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Alamat'),
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
                      InputFieldRounded(
                        hint: "Cari Alamat",
                        onFieldSubmitted: (value) async {
                          if(value!=null){
                            places = await getPlaces(value) ?? [];
                            setState(() {});
                          }
                        },
                        secureText: false,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              Get.back(result: places[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                places[index].placeName ?? "-",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<MapBoxPlace>?> getPlaces(String name) =>
      placesSearch.getPlaces(name);
}
