import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

class MapsController extends GetxController {
  // @override
  // void onInit() async {
  //   await getUserLocation().then((value) {
  //       var lat = value![0];
  //       var long = value[1];
  //       drawRoute(lat, long);
  //   });
  //   super.onInit();
  // }
  double? latitude, longtitude;

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
    RoadInfo roadInfo = await controller.drawRoad(start!, end!,
        roadType: type!,
        roadOption: const RoadOption(
            roadColor: Color.fromRGBO(42, 122, 89, 1),
            roadBorderColor: Color.fromRGBO(42, 122, 89, 1),
            zoomInto: true,
            roadWidth: 10));
    print("Jarak : ${roadInfo!.distance! * 1000} m");
    log("Jarak : ${roadInfo!.distance! * 1000} m");
    log("Jarak : ${roadInfo!.instructions}");
    log("lokasi user : ");
    return roadInfo;
  }

  
  


}
