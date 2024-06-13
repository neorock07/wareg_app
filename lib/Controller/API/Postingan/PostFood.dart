import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:wareg_app/Util/Ip.dart';
// import 'package:dio/dio.dart' as dio;

class PostFood extends GetxController {
  Future<Map<String, dynamic>?> postData(
      Map<String, dynamic> post_data, List<File> img) async {
    var data = post_data;
    Map<String, dynamic>? result;
    var ipAdd = Ip();
    // Create a URI object from the URL of the server endpoint
    final uri = Uri.parse('${ipAdd.getType()}://${ipAdd.getIp()}/post/create');
    var token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImthbnllQGdtYWlsLmNvbSIsImlhdCI6MTcxODE3Mjc5NSwiZXhwIjoxNzIwNzY0Nzk1fQ.upmwj0SYoHKo1DbvBhdTThXj2QmFCyOu9Mt6HpWLsOE";

    // Create an HTTP request object
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] =
        'multipart/form-data'; // Menambahkan Content-Type
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
    if (response.statusCode == 200) {
      // The request was successful
      print('Success!');
      result = {"response": 200};
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
