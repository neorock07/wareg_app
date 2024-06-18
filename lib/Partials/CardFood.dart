import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Util/Ip.dart';

var ipAdd = Ip();
String newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";

Widget CardFood(BuildContext context, {String? url, String? jarak, String? name}) {
  String updatedUrl = url!.replaceFirst("http://localhost:3000", newBaseUrl);
  return Padding(
    padding: EdgeInsets.all(5.dm),
    child: Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (url == null)
              ? CircularProgressIndicator()
              : FutureBuilder(
                  future: precacheImage(NetworkImage(updatedUrl), context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        height: 140.dm,
                        width: 140.dm,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.dm),
                          image: DecorationImage(
                            image: NetworkImage(updatedUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: 140.dm,
                        width: 140.dm,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            "$name",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          Row(
            children: [
              Container(
                width: 20.dm,
                height: 20.dm,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(235, 242, 239, 1),
                  borderRadius: BorderRadius.circular(10.dm),
                ),
                child: Center(
                  child: Icon(
                    Icons.location_on,
                    color: const Color.fromRGBO(42, 122, 89, 1),
                    size: 15.dm,
                  ),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                "${jarak!.split(" ")[0]} ${jarak.split(" ")[1]}",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
