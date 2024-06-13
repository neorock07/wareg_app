import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Controller/API/Postingan/PostFood.dart';
import 'package:wareg_app/Controller/API/PromptController.dart';
import 'package:wareg_app/Controller/FoodController.dart';
import 'package:wareg_app/Controller/PictureController.dart';
import 'package:wareg_app/Partials/CardButton.dart';
import 'package:wareg_app/Partials/CardCheckBox.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wareg_app/Partials/DialogPop.dart';

class CekLayak extends StatefulWidget {
  const CekLayak({Key? key}) : super(key: key);

  @override
  _CekLayakState createState() => _CekLayakState();
}

class _CekLayakState extends State<CekLayak> {
  //count data
  RxBool count = false.obs;
  RxBool count2 = false.obs;
  RxBool count3 = false.obs;
  RxBool count4 = false.obs;
  RxBool count5 = false.obs;

  var isPressed = false.obs;
  var isPressed2 = false.obs;
  var query = Get.put(PromptController());
  var foodController = Get.put(FoodController());
  RxMap<String, dynamic>? presiden = <String, dynamic>{}.obs;
  bool? result_check = false;
  String? expired_time;
  var postController = Get.put(PostFood());
  var picController = Get.put(PictureController());
  List<File> files_img = [];

  Map<int, String> map_item = {
    1: "Makanan tidak berbau busuk atau berlendir",
    2: "Makanan belum lewat tanggal kadaluwarsa (untuk makanan kemasan)",
    3: "Makanan tidak mengandung bahan berbahaya",
    4: "Makanan masih higienis tidak terkontaminasi kotoran",
    5: "Warna makanan terlihat normal seperti aslinya"
  };

