import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wareg_app/Activity/SplashScreen.dart';
import 'Routes/Route.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
      return GetMaterialApp(
        title: 'WaregApp',
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(48, 122, 89, 1)),
          useMaterial3: true,
        ),
        home: child,
      );
    },
    child: const SplashScreen(),
    );
  }
}
