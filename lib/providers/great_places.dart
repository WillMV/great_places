import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/utils/db_utils.dart';

class GreatPlaces with ChangeNotifier {
  final String _tablePlaces = 'Places';

  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> getItemsByDb() async {
    _items.clear();

    final data = await DbUtil.getData(_tablePlaces);

    _items = data
        .map(
          (e) => Place(
            id: e['id'],
            title: e['title'],
            location: PlaceLocation(
              latitude: e['lat'],
              longitude: e['lng'],
              address: e['address'],
            ),
            image: File(
              e['image'],
            ),
          ),
        )
        .toList();

    notifyListeners();
  }

  void addItem(Map<String, dynamic> data) {
    try {
      final place = Place(
        id: _items.length,
        title: data['title'],
        location: PlaceLocation(
          latitude: data['latitude'],
          longitude: data['longitude'],
          address: data['address'],
        ),
        image: data['image'],
      );

      _items.add(place);

      DbUtil.insert(_tablePlaces, {
        'id': place.id,
        'title': place.title,
        'image': place.image.path,
        'lat': place.location.latitude,
        'lng': place.location.longitude,
        'address': place.location.address,
      });

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Place getByIndex(int index) {
    return _items[index];
  }
}
