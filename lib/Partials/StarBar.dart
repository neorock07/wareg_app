import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget StarBar(BuildContext context, {
  RxBool? isPress
}){
  isPress!.value = true;
  return Icon(Icons.star, color: (isPress.value == true)? Colors.amber : Colors.grey, size: 40.dm,);

}