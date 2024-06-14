import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Controller/MapsController.dart';

import 'package:wareg_app/Model/PostFoodModel.dart';
import 'package:wareg_app/Util/Ip.dart';

class PostService extends GetxService {
  
  var mpController = Get.put(MapsController());


  Future<List<Post>> fetchPosts(var lat, var long) async {
    var ipAdd = Ip();
    
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    // await mpController.getUserLocation().then((value){
    //     latitude = value!.latitude;
    //     longtitude = value!.longitude;
    // });
    

    // Fetch token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    // Create request headers with the token
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$_baseUrl/post?lat=$lat&lon=$long'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Post.fromJson(item)).toList();
    } else {
      log("response : ${response.statusCode}");
      throw Exception('Failed to load posts');
    }
  }
}
