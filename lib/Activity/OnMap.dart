import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Controller/API/Lokasi/LocationController.dart';
import 'package:wareg_app/Controller/API/Transaksi/TransaksiController.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Partials/CardButton.dart';
import 'package:wareg_app/Partials/CardCheckBox.dart';
import 'package:wareg_app/Partials/DialogPop.dart';
import 'package:wareg_app/Partials/FormText.dart';
import 'package:wareg_app/Partials/MapBox.dart';
import 'package:wareg_app/Controller/notification_controller.dart';
import 'package:wareg_app/Util/IconMaker.dart';
import 'package:wareg_app/Util/Ip.dart';

import '../Controller/API/Postingan/GetByLokasi.dart';

class OnMap extends StatefulWidget {
  const OnMap({Key? key}) : super(key: key);

  @override
  _OnMapState createState() => _OnMapState();
}

class _OnMapState extends State<OnMap> {
  MapsController mpController = Get.put(MapsController());
  RoadInfo? roadInfo;
  RxBool isPressed = false.obs;
  final NotificationController notificationController =
      Get.put(NotificationController());
  RxBool isPressedBtl = false.obs;
  RxBool isPressedRec = false.obs;
  RxBool isPressedBtn = false.obs;
  RxBool isPressedBtn2 = false.obs;
  RxBool isPressedRate = false.obs;
  RxBool isPressedRpt = false.obs;
  StreamController<GeoPoint>? streamController = StreamController<GeoPoint>();
  Timer? locationUpdateTimer;
  var postController = Get.put(GetPostController());
  var transController = Get.put(TransaksiController());
  var updateLocationController = Get.put(LocationController());

  //button state checkbock report
  RxBool selectReport = false.obs;
  RxBool selectReport2 = false.obs;
  RxBool selectReport3 = false.obs;

  List<StaticPositionGeoPoint>? koordinat;
  double? latUser, longUser;
  var variasi;
  int a = 0;
  List<Map<String, dynamic>> pickedVariants = [];

  var userProfile =
      "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg";
  var markerUser;
  int? id_user;
  var ipAdd = Ip();
  String? updatedUrl;
  String? post_foto;
  String? donatur_foto;
  RxList<int> count = <int>[].obs;
  List<Widget> widgetList = [];
  double? rating_donasi;
  var komenController = TextEditingController();

