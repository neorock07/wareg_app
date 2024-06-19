import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../Controller/FoodController.dart'; // Pastikan Anda menambahkan paket flutter_screenutil di pubspec.yaml

class ResepForm extends StatefulWidget {
  @override
  _ResepFormState createState() => _ResepFormState();
}

class _ResepFormState extends State<ResepForm> {
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> quantityControllers = [];
  List<String> units = [];
  var foodController = Get.put(FoodController());

  @override
  void initState() {
    super.initState();
    addField();
  }

  void addField() {
    nameControllers.add(TextEditingController());
    quantityControllers.add(TextEditingController());
    units.add('kg'); // Default value for the DropdownButton
    setState(() {});
  }

  void _removeTextFields(int index) {
    setState(() {
      nameControllers[index].dispose();
      quantityControllers[index].dispose();
      nameControllers.removeAt(index);
      quantityControllers.removeAt(index);
      units.removeAt(index);

      foodController.jmlController.remove(index);
      foodController.nameController.remove(index);
      foodController.typeController.remove(index);
    });
  }

  @override
  void dispose() {
    for (var controller in nameControllers) {
      controller.dispose();
    }
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Masukkan Bahan Baku',
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Bree",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DATA BAHAN BAKU MAKANAN",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Poppins",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Masukkan data bahan baku yang anda miliki",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Poppins",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: nameControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: nameControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Nama Bahan Baku ${index + 1}',
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: quantityControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Jumlah',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        DropdownButton<String>(
                          value: units[index],
                          items: <String>['kg', 'g', 'l'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              units[index] = newValue!;
                            });
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            _removeTextFields(index);
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: addField,
              icon: Icon(Icons.add),
              label: Text('Tambah Bahan Baku'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Tambahkan aksi yang diinginkan
                },
                icon: Icon(Icons.check, color: Color(0xFF307A59)),
                label: Text(
                  'Cari Rekomendasi',
                  style: TextStyle(color: Color(0xFF307A59)),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF307A59)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
