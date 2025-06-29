import 'dart:async';
import 'package:cruise/features/carpooling/data/models/trip_model.dart';
import 'package:cruise/features/carpooling/data/services/carpooling_sockets.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

class TripSessionScreen extends StatefulWidget {
  final Trip trip;
  final String currentUserId;
  final String currentUserRole; // 'driver' or 'user'
  const TripSessionScreen({
    Key? key,
    required this.trip,
    required this.currentUserId,
    required this.currentUserRole,
  }) : super(key: key);

  @override
  State<TripSessionScreen> createState() => _TripSessionScreenState();
}

class _TripSessionScreenState extends State<TripSessionScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  final SocketService _socketService = SocketService();
  Map<String, Marker> _userMarkers = {};
  StreamSubscription<Position>? _positionStream; // Store stream subscription

  @override
  void initState() {
    print("Track Trips");
    super.initState();
    _checkPermissions();
    _initLocation();
    _decodeAndSetTripPolylineAndMarkers();
    _setupSocketLiveLocation();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return;
      }
    }
  }

  Future<void> _initLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return; // Check if widget is mounted
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentLocation!,
            infoWindow: const InfoWindow(title: 'My Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          ),
        );
      });

      // Listen to position updates
      _positionStream = Geolocator.getPositionStream().listen((Position pos) {
        if (!mounted) return; // Check if widget is mounted
        setState(() {
          _currentLocation = LatLng(pos.latitude, pos.longitude);
          _markers.removeWhere((m) => m.markerId.value == 'currentLocation');
          _markers.add(
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: _currentLocation!,
              infoWindow: const InfoWindow(title: 'My Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
            ),
          );
        });
      }, onError: (e) {
        print('Geolocator stream error: $e');
      });
    } catch (e) {
      print('Error getting initial location: $e');
    }
  }

  void _decodeAndSetTripPolylineAndMarkers() {
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      final result = polylinePoints.decodePolyline(widget.trip.polyline);
      if (result.isNotEmpty) {
        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('trip_route'),
              points:
                  result.map((p) => LatLng(p.latitude, p.longitude)).toList(),
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      }
    } catch (e) {
      print('Error decoding polyline: $e');
    }
    // Add start and end markers
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: widget.trip.startLocationPoint,
          infoWindow: const InfoWindow(title: 'Start'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: widget.trip.endLocationPoint,
          infoWindow: const InfoWindow(title: 'End'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void _setupSocketLiveLocation() {
    final userId = widget.currentUserId;
    final role = widget.currentUserRole;
    final tripId = widget.trip.id;

    _socketService.connect();
    // Wait for socket connection before joining trip and starting location updates
    void startSession() {
      print('Socket connected, joining trip and starting location updates');
      _socketService.joinTrip(tripId, userId);
      _socketService.startSendingLocation(userId, tripId, role);
      _socketService.startAudioRecordingLoop(userId, tripId);
    }

    // If already connected, start immediately
    if (_socketService.socket.connected) {
      startSession();
    } else {
      // Otherwise, wait for connection
      _socketService.socket.onConnect((_) {
        startSession();
      });
    }
    _socketService.listenToUserLocations((data) {
      print('Received userLocation data: $data'); // Debug log
      if (data == null) return;
      final String userId = data['userId'];
      final double lat = (data['lat'] as num).toDouble();
      final double lng = (data['lng'] as num).toDouble();
      final String role = data['role'] ?? 'user';
      final markerId = MarkerId('user_$userId');
      final marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: role == 'driver' ? 'Driver' : 'User'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          role == 'driver'
              ? BitmapDescriptor.hueRed
              : BitmapDescriptor.hueAzure,
        ),
      );
      if (!mounted) return;
      setState(() {
        _userMarkers[userId] = marker;
        _markers.removeWhere((m) => m.markerId == markerId);
        _markers.add(marker);
      });
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel(); // Cancel Geolocator stream
    _socketService.stopSendingLocation();
    _socketService.stopAudioRecordingLoop(); // Stop audio recording loop
    //_socketService.disconnect();
    _mapController?.dispose(); // Dispose map controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.black,
        iconTheme: const IconThemeData(color: MyColors.lightYellow),
        title: const Text('Trip Session',
            style: TextStyle(color: MyColors.lightYellow)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          _currentLocation == null
              ? const Center(
                  child: CircularProgressIndicator(color: MyColors.lightYellow))
              : GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 14,
                  ),
                  polylines: _polylines,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.15,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: MyColors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      '${widget.trip.startLocationName} → ${widget.trip.endLocationName}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: MyColors.lightYellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Driver: ${widget.trip.driverUsername}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: MyColors.lightGrey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Departure: ${DateFormat('MMM d, h:mm a').format(widget.trip.departureTime)}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: MyColors.lightGrey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vehicle: ${widget.trip.vehicleType} · ${widget.trip.seatsAvailable} seats',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: MyColors.lightGrey),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Fee ${_calculateFee(widget.trip.estimatedTripDistance)}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: MyColors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _calculateFee(String distanceStr) {
    // Try to extract the numeric value from the distance string (e.g., '12.3 km')
    final numReg = RegExp(r'[\d.]+');
    final match = numReg.firstMatch(distanceStr);
    if (match != null) {
      final distance = double.tryParse(match.group(0) ?? '0') ?? 0;
      final fee = distance * 3.5 / widget.trip.listOfPassengers.length;
      return 'EGP' + fee.toStringAsFixed(2);
    }
    return '₦0.00';
  }
}
