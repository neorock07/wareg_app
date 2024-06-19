import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FoodController extends GetxController {
  //untuk tag field
  RxString? current_value;
  RxList<String> tag_items = <String>[].obs;
  Map<String, dynamic>? data_food = {};
  var quantityController = <int, TextEditingController>{};
  var valueController = <int, TextEditingController>{};

  //resep controller text field
  var jmlController = <int, TextEditingController>{};
  var nameController = <int, TextEditingController>{};
  var typeController = <int, TextEditingController>{};

  //untuk tanggal
  var selectedDate = DateTime.now().obs;
  var pilihDate = DateTime(2000).obs;
  var selectedTime = TimeOfDay.now().obs;
  String? formattedDate;

  Future<String> showDate(BuildContext context) async {
    final DateTime? datePilih = await showDatePicker(
      context: context,
      initialDate: pilihDate.value,
      firstDate: DateTime(1901),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month),
    );

    if (datePilih != null) {
      pilihDate.value = datePilih;
      String formattedDate = DateFormat('yyyy-MM-dd').format(pilihDate.value);
      log("kiii $formattedDate");
      return "${formattedDate!.substring(0, 10)}";
    } else {
      return "no data";
    }
  }

  Future<String> selectDate(BuildContext context) async {
    // Show date picker and get the selected date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1998),
      lastDate: DateTime(DateTime.now().year + 10),
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
      }

      // Format the selected date
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate.value);
      log("kiii $formattedDate");

      return "${formattedDate.substring(0, 10)} ${selectedTime.value.hour}:${selectedTime.value.minute}";
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
