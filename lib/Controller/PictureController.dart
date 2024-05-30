import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PictureController extends GetxController{
  late CameraController camController;
  final picker = ImagePicker();
  var arr_img = <String>[].obs;
  
  @override
  void onInit() {
    initCamera();
    super.onInit();
  }

  Future<void> initCamera() async {
    var cameras = await availableCameras();
    camController = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    await camController.initialize();
    log("kamera telah init");
  }

  Future<String> takePicture() async {
    Directory root = await getTemporaryDirectory();
    String dir = "${root.path}/GetEats";
    await Directory(dir).create(recursive: true);
    String filePath = "${dir}/${DateTime.now()}.jpg";
    try{
      XFile? pic = await camController!.takePicture();
      pic.saveTo(filePath);
    }catch(e){
      log("Error : ${e.toString()}");
    }
    return filePath;
  }

  Future<String> getImageFromGaleri() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile!.path;
  }

}