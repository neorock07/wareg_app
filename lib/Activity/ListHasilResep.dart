import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Controller/API/PromptController.dart';

class ListHasilResep extends StatefulWidget {
  const ListHasilResep({Key? key}) : super(key: key);

  @override
  _ListHasilResepState createState() => _ListHasilResepState();
}

class _ListHasilResepState extends State<ListHasilResep> {
  var promptController = Get.put(PromptController());

  void saveRecipe(Map<String, dynamic> recipe) {
    // Tambahkan logika penyimpanan atau bookmark di sini
    // Misalnya, simpan ke database lokal atau remote server
    print('Recipe saved: ${recipe['title']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hasil Daftar Resep",
          style: TextStyle(
              fontFamily: "Poppins", color: Colors.black, fontSize: 18.sp),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.pushNamed(context, "/notifications");
              },
              icon: Icon(
                LucideIcons.bell,
                color: Colors.black,
              )),
          SizedBox(
            width: 5.dm,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.dm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Berikut Rekomendasi Resep buat kamu",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8.w),
                Icon(
                  LucideIcons.sparkles,
                  color: Color.fromRGBO(48, 122, 89, 1),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: promptController.content.value['result'].length,
                  itemBuilder: (_, index) {
                    var recipe =
                        promptController.content.value['result'][index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      height: 150.h,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color.fromRGBO(48, 122, 89, 1)),
                        borderRadius: BorderRadius.circular(6.dm),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.dm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${recipe['title']}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              "${recipe['step'].toString().substring(0, 127)}...",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(48, 122, 89, 1),
                                  primary: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                recipe['title'],
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                LucideIcons.bookmark,
                                                color: Color.fromRGBO(
                                                    48, 122, 89, 1),
                                              ),
                                              onPressed: () {
                                                saveRecipe(recipe);
                                              },
                                            ),
                                          ],
                                        ),
                                        content: Container(
                                          width: double.maxFinite,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Bahan:\n" +
                                                      recipe['bahan_baku']
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.grey[600],
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                SizedBox(height: 10.h),
                                                Text(
                                                  "Langkah-langkah:\n" +
                                                      recipe['step'].toString(),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.grey[600],
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Tutup',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    48, 122, 89, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'Selengkapnya',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
