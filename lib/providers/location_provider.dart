import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/utils/geo_code.dart';
import 'package:great_places/utils/location_input.dart';
import 'package:flutter_config/flutter_config.dart';

class LocationProvider with ChangeNotifier {
  final LocationInput location = LocationInput();

  final String _googleApi = FlutterConfig.get('GOOGLE_MAPS_API_KEY');

  String staticMapUrl = '';
  LatLng? position;

  Future<void> setMapCurrentLocation() async {
    position = await location.getCurrentUserLocation();
    staticMapUrl = setMapApiUrl(position!);
    notifyListeners();
  }

  void setMapSelectedLocation(LatLng local) {
    position = local;
    staticMapUrl = setMapApiUrl(local);
    notifyListeners();
  }

  String setMapApiUrl(LatLng local) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=${local.latitude},${local.longitude}&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${local.latitude},${local.longitude}&key=$_googleApi";
  }

  Future<String?> getAddressByLocation() async {
    if (position != null) {
      return await GeoCode().getAddressByLatLng(position!);
    }
    return null;
  }
}
