import 'dart:convert';
import 'package:get/get.dart';
import 'package:wareg_app/Model/PostFoodModel.dart';
import 'package:wareg_app/Services/PostService.dart';

class GetPostController extends GetxController {
  var posts = <Post>[].obs;
  var posts2 = <Post>[].obs;
  var posts3 = <String, dynamic>{}.obs;
  var posts4 = <Post>[].obs;
  var isLoading = true.obs;
  var isLoading2 = true.obs;
  var isLoading3 = true.obs;
  var isLoading4 = true.obs;

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
}
