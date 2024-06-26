import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Controller/FoodController.dart';

var foodController = Get.put(FoodController());

Widget FormDate(BuildContext context,
    {num? width,
    String? hint,
    String? label,
    bool? isEditable = true,
    TextEditingController? controller}) {
  return Column(
    children: [
      SizedBox(height: 5.h),
      Container(
          width: MediaQuery.of(context).size.width * width!,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 1.w),
            child: TextField(
                readOnly: true,
                controller: controller,
                onTap: () {
                  if (isEditable == true) {
                    foodController.selectDate(context).then((value) {
                      controller!.text = value;
                      log("waktu : ${controller.text}");
                    });
                  }
                },
                decoration: const InputDecoration(
                    hintText: "",
                    prefixIcon: Icon(
                      LucideIcons.calendar,
                      size: 20,
                    )),
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12.sp,
                    color: Colors.black)),
          ))
    ],
  );
}
