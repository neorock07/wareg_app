// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:ui';
// import 'dart:async';

// import 'package:wareg_app/Controller/CountdownController.dart';

// class CountdownWidget extends StatefulWidget {
//   @override
//   _CountdownWidgetState createState() => _CountdownWidgetState();
// }

// class _CountdownWidgetState extends State<CountdownWidget> {
//   final CountdownController countdownController = Get.put(CountdownController());
//   late Timer _timer;
//   int remainingTime = 0;

//   @override
//   void initState() {
//     super.initState();
//     countdownController.startCountdown();
//     _updateRemainingTime();
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           _updateRemainingTime();
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   void _updateRemainingTime() {
//     remainingTime = countdownController.getRemainingTime();
//     if (remainingTime <= 0) {
//       _timer.cancel();
//       print('Countdown ended');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(right: 10.w, top: 10.h),
//       child: Align(
//         alignment: Alignment.topRight,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.transparent,
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.white.withOpacity(0.2)),
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.white.withOpacity(0.1),
//                       Colors.white.withOpacity(0.05)
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(10.dm),
//                   child: Text(
//                     _formatRemainingTime(remainingTime),
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontFamily: "Poppins",
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatRemainingTime(int seconds) {
//     final hours = (seconds / 3600).floor().toString().padLeft(2, '0');
//     final minutes = ((seconds % 3600) / 60).floor().toString().padLeft(2, '0');
//     final secs = (seconds % 60).floor().toString().padLeft(2, '0');
//     return '$hours:$minutes:$secs';
//   }
// }
