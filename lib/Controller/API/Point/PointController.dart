import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Util/Ip.dart';
import 'package:http/http.dart' as http;

class PointController extends GetxController{
  RxInt point_result = 0.obs;

  @override
  void onInit() {
    fetchPoints();
    super.onInit();
  }

  Future<void> fetchPoints() async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$_baseUrl/points'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
        point_result.value = json.decode(response.body)['points'];
        log("iki coeg point e");
    } else {
      print('Failed to load points');
    }
  }
}