import 'dart:convert';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:wareg_app/Model/PostFoodModel.dart';
import 'package:wareg_app/Services/PostService.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Util/Ip.dart';

class GetPostController extends GetxController {
  var posts = <Post>[].obs;
  var posts2 = <Post>[].obs;
  var posts3 = <String, dynamic>{}.obs;
  var posts4 = <Post>[].obs;
  var posts5 = <dynamic>[].obs;
  var isLoading = true.obs;
  var isLoading2 = true.obs;
  var isLoading3 = true.obs;
  var isLoading4 = true.obs;
  var isLoading5 = true.obs;

  Future<int> fetchPosts(var lat, var long) async {
    try {
      isLoading(true);
      var fetchedPosts = await PostService().fetchPosts(lat, long);
      if (fetchedPosts == 401) {
        return 401;
      } else if (fetchedPosts != null) {
        posts.value = fetchedPosts;
      }
    } finally {
      isLoading(false);
    }
    return 200;
  }

  Future<int> fetchPostSearch(var lat, var long, String search) async {
    try {
      isLoading4(true);
      var fetchedPosts = await PostService().fetchPostSearch(lat, long, search);
      if (fetchedPosts == 401) {
        return 401;
      } else if (fetchedPosts != null) {
        posts4.value = fetchedPosts;
      }
    } finally {
      isLoading4(false);
    }
    return 200;
  }

  Future<int> fetchPostsNew(var lat, var long) async {
    try {
      isLoading2(true);
      var fetchedPosts = await PostService().fetchPostsNew(lat, long);
      if (fetchedPosts == 401) {
        return 401;
      } else if (fetchedPosts != null) {
        log(fetchedPosts.toString());
        posts2.value = fetchedPosts;
      }
    } finally {
      isLoading2(false);
    }
    return 200;
  }

  Future<RxBool> fetchPostDetail(var lat, var long, var id) async {
    try {
      isLoading3(true);
      var fetchedPosts = await PostService().fetchPostDetail(lat, long, id);
      if (fetchedPosts != null) {
        posts3.value = fetchedPosts;
      }
    } finally {
      isLoading3(false);
    }
    return isLoading3;
  }

  Future<void> fetchPostUser() async {
    isLoading5(true);
    try {
      var ipAdd = Ip();
      String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$_baseUrl/post/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        posts5.value = json.decode(response.body);
      } else {
        log('Failed to load posts');
      }
    } catch (e) {
      log('Error fetching posts: $e');
    } finally {
      isLoading5(false);
    }
  }

  Future<void> deletePost(int id) async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    final response = await http.patch(
      Uri.parse('$_baseUrl/post/hide/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      fetchPostUser();
      log('Post deleted successfully');
    } else {
      log('Failed to delete post');
    }
  }
}
