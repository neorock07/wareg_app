import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Controller/API/Postingan/GetByLokasi.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Controller/notification_controller.dart';
import 'package:wareg_app/Partials/CardMenu.dart';
import 'package:wareg_app/Partials/CardSearch.dart';
import 'package:wareg_app/Partials/MapBox.dart';
import 'package:wareg_app/Services/LocationService.dart';
import 'package:wareg_app/Util/Ip.dart';
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
  RxList<StaticPositionGeoPoint> koordinat = <StaticPositionGeoPoint>[].obs;
  final NotificationController notificationController =
      Get.put(NotificationController());
  var postController = Get.put(GetPostController());
  String userName = "Bento";
  var userProfile =
      "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg";
  var marker_user;
  var ipAdd = Ip();
  String? updatedUrl;
  List<String> title_menu_list = ["Makanan Terdekat", "Makanan Terbaru"];
  RxString menu_title = "".obs;
  var isSelected = false.obs;

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "Bento";
    });
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";

    setState(() {
      userProfile = prefs.getString('profile_picture')!;
      // ??
      //     "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg";

      marker_user =
          userProfile.replaceFirst("http://localhost:3000", newBaseUrl);
    });
  }

  Future<void> _fetchLocationAndPosts() async {
    LocationService locationService = LocationService();
    try {
      Position position = await locationService.getCurrentLocation();
      await postController.fetchPosts(position.latitude, position.longitude);
      var result2 = await postController.fetchPostsNew(
          position.latitude, position.longitude);
      String newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";

      for (var post in postController.posts) {
        var coordinates = post.body.coordinate.split(",");
        double lat = double.parse(coordinates[0]);
        double long = double.parse(coordinates[1]);
        GeoPoint point = GeoPoint(latitude: lat, longitude: long);

        // Update the media URL with the new base URL
        String updatedUrl =
            post.media[0].url.replaceFirst("http://localhost:3000", newBaseUrl);

        await mpController.controller.addMarker(
          point,
          markerIcon: MarkerIcon(
            iconWidget: IconMaker(link: updatedUrl, title: post.title),
          ),
        );
      }
    } catch (e) {
      print('Could not fetch location: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch new data when the widget reappears
    _fetchLocationAndPosts();
  }

  @override
  void initState() {
    super.initState();
    // prefController.loadData("profile_picture");
    menu_title.value = title_menu_list[0];
    setState(() {
      _loadProfile();
      _fetchLocationAndPosts();
    });
    notificationController.checkNotification();
    ScrollController scController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cari Donasi Gratis yuk!",
          style: TextStyle(
              fontFamily: "Bree", color: Colors.black, fontSize: 18.sp),
        ),
        actions: [
          Obx(() {
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/notifications");
                  },
                  icon: const Icon(
                    LucideIcons.bell,
                    color: Colors.black,
                  ),
                ),
                if (notificationController.hasUnread.value)
                  Positioned(
                    right: 10,
                    top: 10,
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
            width: 5.w,
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
                    left: MediaQuery.of(context).size.width * 0.05,
                    bottom: 10.h),
                child: Text(
                  "Peta Sebaran Donasi",
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
                  child: Stack(children: [
                    MapBox(context, mpController.controller, koordinat,
                        marker_user),
                    (postController.isLoading.value)
                        ? CircularProgressIndicator()
                        : Text(""),
                  ]),
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
            if (isSelected.value == false) {
              menu_title.value = title_menu_list[0];
            } else {
              menu_title.value = title_menu_list[1];
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(() => Text(
                            "${menu_title.value}",
                            style: TextStyle(
                              fontFamily: "Bree",
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      Obx(() => Row(
                            children: [
                              ChoiceChip(
                                label: const Center(
                                  child: Text(
                                    "Terdekat",
                                  ),
                                ),
                                onSelected: (value) {
                                  isSelected.value = false;
                                },
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                                selected:
                                    (isSelected.value == false) ? true : false,
                                side: BorderSide(
                                  color: Color.fromRGBO(42, 122, 89, 1),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                selectedColor: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              ChoiceChip(
                                label: Center(
                                  child: Text(
                                    "Terbaru",
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                                selected:
                                    (isSelected.value == true) ? true : false,
                                onSelected: (value) {
                                  isSelected.value = true;
                                },
                                side: BorderSide(
                                  color: Color.fromRGBO(42, 122, 89, 1),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                selectedColor: Colors.white,
                                disabledColor: Colors.white,
                              ),
                            ],
                          )),
                    ],
                  ),
                  Expanded(
                    child: Obx(() {
                      if (postController.isLoading.value) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      } else if (postController.posts.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/image/full.png",
                                fit: BoxFit.fill,
                                height: 100,
                                width: 100,
                              ),
                              Text(
                                "Oops..tidak ada data",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: (isSelected.value == false)
                              ? postController.posts.length
                              : postController.posts2.length,
                          itemBuilder: (context, index) {
                            final post = (isSelected.value == false)
                                ? postController.posts[index]
                                : postController.posts2[index];
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/onmap");
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        String updatedUrl = post.media[0].url
                                            .replaceFirst(
                                                "http://localhost:3000",
                                                newBaseUrl);
                                        mpController.target_lat = double.parse(
                                            post.body.coordinate.split(",")[0]);
                                        mpController.target_long = double.parse(
                                            post.body.coordinate.split(",")[1]);
                                        mpController.map_dataTarget['title'] =
                                            post.title;
                                        mpController.map_dataTarget['stok'] =
                                            post.stok;
                                        mpController.map_dataTarget['alamat'] =
                                            post.body.alamat;
                                        mpController.map_dataTarget['id'] =
                                            post.id;
                                        mpController.map_dataTarget['userId'] =
                                            post.userId;
                                        mpController.map_dataTarget['marker'] =
                                            MarkerIcon(
                                          iconWidget: IconMaker(
                                            link: updatedUrl,
                                            title: post.title,
                                          ),
                                        );
                                        mpController.map_dataTarget['url'] =
                                            post.media[0].url;
                                        mpController.map_dataTarget[
                                            'donatur_name'] = post.userName;
                                        mpController
                                                .map_dataTarget['deskripsi'] =
                                            post.body.deskripsi;
                                        mpController.map_dataTarget['rating'] =
                                            post.averageReview;
                                        mpController.map_dataTarget[
                                                'donatur_profile'] =
                                            post.userProfilePicture;
                                        mpController
                                                .map_dataTarget['updateAt'] =
                                            post.updatedAt;
                                        mpController
                                                .map_dataTarget['expiredAt'] =
                                            post.expiredAt;
                                        log("data : ${mpController.map_dataTarget['url']} | ${mpController.map_dataTarget['stok']}");
                                        Navigator.pushNamed(context, "/onmap");
                                      },
                                      child: CardMenu(
                                        context,
                                        jarak: post.distance,
                                        stok: post.stok,
                                        url: post.media[0].url,
                                        title: post.title,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.grey,
                                      indent: 10,
                                      endIndent: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            );
          },
        )
      ]),
    );
  }
}
