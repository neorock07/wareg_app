import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

class MapsController extends GetxController {
  double? latitude, longtitude;
  double? target_lat, target_long;
  Rx<RoadInfo>? roadInfo;
  var isLoading = true.obs;
  Map<String, dynamic> map_dataTarget = {};
  
  @override
  void onInit() {
    // TODO: implement onInit
    controller;
    super.onInit();
  }

  MapController controller = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );

  Future<GeoPoint?> getUserLocation() async {
    // double? latitude, longtitude;
    GeoPoint? user_location;
    await controller.myLocation().then((value) {
      latitude = value.latitude;
      longtitude = value.longitude;
    });
    user_location = GeoPoint(latitude: latitude!, longitude: longtitude!);

    return user_location;
  }

  Future<RoadInfo?> drawRoad({
    GeoPoint? start,
    GeoPoint? end,
    RoadType? type,
  }) async {
    double? lat_user, long_user;
    await controller.myLocation().then((value) {
      lat_user = value.latitude;
      long_user = value.longitude;
    });
    log("lokasi : ${lat_user} ${long_user}");
    roadInfo!.value = await controller.drawRoad(
        GeoPoint(latitude: lat_user!, longitude: long_user!),
        GeoPoint(
            latitude: target_lat!,
            longitude: target_long!),
        roadType: RoadType.bike,
        roadOption: const RoadOption(
            roadColor: Color.fromRGBO(42, 122, 89, 1),
            roadBorderColor: Color.fromRGBO(42, 122, 89, 1),
            zoomInto: true,
            roadWidth: 10));
    
    return roadInfo!.value;
    
  }
}
