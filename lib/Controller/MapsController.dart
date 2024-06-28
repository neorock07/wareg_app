import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

class MapsController extends GetxController {
  double? latitude, longitude;
  double? target_lat, target_long;
  Rx<RoadInfo>? roadInfo = Rx<RoadInfo>(RoadInfo());
  var isLoading = true.obs;

  Map<String, dynamic> map_dataTarget = {};
  @override
  void onInit() {
    super.onInit();
    controller;
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
    GeoPoint? userLocation;
    await controller.myLocation().then((value) {
      latitude = value.latitude;
      longitude = value.longitude;
    });
    userLocation = GeoPoint(latitude: latitude!, longitude: longitude!);

    return userLocation;
  }

  Future<RoadInfo?> drawRoad({
    GeoPoint? start,
    GeoPoint? end,
    RoadType? type,
  }) async {
    double? latUser, longUser;
    await controller.myLocation().then((value) {
      latUser = value.latitude;
      longUser = value.longitude;
    });
    log("lokasi : ${latUser} ${longUser}");
    roadInfo!.value = await controller.drawRoad(
      GeoPoint(latitude: latUser!, longitude: longUser!),
      GeoPoint(latitude: target_lat!, longitude: target_long!),
      roadType: RoadType.bike,
      roadOption: const RoadOption(
        roadColor: Color.fromRGBO(42, 122, 89, 1),
        roadBorderColor: Color.fromRGBO(42, 122, 89, 1),
        zoomInto: true,
        roadWidth: 10,
      ),
    );

    return roadInfo!.value;
  }
}