  List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cek Kelayakan",
          style: TextStyle(fontFamily: "Bree", color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                LucideIcons.bell,
                color: Colors.black,
              )),
          SizedBox(
            width: 5.dm,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 20.h),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cek Kelayakan Donasi",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp)),
                        Text("Silahkan pilih sesuai kondisi makanan saat ini",
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp)),

                        // Text((presiden !=null)? "${presiden!['result']['expiredAt']}" : "")
                      ])),
            ),
            SizedBox(
              height: 30.h,
            ),
            Obx(() => Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: CardCheckBox(context,
                      text: "${map_item[1]}", count: count),
                )),
            Obx(() => Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: CardCheckBox(context,
                      text: "${map_item[2]}", count: count2),
                )),
            Obx(() => Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: CardCheckBox(context,
                      text: "${map_item[3]}", count: count3),
                )),
            Obx(() => Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: CardCheckBox(context,
                      text: "${map_item[4]}", count: count4),
                )),
            Obx(() => Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: CardCheckBox(context,
                      text: "${map_item[5]}", count: count5),
                )),
            Obx(() => Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: CardButton(context, isPressed, onTap: (_) async {
                    isPressed.value = true;
                    // Navigator.pushNamed(context, "/cek");

                    if (count == true) {
                      items.add(map_item[1]!);
                    }
                    if (count2 == true) {
                      items.add(map_item[2]!);
                    }
                    if (count3 == true) {
                      items.add(map_item[3]!);
                    }
                    if (count4 == true) {
                      items.add(map_item[4]!);
                    }
                    if (count5 == true) {
                      items.add(map_item[5]!);
                    }

                    log("dipilih : ${items.toSet().toString()}");
                    foodController.data_food!['condition'] = items;

                    DialogPop(
                      context,
                      icon: Container(
                          height: 100.h,
                          child: Column(
                            children: [
                              SpinKitCircle(
                                  color: Color.fromRGBO(48, 122, 89, 1)),
                              Text(
                                "MENGECEK KELAYAKAN",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "proses pengecekan sedang berlangsung\nmohon tunggu...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 10.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    );
                    log("there is a ${foodController.data_food!['title']} cook date ${foodController.data_food!['variants[0][startAt]']}, date now at ${DateTime.now()}, condition : ${foodController.data_food!['condition']} it is still allowed to consume?, please answer in Json Format like this");
                    await query
                        .cekQuality(
                            "there is a ${foodController.data_food!['title']} cook date ${foodController.data_food!['variants[0][startAt]']}, date now at ${DateTime.now()}, condition : ${foodController.data_food!['condition']} it is still allowed to consume?, please answer in Json Format like this  !!{'result' : {'scan:'#you should answer only true or false, 'expiredAt':#you should estimate expired time in ISO format, 'reason':#your_reason}}!!")
                        .then((value) {
                      log("ki hasil e : $value");
                      presiden!.value = value;
                      result_check = presiden!.value['result']['scan'];
                      expired_time = presiden!.value['result']['expiredAt'];

                      if (foodController.quantityController.length > 1) {
                        for (int i = 0;
                            i < foodController.quantityController.length;
                            i++) {
                          foodController
                                  .data_food!['variants[${i}][expiredAt]'] =
                              expired_time;
                        }
                      } else {
                        foodController.data_food!['variants[0][expiredAt]'] =
                            expired_time;
                      }

                      for (var i in picController.arr_img.value) {
                        files_img.add(File(i));
                      }

                      if (result_check == true) {
                        Navigator.of(context, rootNavigator: true).pop();
                        DialogPop(
                          context,
                          size: [180.h, 150.w],
                          dismissable: false,
                          icon: Container(
                              height: 180.h,
                              child: Column(
                                children: [
                                  Icon(
                                    LucideIcons.checkCircle,
                                    color: Color.fromRGBO(48, 122, 99, 1),
                                    size: 30.dm,
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    "MAKANAN ANDA\n LAYAK UNTUK KONSUMSI",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Obx(() => Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 20.h, top: 20.h),
                                        child: CardButton(context, isPressed2,
                                            onTap: (_) async {
                                          isPressed2.value = true;

                                          await postController
                                              .postData(
                                                  foodController.data_food!,
                                                  files_img)
                                              .then((value) {
                                            log("sudah rampung!! | ${value.toString()}");
                                          }).then((value) {
                                            Navigator.pushNamed(
                                                context, "/result_check");
                                          });

                                          // log("${foodController.data_food!.values}");
                                          // log("${foodController.data_food!['date_donate']}");
                                        },
                                            width_a: 0.25,
                                            width_b: 0.3,
                                            height_a: 0.05,
                                            height_b: 0.06,
                                            borderRadius: 10.dm,
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromRGBO(52, 135, 98, 1),
                                              Color.fromRGBO(48, 122, 99, 1),
                                            ]),
                                            child: Center(
                                              child: Text(
                                                "Donasikan",
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    color: Colors.white,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            )),
                                      ))
                                ],
                              )),
                        );
                      } else {
                        Navigator.of(context, rootNavigator: true).pop();
                        DialogPop(
                          context,
                          size: [180.h, 150.w],
                          dismissable: false,
                          icon: Container(
                              height: 180.h,
                              child: Column(
                                children: [
                                  Icon(
                                    LucideIcons.checkCircle,
                                    color: Color.fromRGBO(48, 122, 99, 1),
                                    size: 30.dm,
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    "MAKANAN ANDA\n TIDAK LAYAK UNTUK KONSUMSI",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${presiden!['result']['reason']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Obx(() => Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 20.h, top: 20.h),
                                        child: CardButton(context, isPressed2,
                                            onTap: (_) {
                                          isPressed2.value = true;
                                          Navigator.pushNamed(
                                              context, "/result_check");
                                          // log("${foodController.data_food!.values}");
                                          // log("${foodController.data_food!['date_donate']}");
                                        },
                                            width_a: 0.25,
                                            width_b: 0.3,
                                            height_a: 0.05,
                                            height_b: 0.06,
                                            borderRadius: 10.dm,
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromRGBO(52, 135, 98, 1),
                                              Color.fromRGBO(48, 122, 99, 1),
                                            ]),
                                            child: Center(
                                              child: Text(
                                                "Kembali",
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    color: Colors.white,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            )),
                                      ))
                                ],
                              )),
                        );
                      }
                    });
                  },
                      width_a: 0.55,
                      width_b: 0.6,
                      height_a: 0.05,
                      height_b: 0.06,
                      borderRadius: 30.dm,
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(52, 135, 98, 1),
                        Color.fromRGBO(48, 122, 99, 1),
                      ]),
                      child: Center(
                        child: Text(
                          "Cek Kelayakan",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
