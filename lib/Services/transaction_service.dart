import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Util/Ip.dart';

class TransactionService extends GetxService {
  Future<List<dynamic>> fetchTransactions() async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bearerToken = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    final response = await http.get(
      Uri.parse('$_baseUrl/transactions'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}
