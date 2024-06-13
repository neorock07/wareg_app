import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Partials/CardMenu.dart';
import 'package:wareg_app/Partials/CardSearch.dart';
import 'package:wareg_app/Partials/MapBox.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import '../Util/IconMaker.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  MapsController mpController = Get.put(MapsController());
  RoadInfo? roadInfo;
  List<StaticPositionGeoPoint> koordinat = [
    StaticPositionGeoPoint(
        "1",
        MarkerIcon(
          iconWidget: IconMaker(
              link:
                  "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg"),
        ),
        [
          GeoPoint(latitude: -7.0534702, longitude: 110.4351644),
          GeoPoint(latitude: -7.0525505, longitude: 110.4333261),
          GeoPoint(latitude: -7.5809948, longitude: 110.8101376),
          GeoPoint(latitude: -7.5739886, longitude: 110.8098979),
        ]),
    StaticPositionGeoPoint(
        "2",
        MarkerIcon(
          iconWidget: IconMaker(
              link:
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpKUky4T34nKLYbMLkA2Yz2_QCi4vlHgSuN6oGXRn4zw&s"),
        ),
        [
          GeoPoint(latitude: -7.5739886, longitude: 110.8098979),
        ]),
  ];
  Future setPos() async {
    // await mpController.controller.setStaticPosition(koordinat, "1");
    await mpController.controller.setMarkerOfStaticPoint(
        id: "1",
        markerIcon: MarkerIcon(
          iconWidget: IconMaker(
              link:
                  "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg"),
        ));
    // roadInfo = await mpController.controller.drawRoad(
    //     GeoPoint(latitude: -7.5809948, longitude: 110.8101376),
    //     GeoPoint(latitude: -7.5802194, longitude: 110.8093534),
    //     roadType: RoadType.bike,
    //     roadOption: RoadOption(
    //       roadColor: Color.fromRGBO(42, 122, 89, 1),
    //       zoomInto: true,
    //       roadWidth: 10
    //       )
    //     );
  }

  @override
  void initState() {
    super.initState();
    setPos();
    ScrollController scController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hi, Neo",
          style: TextStyle(fontFamily: "Bree", color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () async {
               
              },
              icon: Icon(
                LucideIcons.bell,
                color: Colors.black,
              )),
          SizedBox(
            width: 5.dm,
          )
        ],
      ),
      body: Stack(children: [
        Column(
          children: [
            CardSearch(context),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  "Lokasi",
                  style: TextStyle(
                      color: Colors.black, fontFamily: "Bree", fontSize: 16.sp),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.dm),
                    color: const Color.fromARGB(255, 237, 235, 235)),
                child: Padding(
                  padding: EdgeInsets.all(4.dm),
                  child: MapBox(context, mpController.controller, koordinat),
                ),
              ),
            ),
          ],
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.45,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.dm),
                        topRight: Radius.circular(15.dm))),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Makanan Terdekat",
                          style: TextStyle(
                              fontFamily: "Bree",
                              color: Colors.black,
                              fontSize: 16.sp),
                        ),
                        Row(
                          children: [
                            ChoiceChip(
                              label: const Center(
                                child: Text(
                                  "Terdekat",
                                ),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.black, fontSize: 10.sp),
                              selected: true,
                              side: BorderSide(
                                color: Color.fromRGBO(42, 122, 89, 1),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.dm)),
                              selectedColor: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            ChoiceChip(
                              label: Center(
                                child: Text(
                                  "Semua",
                                ),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.black, fontSize: 10.sp),
                              selected: false,
                              side: BorderSide(
                                color: Color.fromRGBO(42, 122, 89, 1),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.dm)),
                              selectedColor: Colors.white,
                              disabledColor: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      // height: 80.h,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 40.h),
                        child: ListView.builder(
                            controller: scrollController,
                            itemCount: 10,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, "/onmap");
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 5.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CardMenu(context),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Divider(
                                        height: 2.h,
                                        color: Colors.grey,
                                        indent: 10,
                                        endIndent: 10,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              );
            })
      ]),
    );
  }
}
