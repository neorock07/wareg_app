import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Controller/API/Postingan/PostFood.dart';
import 'package:wareg_app/Controller/FoodController.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Partials/CardButton.dart';
import 'package:wareg_app/Partials/CardCheckBox.dart';
import 'package:wareg_app/Partials/CardVariasi.dart';
import 'package:wareg_app/Partials/DialogPop.dart';
import 'package:wareg_app/Partials/DropdownForm.dart';
import 'package:wareg_app/Partials/FormDate.dart';
import 'package:wareg_app/Partials/FormText.dart';
import 'package:wareg_app/Partials/FormText2.dart';
import 'package:wareg_app/Util/Ip.dart';
import '../Controller/PictureController.dart';
import '../Partials/MapBox.dart';
import 'package:flutter_open_street_map/open_street_map.dart';

class FormFood extends StatefulWidget {
  const FormFood({Key? key}) : super(key: key);

  @override
  _FormFoodState createState() => _FormFoodState();
}

class _FormFoodState extends State<FormFood> {
  GlobalKey<FormState> global_key = GlobalKey<FormState>();

  var picController = Get.put(PictureController());
  var foodController = Get.put(FoodController());
  late TextEditingController dateStart = TextEditingController();
  late TextEditingController dateDonate =
      TextEditingController(text: "${DateTime.now()}".substring(0, 16));

  var nameController = TextEditingController();
  var variasiController = TextEditingController();
  var lokasiController = TextEditingController();
  var koordinatController = TextEditingController();
  var jumlahController = TextEditingController();
  var deskripsiController = TextEditingController();

  RxInt count = 0.obs;
  DateFormat formatInput = DateFormat('yyyy-MM-dd HH:mm');

  var mapController = Get.put(MapsController());
  var postController = Get.put(PostFood());

  //dynamic textfield
  // var quantityController = <int, TextEditingController>{};
  // var valueController = <int, TextEditingController>{};
  var item = <int, Widget>{};
  RxBool isActivate = false.obs;

  void addCard() {
    if (isActivate.value == true) {
      if (item.keys.isEmpty) {
        item.addAll({0: newCard(context, 0, true)});
      } else {
        item.addAll(
            {item.keys.last + 1: newCard(context, item.keys.last + 1, true)});
      }
      setState(() {});
    } else {
      item.clear();
      setState(() {
        print(item);
        item.remove(count.value - 1);
        foodController.quantityController.remove(count.value - 1);
        foodController.valueController.remove(count.value - 1);
      });
    }
  }

