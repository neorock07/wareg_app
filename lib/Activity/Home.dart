import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Partials/CardDonate.dart';
import 'package:wareg_app/Partials/CardFood.dart';

import '../Partials/CardBoard.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RxBool isPressed = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hi, Neo",
          style: TextStyle(fontFamily: "Bree", color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                LucideIcons.bell,
                color: Colors.black,
              )),
          SizedBox(
            width: 5.dm,
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.white10,
                  elevation: 3,
                  child: TextFormField(
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15.sp,
                        color: Colors.black),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          LucideIcons.search,
                          color: Colors.grey,
                        ),
                        hintText: "Cari",
                        hintStyle:
                            TextStyle(fontFamily: "Poppins", fontSize: 15.sp),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(3.dm))),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            CardBoard(context),
            SizedBox(
              height: 10.h,
            ),
            Obx(() => CardDonate(context, isPressed)),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  "Makanan Terdekat",
                  style: TextStyle(
                      fontFamily: "Bree", color: Colors.black, fontSize: 18.sp),
                ),
              ),
            ),
            Container(
              height: 200.h,
              child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CardFood();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
