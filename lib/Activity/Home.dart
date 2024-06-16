import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Controller/API/Postingan/GetByLokasi.dart';
import 'package:wareg_app/Partials/CardDonate.dart';
import 'package:wareg_app/Partials/CardFood.dart';
import 'package:wareg_app/Partials/CardSearch.dart';
import 'package:wareg_app/Services/LocationService.dart';

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
      postController.fetchPosts(position.latitude, position.longitude);
      postController.fetchPostsNew(position.latitude, position.longitude);
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
              if (postController.isLoading.value) {
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
                          return CardFood(
                              url: post.media[0].url,
                              jarak: post.distance,
                              name: post.title);
                        }),
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
                          return CardFood(
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
