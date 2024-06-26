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
  RxMap<String, dynamic> transDonor = <String, dynamic>{}.obs;
  /* variable untuk simpan trans_id dari page lain -- intent */
  int transaksi_id = 0;
  String? role_to_riwayat;

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
    final response = await http.delete(
      Uri.parse(
        "${ipAdd.getType()}://${ipAdd.getIp()}/transactions/cancel/$transId"), 
        headers: {
           "Authorization": authorizationHeader
        } 
        );

    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      transDonor.value = result!;
      log("lha iki respon 200");
      log("${result}");
    } else {
      result = jsonDecode(response.body);
      log("response : ${response.statusCode} | ${result}");
    }
    return result!;
  }

  Future<Map<String, dynamic>> reportTransaksi(
      int? postId, int? transId, String? reason) async {
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

  Future<Map<String, dynamic>> getTransaksiDonor(int? transId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    String authorizationHeader = "Bearer $token";

    Map<String, dynamic>? result = {};

    final response = await http.get(
        Uri.parse(
            "${ipAdd.getType()}://${ipAdd.getIp()}/transactions/donor/$transId"),
        headers: {
          "Authorization": authorizationHeader,
          "Content-Type": "application/json"
        });

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

  Future<List<dynamic>> getOngoing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    String authorizationHeader = "Bearer $token";

   var result;

    final response = await http.get(
        Uri.parse(
            "${ipAdd.getType()}://${ipAdd.getIp()}/transactions/ongoing"),
        headers: {
          "Authorization": authorizationHeader,
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      log("lha iki respon 200 untuk ongoing");
      log("${result}");
    } else {
      log("data ongoing : ${result}");
      result = jsonDecode(response.body);
      log("response : ${response.statusCode} | ${result}");
    }
    return result!;
  }

  Future<Map<String, dynamic>> getCompleted(int transId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    String authorizationHeader = "Bearer $token";

   var result;

    final response = await http.get(
        Uri.parse(
            "${ipAdd.getType()}://${ipAdd.getIp()}/transactions/completed/$transId"),
        headers: {
          "Authorization": authorizationHeader,
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      log("lha iki respon 200 untuk completed");
      log("${result}");
    } else {
      log("data completed : ${result}");
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