  newCard(BuildContext context, int index, bool isNewCard) {
    var _quantityController = TextEditingController(text: " ");
    var _valueController = TextEditingController(text: "");
    foodController.quantityController.addAll({index: _quantityController});
    foodController.valueController.addAll({index: _valueController});
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
      child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.dm),
          ),
          shadowColor: Colors.black,
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(5.dm),
            child: Center(
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                print(item);
                                item.removeWhere((key, value) => key == index);
                                foodController.quantityController
                                    .removeWhere((key, value) => key == index);
                                foodController.valueController
                                    .removeWhere((key, value) => key == index);
                              });
                            },
                            icon: const Icon(Icons.cancel)),

                        /// Textfield
                        SizedBox(
                          width: 120.w,
                          child: TextFormField(
                            controller: _quantityController,
                            style: TextStyle(
                              fontFamily: "Poppins",
                            ),
                            decoration: InputDecoration(
                              fillColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              focusColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.dm)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.5.w)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.dm)),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.5.w,
                                  )),
                              errorMaxLines: 2,
                              disabledBorder: const OutlineInputBorder(
                                  gapPadding: 0,
                                  borderRadius: BorderRadius.zero),
                              isDense: true,
                              label: const Text(
                                "Nama",
                                style: TextStyle(
                                    color: Colors.grey, fontFamily: "Poppins"),
                              ),
                              labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 14.sp),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),

                        /// Textfield
                        SizedBox(
                          width: 80.w,
                          child: TextFormField(
                            controller: _valueController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              fillColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              focusColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.dm)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.5.dm)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.dm)),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.5.dm,
                                  )),
                              errorMaxLines: 2,
                              disabledBorder: const OutlineInputBorder(
                                  gapPadding: 0,
                                  borderRadius: BorderRadius.zero),
                              isDense: true,
                              label: const Text(
                                "Jumlah",
                                style: TextStyle(
                                    color: Colors.grey, fontFamily: "Poppins"),
                              ),
                              labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 14.sp),
                            ),
                          ),
                        )
                      ]),
                ],
              ),
            ),
          )),
    );
  }

  List<TextEditingController> variasi_items = [];
  List<TextEditingController> jumlah_items = [];

  String? dropdownValue;
  List<String>? variasi_item = [];
  bool _isVariasi = false;

  double height_container = 0.1;

  List<String> items = [
    "Berkuah",
    "Makanan kering",
    "Buah-buahan/Sayuran",
    "Makanan kemasan",
    "Karbohidrat",
    "Lauk Pauk",
    "Cemilan/Minuman",
  ];

  List<dynamic> items_icon = [
    LucideIcons.soup,
    LucideIcons.popcorn,
    LucideIcons.cherry,
    LucideIcons.cookie,
    LucideIcons.wheat,
    LucideIcons.beef,
    LucideIcons.cupSoda
  ];

  var isPressed = false.obs;

  var userProfile =
      "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg";
  var marker_user;
  var ipAdd = Ip();

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newBaseUrl = "${ipAdd.getType()}://${ipAdd.getIp()}";

    setState(() {
      userProfile = prefs.getString('profile_picture') ??
          "https://cdn.idntimes.com/content-images/duniaku/post/20230309/raw-06202016rf-1606-3d3997f53e6f3e9277cd5a67fbd8f31f-1a44de7c1e0085a4ec8d2e4cb9602659.jpg";
      marker_user =
          userProfile.replaceFirst("http://localhost:3000", newBaseUrl);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
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
        body: WillPopScope(
          onWillPop: () async {
            picController.arr_img.clear(); // Clear the images
            return true; // Allow the back action
          },
          child: SingleChildScrollView(
            child: Form(
              key: global_key,
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
                            image: FileImage(
                                File(picController.arr_img.value![0])))))),
                SizedBox(height: 15.h),
                FormText(context,
                    label: "Nama",
                    hint: "nama donasi",
                    controller: nameController),
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
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: EdgeInsets.all(5.dm),
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

                      items:
                          items!.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Text(
                                "${value}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontFamily: "Poppins"),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Icon(
                                items_icon[items.indexOf(value)],
                                size: 20,
                                color: Color.fromARGB(255, 204, 191, 90),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    )

                        // Obx(() => )
                        ),
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
                Obx(() => Padding(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: SizedBox(
                            width: 120.w,
                            height: 50.h,
                            child: CardVariasi(context,
                                text: "Aktifkan", count: count, function: () {
                              isActivate.value = !isActivate.value;
                              count.value += 1;
                              addCard();
                            }),
                          ),
                        ),
                      ),
                    )),
                (count % 2 != 0)
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: item.length != 0
                            ? Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        itemCount: item.length,
                                        itemBuilder: (context, index) {
                                          return item.values.elementAt(index);
                                        }),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        // count.value += 1;
                                        addCard();
                                      },
                                      child: Text(
                                        "Tambah+",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 12.sp),
                                      ))
                                ],
                              )
                            : const Center(
                                child: Text(
                                  "No any Textfield",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16),
                                ),
                              ),
                      )
                    : Text(""),
                SizedBox(height: 10.h),
                FormText(context,
                    label: "Lokasi",
                    hint: "jln. bersamamu",
                    controller: lokasiController),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () async {
                    DialogPop(context,
                        dismissable: false,
                        size: [350.h, 150.w],
                        icon: Column(
                          children: [
                            Container(
                                height: 280.h,
                                width: 200.h,
                                child: MapBox(
                                    context,
                                    mapController.controller,
                                    null,
                                    marker_user, 
                                    isPicker: true,
                                    isTrack: false
                                    )),
                            SizedBox(height: 10.h),
                            InkWell(
                                onTap: () async {
                                  var geo_picker = await mapController
                                      .controller
                                      .getCurrentPositionAdvancedPositionPicker();
                                  setState(() {
                                    koordinatController.text =
                                        "${geo_picker.latitude},${geo_picker.longitude}";
                                    log("koordinat : ${geo_picker.latitude} | ${geo_picker.longitude}");
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  });
                                },
                                child: Container(
                                  height: 40.h,
                                  width: 200.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.dm),
                                    color: Color.fromRGBO(48, 122, 99, 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Pick",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ))
                          ],
                        ));
                  },
                  child: FormText(context,
                      isEnabled: false,
                      label: "Koordinat",
                      hint: "tekan dan sesuaikan lokasi",
                      controller: koordinatController),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Tanggal beli/masak",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12.sp,
                          color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: FormDate(context,
                      width: 0.9, hint: "0", controller: dateStart),
                ),
                (isActivate == false)
                    ? Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          FormText(context,
                              label: "Jumlah",
                              hint: "0",
                              type: TextInputType.number,
                              controller: jumlahController)
                        ],
                      )
                    : Text(""),
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
                      child: CardButton(context, isPressed, onTap: (_) async {
                        isPressed.value = true;
                        if (global_key.currentState!.validate() == false) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            "Field tidak boleh kosong!",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12.sp,
                            ),
                          )));
                        } else {
                          foodController.data_food!['title'] =
                              "${nameController.text}";
                          foodController.data_food!['categories[]'] =
                              "${items.indexOf(dropdownValue!)}";

                          foodController.data_food!['body[alamat]'] =
                              "${lokasiController.text}";

                          foodController.data_food!['body[deskripsi]'] =
                              "${deskripsiController.text}";

                          if (jumlahController.text == null ||
                              jumlahController.text == '') {
                            for (int i = 0;
                                i < foodController.quantityController.length;
                                i++) {
                              foodController
                                      .data_food!['variants[${i}][name]'] =
                                  "${foodController.quantityController[i]!.text}";
                              foodController
                                      .data_food!['variants[${i}][stok]'] =
                                  "${foodController.valueController[i]!.text}";

                              DateTime waktuStart =
                                  formatInput.parse("${dateStart.text}");

                              String waktuISO_start =
                                  waktuStart.toIso8601String();
                              foodController
                                      .data_food!['variants[${i}][startAt]'] =
                                  waktuISO_start;

                              log("ternyata ${foodController.quantityController[i]!.text}");
                              log("harus ke jalan ${foodController.valueController[i]!.text}");
                            }
                          } else {
                            foodController.data_food!['variants[0][name]'] =
                                "${nameController!.text}";
                            foodController.data_food!['variants[0][stok]'] =
                                "${jumlahController.text}";

                            DateTime waktuStart =
                                formatInput.parse("${dateStart.text}");
                            String waktuISO_start =
                                waktuStart.toIso8601String();
                            foodController.data_food!['variants[0][startAt]'] =
                                waktuISO_start;
                          }

                          foodController.data_food!['body[coordinate]'] =
                              koordinatController.text;

                          Navigator.pushNamed(context, "/cek");
                        }

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
          ),
        ));
  }
}
