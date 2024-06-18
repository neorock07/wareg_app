import 'dart:convert';

import 'package:get/get.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Model/PostFoodDetail.dart';
import 'package:wareg_app/Model/PostFoodModel.dart';
import 'package:wareg_app/Services/PostService.dart';

class GetPostController extends GetxController {
  var posts = <Post>[].obs;
  var posts2 = <Post>[].obs;
  var posts3 = <String, dynamic>{}.obs;
  var isLoading = true.obs;
  var isLoading2 = true.obs;
  var isLoading3 = true.obs;

  Future<RxBool> fetchPosts(var lat, var long) async {
    try {
      isLoading(true);
      var fetchedPosts = await PostService().fetchPosts(lat, long);
      if (fetchedPosts != null) {
        posts.value = fetchedPosts;
      }
    } finally {
      isLoading(false);
    }
    return isLoading;
  }

  Future<RxBool> fetchPostsNew(var lat, var long) async {
    try {
      isLoading2(true);
      var fetchedPosts = await PostService().fetchPostsNew(lat, long);
      if (fetchedPosts != null) {
        posts2.value = fetchedPosts;
      }
    } finally {
      isLoading2(false);
    }
    return isLoading2;
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
