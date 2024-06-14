import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Controller/API/Register/RegisterController.dart';
import 'package:wareg_app/Controller/PictureController.dart';
import 'package:wareg_app/Partials/CardButton.dart';
import 'package:wareg_app/Partials/CardKonPassword.dart';
import 'package:wareg_app/Partials/CardPassword.dart';
import 'package:wareg_app/Partials/DialogPop.dart';
import 'package:wareg_app/Partials/FormDate.dart';
import 'package:wareg_app/Partials/FormSelectDate.dart';
import 'package:wareg_app/Partials/FormText.dart';

class RegisterActivity extends StatefulWidget {
  const RegisterActivity({Key? key}) : super(key: key);

  @override
  _RegisterActivityState createState() => _RegisterActivityState();
}

class _RegisterActivityState extends State<RegisterActivity> {
  var namaController = TextEditingController();
  var deskripsiController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var passKonController = TextEditingController();

  var regisController = Get.put(RegisterController());

  RxBool passCondition = false.obs;
  RxBool passKonCondition = false.obs;
  RxBool isPressed = false.obs;
  RxBool isPressed2 = false.obs;
  RxBool isLoad = false.obs;
  GlobalKey<FormState> global_key = GlobalKey<FormState>();
  File? file_img;

  String? dropdownValue;
  List<String> items = ["l", "p"];
  late TextEditingController dateStart = TextEditingController();
  var picController = Get.put(PictureController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(48, 122, 89, 1),
          title: Text(
            "Daftar Akun Baru",
            style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
          ),
        ),
        body: Stack(children: [
          Container(
            color: Color.fromRGBO(48, 122, 89, 1),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(247, 247, 247, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.dm),
                      topRight: Radius.circular(20.dm))),
              child: Stack(children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 20.w),
                  child: Text(
                    "Silahkan isi data berikut",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.78,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.dm),
                            topRight: Radius.circular(20.dm))),
                    child: SingleChildScrollView(
                      child: Form(
                        key: global_key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(height: 10.h),
                            InkWell(
                              onTap: () {
                                picController
                                    .getImageFromGaleri()
                                    .then((value) {
                                  log("path : $value");
                                  // picController.arr_img.value.add(value);
                                  file_img = File(value);
                                  setState(() {});
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 60.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.dm),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.5,
                                    )),
                                child: Center(
                                  child: (file_img != null)
                                      ? Image.file(
                                          file_img!,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          LucideIcons.camera,
                                          size: 25.dm,
                                          color: Colors.grey,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            FormText(context,
                                label: "Nama",
                                hint: "John Doe",
                                radius: 5.dm,
                                type: TextInputType.name,
                                controller: namaController),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.w, bottom: 5.h),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Jenis Kelamin",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12.sp)),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.dm),
                                    border: Border.all(color: Colors.grey)),
                                child: Padding(
                                    padding: EdgeInsets.all(5.dm),
                                    child: Expanded(
                                        child: DropdownButton<String>(
                                      underline: SizedBox(
                                        height: 5.h,
                                      ),
                                      dropdownColor: Colors.white,
                                      isExpanded: true,

                                      borderRadius:
                                          BorderRadius.circular(10.dm),
                                      padding: EdgeInsets.only(
                                          left: 10.w, right: 10.w),
                                      // value: (controller.current_value == null)? "" : controller.current_value!.value ,
                                      value: dropdownValue,
                                      hint: Text(
                                        "--pilih--",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      icon: const Icon(LucideIcons.chevronDown),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },

                                      items: items!
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            "${value}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontFamily: "Poppins"),
                                          ),
                                        );
                                      }).toList(),
                                    )))),
                            SizedBox(height: 10.h),
                            FormText(context,
                                label: "Email",
                                hint: "example@email.com",
                                radius: 5.dm,
                                type: TextInputType.emailAddress,
                                controller: emailController),
                            SizedBox(height: 10.h),
                            Obx(() => CardPassword(context,
                                label: "Password",
                                isBorder: true,
                                isObscure: passCondition,
                                controller: passController,
                                type: TextInputType.visiblePassword)),
                            SizedBox(height: 10.h),
                            Obx(() => CardKonPassword(context,
                                label: "Konfirmasi Password",
                                isBorder: true,
                                controller2: passController,
                                isObscure: passKonCondition,
                                controller: passKonController,
                                type: TextInputType.visiblePassword)),
                            SizedBox(
                              height: 20.h,
                            ),
                            Obx(() => Padding(
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  child: CardButton(context, isPressed,
                                      onTap: (_) async {
                                    isPressed.value = true;
                                    if (global_key.currentState!.validate() ==
                                        false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                        "Field tidak boleh kosong atau salah",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12.sp,
                                        ),
                                      )));
                                    } else {
                                      // Navigator.pushNamed(context, "/cek");
                                      Map<String, dynamic> data_post = {
                                        'name': namaController.text,
                                        'email': emailController.text,
                                        'password': passKonController.text,
                                        'gender': dropdownValue
                                      };

                                      DialogPop(
                                        context,
                                        icon: Container(
                                            height: 100.h,
                                            child: Column(
                                              children: [
                                                SpinKitCircle(
                                                    color: Color.fromRGBO(
                                                        48, 122, 89, 1)),
                                                Text(
                                                  "Mohon Tunggu...",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 14.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "pendaftaran akun sedang diproses",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 10.sp,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )),
                                      );
                                      /*
                                    Kirim data
                                    */
                                    await regisController
                                            .register(data_post, file_img!)
                                            .then((value) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          log("${value}");    
                                          if (value!['response'] == 200 || value!['response'] == 201) {
                                            DialogPop(
                                              context,
                                              size: [130.h, 100.h],
                                              dismissable: false,
                                              icon: Container(
                                                  height: 130.h,
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        LucideIcons.checkCircle,
                                                        color: Color.fromRGBO(
                                                            48, 122, 99, 1),
                                                        size: 30.dm,
                                                      ),
                                                      Text(
                                                        "AKUN BERHASIL DIBUAT",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 14.sp,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Obx(() => Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        20.h,
                                                                    top: 20.h),
                                                            child: CardButton(
                                                                context,
                                                                isPressed2,
                                                                onTap:
                                                                    (_) async {
                                                              isPressed2.value =
                                                                  true;
                                                              Navigator
                                                                  .pushNamed(
                                                                      context,
                                                                      "/login");

                                                              // log("${foodController.data_food!.values}");
                                                              // log("${foodController.data_food!['date_donate']}");
                                                            },
                                                                width_a: 0.25,
                                                                width_b: 0.3,
                                                                height_a: 0.05,
                                                                height_b: 0.06,
                                                                borderRadius:
                                                                    10.dm,
                                                                gradient:
                                                                    const LinearGradient(
                                                                        colors: [
                                                                      Color.fromRGBO(
                                                                          52,
                                                                          135,
                                                                          98,
                                                                          1),
                                                                      Color.fromRGBO(
                                                                          48,
                                                                          122,
                                                                          99,
                                                                          1),
                                                                    ]),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Konfirmasi",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Poppins",
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: 14
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                )),
                                                          ))
                                                    ],
                                                  )),
                                            );
                                          } else {
                                            DialogPop(
                                              context,
                                              icon: Container(
                                                  height: 100.h,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        "Gagal membuat akun",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 14.sp,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "maaf, coba ulangi pendaftaran lagi",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 10.sp,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          }
                                        });
                                    }

                                    // log("${foodController.data_food!.values}");
                                    // log("${foodController.data_food!['date_donate']}");
                                  },
                                      width_a: 0.8,
                                      width_b: 0.9,
                                      height_a: 0.05,
                                      height_b: 0.06,
                                      borderRadius: 10.dm,
                                      gradient: const LinearGradient(colors: [
                                        Color.fromRGBO(52, 135, 98, 1),
                                        Color.fromRGBO(48, 122, 99, 1),
                                      ]),
                                      child: Center(
                                        child: Text(
                                          "Daftar",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ])

        // Stack(
        //   children: [
        //     DraggableScrollableSheet(
        //                 initialChildSize: 0.45,
        //                 minChildSize: 0.45,
        //                 maxChildSize: 0.6,
        //                 builder: ((context, scrollController) {
        //                   return Container(
        //                     color: Colors.white,
        //                     child: ListView(
        //                             controller: scrollController,
        //                             children: [

        //                               ]),
        //                   );
        //                 })),
        //   ],
        // )
        );
  }
}
