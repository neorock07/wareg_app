import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget FormText(BuildContext context, {
  TextEditingController? controller,
  String? label, 
  String? hint,
  TextInputType? type,
  bool? isEnabled = true,
}) {
  return Column(children: [
    Padding(
      padding: EdgeInsets.only(left: 10.w, bottom: 5.h),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text("$label",
            style: TextStyle(
                color: Colors.grey,
                fontFamily: "Poppins",
                fontWeight: FontWeight.normal,
                fontSize: 12.sp)),
      ),
    ),
    Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Color.fromRGBO(251, 251, 251, 1)
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: TextField(
              enabled: isEnabled ,
              keyboardType: (type == null && type != TextInputType.multiline)? null : type,
              maxLines: (type != TextInputType.multiline)? null : 4,
              controller: controller,
              decoration: InputDecoration(
                hintText: "$hint",
              ),
              style: TextStyle(
                  fontFamily: "Poppins", fontSize: 14.sp, color: Colors.black)),
        ))
  ]);
}
