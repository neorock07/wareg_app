import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:wareg_app/Partials/CardButton.dart';
import 'package:wareg_app/Util/Ip.dart';

class InventoryFormPage extends StatefulWidget {
  final Function() onSubmit;

  InventoryFormPage({required this.onSubmit});

  @override
  _InventoryFormPageState createState() => _InventoryFormPageState();
}

class _InventoryFormPageState extends State<InventoryFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expiredAtController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  RxBool isPressed = false.obs;

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _selectedImage = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      await Permission.camera.request();
    }
  }

  Future<void> _submitForm() async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/inventory'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    if (_selectedImage != null) {
      request.files.add(
          await http.MultipartFile.fromPath('image', _selectedImage!.path));
    }
    request.fields['name'] = _nameController.text;
    request.fields['quantity'] = _quantityController.text;
    request.fields['expiredAt'] = DateFormat('yyyy-MM-ddTHH:mm:ss').format(
        DateFormat('dd/MM/yyyy HH:mm:ss').parse(_expiredAtController.text));

    var response = await request.send();
    if (response.statusCode == 201) {
      print('Inventory item added successfully');
      widget.onSubmit();
      Navigator.pop(context); // Navigate back to the inventory page
    } else {
      print('Failed to add inventory item');
    }
  }

  Future<void> _pickDateTime() async {
    DateTime now = DateTime.now().add(Duration(hours: 1));
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _expiredAtController.text =
            DateFormat('dd/MM/yyyy HH:mm:ss').format(finalDateTime);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Inventory Item',
          style: TextStyle(fontFamily: "Poppins", fontSize: 12.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Nama',
                    labelStyle: TextStyle(fontFamily: "Poppins")),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(fontFamily: "Poppins")),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _expiredAtController,
                decoration: InputDecoration(
                    labelText: 'Expired At',
                    labelStyle: TextStyle(fontFamily: "Poppins")),
                onTap: _pickDateTime,
                readOnly: true,
              ),
              SizedBox(height: 10.h),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 150.h)
                  : Container(height: 150.h, color: Colors.grey[200]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.image),
                    label: Text(
                      'Pick Image',
                      style: TextStyle(fontFamily: "Poppins"),
                    ),
                    onPressed: _pickImageFromGallery,
                  ),
                  SizedBox(width: 10.w),
                  TextButton.icon(
                    icon: Icon(Icons.camera),
                    label: Text('Take Photo',
                        style: TextStyle(fontFamily: "Poppins")),
                    onPressed: _takePhoto,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Obx(() => CardButton(context, isPressed, onTap: (_) {
                    isPressed.value = true;
                    _submitForm();
                  },
                      width_a: 0.78,
                      width_b: 0.8,
                      height_a: 0.05,
                      height_b: 0.06,
                      borderRadius: 10.dm,
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(52, 135, 98, 1),
                        Color.fromRGBO(48, 122, 99, 1),
                      ]),
                      child: Center(
                        child: Text(
                          "Simpan",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