  /*  function to load user profile from preferences and get data from previous map */
  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";
    post_foto = mpController.map_dataTarget['url']
        .toString()
        .replaceFirst("http://localhost:3000", newBaseUrl);
    donatur_foto = mpController?.map_dataTarget['donatur_profile']
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
      id_user = prefs.getInt('user_id')!;
      log("user id : $id_user");
      markerUser =
          userProfile.replaceFirst("http://localhost:3000", newBaseUrl);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
    startLocationUpdates();
    notificationController.checkNotification();
    log("max time : ${transController.transCreate.value}");
  }

  @override
  void dispose() {
    locationUpdateTimer?.cancel();
    streamController?.close();
    mpController.dispose();
    // _timer.cancel();
    super.dispose();
  }

  void startLocationUpdates() {
    locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await mpController.controller.myLocation().then((value) async {
        latUser = value.latitude;
        longUser = value.longitude;
        log("data : ${postController.posts3.value}");

        if (postController.posts3.value['transaction'] != null) {
          log("tipe data id : ${postController.posts3.value['transaction']['id'].runtimeType}");
          await updateLocationController
              .updateLocation(
                  postController.posts3.value['transaction']['id'].toString(),
                  latUser!,
                  longUser!)
              .then((value) {
            log("lokasi pengambil terkirim ke donatur | $latUser , $longUser");
          });
        }

        if (a <= 0) {
          await postController
              .fetchPostDetail(
                  latUser, longUser, mpController.map_dataTarget['id'])
              .then((value) {
            count =
                List.filled(postController.posts3.value['variants'].length, 0)
                    .obs;
            a++;
          });
        }
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

  Future<void> postAmbil() async {
    if (count.value != null || count.value != []) {
      for (int i = 0; i < count.length; i++) {
        pickedVariants.add({
          "variant_id": postController.posts3.value['variants'][i]['id'],
          "jumlah": count.value[i]
        });
      }

      await transController
          .postTransaction(postController.posts3.value['id'], pickedVariants)
          .then((value) async {
        log("reuslt e iki : ${value.keys}");

        if (value['statusCode'] == 400) {
          Navigator.of(context, rootNavigator: true).pop();

          DialogPop(context,
              size: [180.h, 150.w],
              icon: Column(children: [
                Center(
                    child: Image.asset(
                  "assets/image/full.png",
                  fit: BoxFit.fill,
                  height: 100.dm,
                  width: 100.dm,
                )),
                SizedBox(height: 20.h),
                Text("${value['message']}",
                    style: TextStyle(fontFamily: "Poppins", fontSize: 12.sp))
              ]));
        } else {
          Navigator.of(context, rootNavigator: true).pop();

          postController.isLoading3.value = true;
          // mpController = Get.put(MapsController());
          // mpController.map_dataTarget['id'] = postController.posts3.value['id'];

          log("log current: ${value['statusCode']}");
          // locationUpdateTimer!.cancel();
          // startLocationUpdates();

          await postController
              .fetchPostDetail(
                  latUser, longUser, mpController.map_dataTarget['id'])
              .then((value) {
            count =
                List.filled(postController.posts3.value['variants'].length, 0)
                    .obs;
            a++;
          });
          setState(() {});
          // navigateToOnMap();
        }
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();

      DialogPop(context,
          size: [180.h, 150.w],
          icon: Column(children: [
            Center(
                child: Image.asset(
              "assets/image/full.png",
              fit: BoxFit.fill,
              height: 100.dm,
              width: 100.dm,
            )),
            SizedBox(height: 20.h),
            Text("Makanan sudah habis atau\nkamu belum memilih sama sekali",
                style: TextStyle(fontFamily: "Poppins", fontSize: 12.sp))
          ]));
    }
  }

  Future<void> reportDialog() async {
    Map<int, String> map_item = {
      1: "Makanan berbau busuk atau berlendir",
      2: "Makanan tidak higienis telah terkontaminasi kotoran",
      3: "Warna makanan terlihat normal seperti aslinya",
    };
    var toSelect = {};

    DialogPop(context,
        size: [380.h, 150.w],
        icon: Column(children: [
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                icon: Icon(LucideIcons.x, size: 20.dm),
              )),
          Obx(() => Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: CardCheckBox(context,
                    text: "${map_item[1]}", count: selectReport),
              )),
          Obx(() => Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: CardCheckBox(context,
                    text: "${map_item[2]}", count: selectReport2),
              )),
          Obx(() => Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: CardCheckBox(context,
                    text: "${map_item[3]}", count: selectReport3),
              )),
          SizedBox(height: 20.h),
          Obx(() => CardButton(context, isPressedRpt, onTap: (_) async {
                isPressedRpt.value = true;

                if (selectReport.value == true) {
                  toSelect[1] = map_item[1];
                } else {
                  toSelect[1] = "";
                }

                if (selectReport2.value == true) {
                  toSelect[2] = map_item[2];
                } else {
                  toSelect[2] = "";
                }

                if (selectReport3.value == true) {
                  toSelect[3] = map_item[3];
                } else {
                  toSelect[3] = "";
                }

                String reason = toSelect.toString();

                await transController
                    .reportTransaksi(
                        postController.posts3.value['id'],
                        postController.posts3.value['transaction']['id'],
                        reason)
                    .then((value) {
                  log("reuslt e iki : ${value.keys} | reason : $reason");
                  Navigator.pushReplacementNamed(context, "/home");
                  Get.snackbar("Laporan berhasil",
                      "Baiklah kami sudah menerima laporan Anda");
                });
              },
                  width_a: 0.37,
                  width_b: 0.4,
                  height_a: 0.05,
                  height_b: 0.06,
                  borderRadius: 10.dm,
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(52, 135, 98, 1),
                    Color.fromRGBO(48, 122, 99, 1),
                  ]),
                  child: Center(
                    child: Text(
                      "Kirim",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  )))
        ]));
  }

  Future<void> navigateToOnMap() async {
    locationUpdateTimer?.cancel();
    Navigator.pushReplacementNamed(context, "/onmap").then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var data_route;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(48, 122, 99, 1),
          title: Text(
            "${mpController.map_dataTarget['title']}",
            style: TextStyle(fontFamily: "Bree", color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Obx(() {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/notifications");
                    },
                    icon: const Icon(
                      LucideIcons.bell,
                      color: Colors.white,
                    ),
                  ),
                  if (notificationController.hasUnread.value)
                    Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            }),
            SizedBox(
              width: 5.dm,
            )
          ],
        ),
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
                      stream: streamController?.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          data_route = snapshot.data;
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
                  maxChildSize: 0.9,
                  builder: ((context, scrollController) {
                    return Obx(() {
                      if (postController.posts3.value['media'] != null) {
                        widgetList = postController.posts3.value['media']
                            .map<Widget>((item) {
                          return Container(
                            height: 100.h,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.dm),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        // "${post_foto}"),
                                        "${item['url'].toString().replaceFirst('http://localhost:3000', "${ipAdd.getType()}://${ipAdd.getIp()}")}"),
                                    scale: 1,
                                    fit: BoxFit.cover)),
                          );
                        }).toList();

                        //start countdown
                      }

                      return Container(
                        color: Colors.white,
                        child: (postController.isLoading3.value)
                            ? Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SpinKitDoubleBounce(
                                          color: Colors.blue, size: 20.dm),
                                      const Text(
                                        "Loading...",
                                        style: TextStyle(fontFamily: "Poppins"),
                                      )
                                    ]),
                              )
                            : ListView(
                                controller: scrollController,
                                children: [
                                  (postController.posts3.value['userId'] ==
                                          id_user)
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 30.h,
                                          color: Color.fromRGBO(0, 170, 19, 1),
                                          child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: EdgeInsets.all(5.dm),
                                                child: Text("Donasi Anda",
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.white)),
                                              )))
                                      : Text(""),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.9,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10.h),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.w, right: 20.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 45.dm,
                                                      width: 45.dm,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.dm),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  postController
                                                                          .posts3
                                                                          .value[
                                                                              'userProfilePicture']
                                                                          ?.toString()
                                                                          ?.replaceFirst(
                                                                              'http://localhost:3000',
                                                                              "${ipAdd.getType()}://${ipAdd.getIp()}") ??
                                                                      userProfile,
                                                                  scale: 1))),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // "${mpController.map_dataTarget['donatur_name']}",
                                                          "${postController.posts3.value['userName']}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontSize: 14.sp,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Text(
                                                          "donatur",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                                size: 10.dm),
                                                            Text(
                                                              (mpController.map_dataTarget[
                                                                              'rating'] ==
                                                                          0 ||
                                                                      mpController
                                                                              .map_dataTarget['rating'] ==
                                                                          null)
                                                                  ? "Belum ada"
                                                                  : "${mpController.map_dataTarget['rating']}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontSize:
                                                                      12.sp,
                                                                  color: Colors
                                                                      .amber),
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
                                                      "${postController.posts3.value['title']}",
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 12.sp,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          (postController.posts3
                                                      .value['transaction'] ==
                                                  null)
                                              ? Text("")
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10.w, top: 10.h),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 10,
                                                                  sigmaY: 10),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.2)),
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Colors.white
                                                                      .withOpacity(
                                                                          0.1),
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          0.05)
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10
                                                                          .dm),
                                                              child:
                                                                  TimerCountdown(
                                                                enableDescriptions:
                                                                    false,
                                                                timeTextStyle: const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                format: CountDownTimerFormat
                                                                    .hoursMinutesSeconds,
                                                                endTime: DateTime.parse(postController
                                                                            .posts3
                                                                            .value['transaction']
                                                                        [
                                                                        'detail']
                                                                    [
                                                                    'maks_pengambilan']),
                                                                onTick:
                                                                    (value) {
                                                                  print(
                                                                      "countdown : ${value.toString()}");
                                                                },
                                                                onEnd: () {
                                                                  print(
                                                                      'Countdown ended');
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(height: 10.h),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10.h, left: 20.w),
                                              child: Stack(children: [
                                                CarouselSlider(
                                                    items: widgetList,
                                                    options: CarouselOptions(
                                                      height: 100.h,
                                                      aspectRatio: 16 / 9,
                                                      viewportFraction: 0.8,
                                                      initialPage: 0,
                                                      enableInfiniteScroll:
                                                          true,
                                                      reverse: false,
                                                      autoPlay: true,
                                                      autoPlayInterval:
                                                          Duration(seconds: 3),
                                                      autoPlayAnimationDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  800),
                                                      autoPlayCurve:
                                                          Curves.fastOutSlowIn,
                                                      enlargeCenterPage: true,
                                                      enlargeFactor: 0.3,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                    )),
                                              ])),
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
                                                  "${postController.posts3.value['updatedAt']}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "Poppins",
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                Text(
                                                  "(${postController.posts3.value['expiredAt']})",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontFamily: "Poppins",
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.normal),
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
                                                  "${postController.posts3['body']['alamat']}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "Poppins",
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                SizedBox(height: 10.h),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.w, right: 20.w),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text(
                                                              "Sisa Stok",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                            SizedBox(
                                                                height: 5.h),
                                                            Text(
                                                              "${postController.posts3['stok']}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              "Kategori",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                            SizedBox(
                                                                height: 5.h),
                                                            Text(
                                                              (postController
                                                                          .posts3
                                                                          .value['categories'] !=
                                                                      null)
                                                                  ? "${postController.posts3.value['categories'][0]}"
                                                                  : "-",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                                SizedBox(height: 10.h),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Variasi",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontFamily: "Poppins",
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    (postController.posts3[
                                                                'variants'] ==
                                                            null)
                                                        ? Text("")
                                                        : Container(
                                                            height: 30.h *
                                                                postController
                                                                    .posts3[
                                                                        'variants']
                                                                    .length,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4,
                                                            child: ListView
                                                                .builder(
                                                                    // scrollDirection: Axis.horizontal,
                                                                    itemCount: postController
                                                                        .posts3[
                                                                            'variants']
                                                                        .length,
                                                                    itemBuilder:
                                                                        (_, index) {
                                                                      return Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 5.h),
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5.dm),
                                                                              color: const Color.fromARGB(255, 247, 247, 247)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(3.dm),
                                                                            child:
                                                                                Text(
                                                                              "${postController.posts3['variants'][index]['name']}",
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontFamily: "Poppins",
                                                                                fontSize: 12.sp,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20.w, top: 10.h),
                                                  child: Divider(
                                                    height: 1.h,
                                                  ),
                                                ),
                                                SizedBox(height: 3.h),
                                                Text(
                                                  "Deskripsi",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: "Poppins",
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                SizedBox(height: 5.h),
                                                Text(
                                                  "${postController.posts3.value['body']['description']}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "Poppins",
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.normal),
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
                                  ),
                                ],
                              ),
                      );
                    });
                  })),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 5.dm, bottom: 5.dm),
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(() {
                          return (postController.posts3.value['userId'] ==
                                  id_user)
                              ? Text("")
                              : (postController.isLoading3.value)
                                  ? Center(child: CircularProgressIndicator())
                                  : postController
                                              .posts3.value['transaction'] ==
                                          null
                                      ? CardButton(context, isPressed,
                                          onTap: (_) async {
                                          isPressed.value = true;
                                          DialogPop(context,
                                              size: [
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.6,
                                                180.w
                                              ],
                                              dismissable: true,
                                              icon: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                        "Variasi Makanan",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: "Poppins",
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        icon:
                                                            Icon(LucideIcons.x),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  Text(
                                                    "${postController.posts3.value['title']}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "Poppins",
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "*Sesuaikan jumlah variasi makanan yang diambil",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: "Poppins",
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  Divider(height: 1.h),
                                                  SizedBox(height: 10.h),
                                                  Container(
                                                    height: 180.h,
                                                    child:
                                                        Obx(
                                                            () => ListView
                                                                    .builder(
                                                                  itemCount: postController
                                                                      .posts3
                                                                      .value[
                                                                          'variants']
                                                                      .length,
                                                                  itemBuilder:
                                                                      (_, index) {
                                                                    return Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: 5
                                                                              .h),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "${postController.posts3.value['variants'][index]['name']}",
                                                                          ),
                                                                          (postController.posts3.value['variants'][index]['stok'] == 0)
                                                                              ? Text("habis", style: TextStyle(color: Colors.red, fontFamily: "Poppins", fontSize: 12.sp, fontStyle: FontStyle.italic))
                                                                              : Row(
                                                                                  children: [
                                                                                    Material(
                                                                                      color: Colors.transparent,
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          if (count[index]! > 1) {
                                                                                            count[index]--;
                                                                                          }
                                                                                        },
                                                                                        splashColor: Colors.grey,
                                                                                        child: Container(
                                                                                          height: 20.dm,
                                                                                          width: 20.dm,
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(2.dm),
                                                                                            border: Border.all(color: Colors.black),
                                                                                          ),
                                                                                          child: Icon(
                                                                                            LucideIcons.minus,
                                                                                            size: 10,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(width: 20.w),
                                                                                    Obx(() => Text(
                                                                                          "${count[index]}",
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontFamily: "Poppins",
                                                                                            fontSize: 14.sp,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        )),
                                                                                    SizedBox(width: 20.w),
                                                                                    Material(
                                                                                      color: Colors.transparent,
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          if (count[index]! < postController.posts3.value['variants'][index]['stok']) {
                                                                                            count[index]++;
                                                                                          }
                                                                                        },
                                                                                        splashColor: Colors.grey,
                                                                                        child: Container(
                                                                                          height: 20.dm,
                                                                                          width: 20.dm,
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(2.dm),
                                                                                            border: Border.all(color: Colors.black),
                                                                                          ),
                                                                                          child: const Icon(
                                                                                            LucideIcons.plus,
                                                                                            size: 10,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                )),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "Pengambilan donasi Anda tersisa ${postController.posts3.value['sisa_pengambilan']}/${postController.posts3.value['max_pengambilan']}",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontFamily: "Poppins",
                                                        fontSize: 10.sp,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                                  Obx(() => Center(
                                                        child: CardButton(
                                                            context,
                                                            isPressedBtn,
                                                            onTap: (_) {
                                                          isPressedBtn.value =
                                                              true;
                                                          // Navigator.pushNamed(
                                                          //     context, "/formfood");
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                          DialogPop(context,
                                                              size: [
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.4,
                                                                150.dm
                                                              ],
                                                              dismissable:
                                                                  false,
                                                              icon: Column(
                                                                  children: [
                                                                    Center(
                                                                        child: Image
                                                                            .asset(
                                                                      "assets/image/load.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          120.dm,
                                                                      width: 120
                                                                          .dm,
                                                                    )),
                                                                    SizedBox(
                                                                        height:
                                                                            10.h),
                                                                    Text(
                                                                      "Pengambilan donasi Anda tersisa ${postController.posts3.value['sisa_pengambilan']}/${postController.posts3.value['max_pengambilan']}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontFamily:
                                                                            "Poppins",
                                                                        fontSize:
                                                                            10.sp,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5.h),
                                                                    Text(
                                                                      "Segera ambil makanan donasi Anda sebelum waktu pengambilan berakhir",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontFamily:
                                                                            "Poppins",
                                                                        fontSize:
                                                                            10.sp,
                                                                        fontStyle:
                                                                            FontStyle.normal,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            20.h),
                                                                    Obx(() =>
                                                                        CardButton(
                                                                            context,
                                                                            isPressedBtn2,
                                                                            onTap:
                                                                                (_) async {
                                                                          isPressedBtn2.value =
                                                                              true;

                                                                          postAmbil();
                                                                          drawRoute(data_route);
                                                                          // Navigator.pushNamed(context, "/formfood");
                                                                        },
                                                                            width_a:
                                                                                0.38,
                                                                            width_b:
                                                                                0.4,
                                                                            height_a:
                                                                                0.05,
                                                                            height_b:
                                                                                0.06,
                                                                            borderRadius:
                                                                                10.dm,
                                                                            gradient: const LinearGradient(colors: [
                                                                              Color.fromRGBO(52, 135, 98, 1),
                                                                              Color.fromRGBO(48, 122, 99, 1),
                                                                            ]),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "Ambil Donasi",
                                                                                style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.normal),
                                                                              ),
                                                                            )))
                                                                  ]));
                                                          log("yg diambil : ${count.value.toString()}");
                                                        },
                                                            width_a: 0.4,
                                                            width_b: 0.36,
                                                            height_a: 0.05,
                                                            height_b: 0.06,
                                                            borderRadius: 10.dm,
                                                            gradient:
                                                                const LinearGradient(
                                                                    colors: [
                                                                  Color
                                                                      .fromRGBO(
                                                                          52,
                                                                          135,
                                                                          98,
                                                                          1),
                                                                  Color
                                                                      .fromRGBO(
                                                                          48,
                                                                          122,
                                                                          99,
                                                                          1),
                                                                ]),
                                                            child: Center(
                                                              child: Text(
                                                                "Konfirmasi",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            )),
                                                      ))
                                                ],
                                              ));
                                        },
                                          gradient:
                                              const LinearGradient(colors: [
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
                                          ))
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            CardButton(context, isPressedBtl,
                                                onTap: (_) async {
                                              isPressedBtl.value = true;

                                              DialogPop(context,
                                                  size: [
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.4,
                                                    100.w
                                                  ],
                                                  icon: Column(children: [
                                                    Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            },
                                                            icon: Icon(
                                                                LucideIcons.x,
                                                                size: 20))),
                                                    Center(
                                                        child: Image.asset(
                                                      "assets/image/cancel_load.png",
                                                      fit: BoxFit.fill,
                                                      height: 80.dm,
                                                      width: 80.dm,
                                                    )),
                                                    SizedBox(height: 10.h),
                                                    Text(
                                                        "Batalkan pengambilan donasi ?",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                "Poppins",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.sp)),
                                                    SizedBox(height: 20.h),
                                                    InkWell(
                                                      onTap: () async {
                                                        log("posting id : ${postController.posts3.value['transaction']['id']}");
                                                        await transController
                                                            .cancelTransaksi(
                                                                postController
                                                                        .posts3
                                                                        .value[
                                                                    'transaction']['id'])
                                                            .then((value) {
                                                          Get.snackbar(
                                                              "Pembatalan Pengambilan",
                                                              "Pengambilan berhasil dibatalkan!");
                                                          postController
                                                              .isLoading3
                                                              .value = true;

                                                          Navigator
                                                              .pushReplacementNamed(
                                                                  context,
                                                                  "/home");
                                                        });
                                                      },
                                                      child: Container(
                                                          height: 30.h,
                                                          width: 120.w,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10.dm,
                                                                  ),
                                                                  color:
                                                                      const Color
                                                                              .fromRGBO(
                                                                          48,
                                                                          122,
                                                                          89,
                                                                          1)),
                                                          child: Center(
                                                              child: Text(
                                                                  "Ya, Batalkan",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12.sp)))),
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                      child: Container(
                                                          height: 30.h,
                                                          width: 120.w,
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border.all(
                                                                      color: const Color.fromRGBO(
                                                                          48,
                                                                          122,
                                                                          89,
                                                                          1)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10.dm,
                                                                  ),
                                                                  color: Colors
                                                                      .white),
                                                          child: Center(
                                                              child: Text(
                                                                  "Tidak",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      color: const Color.fromRGBO(
                                                                          48,
                                                                          122,
                                                                          89,
                                                                          1),
                                                                      fontSize:
                                                                          12.sp)))),
                                                    ),
                                                  ]));
                                            },
                                                color: Colors.red,
                                                width_b: 0.35,
                                                width_a: 0.32,
                                                height_b: 40.h,
                                                height_a: 38.h,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(10.dm),
                                                    child: Center(
                                                      child: Text(
                                                        "Batal",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "Poppins",
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                            SizedBox(width: 10.w),
                                            CardButton(context, isPressedRec,
                                                onTap: (_) async {
                                              isPressedRec.value = true;
                                              DialogPop(context,
                                                  size: [
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.5,
                                                    100.w
                                                  ],
                                                  icon: Column(children: [
                                                    Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            },
                                                            icon: Icon(
                                                                LucideIcons.x,
                                                                size: 20))),
                                                    Center(
                                                        child: Image.asset(
                                                      "assets/image/terima_load.png",
                                                      fit: BoxFit.fill,
                                                      height: 100.dm,
                                                      width: 100.dm,
                                                    )),
                                                    SizedBox(height: 10.h),
                                                    Text(
                                                        "Donasi telah diterima ?",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                "Poppins",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.sp)),
                                                    SizedBox(height: 20.h),
                                                    InkWell(
                                                      onTap: () async {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        DialogPop(context,
                                                            dismissable: false,
                                                            size: [
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.5,
                                                              100.w
                                                            ],
                                                            icon: Column(
                                                                children: [
                                                                  Center(
                                                                      child: Image
                                                                          .asset(
                                                                    "assets/image/thank_load.png",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    height:
                                                                        100.dm,
                                                                    width:
                                                                        100.dm,
                                                                  )),
                                                                  SizedBox(
                                                                      height:
                                                                          20.h),
                                                                  Text(
                                                                      "Terimakasih!\nDonasi telah diterima",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              "Poppins",
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              14.sp)),
                                                                  SizedBox(
                                                                      height:
                                                                          10.h),
                                                                  Text(
                                                                      "Selamat menikmati donasi\nyang telah diterima, jangan lupa\nmengucapkan terimakasih ya ☺",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontFamily:
                                                                              "Poppins",
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          fontSize:
                                                                              12.sp)),
                                                                  SizedBox(
                                                                      height:
                                                                          5.h),
                                                                  Text(
                                                                    "Pengambilan donasi Anda tersisa ${postController.posts3.value['sisa_pengambilan']}/${postController.posts3.value['max_pengambilan']}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      fontSize:
                                                                          10.sp,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          20.h),
                                                                  const SpinKitCircle(
                                                                      color: Colors
                                                                          .green)
                                                                ]));
                                                        Future.delayed(Duration(
                                                                seconds: 3))
                                                            .then((value) {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                          showModalBottomSheet(
                                                              context: context,
                                                              useSafeArea: true,
                                                              isScrollControlled:
                                                                  true,
                                                              builder:
                                                                  (context) {
                                                                return Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets
                                                                        .bottom,
                                                                  ),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child: Container(
                                                                        height: MediaQuery.of(context).size.height * 0.7,
                                                                        width: MediaQuery.of(context).size.height * 0.9,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.dm),
                                                                        ),
                                                                        child: Column(children: [
                                                                          SizedBox(
                                                                              height: 20.h),
                                                                          Text(
                                                                              "Rate Donasi",
                                                                              style: TextStyle(fontFamily: "Poppins", fontSize: 14.sp, fontWeight: FontWeight.bold)),
                                                                          Text(
                                                                              "Berikan rating makanan yang telah diterima",
                                                                              style: TextStyle(fontFamily: "Poppins", fontSize: 14.sp, fontWeight: FontWeight.bold)),
                                                                          RatingBar
                                                                              .builder(
                                                                            initialRating:
                                                                                1,
                                                                            minRating:
                                                                                1,
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            allowHalfRating:
                                                                                true,
                                                                            itemCount:
                                                                                5,
                                                                            itemPadding:
                                                                                EdgeInsets.symmetric(horizontal: 4.dm),
                                                                            itemBuilder: (context, _) =>
                                                                                const Icon(
                                                                              Icons.star,
                                                                              color: Colors.amber,
                                                                            ),
                                                                            onRatingUpdate:
                                                                                (rating) {
                                                                              rating_donasi = rating;
                                                                              setState(() {});
                                                                            },
                                                                          ),
                                                                          SizedBox(
                                                                              height: 20.h),
                                                                          FormText(
                                                                              context,
                                                                              label: "Komentar Anda terhadap  ",
                                                                              hint: "deskripsi makanan...",
                                                                              type: TextInputType.multiline,
                                                                              controller: komenController),
                                                                          SizedBox(
                                                                              height: 30.h),
                                                                          Center(
                                                                            child: Obx(() =>
                                                                                CardButton(context, isPressedRate, onTap: (_) async {
                                                                                  isPressedRate.value = true;
                                                                                  // Navigator.pushReplacementNamed(context, "/formfood");
                                                                                  log("rating : ${rating_donasi!.ceil()}");
                                                                                  await transController.postConfirmation(postController.posts3.value['transaction']['id'], rating_donasi!.ceil(), komenController.text).then((value) {
                                                                                    // Get.snackbar("Review berhasil dikirim", "Terima kasih Anda telah membantu menyelamatkan Bumi🙏🙏 ");
                                                                                    // Navigator.pushReplacementNamed(context, "/home");
                                                                                    log("pesan konfirmasi : ${value['message']}");
                                                                                    postController.isLoading3.value = true;
                                                                                    a = 0;
                                                                                  });
                                                                                },
                                                                                    width_a: 0.78,
                                                                                    width_b: 0.8,
                                                                                    height_a: 0.05,
                                                                                    height_b: 0.06,
                                                                                    borderRadius: 10.dm,
                                                                                    gradient: const LinearGradient(colors: [
                                                                                      Color.fromRGBO(52, 135, 98, 1),
                                                                                      Color.fromRGBO(48, 122, 99, 1),
                                                                                    ]),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        "Konfirmasi",
                                                                                        style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ))),
                                                                          )
                                                                        ])),
                                                                  ),
                                                                );
                                                              });
                                                        });
                                                      },
                                                      child: Container(
                                                          height: 30.h,
                                                          width: 120.w,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10.dm,
                                                                  ),
                                                                  color:
                                                                      const Color
                                                                              .fromRGBO(
                                                                          48,
                                                                          122,
                                                                          89,
                                                                          1)),
                                                          child: Center(
                                                              child: Text(
                                                                  "Donasi diterima",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12.sp)))),
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    InkWell(
                                                        onTap: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                          reportDialog();
                                                        },
                                                        child: Text(
                                                            "Laporkan Donasi",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                color: const Color
                                                                        .fromRGBO(
                                                                    48,
                                                                    122,
                                                                    89,
                                                                    1),
                                                                fontSize:
                                                                    12.sp))),
                                                  ]));
                                            },
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color.fromRGBO(
                                                          52, 135, 98, 1),
                                                      Color.fromRGBO(
                                                          48, 122, 99, 1),
                                                    ]),
                                                width_b: 0.4,
                                                width_a: 0.37,
                                                height_b: 40.h,
                                                height_a: 38.h,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(10.dm),
                                                    child: Center(
                                                      child: Text(
                                                        "Donasi Diterima",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "Poppins",
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        );
                        }),
                        (postController.posts3.value['userId'] == id_user)
                            ? Text("")
                            : IconButton(
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
                                icon: const Icon(LucideIcons.messagesSquare))
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
