import 'package:cruise/features/carpooling/data/models/trip_model.dart';
import 'package:cruise/features/carpooling/presentation/manager/join_trip_manager/join_trip_bloc.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

class CarpoolTripDetail extends StatefulWidget {
  const CarpoolTripDetail(
      {super.key, required this.trip, this.joinedTrip = false});
  final Trip trip;
  final bool joinedTrip;

  @override
  State<CarpoolTripDetail> createState() => _CarpoolTripDetailState();
}

class _CarpoolTripDetailState extends State<CarpoolTripDetail> {
  late JoinTripBloc _joinTripBloc;
  late var box;
  late dynamic user;
  GoogleMapController? _mapController;
  List<LatLng> _polylineCoordinates = [];
  List<LatLng> _pickupPolylineCoordinates = [];
  List<LatLng> _dropoffPolylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _joinTripBloc = JoinTripBloc();
    box = Hive.box('userBox');
    user = box.get('userModel');
    _decodePolyline();
    _decodePickupAndDropoffPolylines();
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

  void _decodePickupAndDropoffPolylines() {
    try {
      PolylinePoints polylinePoints = PolylinePoints();

      // Decode pickup polyline if available
      if (widget.trip.pickupPolyline != null &&
          widget.trip.pickupPolyline!.isNotEmpty) {
        final pickupResult =
            polylinePoints.decodePolyline(widget.trip.pickupPolyline!);
        if (pickupResult.isNotEmpty) {
          setState(() {
            _pickupPolylineCoordinates = pickupResult
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
            _polylines.add(
              Polyline(
                polylineId: PolylineId('pickup_${widget.trip.id}'),
                points: _pickupPolylineCoordinates,
                color: Colors.green,
                width: 5,
                patterns: [PatternItem.dash(20), PatternItem.gap(10)],
              ),
            );
          });
        }
      }

      // Decode dropoff polyline if available
      if (widget.trip.dropoffPolyline != null &&
          widget.trip.dropoffPolyline!.isNotEmpty) {
        final dropoffResult =
            polylinePoints.decodePolyline(widget.trip.dropoffPolyline!);
        if (dropoffResult.isNotEmpty) {
          setState(() {
            _dropoffPolylineCoordinates = dropoffResult
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
            _polylines.add(
              Polyline(
                polylineId: PolylineId('dropoff_${widget.trip.id}'),
                points: _dropoffPolylineCoordinates,
                color: Colors.orange,
                width: 5,
                patterns: [PatternItem.dash(20), PatternItem.gap(10)],
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Error decoding pickup/dropoff polylines: $e');
    }
  }

  void _setMarkers() {
    setState(() {
      // Main route markers
      _markers.add(
        Marker(
          markerId: MarkerId('start_${widget.trip.id}'),
          position: widget.trip.startLocationPoint,
          infoWindow:
              InfoWindow(title: 'Trip Start: ${widget.trip.startLocationName}'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('end_${widget.trip.id}'),
          position: widget.trip.endLocationPoint,
          infoWindow:
              InfoWindow(title: 'Trip End: ${widget.trip.endLocationName}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      // Add pickup point marker if available
      if (widget.trip.closestPickupPoint != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('pickup_${widget.trip.id}'),
            position: widget.trip.closestPickupPoint!,
            infoWindow: const InfoWindow(title: 'Your Pickup Point'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow),
          ),
        );
      }

      // Add dropoff point marker if available
      if (widget.trip.closestDropoffPoint != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('dropoff_${widget.trip.id}'),
            position: widget.trip.closestDropoffPoint!,
            infoWindow: const InfoWindow(title: 'Your Dropoff Point'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
          ),
        );
      }
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
    List<LatLng> allPoints = [
      ..._polylineCoordinates,
      ..._pickupPolylineCoordinates,
      ..._dropoffPolylineCoordinates,
      widget.trip.startLocationPoint,
      widget.trip.endLocationPoint,
    ];

    if (widget.trip.closestPickupPoint != null) {
      allPoints.add(widget.trip.closestPickupPoint!);
    }
    if (widget.trip.closestDropoffPoint != null) {
      allPoints.add(widget.trip.closestDropoffPoint!);
    }

    if (allPoints.isEmpty) {
      // Fallback to start location if no points available
      return LatLngBounds(
        southwest: widget.trip.startLocationPoint,
        northeast: widget.trip.startLocationPoint,
      );
    }

    double minLat = allPoints[0].latitude;
    double maxLat = allPoints[0].latitude;
    double minLng = allPoints[0].longitude;
    double maxLng = allPoints[0].longitude;

    for (var point in allPoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _joinTripBloc.close();
    super.dispose();
  }

  Widget _buildJoinButton(BuildContext context, ThemeData theme) {
    return BlocConsumer<JoinTripBloc, JoinTripState>(
      bloc: _joinTripBloc,
      listener: (context, state) {
        if (state is JoinTripSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Successfully joined ${widget.trip.driverUsername}\'s trip!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is JoinTripFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is JoinTripLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: MyColors.lightYellow,
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            print('Joining trip: ${widget.trip.id}');
            print('User ID: ${user.id}');
            print('User Name: ${user.userName}');
            print('Trip ID: ${widget.trip.id}');
            print('Trip Start Location: ${widget.trip.startLocationName}');
            print('Trip End Location: ${widget.trip.endLocationName}');
            _joinTripBloc.add(
              JoinTripRequested(
                tripId: widget.trip.id,
                passengerId: user!.id,
                username: user!.userName,
                passengerPickup: widget.trip.startLocationName,
                passengerDropoff: widget.trip.endLocationName,
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
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: MyColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
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
                              !widget.joinedTrip
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: _buildJoinButton(context, theme),
                                    )
                                  : const SizedBox.shrink(),
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
