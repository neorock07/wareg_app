import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class PromptController extends GetxController {
  static String API_URL = "https://api.openai.com/v1/chat/completions";
  static String apiKey = dotenv.env['API_KEY'] ?? 'Unknown API Key';
  static String authorizationHeader = "Bearer $apiKey";
  // static String API_URL =
  //     "https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.3";
  // static String authorizationHeader =
  //     "Bearer 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";

  Future<Map<String, dynamic>> cekQuality(String prompt) async {
    final Map<String, dynamic> payload = {
  "model": "gpt-3.5-turbo",
  "messages": [
    {
      "role": "system",
      "content": "Anda adalah seorang analisis kesehatan, Anda bertugas mengecek apakah makanan tersebut layak konsumsi dan data yang diberikan valid atau tidak jawab dengan JSON format: {\"result\": {\"isValid\": true_or_false, \"isEdible\": true_or_false, \"reason\": \"alasan\", \"expiredAt\": \"expiration_date_in_ISO_format\"}}."
    },
    {
      "role": "user",
      "content": prompt
    }
  ]
};

    var result = {};
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
      // hasil = result[0]['generated_text'].toString().split('!!');
      hasil = result['choices'][0]['message']['content'];
      // hasil = hasil[hasil.length - 1].replaceAll("'", '"');
      // hasil = hasil[hasil.length - 1].replaceAll("'", '"');
      log("ki cuk : $hasil");
      json_hasil = json.decode(hasil);
      log("${json_hasil}");
    } else {
      json_hasil = {
        'result': {'scan': 'error'}
      };
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
