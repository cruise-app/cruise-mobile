import 'package:cruise/features/carpooling/data/models/trip_model.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:intl/intl.dart';

class CarpoolTripDetail extends StatefulWidget {
  const CarpoolTripDetail({super.key, required this.trip});
  final Trip trip;

  @override
  State<CarpoolTripDetail> createState() => _CarpoolTripDetailState();
}

class _CarpoolTripDetailState extends State<CarpoolTripDetail> {
  GoogleMapController? _mapController;
  List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _decodePolyline();
    _setMarkers();
  }

  void _decodePolyline() {
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      final result = polylinePoints.decodePolyline(widget.trip.polyline);
      if (result.isNotEmpty) {
        setState(() {
          _polylineCoordinates = result
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
          _polylines.add(
            Polyline(
              polylineId: PolylineId(widget.trip.id),
              points: _polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      } else {
        print('No polyline points decoded');
      }
    } catch (e) {
      print('Error decoding polyline: $e');
    }
  }

  void _setMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('start_${widget.trip.id}'),
          position: widget.trip.startLocationPoint,
          infoWindow: InfoWindow(title: widget.trip.startLocationName),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('end_${widget.trip.id}'),
          position: widget.trip.endLocationPoint,
          infoWindow: InfoWindow(title: widget.trip.endLocationName),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Fit the map to show the entire polyline and markers
    if (_polylineCoordinates.isNotEmpty) {
      LatLngBounds bounds = _calculateBounds();
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    } else {
      // If no polyline, center on start location
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(widget.trip.startLocationPoint, 12),
      );
    }
  }

  LatLngBounds _calculateBounds() {
    double minLat = _polylineCoordinates[0].latitude;
    double maxLat = _polylineCoordinates[0].latitude;
    double minLng = _polylineCoordinates[0].longitude;
    double maxLng = _polylineCoordinates[0].longitude;

    for (var point in _polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Include start and end points in bounds
    if (widget.trip.startLocationPoint.latitude < minLat) {
      minLat = widget.trip.startLocationPoint.latitude;
    }
    if (widget.trip.startLocationPoint.latitude > maxLat) {
      maxLat = widget.trip.startLocationPoint.latitude;
    }
    if (widget.trip.startLocationPoint.longitude < minLng) {
      minLng = widget.trip.startLocationPoint.longitude;
    }
    if (widget.trip.startLocationPoint.longitude > maxLng) {
      maxLng = widget.trip.startLocationPoint.longitude;
    }
    if (widget.trip.endLocationPoint.latitude < minLat) {
      minLat = widget.trip.endLocationPoint.latitude;
    }
    if (widget.trip.endLocationPoint.latitude > maxLat) {
      maxLat = widget.trip.endLocationPoint.latitude;
    }
    if (widget.trip.endLocationPoint.longitude < minLng) {
      minLng = widget.trip.endLocationPoint.longitude;
    }
    if (widget.trip.endLocationPoint.longitude > maxLng) {
      maxLng = widget.trip.endLocationPoint.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.black,
        iconTheme: const IconThemeData(color: MyColors.lightYellow),
        title: Text(
          'Trip Details',
          style: theme.textTheme.titleLarge?.copyWith(
            color: MyColors.lightYellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // GoogleMap
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.trip.startLocationPoint,
              zoom: 14,
            ),
            polylines: _polylines,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            padding: const EdgeInsets.only(
                bottom: 100), // Adjusted for draggable sheet
          ),
          // Draggable Trip Details Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.4, // Start at 40% of screen height
            minChildSize: 0.2, // Minimum 20% of screen height
            maxChildSize: 0.8, // Maximum 80% of screen height
            snap: true,
            snapSizes: const [0.2, 0.4, 0.8], // Snap to 20%, 40%, 80%
            builder: (context, scrollController) {
              return Card(
                elevation: 6,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [MyColors.black.withOpacity(0.9), MyColors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag Handle
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: MyColors.lightGrey,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trip Details',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: MyColors.lightYellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                icon: Icons.person,
                                label: 'Driver Username',
                                value: widget.trip.driverUsername,
                                theme: theme,
                              ),
                              _buildDetailRow(
                                icon: Icons.location_on,
                                label: 'Start',
                                value: widget.trip.startLocationName,
                                theme: theme,
                              ),
                              _buildDetailRow(
                                icon: Icons.location_on,
                                label: 'End',
                                value: widget.trip.endLocationName,
                                theme: theme,
                              ),
                              if (widget.trip.departureTime != null)
                                _buildDetailRow(
                                  icon: Icons.access_time,
                                  label: 'Departure',
                                  value: DateFormat('MMM d, h:mm a')
                                      .format(widget.trip.departureTime!),
                                  theme: theme,
                                ),
                              if (widget.trip.seatsAvailable != null)
                                _buildDetailRow(
                                  icon: Icons.event_seat,
                                  label: 'Seats Available',
                                  value: widget.trip.seatsAvailable.toString(),
                                  theme: theme,
                                ),
                              if (widget.trip.estimatedTripTime != null)
                                _buildDetailRow(
                                  icon: Icons.timer,
                                  label: 'Duration',
                                  value: widget.trip.estimatedTripTime!,
                                  theme: theme,
                                ),
                              if (widget.trip.listOfPassengers.isNotEmpty)
                                _buildDetailRow(
                                  icon: Icons.people,
                                  label: 'Passengers',
                                  value: widget.trip.listOfPassengers
                                      .map((p) => p.username)
                                      .join(', '),
                                  theme: theme,
                                ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  // Handle contact driver action
                                  // This could be a call, message, etc.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Joining ${widget.trip.driverUsername}'s Trip...",
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.lightYellow,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Join Trip',
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: MyColors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: MyColors.lightYellow, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: MyColors.lightGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: MyColors.lightYellow,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
