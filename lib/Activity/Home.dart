import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Controller/API/Postingan/GetByLokasi.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Partials/CardDonate.dart';
import 'package:wareg_app/Partials/CardFood.dart';
import 'package:wareg_app/Partials/CardSearch.dart';
import 'package:wareg_app/Partials/DialogPop.dart';
import 'package:wareg_app/Services/LocationService.dart';
import 'package:wareg_app/Util/IconMaker.dart';

import '../Partials/CardBoard.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RxBool isPressed = false.obs;
  String userName = "Bento";
  var postController = Get.put(GetPostController());
  MapsController mpController = Get.put(MapsController());
  var lat, long;

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "Bento";
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _fetchLocationAndPosts();
  }

  Future<void> _fetchLocationAndPosts() async {
    LocationService locationService = LocationService();
    try {
      Position position = await locationService.getCurrentLocation();
      log(position.latitude);
      log(position.longitude);

      var result1 = await postController.fetchPosts(
          position.latitude, position.longitude);
      var result2 = await postController.fetchPostsNew(
          position.latitude, position.longitude);

      if (result1 == 401 || result2 == 401) {
        // Clear all shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Could not fetch location: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch new data 
    _fetchLocationAndPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Hi, $userName",
          style: TextStyle(
              fontFamily: "Bree", color: Colors.black, fontSize: 18.sp),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                LucideIcons.bell,
                color: Colors.black,
              )),
          SizedBox(
            width: 5.dm,
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: CardSearch(context)),
            SizedBox(
              height: 10.h,
            ),
            CardBoard(context),
            SizedBox(
              height: 10.h,
            ),
            Obx(() => CardDonate(context, isPressed)),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  "Makanan Terdekat",
                  style: TextStyle(
                      fontFamily: "Bree", color: Colors.black, fontSize: 18.sp),
                ),
              ),
            ),
            Obx(() {
              if (postController.isLoading.value ||
                  postController.posts.value == null) {
                return Center(child: CircularProgressIndicator());
              } else if (postController.posts.isEmpty) {
                return Center(child: Text('No posts found.'));
              } else {
                return Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Container(
                    height: 200.h,
                    child: ListView.builder(
                      itemCount: min(postController.posts.length, 10),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final post = postController.posts[index];
                        if (post.media == null || post.media.isEmpty) {
                          return Container();
                        }
                        final mediaUrl = post.media[0].url;
                        if (mediaUrl == null) {
                          return Container();
                        }
                        String updatedUrl = mediaUrl.replaceFirst(
                            "http://localhost:3000", newBaseUrl);
                        return InkWell(
                          onTap: () {
                            mpController.target_lat = double.parse(
                                post.body.coordinate.toString().split(",")[0]);
                            mpController.target_long = double.parse(
                                post.body.coordinate.toString().split(",")[1]);
                            mpController.map_dataTarget['title'] = post.title;
                            mpController.map_dataTarget['stok'] = post.stok;
                            mpController.map_dataTarget['alamat'] =
                                post.body.alamat;
                            mpController.map_dataTarget['id'] = post.id;
                            mpController.map_dataTarget['userId'] = post.userId;
                            mpController.map_dataTarget['marker'] = MarkerIcon(
                              iconWidget: IconMaker(
                                  link: updatedUrl, title: post.title),
                            );
                            mpController.map_dataTarget['url'] = mediaUrl;
                            mpController.map_dataTarget['donatur_name'] =
                                post.userName;
                            mpController.map_dataTarget['deskripsi'] =
                                post.body.deskripsi;
                            mpController.map_dataTarget['rating'] =
                                post.averageReview;
                            mpController.map_dataTarget['donatur_profile'] =
                                post.userProfilePicture;
                            mpController.map_dataTarget['updateAt'] =
                                post.updatedAt;
                            mpController.map_dataTarget['expiredAt'] =
                                post.expiredAt;

                            print(
                                "data : ${mpController.map_dataTarget['url']} | ${mpController.map_dataTarget['stok']}");

                            if (post.media == null || post.media.isEmpty) {
                              DialogPop(
                                context,
                                size: [180.h, 150.w],
                                dismissable: false,
                                icon: Container(
                                  height: 180.h,
                                  child: Column(
                                    children: [
                                      const SpinKitCircle(
                                        color: Color.fromRGBO(48, 122, 99, 1),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        "Loading...",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              Navigator.pushNamed(context, "/onmap");
                            }
                          },
                          child: CardFood(
                            context,
                            url: mediaUrl,
                            jarak: post.distance,
                            name: post.title,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            }),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  "Makanan Terbaru",
                  style: TextStyle(
                      fontFamily: "Bree", color: Colors.black, fontSize: 18.sp),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Obx(() {
              if (postController.isLoading2.value) {
                return Center(child: CircularProgressIndicator());
              } else if (postController.posts2.isEmpty) {
                return Center(child: Text('No posts found.'));
              } else {
                return Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Container(
                    height: 200.h,
                    child: ListView.builder(
                        itemCount: min(postController.posts2.length, 10),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final post = postController.posts2[index];
                          return CardFood(context,
                              url: post.media[0].url,
                              jarak: post.distance,
                              name: post.title);
                        }),
                  ),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
