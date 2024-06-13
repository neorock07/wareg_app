import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget CardBoard(
  BuildContext context, {
  List<Color?>? colors,
  String? status, 
  String? food_name,
  String? point
}) {
  return SizedBox(
    // height: MediaQuery.of(context).size.height * 0.15,
    width: MediaQuery.of(context).size.width * 0.9,
    child: Stack(
      children: [
        Center(
          child: Container(
            height: 106.h,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.dm),
                color: Color.fromRGBO(143, 190, 169, 1)
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
                  ])),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                              text: "Status Donasi",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              children: [
                                TextSpan(
                                    text: "\nBakso sisa kemarin",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white))
                              ]),
                        ),
                      ],
                    ),
                    Container(
                      height: 25.h,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10.dm)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(5.dm),
                          child: Text(
                            "Sedang Dijemput",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontSize: 12.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.h, left: 10.w, bottom: 15),
                    child: Text(
                      "80 Points",
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Poppins"),
                    ),
                  ))
            ],
          ),
        ),
      ],
    ),
  );
}
