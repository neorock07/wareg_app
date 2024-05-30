import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromRGBO(62, 161, 117, 1),
              Color.fromRGBO(48, 122, 89, 1),
            ])),
        child: Stack(children: [
          // Image.asset("assets/image/geo.png", opacity: 90,),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/image/bg_sp.png"),
                    fit: BoxFit.fill)),
          ),
          Center(
              child: RichText(
                  text: TextSpan(
                      text: "Re",
                      style: TextStyle(
                          fontFamily: "Bree",
                          fontSize: 30.sp,
                          color: Colors.white),
                      children: [
                        
                TextSpan(
                  text: "Food",
                  style: TextStyle(
                      fontFamily: "Bree",
                      fontSize: 30.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ]))),
        ]),
      ),
    );
  }
}
