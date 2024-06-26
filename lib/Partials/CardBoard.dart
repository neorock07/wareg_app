import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

List<Widget> textWidgetList = [];
Widget CardBoard(BuildContext context,
    {List<Color?>? colors,
    List<dynamic>? status,
    String? food_name,
    String? point}) {
  textWidgetList = status!.map<Widget>((item) {
    return InkWell(
        onTap: () {
          // Navigator.pushNamed(context, "/donasi");
        },
        child: Text(
          "${item['postTitle']}",
          style: TextStyle(
              fontFamily: "Poppins", fontSize: 12.sp, color: Colors.white),
        ));
  }).toList();

  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.9,
    child: Stack(
      children: [
        Center(
          child: Container(
            height: 110.h,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.dm),
              color: Color.fromRGBO(143, 190, 169, 1),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.dm),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(62, 161, 117, 1),
                Color.fromRGBO(48, 122, 89, 1),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Status Aktivitas",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: 14.sp),
                        ),
                        (status.isEmpty)
                            ? Text(
                                "Tidak ada aktivitas",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                    fontSize: 12.sp),
                              )
                            : Container(
                                height: 20.h,
                                width: 60.w,
                                child: CarouselSlider(
                                    items: textWidgetList,
                                    options: CarouselOptions(
                                      height: 15.h,
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
                                      scrollDirection: Axis.vertical,
                                    )),
                              ),
                      ],
                    ),
                     (status.isEmpty)
                            ? Text("") : Row(
                              children: [
                                SpinKitRipple(color: Colors.white, size: 20.dm,duration: const Duration(milliseconds: 600),),
                                Container(
                      height: 25.h,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.dm),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(5.dm),
                          child: Text(
                                "sebagai ${status[0]['role']}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 12.sp,
                                ),
                          ),
                        ),
                      ),
                    ),
                              ],
                            ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.h, left: 10.w, bottom: 15),
                  child: Text(
                    point != null ? "$point Points" : "0 Points",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
