import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wareg_app/Activity/FoodPicture.dart';
import 'package:wareg_app/Partials/CardButton.dart';
import "package:camera/camera.dart";

class Donasi extends StatefulWidget {
  const Donasi({Key? key}) : super(key: key);

  @override
  _DonasiState createState() => _DonasiState();
}

class _DonasiState extends State<Donasi> {
  RxBool isPressed = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 80.dm,
              width: 80.dm,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image/lg.png"),
                      fit: BoxFit.fill)),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            "Foto makanan donasimu",
            style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Text(
              "Foto dulu makananmu yang akan didonasikan\nuntuk pengecekan kelayakan makanan ya",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.grey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(
            height: 80.h,
          ),
          Obx(() => CardButton(context, isPressed, onTap: (_) {
                // isPressed.value = true;
                // Navigator.pushNamed(context, "/picture");
                Navigator.push(
                  context, MaterialPageRoute(builder: ((context) => FoodPicture())));
              },
                  width_a: 0.4,
                  width_b: 0.5,
                  height_a: 0.05,
                  height_b: 0.06,
                  borderRadius: 40.dm,
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(52, 135, 98, 1),
                    Color.fromRGBO(48, 122, 99, 1),
                  ]),
                  child: Center(
                    child: Text(
                      "Selanjutnya",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  )))
        ],
      ),
    );
  }
}
