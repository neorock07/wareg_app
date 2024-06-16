import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Controller/PrefController.dart';
import 'package:wareg_app/Util/IconMaker.dart';
import 'package:wareg_app/Util/Ip.dart';

var marker_user;
var ipAdd = Ip();
var prefController = Get.put(PrefController());
var mpController = Get.put(MapsController());

Widget MapBox(
  BuildContext context,
  var controller,
  dynamic point,
  var url_profile, {
  bool? isDraw = false,
  bool? isPicker = false,
  bool? isTrack = true,
  double? lat,
  double? long,
}) {
  var mpController = Get.put(MapsController());

  return OSMFlutter(
    onMapIsReady: (condition) async {
      if (condition == true && isDraw == true) {
        // Ensure the getUserLocation method returns a valid location
        try {
          var userLocation = await mpController.getUserLocation();
          if (userLocation != null) {
            await controller.drawRoad(
              GeoPoint(
                  latitude: userLocation.latitude,
                  longitude: userLocation.longitude),
              GeoPoint(latitude: lat!, longitude: long!),
              roadType: RoadType.bike,
              roadOption: RoadOption(
                roadWidth: 10,
                roadColor: Color.fromRGBO(48, 122, 89, 1),
              ),
            );
          }
          // mpController.roadInfo!.value;
        } finally {
          mpController.isLoading.value = false;
        }
      }
    },
    osmOption: OSMOption(
      isPicker: isPicker ?? false,
      staticPoints: (point != null) ? point : [],
      showDefaultInfoWindow: true,
      showZoomController: false,
      userTrackingOption: UserTrackingOption(
        enableTracking: isTrack!,
        unFollowUser: false,
      ),
      zoomOption: const ZoomOption(
        initZoom: 15,
        minZoomLevel: 3,
        maxZoomLevel: 19,
        stepZoom: 1.0,
      ),
      userLocationMarker: UserLocationMaker(
        personMarker: MarkerIcon(
          iconWidget: IconMaker(
            title: "Aku",
            link: "$url_profile",
          ),
        ),
        directionArrowMarker: MarkerIcon(
          iconWidget: IconMaker(
            title: "Aku",
            link: "$url_profile",
          ),
        ),
      ),
    ),
    controller: controller,
  );
}
