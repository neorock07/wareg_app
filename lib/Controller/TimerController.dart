import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TimerController extends GetxController {
  Rx<DateTime> endTime = DateTime.now().add(Duration(minutes: 2)).obs;
  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _initializeTimer();
  }

  Future<void> _initializeTimer() async {
    _prefs = await SharedPreferences.getInstance();
    final endTimeString = _prefs.getString('endTime');
    if (endTimeString != null) {
      endTime.value = DateTime.parse(endTimeString);
    } else {
      endTime.value = DateTime.now().add(Duration(minutes: 3)); // 5 minutes countdown
      _prefs.setString('endTime', endTime.value.toIso8601String());
    }
  }
}
