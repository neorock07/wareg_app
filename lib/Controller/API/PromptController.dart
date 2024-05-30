import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class PromptController extends GetxController {
  static String API_URL =
      "https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.3";
  static String authorizationHeader =
      "Bearer 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";

  Future<String> cekQuality(String prompt) async {
    final Map<String, dynamic> payload = {"inputs": prompt};
    var result = [];
    final response = await http.post(Uri.parse(API_URL),
        headers: {
          "Authorization": authorizationHeader,
          "Content-Type": "application/json"
        },

        // body: jsonEncode(payload)
        body: jsonEncode(payload));

    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      log("hasil : ${result[0][['generated_text']]}");
      log("lha iki respon 200");
    } else {
      log("response : ${response.statusCode}");
    }
    return result[0]['generated_text'];
  }
}

/**
 * 
 * [
    {
        "generated_text": "sebutkan 5 nama presiden indonesia yang memiliki gelar doctor\n5 Presiden Indonesia yang memiliki gelar Doctor:\n1. Sukarno (1950-1966) - memiliki gelar Doktor Honoris Causa dalam Jurusan Filologi Universitas Paris-Luminyre, Perancis.\n2. Suharto (1966-1998) - memiliki gelar Doktor Honoris Causa dalam Jurusan Sastra Universitas Padjadjaran, Bandung.\n3. Megawati"
    }
]
 */
