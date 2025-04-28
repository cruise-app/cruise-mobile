import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsWidget extends StatefulWidget {
  const GoogleMapsWidget({
    super.key,
    required this.myCurrentLocation,
    required this.markers,
    required this.onMapCreated,
  });

  final LatLng myCurrentLocation;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 👈 This keeps the map alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // 👈 Important when using KeepAlive

    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: widget.myCurrentLocation,
        zoom: 14,
      ),
      onMapCreated: (controller) {
        widget.onMapCreated(controller);
      },
      markers: widget.markers,
    );
  }
}
