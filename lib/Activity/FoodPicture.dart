import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Activity/PreviewFood.dart';
import 'package:wareg_app/Controller/FoodController.dart';
import 'package:wareg_app/Controller/PictureController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FoodPicture extends StatefulWidget {
  const FoodPicture({Key? key}) : super(key: key);

  @override
  _FoodPictureState createState() => _FoodPictureState();
}

class _FoodPictureState extends State<FoodPicture> {
  PictureController picController = Get.put(PictureController());
  // late PictureController picController;
  var paths = <String>[].obs;
  CameraController? _camController;

  
  Future<void> initCamera() async {
    var cameras = await availableCameras();
    _camController = CameraController(cameras[0], ResolutionPreset.medium);
    await _camController!.initialize();
  }

  @override
  void dispose() {
    _camController!.dispose();
    super.dispose();
  }

 Future<String> takePicture() async {
    Directory root = await getTemporaryDirectory();
    String dir = "${root.path}/ReFood";
    await Directory(dir).create(recursive: true);
    String filePath = "${dir}/${DateTime.now()}.jpg";
    try {
      XFile? pic = await _camController!.takePicture();
      pic.saveTo(filePath);
    } catch (e) {
      log("Error : ${e.toString()}");
    }
    return filePath;
  }

  // Future<void> initCamera() async {
  //   var cameras = await availableCameras();
  //   camController = CameraController(cameras[0], ResolutionPreset.ultraHigh);
  //   await camController.initialize();
  // }

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
                onPressed: () {
                  picController.arr_img.value.clear();
                },
                icon: Icon(
                  LucideIcons.bell,
                  color: Colors.black,
                )),
            SizedBox(
              width: 5.dm,
            ),
          ],
        ),
        body: FutureBuilder(
            future: initCamera(),
            builder: (_, snap) => (snap.connectionState == ConnectionState.waiting)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text("paths : ${paths.toString()}"),
                        Container(
                          height: MediaQuery.of(context).size.height *
                                0.8 /
                                _camController!.value.aspectRatio,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: CameraPreview(_camController!),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                FloatingActionButton.large(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.dm)),
                                  backgroundColor:
                                      Color.fromRGBO(42, 122, 89, 1),
                                  onPressed: () {
                                    // picController.takePicture().then((value) {
                                    takePicture().then((value) {
                                      log("path : ${value}");
                                      // paths.value.add(value);
                                      picController.arr_img.value.add(value);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => PreviewFood()));
                                    });
                                  },
                                  child: const Center(
                                    child: Icon(
                                      Icons.camera,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                Positioned(
                                  left: 250.w,
                                  child: Column(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            picController
                                                .getImageFromGaleri()
                                                .then((value) {
                                              log("path : $value");
                                              picController.arr_img.value
                                                  .add(value);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PreviewFood()));
                                            });
                                            // Navigator.pushNamed(context, "/preview");
                                          },
                                          icon: const Icon(
                                            Icons.upload_file,
                                            color: Colors.black,
                                          )),
                                      Text(
                                        "Upload Foto",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Poppins",
                                            fontSize: 12.sp),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ],
                    )
            ));
  }
}
