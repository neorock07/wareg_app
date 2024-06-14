import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:wareg_app/Util/Ip.dart';
// import 'package:dio/dio.dart' as dio;

class RegisterController extends GetxController {
  Future<Map<String, dynamic>?> register(
      Map<String, dynamic> post_data, File img) async {
    var data = post_data;
    Map<String, dynamic>? result;
    var ipAdd = Ip();
    // Create a URI object from the URL of the server endpoint
    final uri = Uri.parse('${ipAdd.getType()}://${ipAdd.getIp()}/auth/register');
    
    // Create an HTTP request object
    final request = http.MultipartRequest('POST', uri);
    request.headers['Content-Type'] =
        'multipart/form-data'; // Menambahkan Content-Type
    
      request.files.add(await http.MultipartFile.fromPath(
        "profile_picture",
        img.path,
      ));
    
    for (final entry in data.entries) {
      request.fields[entry.key] = entry.value.toString();
    }

    log("request fields: ${request.fields.toString()}");
    log("request files: ${request.files.map((f) => f.filename).toList()}");

    // Send the request and await the response
    final response = await request.send();

    // Check the status code of the response
    if (response.statusCode == 200 || response.statusCode == 201) {
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
