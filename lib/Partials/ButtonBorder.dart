import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget ButtonBorder(BuildContext context, String label, {
  Color? color,
  double? height, 
  double? width,
  double? fontSize,
  double? borderRadius,
  Function()? onTap
}) {
  return InkWell(
    onTap: onTap,
    splashColor: Colors.grey,
    child: Container(
        height: (height == null)? 30.h : height,
        width: (height == null)? 120.h : width,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(48, 122, 89, 1)),
            borderRadius: BorderRadius.circular(
             (borderRadius == null)?  10.dm : borderRadius,
            ),
            color: Colors.white),
        child: Center(
            child: Text("$label",
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: const Color.fromRGBO(48, 122, 89, 1),
                    fontSize: (fontSize == null)? 12.sp : fontSize)))),
  );
}
