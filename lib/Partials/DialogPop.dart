import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<dynamic> DialogPop(BuildContext context,
    {Widget? icon, List<double>? size, bool? dismissable = true}) {
  return showDialog(
      context: context,
      barrierDismissible: dismissable!,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text("Loading..."),
          backgroundColor: Colors.white,
          content: AnimatedContainer(
              duration: Duration(seconds: 2),
              curve: Curves.elasticIn,
              height: (size != null) ? size[0] : 100.h,
              width: (size != null) ? size[1] : 100.h,
              child: Column(
                children: [icon!],
              )),
        );
      });
}
