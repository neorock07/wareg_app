import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FoodController extends GetxController{
  //untuk tag field
  RxString? current_value;  
  RxList<String> tag_items = <String>[].obs;
  Map<String, dynamic>? data_food = {};
  

  //untuk tanggal
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;
   Future<String> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101,
    )).then((value) async{
      final newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (newTime != null) {
      selectedTime.value = newTime;
    }
    });
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate(pickedDate);
    }
    return "${selectedDate.string.substring(0,10)} ${selectedTime.value.hour}:${selectedTime.value.minute}";
  }

  String getFormatDate(DateTime date){
      return DateFormat("dd/mm/YYYY").format(date);
  }

  void addTag(String name){
    tag_items.value.add(name);
  }
  void removeTag(String name){
    tag_items.value.remove(name);
  }

  //fungsi untuk menambah textField
  void addTextField({
    List<TextEditingController>? ed1,  
    List<TextEditingController>? ed2,  
  }){
      ed1!.add(TextEditingController());
      ed2!.add(TextEditingController());
  }

}