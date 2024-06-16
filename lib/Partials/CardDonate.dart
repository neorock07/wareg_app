import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget CardDonate(BuildContext context, RxBool isPressed) {
  return GestureDetector(
    onTapDown: (_) {
      isPressed.value = true;
    },
    onTapUp: (_) {
      isPressed.value = false;
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: isPressed.value!
          ? MediaQuery.of(context).size.width * 0.88
          : MediaQuery.of(context).size.width * 0.9,
      height: isPressed.value!
          ? MediaQuery.of(context).size.height * 0.17
          : MediaQuery.of(context).size.height * 0.18,
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(10.dm),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.dm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Donasikan Makanan\nSisamu",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/donasi");
                      },
                      splashColor: Colors.grey,
                      hoverColor: Colors.grey,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(42, 122, 89, 1),
                            borderRadius: BorderRadius.circular(5.dm)),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 5.dm, bottom: 5.dm, left: 8.dm, right: 8.dm),
                          child: Text(
                            "Donasikan",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontSize: 12.sp),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 130.dm,
                width: 130.dm,
                child: Image.asset(
                  "assets/image/img.png",
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
