import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final LatLng initialLocation;
  final bool isReadOnly;

  const MapPage({
    super.key,
    this.initialLocation = const LatLng(37.422, -122.084),
    this.isReadOnly = false,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _pickedPosition;

  void _selectPosition(LatLng local) {
    setState(() {
      _pickedPosition = local;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: widget.isReadOnly
            ? []
            : [
                IconButton(
                    onPressed: _pickedPosition == null
                        ? null
                        : () {
                            Navigator.of(context).pop(_pickedPosition);
                          },
                    icon: const Icon(Icons.check))
              ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          zoom: 13,
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (argument) =>
            widget.isReadOnly ? null : _selectPosition(argument),
        mapToolbarEnabled: true,
        markers: (_pickedPosition == null && !widget.isReadOnly)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('p1'),
                  position: _pickedPosition ?? widget.initialLocation,
                )
              },
      ),
    );
  }
}
