import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Controller/API/Postingan/GetByLokasi.dart';
import 'package:wareg_app/Controller/notification_controller.dart';
import 'package:wareg_app/Partials/CardMenu.dart';
import 'package:wareg_app/Partials/CardSearch.dart';
import 'package:wareg_app/Services/LocationService.dart';
import 'package:wareg_app/Util/IconMaker.dart';
import 'package:wareg_app/Util/Ip.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final GetPostController postController = Get.put(GetPostController());
  final MapsController mpController = Get.put(MapsController());
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    notificationController.checkNotification();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchSearchResults());
  }

  Future<void> _fetchSearchResults() async {
    postController.isLoading4(true); // Set isLoading to true initially
    LocationService locationService = LocationService();
    Position position = await locationService.getCurrentLocation();
    await postController.fetchPostSearch(
        position.latitude, position.longitude, widget.query);
    postController.isLoading4(false); // Set isLoading to false after fetching
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Results for "${widget.query}"',
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: Center(child: CardSearch(context)),
          ), // CardSearch properly centered
          Expanded(
            child: Obx(() {
              if (postController.isLoading4.value) {
                return Center(child: CircularProgressIndicator());
              } else if (postController.posts4.isEmpty) {
                return Center(child: Text('No posts found.'));
              } else {
                return ListView.builder(
                  itemCount: postController.posts4.length,
                  itemBuilder: (context, index) {
                    final post = postController.posts4[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/onmap");
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                String updatedUrl = post.media[0].url
                                    .replaceFirst(
                                        "http://localhost:3000", newBaseUrl);
                                mpController.target_lat = double.parse(post
                                    .body.coordinate
                                    .toString()
                                    .split(",")[0]);
                                mpController.target_long = double.parse(post
                                    .body.coordinate
                                    .toString()
                                    .split(",")[1]);
                                mpController.map_dataTarget['title'] =
                                    post.title;
                                mpController.map_dataTarget['stok'] = post.stok;
                                mpController.map_dataTarget['alamat'] =
                                    post.body.alamat;
                                mpController.map_dataTarget['id'] = post.id;
                                mpController.map_dataTarget['userId'] =
                                    post.userId;
                                mpController.map_dataTarget['marker'] =
                                    MarkerIcon(
                                  iconWidget: IconMaker(
                                      link: updatedUrl, title: post.title),
                                );
                                mpController.map_dataTarget['url'] =
                                    post.media[0].url;
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

                                Navigator.pushNamed(context, "/onmap");
                              },
                              child: CardMenu(context,
                                  jarak: post.distance,
                                  stok: post.stok,
                                  url: post.media[0].url,
                                  title: post.title),
                            ),
                            SizedBox(height: 5.h),
                            Divider(
                              height: 2.h,
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
  }
}
