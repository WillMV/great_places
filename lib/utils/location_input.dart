import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput {
  Future<LatLng> getCurrentUserLocation() async {
    final locData = await Location().getLocation();

    return LatLng(locData.latitude!, locData.longitude!);
  }
}
