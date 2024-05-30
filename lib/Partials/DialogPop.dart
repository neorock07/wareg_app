import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<dynamic> DialogPop(BuildContext context, {
  Widget? icon,
  bool? dismissable = true
}){
  return showDialog(
                      context: context,
                      barrierDismissible: dismissable!,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          // title: Text("Loading..."),
                          backgroundColor: Colors.white,
                          content: Container(
                              height: 100.h,
                              child: Column(
                                children: [
                                  icon!
                                ],
                              )),
                        );
                      });
}