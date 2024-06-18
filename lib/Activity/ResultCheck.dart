import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wareg_app/Controller/FoodController.dart';
import 'package:wareg_app/Controller/PictureController.dart';
import 'package:wareg_app/Partials/CardButton.dart';

class ResultCheck extends StatefulWidget {
  const ResultCheck({Key? key}) : super(key: key);

  @override
  _ResultCheckState createState() => _ResultCheckState();
}

class _ResultCheckState extends State<ResultCheck> {
  var isPressed2 = false.obs;
  var foodController = Get.put(PictureController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Donasi",
          style: TextStyle(fontFamily: "Bree", color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
              child: Image.asset(
            "assets/image/food_worth.png",
            height: 200.dm,
            width: 200.dm,
          )),
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: Text(
              "Terima Kasih atas kebaikan Anda",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              "Makanan sudah masuk\nke daftar makanan donasi✅",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20.h,),
          Obx(() => Padding(
            padding: EdgeInsets.only(bottom: 120.h),
            child: CardButton(context, isPressed2, onTap: (_) {
                  isPressed2.value = true;
                  foodController.arr_img.value.clear();
                  Navigator.pushNamed(context, "/home");
                  // log("${foodController.data_food!.values}");
                  // log("${foodController.data_food!['date_donate']}");
                },
                    width_a: 0.45,
                    width_b: 0.5,
                    height_a: 0.05,
                    height_b: 0.06,
                    borderRadius: 10.dm,
                    gradient: const LinearGradient(colors: [
                      Color.fromRGBO(52, 135, 98, 1),
                      Color.fromRGBO(48, 122, 99, 1),
                    ]),
                    child: Center(
                      child: Text(
                        "Lihat daftar makanan",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal),
                      ),
                    )),
          )),
        ],
      ),
    );
  }
}
