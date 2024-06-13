import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Activity/Home.dart';
import 'package:wareg_app/Activity/LoginActivity.dart';
import 'package:wareg_app/Util/Ip.dart';
import 'package:http/http.dart' as http;

class PrefController extends GetxController {
  var ipAdd = Ip();

  Future<void> saveData(Map<String, dynamic> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = data['user'];
    await prefs.setString('token', data['token']);
    await prefs.setInt('user_id', user['id']);
    await prefs.setString('user_name', user['name']);
    await prefs.setString('user_email', user['email']);
    await prefs.setString('user_gender', user['gender']);
    await prefs.setString('profile_picture', user['profile_picture']);
  }

  Map<dynamic, dynamic>? parseJwt(String token) {
    try {
      final part = token.split(".");
      String payload = part[1];
      if (part.length != 3) {
        return null;
      }

      final String decoded =
          utf8.decode(base64Url.decode(base64Url.normalize(payload)));

      return json.decode(decoded);
    } catch (e) {
      log("error : $e");
    }
  }

  bool isTokenValid(String? token) {
    Map<dynamic, dynamic> jwtPayload = parseJwt(token!)!;

    /*
      cek expired jwt
    */
    int currTime = int.parse(
        DateTime.now().microsecondsSinceEpoch.toString().substring(0, 10));
    int expTime = jwtPayload['exp'];
    log("iki lo currTime : ${currTime} | exp : ${expTime}");
    if (currTime > expTime) {
      Get.snackbar("Sesi Berakhir", "Token sudah tidak berlaku");
    }

    return (currTime > expTime) ? false : true;
  }

  Future<void> cekLogin(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      bool isValid = isTokenValid(token);
      if (isValid) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
