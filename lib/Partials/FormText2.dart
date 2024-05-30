import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget FormText2(BuildContext context, {
  num? width,
  String? hint,
  String? label,
  TextEditingController? controller
}){
  return Column(
            children: [
              Text(
                "$label",
                style: TextStyle(
                    fontFamily: "Poppins", fontSize: 12.sp, color: Colors.grey),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * width!,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  color: Color.fromRGBO(251, 251, 251, 1)
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "$hint",
                        ),
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14.sp,
                            color: Colors.black)),
                  ))
            ],
          );
}