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
  final CameraDescription cameraDescription;

  const FoodPicture({Key? key, required this.cameraDescription})
      : super(key: key);

  @override
  _FoodPictureState createState() => _FoodPictureState();
}

class _FoodPictureState extends State<FoodPicture> {
  PictureController picController = Get.put(PictureController());
  FoodController foodController = Get.put(FoodController());
  var paths = <String>[].obs;
  late CameraController _cameraController;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.cameraDescription,
      ResolutionPreset.medium,
    );
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      log("Error initializing camera: ${e.toString()}");
    }
  }

  Future<void> takePicture() async {
    if (!_isCameraInitialized) return;

    Directory root = await getTemporaryDirectory();
    String dir = "${root.path}/ReFood";
    await Directory(dir).create(recursive: true);
    String filePath = "${dir}/${DateTime.now()}.jpg";
    try {
      XFile? pic = await _cameraController.takePicture();
      if (pic != null) {
        await pic.saveTo(filePath);
        picController.arr_img.value.add(filePath);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PreviewFood(),
          ),
        );
      }
    } catch (e) {
      log("Error taking picture: ${e.toString()}");
    }
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        picController.arr_img.value.add(pickedFile.path);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewFood(),
        ),
      );
    } else {
      log('No image selected.');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
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
            onPressed: () {
              picController.arr_img.value.clear();
            },
            icon: Icon(
              LucideIcons.bell,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 5.dm,
          ),
        ],
      ),
      body: _isCameraInitialized
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.8 /
                      _cameraController.value.aspectRatio,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: CameraPreview(_cameraController),
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
                            borderRadius: BorderRadius.circular(50.dm)),
                        backgroundColor: Color.fromRGBO(42, 122, 89, 1),
                        onPressed: () async {
                          await takePicture();
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
                              onPressed: () async {
                                await getImageFromGallery();
                              },
                              icon: const Icon(
                                Icons.upload_file,
                                color: Colors.black,
                              ),
                            ),
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
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
