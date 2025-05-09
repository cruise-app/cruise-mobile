import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsWidget extends StatelessWidget {
  const GoogleMapsWidget(
      {super.key,
      required this.myCurrentLocation,
      required this.markers,
      required this.onMapCreated,
      required this.polyline});

  final LatLng myCurrentLocation;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;
  final Set<Polyline> polyline; // Store the polyline here

  // 👈 This keeps the map alive
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: myCurrentLocation,
        zoom: 14,
      ),
      onMapCreated: onMapCreated,
      polylines: polyline, // Pass the polyline to the map
      markers: markers,
    );
  }
}
