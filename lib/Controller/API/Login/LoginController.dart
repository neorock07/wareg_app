import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wareg_app/Controller/PrefController.dart';
import 'package:wareg_app/Util/Ip.dart';

class LoginController extends GetxController {
  var ipAdd = Ip();
  var prefController = Get.put(PrefController());
  Map<String, dynamic>? data;
  bool? isSucces;

  Future<bool> login(String email, String password) async {
    final url = Uri.parse(
        '${ipAdd.getType()}://${ipAdd.getIp()}/auth/login'); // Replace with your actual API endpoint

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      log("response : ${response.statusCode}");
      data = jsonDecode(response.body);
      prefController.saveData(data!);
      isSucces = true;
    } else {
      log("response : ${response.statusCode}");
      isSucces = false;
    }
    return isSucces!;
  }
}
