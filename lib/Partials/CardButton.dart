import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget CardButton(BuildContext context, RxBool isPressed,
    {
    Function(TapDownDetails)? onTap,
    Widget? child,  
    Gradient? gradient,  
    Color? color = Colors.blue,
    double? width_b = 0.4,
    double? height_b = 0.4,
    double? width_a = 0.4,
    double? borderRadius,
    double? height_a = 0.4}) {
  return GestureDetector(
    onTapDown: onTap, 
    
    // (_) {
    //   isPressed.value = true;
    //   onTap;
    // },
    onTapUp: (_) {
      isPressed.value = false;
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: isPressed.value!
          ? MediaQuery.of(context).size.width * width_a!
          : MediaQuery.of(context).size.width * width_b!,
      height: isPressed.value!
          ? MediaQuery.of(context).size.height * height_a!
          : MediaQuery.of(context).size.height * height_b!,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: BorderRadius.circular((borderRadius != null)? borderRadius : 10.dm),
      ),
      child: child
    ),
  );
}
