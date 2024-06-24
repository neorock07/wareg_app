import 'dart:convert';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Util/Ip.dart';
import 'package:http/http.dart' as http;

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<dynamic> updateLocation(String transId, double lat, double long) async {
    var ipAdd = Ip();

    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    Map<String, dynamic> payload = {
      "transactionId": transId,
      "lat": "$lat",
      "lon": "$long"
    };

    final response = await http.post(Uri.parse('$_baseUrl/location/update'),
        headers: headers, body: payload);
    var result;
    if (response.statusCode == 200 || response.statusCode == 201) {
      result = jsonDecode(response.body);
      return result;
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      result = jsonDecode(response.body);
      log("error update lokasi : $result");
      return response.statusCode;
    } else {
      log("response : ${response.statusCode}");
      throw Exception('Failed to update location to donatur');
    }
  }

  Future<dynamic> getUpdateLocation(int transId) async {
    var ipAdd = Ip();

    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse('$_baseUrl/location/recipient/$transId'),
        headers: headers);
    var result;
    if (response.statusCode == 200 || response.statusCode == 201) {
      result = jsonDecode(response.body);
      return result;
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      result = jsonDecode(response.body);
      log("error getting update lokasi : $result");
      return response.statusCode;
    } else {
      log("response : ${response.statusCode}");
      throw Exception('Failed to getting update location for donatur');
    }
  }
}
