import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget CardCheckBox(BuildContext context, {
  String? text,
  RxBool? count,
  // RxBool? isPressed
}) {
  return InkWell(
    onTap: (){
      //  isPressed!.value = true;
       count.value = !count.value; 
    },
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: (count!.value == false)? Colors.white : Color.fromRGBO(48, 122, 89, 1),
        border: Border.all(color: Colors.grey)
      ),
      child: Padding(
        padding: EdgeInsets.all(15.dm),
        child: Center(
          child: Text(
            text!,
            style: TextStyle(
              fontFamily: "Poppins",
              color: (count.value == false)? Colors.black : Colors.white
            ),
          ),
        ),
      ),
    ),
  );
}