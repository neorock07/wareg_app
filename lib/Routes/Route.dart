import 'package:flutter/material.dart';
import 'package:wareg_app/Activity/BottomNavPage.dart';
import 'package:wareg_app/Activity/Home.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings setting){
    switch(setting.name){
      case '/home':
        return MaterialPageRoute(builder: (_)=> BottomNavPage());
      default:
        return _errorRoute();

    }   
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return const Scaffold(
          body: Center(
            child: Text("Error!"),
          ),
      );
    });
  }
}