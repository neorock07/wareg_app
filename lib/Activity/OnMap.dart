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
  StreamController<GeoPoint>? streamController = StreamController<GeoPoint>();
  Timer? locationUpdateTimer;

  List<StaticPositionGeoPoint>? koordinat;

  var userProfile =
      "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg";
  var markerUser;
  var ipAdd = Ip();
  String? updatedUrl;
  String? post_foto;
  String? donatur_foto;
  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";
    post_foto = mpController.map_dataTarget['url']
        .toString()
        .replaceFirst("http://localhost:3000", newBaseUrl);
    donatur_foto = mpController.map_dataTarget['donatur_profile']
        .toString()
        .replaceFirst("http://localhost:3000", newBaseUrl);
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
      markerUser =
          userProfile.replaceFirst("http://localhost:3000", newBaseUrl);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
    startLocationUpdates();
  }

  @override
  void dispose() {
    locationUpdateTimer?.cancel();
    streamController?.close();
    super.dispose();
  }

  void startLocationUpdates() {
    locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      double? latUser, longUser;
      await mpController.controller.myLocation().then((value) {
        latUser = value.latitude;
        longUser = value.longitude;
      });
      if (latUser != null && longUser != null) {
        streamController
            ?.add(GeoPoint(latitude: latUser!, longitude: longUser!));
      }
    });
  }

  Future<void> drawRoute(GeoPoint userLocation) async {
    await mpController.controller.removeLastRoad();
    roadInfo = await mpController.controller.drawRoad(
        userLocation,
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${mpController.map_dataTarget['title']}",
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
                  child: StreamBuilder<GeoPoint>(
                      stream: streamController?.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          drawRoute(snapshot.data!);
                        }
                        return MapBox(
                          context,
                          mpController.controller,
                          koordinat,
                          userProfile,
                          isDraw: true,
                          lat: mpController.target_lat,
                          long: mpController.target_long,
                        );
                      })),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10.h),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w, right: 20.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
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
                                                              "${donatur_foto}",
                                                              scale: 1))),
                                                ),
                                                SizedBox(width: 10.w),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${mpController.map_dataTarget['donatur_name']}",
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 14.sp,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      "donatur",
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 12.sp,
                                                          color: Colors.grey),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.star,
                                                            color: Colors.amber,
                                                            size: 10.dm),
                                                        Text(
                                                          (mpController.map_dataTarget[
                                                                          'rating'] ==
                                                                      0 ||
                                                                  mpController.map_dataTarget[
                                                                          'rating'] ==
                                                                      null)
                                                              ? "Belum ada"
                                                              : "${mpController.map_dataTarget['rating']}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.amber),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Makanan",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 12.sp,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  "${mpController.map_dataTarget['title']}",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 14.sp,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.h, left: 20.w),
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
                                                      "${post_foto}"),
                                                  scale: 1,
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 15.h,
                                          left: 20.w,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Waktu Posting",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: "Poppins",
                                                  fontSize: 14.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              "${mpController.map_dataTarget['updateAt']}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Poppins",
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              "(${mpController.map_dataTarget['expiredAt']})",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontFamily: "Poppins",
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              "Alamat Pengambilan",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: "Poppins",
                                                  fontSize: 14.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              "${mpController.map_dataTarget['alamat']}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Poppins",
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              "${mpController.map_dataTarget['deskripsi']}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Poppins",
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
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
                              double? latUser, longUser;
                              await mpController.controller
                                  .myLocation()
                                  .then((value) {
                                latUser = value.latitude;
                                longUser = value.longitude;
                              });
                              log("lokasi : ${latUser} ${longUser}");
                              await mpController.controller.removeLastRoad();
                              roadInfo = await mpController.controller.drawRoad(
                                  GeoPoint(
                                      latitude: latUser!, longitude: longUser!),
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
                              Navigator.pushNamed(
                                context,
                                "/chat",
                                arguments: {
                                  'userId':
                                      mpController.map_dataTarget['userId'],
                                  'donatur_name': mpController
                                      .map_dataTarget['donatur_name'],
                                },
                              );
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
