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
  var postController = Get.put(GetPostController());
  String userName = "Bento";
  var userProfile =
      "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg";
  var marker_user;
  var ipAdd = Ip();
  String? updatedUrl;

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
      String newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";

      for (var post in postController.posts) {
        var coordinates = post.body.coordinate.split(",");
        double lat = double.parse(coordinates[0]);
        double long = double.parse(coordinates[1]);
        GeoPoint point = GeoPoint(latitude: lat, longitude: long);

        // Update the media URL with the new base URL
        String updatedUrl =
            post.media[0].url.replaceFirst("http://localhost:3000", newBaseUrl);

        // Add marker to the map with the correct icon and title
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
    setState(() {
      _loadProfile();
      _fetchLocationAndPosts();
    });

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
          IconButton(
              onPressed: () async {
                log("ki coeg : ${updatedUrl}");
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
                    left: MediaQuery.of(context).size.width * 0.05,
                    bottom: 10.h),
                child: Text(
                  "Lihat makanan disekitar mu",
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
                    Obx(() {
                      if (postController.isLoading.value) {
                        return Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: CircularProgressIndicator(),
                        ));
                      } else if (postController.posts.isEmpty) {
                        return Center(child: Text('No posts found.'));
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          // height: 80.h,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 40.h),
                            child: ListView.builder(
                                controller: scrollController,
                                itemCount: postController.posts.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  final post = postController.posts[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, "/onmap");
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 5.h),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              String updatedUrl = post
                                                  .media[0].url
                                                  .replaceFirst(
                                                      "http://localhost:3000",
                                                      newBaseUrl);
                                              mpController.target_lat =
                                                  double.parse(post
                                                      .body.coordinate
                                                      .toString()
                                                      .split(",")[0]);
                                              mpController.target_long =
                                                  double.parse(post
                                                      .body.coordinate
                                                      .toString()
                                                      .split(",")[1]);
                                              mpController
                                                      .map_dataTarget['title'] =
                                                  post.title;
                                              mpController.map_dataTarget['stok'] = post.stok;
                                              mpController.map_dataTarget['alamat'] = post.body.alamat;
                                              mpController.map_dataTarget['id'] = post.id;
                                              mpController.map_dataTarget[
                                                  'marker'] = MarkerIcon(
                                                iconWidget: IconMaker(
                                                    link: updatedUrl,
                                                    title: post.title),
                                              );
                                              mpController.map_dataTarget['url'] = post.media[0].url;
                                              mpController.map_dataTarget['donatur_name'] = post.userName;
                                              mpController.map_dataTarget['deskripsi'] = post.body.deskripsi;
                                              mpController.map_dataTarget['donatur_profile'] = post.userProfilePicture;
                                              log("data : ${mpController.map_dataTarget['url']} | ${mpController.map_dataTarget['stok']}");
                                              Navigator.pushNamed(
                                                  context, "/onmap");
                                            },
                                            child: CardMenu(context,
                                                jarak: post.distance,
                                                stok: post.stok,
                                                url: post.media[0].url,
                                                title: post.title),
                                          ),
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
                        );
                      }
                    })
                  ],
                ),
              );
            })
      ]),
    );
  }
}
