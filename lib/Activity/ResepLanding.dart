import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wareg_app/Partials/CardButton.dart';

class ResepLanding extends StatefulWidget {
  const ResepLanding({Key? key}) : super(key: key);

  @override
  _ResepLandingState createState() => _ResepLandingState();
}

class _ResepLandingState extends State<ResepLanding> {
  RxBool isPressed = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
            "assets/image/cook.png",
            fit: BoxFit.fill,
            height: 180.dm,
            width: 180.dm,
          )),
          Text(
            "Kreasikan bahan baku Anda",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Poppins",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(5.dm),
            child: Text(
              "Butuh ide untuk hidangan selanjutnya? Dapatkan resep yang tepat sesuai selera dan bahan baku Anda",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Poppins",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Obx(() => CardButton(context, isPressed, onTap: (_) {
                isPressed.value = true;
                Navigator.pushNamed(context, "/form_resep");
              },
                  width_a: 0.78,
                  width_b: 0.8,
                  height_a: 0.05,
                  height_b: 0.06,
                  borderRadius: 10.dm,
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(52, 135, 98, 1),
                    Color.fromRGBO(48, 122, 99, 1),
                  ]),
                  child: Center(
                    child: Text(
                      "Masukkan Bahan Baku",
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
