import 'package:flutter/material.dart';
import 'package:wareg_app/Activity/BottomNavPage.dart';
import 'package:wareg_app/Activity/CekLayak.dart';
import 'package:wareg_app/Activity/ChatActivity.dart';
import 'package:wareg_app/Activity/Donasi.dart';
import 'package:wareg_app/Activity/FoodPicture.dart';
import 'package:wareg_app/Activity/FormFood.dart';
import 'package:wareg_app/Activity/Home.dart';
import 'package:wareg_app/Activity/Inventory.dart';
import 'package:wareg_app/Activity/LoginActivity.dart';
import 'package:wareg_app/Activity/OnMap.dart';
import 'package:wareg_app/Activity/PreviewFood.dart';
import 'package:wareg_app/Activity/RegisterActivity.dart';
import 'package:wareg_app/Activity/ResultCheck.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings setting){
    switch(setting.name){
      case '/home':
        return MaterialPageRoute(builder: (_)=> BottomNavPage());
      case '/login':
        return MaterialPageRoute(builder: (_)=> LoginActivity());
      case '/register':
        return MaterialPageRoute(builder: (_)=> RegisterActivity());
      case '/inventory':
        return MaterialPageRoute(builder: (_)=> Inventory());
      case '/donasi':
        return MaterialPageRoute(builder: (_)=> Donasi());
      case '/onmap':
        return MaterialPageRoute(builder: (_)=> OnMap());
      case '/chat':
        return MaterialPageRoute(builder: (_)=> ChatActivity());
      case '/picture':
        return MaterialPageRoute(builder: (_)=> FoodPicture());
      case '/formfood':
        return MaterialPageRoute(builder: (_)=> FormFood());
      case '/cek':
        return MaterialPageRoute(builder: (_)=> CekLayak());
      case '/result_check':
        return MaterialPageRoute(builder: (_)=> ResultCheck());
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