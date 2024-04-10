import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/pages/map_page.dart';

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final place = ModalRoute.of(context)!.settings.arguments as Place;
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Image.file(
            place.image,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            place.location.address,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.grey),
          ),
          TextButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MapPage(
                        isReadOnly: true,
                        initialLocation: LatLng(
                          place.location.latitude,
                          place.location.longitude,
                        )),
                  )),
              icon: const Icon(Icons.map),
              label: const Text('Ver no mapa'))
        ]),
      ),
    );
  }
}
