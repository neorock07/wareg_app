import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Activity/Home.dart';
import 'package:wareg_app/Activity/LoginActivity.dart';
import 'package:wareg_app/Services/PrefService.dart';
import 'package:wareg_app/Util/Ip.dart';
import 'package:http/http.dart' as http;

class PrefController extends GetxController {
  var ipAdd = Ip();
  var storedData = ''.obs;

  void loadData(String key) {
    String? data = SharedPreferencesService().getString(key);
    if (data != null) {
      storedData.value = data;
    }
  }

  String getFullProfilePictureUrl(String profilePicture) {
    return profilePicture.replaceFirst(
        'http://localhost:3000', '${ipAdd.getType()}://${ipAdd.getIp()}');
  }

  Future<Map<String, String>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('user_name') ?? '';
    String email = prefs.getString('user_email') ?? '';
    String gender = prefs.getString('user_gender') ?? '';
    String profilePicture = prefs.getString('profile_picture') ?? '';

    // Update gender value
    String genderDisplay = '';
    if (gender == 'l') {
      genderDisplay = 'Laki-Laki';
    } else if (gender == 'p') {
      genderDisplay = 'Perempuan';
    }

    return {
      'name': name,
      'email': email,
      'gender': genderDisplay,
      'profilePicture': getFullProfilePictureUrl(profilePicture),
    };
  }

  Future<void> setProfilePicture(String profilePicture) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_picture', profilePicture);
  }

  Future<void> setName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

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

  Future<bool> clearData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.clear();
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
      if (isValid == true) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        await prefs.clear();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      await prefs.clear();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
