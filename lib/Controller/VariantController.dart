import 'package:get/get.dart';

class VariantController extends GetxController {
  var variants = [].obs;
  RxList<int> counts = <int>[].obs;

  void initializeData(List<dynamic> data) {
    variants.value = data;
    counts.value = List<int>.filled(data.length, 0);
  }
}
