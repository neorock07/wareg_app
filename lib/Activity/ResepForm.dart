import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../Controller/FoodController.dart';

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
    units.add('kg');
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
        title: const Text(
          'Masukkan Bahan Baku',
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Bree",
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.dm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              padding: EdgeInsets.only(top: 5.dm),
              child: Text(
                "Masukkan data bahan baku yang anda miliki",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Poppins",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: ListView.builder(
                itemCount: nameControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.dm),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: TextField(
                              controller: nameControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Nama Bahan Baku ${index + 1}',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: TextField(
                              controller: quantityControllers[index],
                              decoration: const InputDecoration(
                                labelText: 'Jumlah',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: EdgeInsets.only(top: 14.h),
                            child: Expanded(
                              child: DropdownButton<String>(
                                underline: SizedBox(
                                  height: 5.h,
                                ),
                                value: units[index],
                                items: <String>['kg', 'g', 'l', 'pcs']
                                    .map((String value) {
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
                            ),
                          ),
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
            SizedBox(height: 15.h),
            ElevatedButton.icon(
              onPressed: addField,
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: const Text(
                'Tambah Bahan Baku',
                style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(48, 122, 89, 1),
              ),
            ),
            SizedBox(height: 15.h),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon:
                    const Icon(LucideIcons.sparkles, color: Color(0xFF307A59)),
                label: const Text(
                  'Cari Rekomendasi',
                  style: TextStyle(
                      color: Color(0xFF307A59), fontFamily: "Poppins"),
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
