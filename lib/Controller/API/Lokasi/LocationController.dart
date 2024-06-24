import 'dart:developer';

import 'package:get/get.dart';
import 'package:wareg_app/Services/LocationService.dart';

class LocationController extends GetxController{

    Future<Map<String, dynamic>> updateLocation(String transId, double lat, double long) async{
      var result = await LocationService().updateLocation(transId, lat, long);
      
      if(result == 401 || result == 400 ){
        return {"message" : "failed to update location"}; 
      }else{
        log("update lokasi : $result");
        return result;
      }
    }

    Future<Map<String, dynamic>> getUpdateLocation(int transId) async{
      var result = await LocationService().getUpdateLocation(transId);
      
      if(result == 401 || result == 400 ){
        return {"message" : "failed to update location"}; 
      }else{
        log("get lokasi : $result");
        return result;
      }
    }

}