import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class PromptController extends GetxController {
  static String API_URL =
      "https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.3";
  static String authorizationHeader =
      "Bearer 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";

  Future<Map<String, dynamic>> cekQuality(String prompt) async {
    final Map<String, dynamic> payload = {"inputs": prompt};
    var result = [];
    var hasil;
    Map<String, dynamic>? json_hasil;
    final response = await http.post(Uri.parse(API_URL),
        headers: {
          "Authorization": authorizationHeader,
          "Content-Type": "application/json"
        },

        // body: jsonEncode(payload)
        body: jsonEncode(payload));

    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      // log("hasil : ${result[0][['generated_text']]}");
      // hasil = result[0]['generated_text'].toString().split('```')[1];
      // hasil = hasil.replaceAll("'", '"');
      // json_hasil = jsonDecode(hasil);
      log("lha iki respon 200");
      hasil = result[0]['generated_text'].toString().split('!!');
      hasil = hasil[hasil.length - 1].replaceAll("'", '"');
      json_hasil = jsonDecode(hasil);
      log(
        "${json_hasil}" 
      );
    } else {
      json_hasil = {'result':{'scan' : 'error'}};
      log("response : ${response.statusCode}");
    }
    return json_hasil!;
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
