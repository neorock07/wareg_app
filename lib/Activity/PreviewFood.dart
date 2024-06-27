import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Controller/PictureController.dart';
import 'package:wareg_app/Partials/CardButton.dart';

class PreviewFood extends StatefulWidget {
  PreviewFood({super.key});


  @override
  _PreviewFoodState createState() => _PreviewFoodState();
}

class _PreviewFoodState extends State<PreviewFood> {
  var picController = Get.put(PictureController());
  RxBool isPressed = false.obs;

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
        body: Stack(
          children: [
            GridView.count(
            mainAxisSpacing: 7.dm,
            crossAxisSpacing: 5.dm,
            padding: EdgeInsets.all(10.dm),
            crossAxisCount: 2,
            children:
                List.generate(picController.arr_img.value.length + 1, (index) {
              return (index == picController.arr_img.value.length || picController.arr_img.value.length == 0 )
                  ?  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: 50.dm,
                        width: 20.dm,
                        // color: Colors.white,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(241, 241, 241, 1.0),
                            borderRadius: BorderRadius.circular(5.dm),
                            border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignOutside)),
                         child: Center(
                            child: Icon(LucideIcons.imagePlus, color: Colors.grey,),
                          ),       
                      ),
                  )
                  : Obx(() => Container(
                        height: 50.dm,
                        width: 20.dm,
                        // color: Colors.red,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.dm),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(
                                    File(picController.arr_img.value![index])))),
                        child: InkWell(
                          onTap: (){
                            picController.arr_img.value.removeAt(index);
                            setState(() {
                              
                            });
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 20.dm,
                              width: 20.dm,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.dm) 
                                
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(LucideIcons.x,size: 15.dm,  color: Colors.white,)),
                            ),
                          ),
                        ),            
                      ));
            }),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() => CardButton(context, isPressed, onTap: (_) {
                  isPressed.value = true;
                  Navigator.pushReplacementNamed(context, "/formfood");
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
                        "Selanjutnya",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    )))
            ),
          )
        ]));
  }
}
