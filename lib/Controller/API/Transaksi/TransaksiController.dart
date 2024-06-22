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

  RxMap<String, dynamic> transCreate = <String, dynamic>{}.obs;
  RxMap<String, dynamic> transConf = <String, dynamic>{}.obs;
  RxMap<String, dynamic> transCancel = <String, dynamic>{}.obs;

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

    if (response.statusCode == 200 || response.statusCode == 201) {
      result = jsonDecode(response.body);
      transCreate.value = result!;
      log("lha iki respon 200");
      log("${result}");
    } else {
      result = jsonDecode(response.body);
      log("response : ${response.statusCode} | ${result}");
    }
    return result!;
  }

// {
//     "transactionId":7,
//     "review":4,
//     "comment":"terpercaya"
// }
  Future<Map<String, dynamic>> postConfirmation(
      int? transId, int? review, String? comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    String authorizationHeader = "Bearer $token";

    final Map<String, dynamic> payload = {
      "transactionId": transId!,
      "review": review!,
      "comment": comment
    };

    Map<String, dynamic>? result = {};

    final response = await http.post(
        Uri.parse(
            "${ipAdd.getType()}://${ipAdd.getIp()}/transactions/confirm-pengambilan"),
        headers: {
          "Authorization": authorizationHeader,
          "Content-Type": "application/json"
        },
        body: jsonEncode(payload));

    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      transConf.value = result!;
      log("lha iki respon 200");
      log("${result}");
    } else {
      result = jsonDecode(response.body);
      log("response : ${response.statusCode} | ${result}");
    }
    return result!;
  }

  Future<Map<String, dynamic>> cancelTransaksi(int? transId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    String authorizationHeader = "Bearer $token";

    Map<String, dynamic>? result = {};
    final response = await http.delete(Uri.parse(
        "${ipAdd.getType()}://${ipAdd.getIp()}/transactions/cancel/$transId"), 
        headers: {
          "Authorization": authorizationHeader
        },
        );

    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      transCancel.value = result!;
      log("lha iki respon 200");
      log("${result}");
    } else {
      result = jsonDecode(response.body);
      log("response : ${response.statusCode} | ${result}");
    }
    return result!;
  }

  Future<Map<String, dynamic>> reportTransaksi(int? postId, int? transId, String? reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    String authorizationHeader = "Bearer $token";

    Map<String, dynamic>? result = {};
    Map<String, dynamic> payload = {
      "reason": "$reason",
      "transactionId": transId
    };
    final response = await http.post(
        Uri.parse("${ipAdd.getType()}://${ipAdd.getIp()}/post/report/$postId"),
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

//   {
//     "reason":"Makanan telah basi",
//     "transactionId":5
// }
}
