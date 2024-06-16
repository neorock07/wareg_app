import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as httpMultipart;

import '../Util/Ip.dart';

class MessageService extends GetxService {
  Future<void> saveFcmToken(String? token) async {
    var ipAdd = Ip();

    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bearerToken = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/users/update-fcm-token'),
      headers: headers,
      body: jsonEncode({'fcmToken': token}),
    );

    if (response.statusCode != 200) {
      log('Failed to save FCM token.');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessages(int userId) async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bearerToken = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    final response = await http.get(
      Uri.parse('$_baseUrl/messages/$userId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> messages =
          List<Map<String, dynamic>>.from(body);

      // Update image path to use _baseUrl
      messages.forEach((message) {
        if (message['file'] != null) {
          message['file'] =
              message['file'].replaceFirst('http://localhost:3000', _baseUrl);
        }
      });

      return messages;
    } else {
      log("Failed to load messages: ${response.statusCode}");
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendFile(String filePath, int userId) async {
    var ipAdd = Ip();

    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bearerToken = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'multipart/form-data',
    };

    var request =
        httpMultipart.MultipartRequest('POST', Uri.parse('$_baseUrl/messages'));

    request.headers.addAll(headers);

    request.fields['receiverId'] = '$userId'; // Replace with actual receiverId

    request.files
        .add(await httpMultipart.MultipartFile.fromPath('file', filePath));

    var streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      log('Failed to send file.');
      throw Exception('Failed to send file');
    }
  }

  Future<void> sendMessage(String message, int userId) async {
    var ipAdd = Ip();

    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bearerToken = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/messages'),
      headers: headers,
      body: jsonEncode({
        'receiverId': '$userId', // Replace with actual receiverId
        'message': message,
      }),
    );

    if (response.statusCode != 201) {
      log('Failed to send message.');
      throw Exception('Failed to send message');
    }
  }
}
