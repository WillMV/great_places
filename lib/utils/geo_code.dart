import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_config/flutter_config.dart';

class GeoCode {
  final String _googleApi = FlutterConfig.get('GOOGLE_MAPS_API_KEY');

  Future<String> getAddressByLatLng(LatLng position) async {
    final dio = Dio();
    final Response response = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$_googleApi');

    return response.data["results"][0]["formatted_address"];
  }
}
