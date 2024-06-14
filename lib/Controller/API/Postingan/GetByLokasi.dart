import 'package:get/get.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Model/PostFoodModel.dart';
import 'package:wareg_app/Services/PostService.dart';


class GetPostController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = true.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchPosts(); // Example coordinates
  // }

  void fetchPosts(var lat, var long) async {
    try {
      isLoading(true);
      var fetchedPosts = await PostService().fetchPosts(lat, long);
      if (fetchedPosts != null) {
        posts.value = fetchedPosts;
      }
    } finally {
      isLoading(false);
    }
  }
}
