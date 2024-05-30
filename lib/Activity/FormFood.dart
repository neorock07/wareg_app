import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Controller/FoodController.dart';
import 'package:wareg_app/Partials/CardButton.dart';
import 'package:wareg_app/Partials/DropdownForm.dart';
import 'package:wareg_app/Partials/FormDate.dart';
import 'package:wareg_app/Partials/FormText.dart';
import 'package:wareg_app/Partials/FormText2.dart';
import '../Controller/PictureController.dart';


class FormFood extends StatefulWidget {
  const FormFood({Key? key}) : super(key: key);

  @override
  _FormFoodState createState() => _FormFoodState();
}

class _FormFoodState extends State<FormFood> {
  var picController = Get.put(PictureController());
  var foodController = Get.put(FoodController());
  late TextEditingController dateStart = TextEditingController();
  late TextEditingController dateDonate =
      TextEditingController(text: "${DateTime.now()}".substring(0, 16));

  var nameController = TextEditingController();
  var variasiController = TextEditingController();
  var lokasiController = TextEditingController();
  var jumlahController = TextEditingController();
  var deskripsiController = TextEditingController();

  String? dropdownValue;
  List<String>? variasi_item = [];
  bool _isVariasi = false;

  List<String> items = [
    "Berkuah",
    "Makanan kering",
    "Buah-buahan/Sayuran",
    "Makanan kemasan",
    "Karbohidrat",
    "Lauk Pauk",
    "Minuman"
  ];
  var isPressed = false.obs;


  @override
  void initState() {
    super.initState();
    variasiController.addListener(_checkVariasi);
  }  

   void _checkVariasi() {
    setState(() {
      _isVariasi = variasiController.text.isNotEmpty;
    });
  }

   @override
  void dispose() {
    variasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Donasi",
          style: TextStyle(fontFamily: "Bree", color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                LucideIcons.bell,
                color: Colors.black,
              )),
          SizedBox(
            width: 5.dm,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("DATA MAKANAN",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp)),
                      Text("Pastikan isi data dengan benar dan teliti",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.normal,
                              fontSize: 12.sp)),
                    ])),
          ),
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.only(left: 10.w, bottom: 5.h),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("Foto sampul",
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp)),
            ),
          ),
          Obx(() => Container(
              height: 80.h,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.dm),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          FileImage(File(picController.arr_img.value![0])))))),
          SizedBox(height: 15.h),
          FormText(context, label: "Nama", hint: "nama donasi", controller: nameController),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 10.w, bottom: 5.h),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("Kategori",
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp)),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Expanded(
                child: DropdownButton<String>(
              underline: SizedBox(
                height: 5.h,
              ),
              dropdownColor: Colors.white,
              isExpanded: true,

              borderRadius: BorderRadius.circular(10.dm),
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              // value: (controller.current_value == null)? "" : controller.current_value!.value ,
              value: dropdownValue,
              hint: Text(
                "--pilih--",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14.sp,
                ),
              ),
              icon: const Icon(LucideIcons.chevronDown),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },

              items: items!.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontFamily: "Poppins"),
                  ),
                );
              }).toList(),
            )

                // Obx(() => )
                ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 10.w, bottom: 5.h),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("Variasi",
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp)),
            ),
          ),
          Container(
            // height: 50.h,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index){
                      return 
                    }
                    )
                  )

                (_isVariasi)? Row(
                  children: [
                   SizedBox(
                     width: 100.w,
                     child: TextField(
                        decoration: InputDecoration(labelText: 'Variasi'),
                        controller: variasiController,
                      ),
                   ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 100.w,
                    child: TextField(
                        decoration: InputDecoration(labelText: 'Jumlah'),
                      ),
                  ),
                  ],
                ) : TextField(
                      decoration: InputDecoration(labelText: 'Variasi'),
                      controller: variasiController,
                    ), 

                // TagForm(context),
                // Padding(
                //   padding: EdgeInsets.only(left: 10.w),
                //   child: TextField(
                //     onSubmitted: (String value) {
                //       variasi_item!.add(value);
                //       foodController.addTag(value);
                //     },
                //     style: TextStyle(fontSize: 12.sp),
                //   ),
                // )
              ],
            ),
          ),


          SizedBox(height: 10.h),
          FormText(context, label: "Lokasi", hint: "jln. bersamamu", controller: lokasiController),
          ElevatedButton(onPressed: () async{
              
          }, child: Center(child: Text("Pick Location"))),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // FormText2(context, width: 0.2, hint:"0", label:"Jumlah"),
                FormDate(context,
                    width: 0.45,
                    hint: "0",
                    label: "Tanggal beli/masak",
                    controller: dateStart),
                FormDate(context,
                    width: 0.45,
                    hint: "0",
                    label: "Tanggal donasi",
                    controller: dateDonate,
                    isEditable: false),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          FormText(context,
              label: "Jumlah", hint: "0", type: TextInputType.number, controller: jumlahController),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: FormText(context,
                label: "Deskripsi",
                hint: "deskripsi makanan...",
                type: TextInputType.multiline,
                controller: deskripsiController),
          ),

          Obx(() => Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: CardButton(context, isPressed, onTap: (_) {
                  isPressed.value = true;

                  foodController.data_food!['name'] = "${nameController.text}";
                  foodController.data_food!['kategori'] = "${dropdownValue}";
                  foodController.data_food!['variasi'] = variasi_item;
                  foodController.data_food!['lokasi'] = "${nameController.text}";
                  foodController.data_food!['date_start'] = "${dateStart.text}";
                  foodController.data_food!['date_donate'] = "${dateDonate.text}";
                  foodController.data_food!['jumlah'] = "${jumlahController.text}";
                  foodController.data_food!['deskripsi'] = "${deskripsiController.text}";

                  Navigator.pushNamed(context, "/cek");
                  // log("${foodController.data_food!.values}");
                  // log("${foodController.data_food!['date_donate']}");
                },
                    width_a: 0.8,
                    width_b: 0.9,
                    height_a: 0.05,
                    height_b: 0.06,
                    borderRadius: 10.dm,
                    gradient: const LinearGradient(colors: [
                      Color.fromRGBO(52, 135, 98, 1),
                      Color.fromRGBO(48, 122, 99, 1),
                    ]),
                    child: Center(
                      child: Text(
                        "Selanjutnya",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ))
        ]),
      ),
    );
  }
}
