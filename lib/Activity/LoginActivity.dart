import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Controller/API/Login/LoginController.dart';
import 'package:wareg_app/Partials/CardButton.dart';
import 'package:wareg_app/Partials/CardPassword.dart';
import 'package:wareg_app/Partials/CardTextField.dart';
import 'package:wareg_app/Partials/DialogPop.dart';

class LoginActivity extends StatefulWidget {
  const LoginActivity({Key? key}) : super(key: key);

  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  RxBool passCondition = false.obs;
  RxBool isPressed = false.obs;
  RxBool isLoad = false.obs;
  GlobalKey<FormState> global_key = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: global_key,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 80.h,
              ),
              Center(
                child: RichText(
                    text: TextSpan(
                        text: "Re",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 25.sp,
                            color: Color.fromRGBO(48, 122, 89, 1)),
                        children: [
                      TextSpan(
                        text: "Food",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 25.sp,
                            color: Color.fromRGBO(48, 122, 89, 1),
                            fontWeight: FontWeight.bold),
                      )
                    ])),
              ),
              SizedBox(
                height: 20.h,
              ),
              CardTextField(context,
                  label: "Email",
                  hint: "example@email.com",
                  controller: emailController,
                  type: TextInputType.emailAddress),
              SizedBox(
                height: 20.h,
              ),
              Obx(() => CardPassword(context,
                  label: "Password",
                  isObscure: passCondition,
                  controller: passController,
                  type: TextInputType.visiblePassword)),
              SizedBox(
                height: 30.h,
              ),
              Obx(() => CardButton(context, isPressed, onTap: (_) async {
                    isPressed.value = true;
                    if (global_key.currentState!.validate() == false) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        "Pengisian tidak sesuai ketentuan!",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12.sp,
                        ),
                      )));
                    } else {
                      setState(() {
                        isLoad.value = true;
                      });
                      DialogPop(
                        context,
                        icon: Container(
                            height: 100.h,
                            child: Column(
                              children: [
                                SpinKitCircle(
                                    color: Color.fromRGBO(48, 122, 89, 1)),
                                Text(
                                  "Mohon Tunggu...",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      );
                      await loginController
                          .login(emailController.text, passController.text)
                          .then((value) {
                        setState(() {
                          isLoad.value = false;
                          Navigator.of(context, rootNavigator: true).pop();
                        });

                        if (value == true) {
                          Navigator.pushNamed(context, "/home");
                        } else {
                          setState(() {
                            isLoad.value = false;
                          });
                          DialogPop(
                            context,
                            size: [180.h, 150.w],
                            dismissable: false,
                            icon: Container(
                                height: 80.h,
                                child: Column(
                                  children: [
                                    Icon(
                                      LucideIcons.shieldOff,
                                      color: Colors.red,
                                      size: 30.dm,
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      "Email atau Password Anda salah!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                          );
                        }
                      });
                    }
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
                          "Konfirmasi",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ))),
              SizedBox(
                height: 40.h,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun?",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                          fontSize: 12.sp),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/register");
                          log("kami tak sudi memilih");
                        },
                        splashColor: Colors.grey,
                        child: Text(
                          "Daftar disini!",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(48, 122, 89, 1),
                              fontSize: 12.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              
            ],
          ),
        ),
      ),
    );
  }
}
