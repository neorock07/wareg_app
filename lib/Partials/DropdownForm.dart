import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Controller/FoodController.dart';

var foodController = Get.put(FoodController());

Widget TagForm(BuildContext context,
    {String? dropdownValue, List<String>? items, String? label}) {
  return Padding(
    padding: EdgeInsets.only(left: 5.w),
    child: Wrap(
      spacing: 5,
      children: foodController.tag_items.value.map((e) {
        return Chip(
          side: const BorderSide(color: Color.fromRGBO(217, 217, 217, 1)),
          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
          label: Text(e),
          onDeleted: () {
              foodController.removeTag(e);
          },
          deleteIcon: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.dm)),
              child: const Icon(
                LucideIcons.x,
                color: Colors.white,
                size: 15,
              )),
        );
      }).toList(),
    ),
  );
}
