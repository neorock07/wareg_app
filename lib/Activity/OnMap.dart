import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Partials/CardButton.dart';
import 'package:wareg_app/Partials/MapBox.dart';
import 'package:wareg_app/Util/IconMaker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wareg_app/Util/Ip.dart';

class OnMap extends StatefulWidget {
  const OnMap({Key? key}) : super(key: key);

  @override
  _OnMapState createState() => _OnMapState();
}

class _OnMapState extends State<OnMap> {
  MapsController mpController = Get.put(MapsController());
  RoadInfo? roadInfo;
  RxBool isPressed = false.obs;
  StreamController<GeoPoint>? stream_controller = StreamController<GeoPoint>();

  List<StaticPositionGeoPoint>? koordinat;

  var userProfile =
      "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg";
  var marker_user;
  var ipAdd = Ip();
  String? updatedUrl;

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";

    koordinat = [
      StaticPositionGeoPoint(
          "2",
          MarkerIcon(
            iconWidget: IconMaker(
                title: mpController.map_dataTarget['title'],
                link: "${mpController.map_dataTarget['url']}"),
          ),
          [
            GeoPoint(
                latitude: mpController.target_lat!,
                longitude: mpController.target_long!),
          ]),
    ];
    setState(() {
      userProfile = prefs.getString('profile_picture')!;
      // ??
      //     "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg";

      marker_user =
          userProfile.replaceFirst("http://localhost:3000", newBaseUrl);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> drawRoute() async {
    double? lat_user, long_user;
    await mpController.controller.myLocation().then((value) {
      lat_user = value.latitude;
      long_user = value.longitude;
    });
    log("lokasi : ${lat_user} ${long_user}");
    roadInfo = await mpController.controller.drawRoad(
        GeoPoint(latitude: lat_user!, longitude: long_user!),
        GeoPoint(
            latitude: mpController.target_lat!,
            longitude: mpController.target_long!),
        roadType: RoadType.bike,
        roadOption: const RoadOption(
            roadColor: Color.fromRGBO(42, 122, 89, 1),
            roadBorderColor: Color.fromRGBO(42, 122, 89, 1),
            zoomInto: true,
            roadWidth: 10));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    drawRoute();
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
                onPressed: () async {},
                icon: Icon(
                  LucideIcons.bell,
                  color: Colors.black,
                )),
            SizedBox(
              width: 5.dm,
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            mpController.isLoading.value = true;
            return true;
          },
          child: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: MapBox(
                    context,
                    mpController.controller,
                    koordinat,
                    userProfile,
                    isDraw: true,
                    lat: mpController.target_lat,
                    long: mpController.target_long,
                  )),
              DraggableScrollableSheet(
                  initialChildSize: 0.45,
                  minChildSize: 0.45,
                  maxChildSize: 0.6,
                  builder: ((context, scrollController) {
                    return Obx(() {
                      return Container(
                        color: Colors.white,
                        child: (mpController.isLoading.value)
                            ? Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SpinKitDoubleBounce(
                                          color: Colors.blue, size: 20.dm),
                                      Text(
                                        "Loading...",
                                        style: TextStyle(fontFamily: "Poppins"),
                                      )
                                    ]),
                              )
                            : ListView(controller: scrollController, children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: Container(
                                          height: 100.h,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.dm),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      "${updatedUrl}"),
                                                  scale: 1,
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 15.h,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${mpController.map_dataTarget['title']}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "Poppins",
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${mpController.map_dataTarget['alamat']}",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: "Poppins",
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                Text(
                                                  "${mpController.map_dataTarget['stok']} porsi | Layak Konsumsi",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: "Poppins",
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  height: 45.dm,
                                                  width: 45.dm,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.dm),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg",
                                                              scale: 1))),
                                                ),
                                                Text(
                                                  "John Cena",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 10.sp,
                                                      color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                      );
                    });
                  })),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Container(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(() =>
                            CardButton(context, isPressed, onTap: (_) async {
                              isPressed.value = true;
                              double? lat_user, long_user;
                              await mpController.controller
                                  .myLocation()
                                  .then((value) {
                                lat_user = value.latitude;
                                long_user = value.longitude;
                              });
                              log("lokasi : ${lat_user} ${long_user}");
                              roadInfo = await mpController.controller.drawRoad(
                                  GeoPoint(
                                      latitude: lat_user!,
                                      longitude: long_user!),
                                  GeoPoint(
                                      latitude: -7.056030,
                                      longitude: 110.434945),
                                  roadType: RoadType.bike,
                                  roadOption: RoadOption(
                                      roadColor: Color.fromRGBO(42, 122, 89, 1),
                                      roadBorderColor:
                                          Color.fromRGBO(42, 122, 89, 1),
                                      zoomInto: true,
                                      roadWidth: 10));
                              print("Jarak : ${roadInfo!.distance! * 1000} m");
                              log("Jarak : ${roadInfo!.distance! * 1000} m");
                              log("Jarak : ${roadInfo!.instructions}");
                              log("lokasi user : ");
                            },
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(52, 135, 98, 1),
                                  Color.fromRGBO(48, 122, 99, 1),
                                ]),
                                width_b: 0.7,
                                width_a: 0.6,
                                height_b: 40.h,
                                height_a: 38.h,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.dm),
                                    child: Center(
                                      child: Text(
                                        "Ambil ini",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))),
                        IconButton(
                            color: Colors.grey,
                            onPressed: () async {
                              // log("lokasi user : )}");
                            },
                            icon: Icon(LucideIcons.messagesSquare))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
