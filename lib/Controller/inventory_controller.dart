import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wareg_app/Util/Ip.dart';

class InventoryController extends GetxController {
  var items = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  Future<void> fetchInventory(String endpoint) async {
    try {
      isLoading(true);
      var ipAdd = Ip();
      String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var bearerToken = prefs.getString('token') ?? '';
      Map<String, String> headers = {
        'Authorization': 'Bearer $bearerToken',
      };
      var response =
          await http.get(Uri.parse('$_baseUrl$endpoint'), headers: headers);
      if (response.statusCode == 200) {
        items.value =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      }
      log('$_baseUrl/$endpoint');
      log(response.body.toString());
    } catch (e) {
      print('Error fetching inventory: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      var ipAdd = Ip();
      String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var bearerToken = prefs.getString('token') ?? '';
      Map<String, String> headers = {
        'Authorization': 'Bearer $bearerToken',
      };
      var response = await http.delete(
          Uri.parse('$_baseUrl/inventory/delete/$id'),
          headers: headers);
      if (response.statusCode == 200) {
        items.removeWhere((item) => item['id'] == id);
      } else {
        print('Failed to delete item');
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Future<void> updateItem(Map<String, dynamic> updatedItem) async {
    try {
      var ipAdd = Ip();
      String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var bearerToken = prefs.getString('token') ?? '';
      Map<String, String> headers = {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      };
      var response = await http.put(
        Uri.parse('$_baseUrl/inventory/update/${updatedItem['id']}'),
        headers: headers,
        body: jsonEncode(updatedItem),
      );
      if (response.statusCode == 200) {
        int index = items.indexWhere((item) => item['id'] == updatedItem['id']);
        if (index != -1) {
          items[index] = updatedItem;
        }
      } else {
        print('Failed to update item');
      }
    } catch (e) {
      print('Error updating item: $e');
    }
  }
}
