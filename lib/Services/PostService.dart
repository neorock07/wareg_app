import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Model/PostFoodDetail.dart';

import 'package:wareg_app/Model/PostFoodModel.dart';
import 'package:wareg_app/Util/Ip.dart';

class PostService extends GetxService {
  var mpController = Get.put(MapsController());

  Future<dynamic> fetchPosts(var lat, var long) async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    String url = '$_baseUrl/post?lat=$lat&lon=$long';

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Post.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      return 401;
    } else {
      log("response : ${response.statusCode}");
      throw Exception('Failed to load posts');
    }
  }

  Future<dynamic> fetchPostSearch(var lat, var long, String search) async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    String url = '$_baseUrl/post?lat=$lat&lon=$long&search=$search';

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Post.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      return 401;
    } else {
      log("response : ${response.statusCode}");
      throw Exception('Failed to load posts');
    }
  }

  Future<dynamic> fetchPostsNew(var lat, var long) async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    String url1 = '$_baseUrl/post/recent?lat=$lat&lon=$long';

    final response1 = await http.get(Uri.parse(url1), headers: headers);

    if (response1.statusCode == 200) {
      log(response1.body.toString());
      List<dynamic> body = jsonDecode(response1.body);
      return body.map((dynamic item) => Post.fromJson(item)).toList();
    } else if (response1.statusCode == 401) {
      return 401;
    } else {
      log("response : ${response1.statusCode}");
      throw Exception('Failed to load posts');
    }
  }

  Future<Map<String, dynamic>?> fetchPostDetail(
      var lat, var long, var id) async {
    var ipAdd = Ip();

    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$_baseUrl/post/find/$id?lat=$lat&lon=$long'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      log("response : ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  }
}
