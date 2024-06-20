import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Util/Ip.dart';

class TransaksiController extends GetxController {
  static Ip ipAdd = Ip();
  static String API_URL =
      "${ipAdd.getType()}://${ipAdd.getIp()}/transactions/create";

  Future<Map<String, dynamic>> postTransaction(
      int postId, List<Map<String, dynamic>> detail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    String authorizationHeader = "Bearer $token";

    final Map<String, dynamic> payload = {"post_id": postId, "detail": detail};

     Map<String, dynamic>? result = {};
    final response = await http.post(Uri.parse(API_URL),
        headers: {
          "Authorization": authorizationHeader,
          "Content-Type": "application/json"
        },

       
        body: jsonEncode(payload));

    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      log("lha iki respon 200");
      log("${result}");
    } else {
      result = jsonDecode(response.body);
      log("response : ${response.statusCode} | ${result}");
    }
    return result!;
  }
}
