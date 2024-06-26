import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';
import 'package:wareg_app/Controller/API/Lokasi/LocationController.dart';
import 'package:wareg_app/Controller/API/Transaksi/TransaksiController.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Controller/notification_controller.dart';
import 'package:wareg_app/Partials/MapBox.dart';
import 'package:wareg_app/Partials/MapBoxDonatur.dart';
import 'package:wareg_app/Util/IconMaker.dart';
import 'package:wareg_app/Util/Ip.dart';
import '../Controller/API/Postingan/GetByLokasi.dart';

class OnMapDonatur extends StatefulWidget {
  const OnMapDonatur({Key? key}) : super(key: key);

  @override
  _OnMapDonaturState createState() => _OnMapDonaturState();
}

class _OnMapDonaturState extends State<OnMapDonatur> {
  final MapsController mpController = Get.put(MapsController());
  RoadInfo? roadInfo;
  final RxBool isPressed = false.obs;
  final NotificationController notificationController =
      Get.put(NotificationController());

  final StreamController<GeoPoint> streamController =
      StreamController<GeoPoint>();
  Timer? locationUpdateTimer;
  final postController = Get.put(GetPostController());
  final transController = Get.put(TransaksiController());
  final updateLocationController = Get.put(LocationController());

  List<StaticPositionGeoPoint>? koordinat;
  double? latRecipient, longRecipient;
  var variasi;
  int a = 0;

  final String userProfile =
      "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg";
  var markerUser;
  int? id_user;
  final ipAdd = Ip();
  String? newBaseUrl;
  String? updatedUrl;
  String? post_foto;
  String? donatur_foto;
  final RxList<int> count = <int>[].obs;
  List<Widget> widgetList = [];
  double? rating_donasi;
  var id_trans;
  final RxMap<String, dynamic> getTrans = <String, dynamic>{}.obs;
  String? formattedDate;
  final List<String> data_timeline = ["Konfirmasi", "Pengambilan", "Selesai"];
  int currIndex = 0;

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";

    id_trans = transController.transaksi_id;
    try {
      final value =
          await transController.getTransaksiDonor(id_trans).then((value) async {
        getTrans.value = value;
        
        latRecipient = double.parse(value['lat']);
        longRecipient = double.parse(value['lon']);
        // GeoPoint point = GeoPoint(latitude: latRecipient!, longitude:longRecipient!);
        // await mpController.controller.addMarker(point,
        // markerIcon:  MarkerIcon(
        //             icon: Icon(
        //                 Icons.location_history_rounded,
        //                 color: Colors.red,
        //                 size: 48,
        //             )),
        // // angle: pi / 3,
        // iconAnchor: IconAnchor(
        //   anchor: Anchor.top,
        // ));

        GeoPoint geo_target = GeoPoint(latitude: double.parse(
                            getTrans.value['post_coordinate'].split(",")[0]), longitude: double.parse(
                            getTrans.value['post_coordinate'].split(",")[1]));
        await mpController.controller.addMarker(
          geo_target,
          markerIcon: MarkerIcon(
            icon: Icon(
              Icons.pin_drop,
              color: Colors.red,
              size: 48,
            ),
          ),
          iconAnchor: IconAnchor(
            anchor: Anchor.top,
          ),
        );

        koordinat = [
          StaticPositionGeoPoint(
              "2",
              MarkerIcon(
                iconWidget: IconMaker(title: "Penerima", link: userProfile),
              ),
              [
                GeoPoint(latitude: latRecipient!, longitude: longRecipient!),
              ]),
          StaticPositionGeoPoint(
              "3",
              MarkerIcon(
                iconWidget: IconMaker(title: "Lokasi Anda", link: userProfile),
              ),
              [
                GeoPoint(
                    latitude: (getTrans.value == null)
                        ? 0
                        : double.parse(
                            getTrans.value['post_coordinate'].split(",")[0]),
                    longitude: (getTrans.value == null)
                        ? 0
                        : double.parse(
                            getTrans.value['post_coordinate'].split(",")[1])),
              ]),
        ];

        await _setMarkers();
      });
      log("sudah mendapatkan data transaksi : ${value['user_recipient_name']}");
    } catch (e) {
      log("Error loading profile: $e");
    }

