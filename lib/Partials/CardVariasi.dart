import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget CardVariasi(BuildContext context, {
  String? text,
  RxInt? count,
  Function()? function,
  // RxBool? isPressed
}) {
  return InkWell(
    onTap: function,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: (count!.value % 2 == 0)? Colors.white : Color.fromRGBO(48, 122, 89, 1),
        border: Border.all(color: Colors.grey)
      ),
      child: Padding(
        padding: EdgeInsets.all(15.dm),
        child: Center(
          child: Text(
            text!,
            style: TextStyle(
              fontFamily: "Poppins",
              color: (count.value % 2 == 0)? Colors.black : Colors.white
            ),
          ),
        ),
      ),
    ),
  );
}