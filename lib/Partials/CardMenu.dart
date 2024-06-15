import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../Util/Ip.dart';

var ipAdd = Ip();
String newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";
Widget CardMenu(BuildContext context,
    {String? url, String? title, String? jarak, int? stok}) {
  String updatedUrl = url!.replaceFirst("http://localhost:3000", newBaseUrl);
  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    child: Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80.dm,
            width: 80.dm,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.dm),
                image: DecorationImage(
                  image: NetworkImage("$updatedUrl"),
                  fit: BoxFit.cover,
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.dm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: "Poppins"),
                ),
                Row(
                  children: [
                    Icon(
                      LucideIcons.shieldCheck,
                      color: Colors.grey,
                      size: 10,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "Layak Makan",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12.sp,
                          color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  "$stok Porsi",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12.sp,
                      color: Colors.grey),
                ),
                Row(
                  children: [
                    Container(
                      width: 20.dm,
                      height: 20.dm,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(235, 242, 239, 1),
                          borderRadius: BorderRadius.circular(10.dm)),
                      child: Center(
                          child: Icon(
                        Icons.location_on,
                        color: Color.fromRGBO(42, 122, 89, 1),
                        size: 15,
                      )),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "$jarak",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12.sp,
                          color: Colors.grey),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
