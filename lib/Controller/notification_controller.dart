import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Util/Ip.dart';

class NotificationController extends GetxController {
  var notifications = <dynamic>[].obs;
  var isLoading = true.obs;

  Future<void> fetchNotifications() async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bearerToken = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('$_baseUrl/notifications'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        notifications.value = json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Failed to fetch notifications: $e');
    } finally {
      isLoading(false);
    }
  }
}
