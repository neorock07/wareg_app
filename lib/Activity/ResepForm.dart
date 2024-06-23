import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wareg_app/Activity/ListHasilResep.dart';
import 'package:wareg_app/Controller/API/PromptController.dart';

import '../Controller/FoodController.dart';
import '../Partials/DialogPop.dart';

class ResepForm extends StatefulWidget {
  @override
  _ResepFormState createState() => _ResepFormState();
}

class _ResepFormState extends State<ResepForm> {
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> quantityControllers = [];
  List<String> units = [];
  var foodController = Get.put(FoodController());
  var promptController = Get.put(PromptController());

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

  String _generatePrompt() {
    List<String> bahanList = [];
    for (int i = 0; i < nameControllers.length; i++) {
      String bahan =
          "${nameControllers[i].text} ${quantityControllers[i].text} ${units[i]}";
      bahanList.add(bahan);
    }
    return "saya punya bahan baku : ${bahanList.join(', ')}. berikan 3 rekomendasi resep makanan";
  }

  bool _validateInputs() {
    for (int i = 0; i < nameControllers.length; i++) {
      if (nameControllers[i].text.isEmpty ||
          quantityControllers[i].text.isEmpty ||
          units[i].isEmpty) {
        return false;
      }
    }
    return true;
  }

  void _showWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Periksa kembali data yang anda masukkan, semua field harus diisi!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showLoadingDialog() {
    DialogPop(
      context,
      size: [100.h, 100.w],
      icon: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitCircle(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ),
            SizedBox(height: 10.h),
            Text("Sedang mencari resep yang cocok untuk kamu...", style: TextStyle(fontFamily: "Poppins", fontSize: 12.sp),),
          ],
        ),
      ),
    );

    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return Dialog(
    //       child: Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Row(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             SpinKitCircle(
    //               color: Theme.of(context).primaryColor,
    //               size: 50.0,
    //             ),
    //             SizedBox(width: 20),
    //             Text("Pencarian resep sedang berlangsung silahkan tunggu..."),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  void _hideLoadingDialog() {
    Navigator.of(context).pop();
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
              "DATA BAHAN BAKU OLAHAN",
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
                "Masukkan data bahan baku olahan yang anda miliki",
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
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: TextField(
                              controller: nameControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Nama Bahan Baku ${index + 1}',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: TextField(
                              controller: quantityControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Jumlah',
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: DropdownButton<String>(
                            underline: SizedBox(),
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
                onPressed: () async {
                  if (_validateInputs()) {
                    String prompt = _generatePrompt();
                    log(prompt);
                    DialogPop(
                      
                      context,
                      size: [150.h, 100.w],
                      icon: Container(
                          height: 150.h,
                          child: Column(
                            children: [
                              SpinKitCircle(
                                  color: Color.fromRGBO(48, 122, 89, 1)),
                              Text(
                                "MENCARI RESEP",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "proses pencarian resep sedang berlangsung\nmohon tunggu...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 10.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    );
                    await promptController.getRecipe(prompt);
                    _hideLoadingDialog();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListHasilResep(),
                        ));
                  } else {
                    _showWarning();
                  }
                },
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
