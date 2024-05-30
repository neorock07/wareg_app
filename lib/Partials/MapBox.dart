import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Controller/MapsController.dart';
import 'package:wareg_app/Util/IconMaker.dart';

Widget MapBox(BuildContext context, var controller, var point, {
  bool? isDraw = false
}) {
  var mpController = Get.put(MapsController());
  return OSMFlutter(
      onMapIsReady: (condition)async{
      if(condition == true && isDraw == true){
        await mpController.getUserLocation().then((value) {
          mpController.drawRoad(
            start: GeoPoint(latitude: value!.latitude, longitude: value.longitude),
            end: GeoPoint(latitude: -7.056030, longitude: 110.434945),
            type: RoadType.bike
          );
        });
      }   
      },
      osmOption: OSMOption(
          staticPoints: point,
          showDefaultInfoWindow: true,
          showZoomController: false,
          userTrackingOption: const UserTrackingOption(
            enableTracking: true,
            unFollowUser: false,
          ),
          zoomOption: const ZoomOption(
            initZoom: 15,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
          userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                iconWidget: IconMaker(
                    link:
                        "https://asset.kompas.com/crops/H7XTk9ntv_CTYnqCryb67P2Zmkc=/66x15:694x433/750x500/data/photo/2018/10/23/8967977.png"),
              ),
              directionArrowMarker: const MarkerIcon(
                iconWidget: IconMaker(
                    link:
                        "https://asset.kompas.com/crops/H7XTk9ntv_CTYnqCryb67P2Zmkc=/66x15:694x433/750x500/data/photo/2018/10/23/8967977.png"),
              ),)),
      controller: controller);
}
