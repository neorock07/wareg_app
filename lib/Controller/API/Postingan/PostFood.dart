import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Util/Ip.dart';

class PostFood extends GetxController {
  Future<Map<String, dynamic>?> postData(
      Map<String, dynamic> post_data, List<File> img) async {
    var data = post_data;
    Map<String, dynamic>? result;
    var ipAdd = Ip();

    // Fetch token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    // Create a URI object from the URL of the server endpoint
    final uri = Uri.parse('${ipAdd.getType()}://${ipAdd.getIp()}/post/create');

    // Create an HTTP request object
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] =
        'multipart/form-data'; // Adding Content-Type
    for (var i in img) {
      request.files.add(await http.MultipartFile.fromPath(
        "images",
        i.path,
      ));
    }

    for (final entry in data.entries) {
      request.fields[entry.key] = entry.value.toString();
    }

    log("request fields: ${request.fields.toString()}");
    log("request files: ${request.files.map((f) => f.filename).toList()}");

    // Send the request and await the response
    final response = await request.send();

    // Check the status code of the response
    if (response.statusCode == 201) {
      // The request was successful
      print('Success!');
      result = {"response": 201};
    } else {
      final responseBody = await http.Response.fromStream(response);
      // The request failed
      print('Error: ${response.statusCode}');
      print('Response body: ${responseBody.body}');
      result = {"response": responseBody.body};
    }
    return result;
  }
}
