import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Controller/API/Transaksi/TransaksiController.dart';
import 'package:wareg_app/Controller/notification_controller.dart';
import 'package:wareg_app/Util/Ip.dart';
import 'package:timelines/timelines.dart';

class CompletedActivity extends StatefulWidget {
  const CompletedActivity({Key? key}) : super(key: key);

  @override
  _CompletedActivityState createState() => _CompletedActivityState();
}

class _CompletedActivityState extends State<CompletedActivity> {
  var transController = Get.put(TransaksiController());
  var result_completed = <String, dynamic>{}.obs;
  final NotificationController notificationController =
      Get.put(NotificationController());

  List<Widget> widgetList = [];
  var ipAdd = Ip();
  var item_indicator = ["Konfirmasi", "Pengambilan", "Selesai"];
  var map_indicator = {"Konfirmasi": 0, "Pengambilan": 1, "Selesai": 2};
  Future<void> _getCompleted(int transId) async {
    await transController.getCompleted(transId).then((value) {
      result_completed.value = value;
    });
    log("data completed : ${result_completed.value}");
  }

  @override
  void initState() {
    super.initState();

    _getCompleted(transController.transaksi_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(48, 122, 89, 1),
        automaticallyImplyLeading: false,
        title: Obx(() => Text(
              (result_completed.value == null)
                  ? ""
                  : "selesai: ${result_completed.value['postTitle']}",
              style: TextStyle(
                  fontFamily: "Bree", color: Colors.white, fontSize: 18.sp),
            )),
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
      body: Obx(() {
        String newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";

        if (result_completed.value != null &&
            result_completed.value['postMedia'] != null) {
          widgetList = result_completed.value['postMedia'].map<Widget>((item) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/donasi");
              },
              child: Container(
                height: 120.h,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.dm),
                  image: DecorationImage(
                    image: NetworkImage(
                        "${item['url'].toString().replaceFirst("http://localhost:3000", newBaseUrl)}"),
                    scale: 1,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }).toList();
        }

        return (result_completed.value == null)
            ? Center(
                child: SpinKitCircle(
                color: Colors.blue,
              ))
            : Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    IntrinsicWidth(
                      child: Container(
                        height: 30.h,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 156, 251, 160)
                                .withOpacity(0.3),
                            border: Border.all(
                              color: Colors.green,
                            ),
                            borderRadius: BorderRadius.circular(10.dm)),
                        child: Padding(
                          padding: EdgeInsets.all(3.dm),
                          child: Center(
                            child: Text(
                              "Sebagai : ${result_completed.value['role']}",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    CarouselSlider(
                        items: widgetList,
                        options: CarouselOptions(
                          height: 100.h,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          scrollDirection: Axis.horizontal,
                        )),
                    SizedBox(
                      height: 20.h,
                    ),
                    (result_completed.value == null)
                        ? Text("")
                        : Container(
                            height: 80.h,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Timeline.tileBuilder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              builder: TimelineTileBuilder.connected(
                                connectionDirection: ConnectionDirection.before,
                                itemExtentBuilder: (_, __) => 120,
                                contentsBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("${item_indicator[index]}"),
                                  );
                                },
                                indicatorBuilder: (context, index) {
                                  String step = item_indicator[index];
                                  String? date = result_completed[step];
                                  // if(map_indicator[index] )
                                  if (result_completed.value['timeline'] != null) {
                                    if(result_completed.value['timeline']['konfirmasi'] != null){
                                        if(index == 0){
                                          return DotIndicator(color: Colors.green,);
                                        }
                                    }

                                    if(result_completed.value['timeline']['pengambilan'] != null){
                                      if(index == 1){
                                          return DotIndicator(color: Colors.green,);
                                        }
                                    }else{
                                          return DotIndicator(color: Colors.grey,);

                                    }
                                    
                                    if(result_completed.value['review'] == null){
                                      if(index == 2){
                                          return DotIndicator(color: Colors.grey,);
                                        }
                                    }else{
                                          return DotIndicator(color: Colors.green,);

                                        }

                                  }

                                  
                                },
                                connectorBuilder: (_, index, ___) {
                                  return SolidLineConnector(
                                    color: (result_completed
                                                .value['timeline'] !=
                                            null)
                                        ? (result_completed.value['timeline']
                                                    ['pengambilan'] !=
                                                null)
                                            ? Color.fromRGBO(48, 122, 89, 1)
                                            : Colors.grey
                                        : Colors.grey,
                                  );
                                },
                                itemCount: 3,
                              ),
                            ),
                          ),
                    Text(
                        (result_completed.value['role'] == 'Donatur')
                            ? "Penerima Donasi"
                            : "Donatur",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.w),
                    Row(
                      children: [
                        Container(
                          height: 45.dm,
                          width: 45.dm,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.dm),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      result_completed
                                              .value['userProfilePicture']
                                              ?.toString()
                                              ?.replaceFirst(
                                                  'http://localhost:3000',
                                                  "${ipAdd.getType()}://${ipAdd.getIp()}") ??
                                          "",
                                      scale: 1))),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 10.w),
                            Text(
                              // "${mpController.map_dataTarget['donatur_name']}",
                              "${result_completed.value['userName']}",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14.sp,
                                  color: Colors.black),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      // "${mpController.map_dataTarget['donatur_name']}",
                      "Kamu ${(result_completed.value['role'] == 'Donatur') ? 'mendapat' : 'memberi'} rate",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.sp,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 30,
                        ),
                        Text(
                          "${(result_completed.value['review'] == null) ? 'belum ada' : result_completed.value['review']}/5",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins",
                              fontSize: 25.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