    setState(() {});
  }

  Future<void> _setMarkers() async {
//     await mpController.controller.setMarkerOfStaticPoint(
//         id: "2",
//         markerIcon: MarkerIcon(
//           iconWidget: IconMaker(title: "Penerima", link: userProfile),
//         ));
//     await mpController.controller.setMarkerOfStaticPoint(
//         id: "3",
//         markerIcon: MarkerIcon(
//           iconWidget: IconMaker(title: "Lokasi Anda", link: userProfile),
//         ));
//     await mpController.controller.addMarker(
//       GeoPoint(
//           latitude:
//           double.parse(getTrans.value['post_coordinate'].split(",")[0]),
//           longitude:
//           double.parse(getTrans.value['post_coordinate'].split(",")[1])),
//       markerIcon: MarkerIcon(
//         iconWidget: IconMaker(link: "", title: "Lokasi Donasi"),
//       ),
//     );

//     await mpController.controller.addMarker(GeoPoint(latitude: double.parse(getTrans.value['post_coordinate'].split(",")[0]), longitude: double.parse(getTrans.value['post_coordinate'].split(",")[0])),
//       markerIcon:MarkerIcon(
//             iconWidget: IconMaker(link: "donatur", title:"donatur"),
//           ),

// );
    // await mpController.controller.addMarker(GeoPoint(latitude: -7.051894836887435, longitude: 110.43593567094251),
    //     markerIcon:  MarkerIcon(
    //                 icon: Icon(
    //                     Icons.location_history_rounded,
    //                     color: Colors.red,
    //                     size: 48,
    //                 )),
    //     // angle: pi / 3,
    //     iconAnchor: IconAnchor(
    //       anchor: Anchor.top,
    //     ));
  }

  @override
  void initState() {
    super.initState();
    startLocationUpdates();
    _loadProfile();
    notificationController.checkNotification();
  }

  @override
  void dispose() {
    locationUpdateTimer?.cancel();
    streamController.close();
    mpController.controller.dispose();
    super.dispose();
  }

  void startLocationUpdates() {
  locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
    try {
      final value = await updateLocationController.getUpdateLocation(id_trans);
      log("update lokasi pengambil : ${value}");
      latRecipient = double.parse(value['lat']);
      longRecipient = double.parse(value['lon']);
      setState(() {});
      if (latRecipient != null &&
          longRecipient != null &&
          getTrans.isNotEmpty) {
        GeoPoint oldPoint = GeoPoint(latitude: latRecipient!, longitude: longRecipient!);
        GeoPoint newPoint = GeoPoint(latitude: latRecipient!, longitude: longRecipient!);

        GeoPoint geo_target = GeoPoint(latitude: double.parse(
                            getTrans.value['post_coordinate'].split(",")[0]), longitude: double.parse(
                            getTrans.value['post_coordinate'].split(",")[1]));
        await mpController.controller.addMarker(
          geo_target,
          markerIcon: MarkerIcon(
            icon: Icon(
              Icons.pin_drop,
              color: Colors.red,
              size: 48,
            ),
          ),
          iconAnchor: IconAnchor(
            anchor: Anchor.top,
          ),
        );


        await mpController.controller.changeLocationMarker(
          oldLocation:  oldPoint,
          newLocation : newPoint,
          markerIcon : MarkerIcon(
            iconWidget: IconMaker(
              title: "Aku",
              link: "${getTrans.value['user_recipient_profile_picture'].toString().replaceFirst("http://localhost:3000", newBaseUrl!)}",
            ),
          ),
        );

        // GeoPoint oldPoint2 = GeoPoint(latitude: double.parse(getTrans['post_coordinate'].split(",")[0]), longitude: double.parse(getTrans['post_coordinate'].split(",")[1]));
        // GeoPoint newPoint2 = GeoPoint(latitude: double.parse(getTrans['post_coordinate'].split(",")[0]), longitude: double.parse(getTrans['post_coordinate'].split(",")[1]));
        // await mpController.controller.changeLocationMarker(
        //   oldLocation: oldPoint2,
        //   newLocation: newPoint2,
        //   markerIcon: MarkerIcon(
        //     icon: Icon(
        //       Icons.pin_drop,
        //       color: Colors.red,
        //       size: 48,
        //     ),
        //   ),
        //   iconAnchor: IconAnchor(
        //     anchor: Anchor.top,
        //   ),
        // );
      } else {
        log("ada null");
      }
    } catch (e) {
      log("Error updating location: $e");
    }
  });
}


  Future<void> drawRoute(GeoPoint recipientLocation) async {
    await mpController.controller.removeLastRoad();
    roadInfo = await mpController.controller.drawRoad(
        GeoPoint(
            latitude: (getTrans.isEmpty)
                ? 0
                : double.parse(getTrans['post_coordinate'].split(",")[0]),
            longitude: (getTrans.isEmpty)
                ? 0
                : double.parse(getTrans['post_coordinate'].split(",")[1])),
        GeoPoint(
            latitude: recipientLocation.latitude,
            longitude: recipientLocation.longitude),
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
      body: WillPopScope(
        onWillPop: () async {
          postController.isLoading3.value = true;
          a = 0;
          return true;
        },
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: StreamBuilder<GeoPoint>(
                stream: streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    drawRoute(snapshot.data!);
                  }
                  return MapBoxDonatur(
                    context,
                    mpController.controller,
                    koordinat,
                    userProfile,
                    isDraw: true,
                    isUserTrack: false,
                    lat: (getTrans.isEmpty)
                        ? 0
                        : double.parse(
                            getTrans['post_coordinate'].split(",")[0]),
                    long: (getTrans.isEmpty)
                        ? 0
                        : double.parse(
                            getTrans['post_coordinate'].split(",")[1]),
                    lat_recipient: latRecipient,
                    long_recipient: longRecipient,
                  );
                },
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.45,
              minChildSize: 0.45,
              maxChildSize: 0.7,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.dm)),
                  child: Obx(() {
                    if (getTrans['transaction_timeline'] != null) {
                      DateTime dateTime = DateTime.parse(
                          getTrans['transaction_timeline']['konfirmasi']);
                      formattedDate =
                          DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
                    }

                    if (getTrans.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitDoubleBounce(
                                color: Colors.blue, size: 20.dm),
                            const Text(
                              "Loading...",
                              style: TextStyle(fontFamily: "Poppins"),
                            )
                          ],
                        ),
                      );
                    }

                    return ListView(
                      controller: scrollController,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  "Penerima sedang menuju\nlokasi donasi Anda",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 80.h,
                          width: MediaQuery.of(context).size.width * 0.33,
                          child: Timeline.tileBuilder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            builder: TimelineTileBuilder.connected(
                              connectionDirection: ConnectionDirection.before,
                              itemExtentBuilder: (_, __) => 120,
                              contentsBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${data_timeline[index]}"),
                                );
                              },
                              indicatorBuilder: (context, index) {
                                String step = data_timeline[index];
                                String? date = getTrans[step];
                                if (date != null) {
                                  return DotIndicator(
                                    color: Colors.green,
                                  );
                                } else if (index == 0 ||
                                    getTrans[data_timeline[index - 1]] !=
                                        null) {
                                  return DotIndicator(
                                    color: Colors.green,
                                  );
                                } else {
                                  return OutlinedDotIndicator(
                                    borderWidth: 2.0,
                                    color: Colors.grey,
                                  );
                                }
                              },
                              connectorBuilder: (_, index, ___) {
                                return SolidLineConnector(
                                  color: (getTrans['transaction_timeline']
                                              ['pengambilan'] !=
                                          null)
                                      ? Color.fromRGBO(48, 122, 89, 1)
                                      : Colors.grey,
                                );
                              },
                              itemCount: 3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10.h, left: 10.w, right: 10.w, bottom: 10.h),
                          child: Divider(
                            color: Colors.grey,
                            height: 1.h,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.h),
                          child: Row(
                            children: [
                              Container(
                                height: 45.dm,
                                width: 45.dm,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.dm),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            getTrans['user_recipient_profile_picture']
                                                    ?.toString()
                                                    ?.replaceFirst(
                                                        'http://localhost:3000',
                                                        "${ipAdd.getType()}://${ipAdd.getIp()}") ??
                                                userProfile,
                                            scale: 1))),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${getTrans['user_recipient_name']}",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14.sp,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "penerima",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 12.sp,
                                        color: Colors.grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.dm),
                          child: Row(children: [
                            Text(
                              "${getTrans['post_title']}",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14.sp,
                                  color: Colors.black),
                            ),
                            Text(
                              (getTrans['transaction_timeline'] == null)
                                  ? ""
                                  : " | ${formattedDate}",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14.sp,
                                  color: Colors.black),
                            ),
                          ]),
                        ),
                        (getTrans['variant'] == null)
                            ? Text("")
                            : Padding(
                                padding: EdgeInsets.all(10.dm),
                                child: Text(
                                  "${getTrans['variant'].length} Pesanan",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14.sp,
                                      color: Colors.grey),
                                ),
                              ),
                        (getTrans['variant'] == null)
                            ? Text("")
                            : Container(
                                height: 30.h * getTrans['variant'].length,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ListView.builder(
                                  // scrollDirection: Axis.horizontal,
                                  itemCount: getTrans['variant'].length,
                                  itemBuilder: (_, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.h, left: 10.w, right: 10.w),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.dm),
                                            color: const Color.fromARGB(
                                                255, 247, 247, 247)),
                                        child: Padding(
                                          padding: EdgeInsets.all(3.dm),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${getTrans['variant'][index]['name']}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Poppins",
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              Text(
                                                " : ${getTrans['variant'][index]['jumlah']}",
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
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    );
                  }),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.keyboard_arrow_left_sharp,
                  color: Color.fromRGBO(48, 122, 89, 1),
                  size: 40.dm,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
