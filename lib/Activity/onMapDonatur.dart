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

class OnMapDonatur extends StatefulWidget {
  const OnMapDonatur({Key? key}) : super(key: key);

  @override
  _OnMapDonaturState createState() => _OnMapDonaturState();
}

class _OnMapDonaturState extends State<OnMapDonatur> {
  MapsController mpController = Get.put(MapsController());
  RoadInfo? roadInfo;
  RxBool isPressed = false.obs;
  final NotificationController notificationController =
      Get.put(NotificationController());

  StreamController<GeoPoint>? streamController = StreamController<GeoPoint>();
  Timer? locationUpdateTimer;
  var postController = Get.put(GetPostController());
  var transController = Get.put(TransaksiController());
  var updateLocationController = Get.put(LocationController());

  List<StaticPositionGeoPoint>? koordinat;
  double? latUser, longUser;
  var variasi;
  int a = 0;

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

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";

    var id_trans = transController.transaksi_id;
    await transController.getTransaksiDonor(id_trans).then((value) {
      log("sudah mendapatkan data transaksi : ${value['user_recipient_name']}");
    });

    // post_foto = mpController.map_dataTarget['url']
    //     .toString()
    //     .replaceFirst("http://localhost:3000", newBaseUrl);
    // donatur_foto = mpController?.map_dataTarget['donatur_profile']
    //     .toString()
    //     .replaceFirst("http://localhost:3000", newBaseUrl);
    // koordinat = [
    //   StaticPositionGeoPoint(
    //       "2",
    //       MarkerIcon(
    //         iconWidget: IconMaker(
    //             title: mpController.map_dataTarget['title'],
    //             link: "${mpController.map_dataTarget['url']}"),
    //       ),
    //       [
    //         GeoPoint(
    //             latitude: mpController.target_lat!,
    //             longitude: mpController.target_long!),
    //       ]),
    // ];
    // setState(() {
    //   userProfile = prefs.getString('profile_picture')!;
    //   id_user = prefs.getInt('user_id')!;
    //   log("user id : $id_user");
    //   markerUser =
    //       userProfile.replaceFirst("http://localhost:3000", newBaseUrl);
    // });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();

    // startLocationUpdates();
    notificationController.checkNotification();
  }

  // @override
  // void dispose() {
  //   locationUpdateTimer?.cancel();
  //   streamController?.close();
  //   mpController.controller.dispose();
  //   // _timer.cancel();
  //   super.dispose();
  // }

  void startLocationUpdates() {
    locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await mpController.controller.myLocation().then((value) async {
        latUser = value.latitude;
        longUser = value.longitude;
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
              maxChildSize: 0.9,
              builder: ((context, scrollController) {
                return Container();
              })),

               Padding(
                 padding: EdgeInsets.only(top: 20.h),
                 child: IconButton(
                  color: Colors.white,
                             onPressed: () {
                              Navigator.pop(context);
                             },
                             icon: Icon(
                  Icons.keyboard_arrow_left_sharp,
                  color: Colors.green,
                  size: 40.dm,
                             )),
               ), 
        ],
      ),
    ));
  }
}
