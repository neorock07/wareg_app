import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

Widget CardFood(){
  return Padding(
    padding: EdgeInsets.all(5.dm),
    child: Container(
      // height: 140.dm,
      // width: 100.dm,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140.dm,
            width: 140.dm,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.dm),
              image: DecorationImage(
                image: AssetImage("assets/image/kupat.jpg"),
                fit: BoxFit.cover,
                )
            ),
            
          ),
          SizedBox(
            height: 5.h,
          ),
          Text("Tahu Kupat",
           style:TextStyle(
            fontFamily: "Poppins",
            fontSize: 14.sp,
            color: Colors.black,
            fontWeight: FontWeight.normal
           ) ,),
          Row(
            children: [
              Icon(LucideIcons.locate,color: Colors.orange,size: 15,),
              Text("300m",
               style:TextStyle(
                fontFamily: "Poppins",
                fontSize: 12.sp,
                color: Colors.grey,
                fontWeight: FontWeight.normal
               ) ,),
            ],
          ),
        ],
      ),
    ),
  );
}