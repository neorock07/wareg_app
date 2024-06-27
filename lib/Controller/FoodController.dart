import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FoodController extends GetxController {
  //untuk tag field
  RxString? current_value;
  RxList<String> tag_items = <String>[].obs;
  Map<String, dynamic>? data_food = {};
  var data_treatment = "";
  var quantityController = <int, TextEditingController>{};
  var valueController = <int, TextEditingController>{};

  //resep controller text field
  var jmlController = <int, TextEditingController>{};
  var nameController = <int, TextEditingController>{};
  var typeController = <int, TextEditingController>{};

  var pilihDate = DateTime(2000).obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  String? formattedDate;

  Future<String> selectDate(BuildContext context) async {
    // Show date picker and get the selected date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1998),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate;

      // Show time picker and get the selected time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime.value,
      );

      if (pickedTime != null) {
        selectedTime.value = pickedTime;

        // Combine selected date and time
        final DateTime finalDateTime = DateTime(
          selectedDate.value.year,
          selectedDate.value.month,
          selectedDate.value.day,
          selectedTime.value.hour,
          selectedTime.value.minute,
        );

        // Check if the selected date and time is in the past
        if (finalDateTime.isAfter(DateTime.now())) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Cannot select a future date and time."),
            ),
          );
          return "Invalid date selected";
        }

        // Format the selected date
        String formattedDate =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(finalDateTime);
        log("kiii $formattedDate");

        return formattedDate;
      } else {
        // Handle case when no time is picked
        return "No time selected";
      }
    } else {
      // Handle case when no date is picked
      return "No date selected";
    }
  }

  String getFormatDate(DateTime date) {
    return DateFormat("dd/mm/YYYY").format(date);
  }

  void addTag(String name) {
    tag_items.value.add(name);
  }

  void removeTag(String name) {
    tag_items.value.remove(name);
  }

  //fungsi untuk menambah textField
  void addTextField({
    List<TextEditingController>? ed1,
    List<TextEditingController>? ed2,
  }) {
    ed1!.add(TextEditingController());
    ed2!.add(TextEditingController());
  }
}
