import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {
  final String id;
  final String driverId;
  final String driverUsername;
  final String vehicleType;
  final List<Passenger> listOfPassengers;
  final String startLocationName;
  final String endLocationName;
  final DateTime departureTime;
  final String estimatedTripTime;
  final String estimatedTripDistance;
  final int seatsAvailable;
  final String polyline;
  final LatLng startLocationPoint;
  final LatLng endLocationPoint;
  final LatLng? closestPickupPoint; // Added
  final LatLng? closestDropoffPoint; // Added
  final String? pickupPolyline; // Added
  final String? dropoffPolyline; // Added

  Trip({
    required this.id,
    required this.driverId,
    required this.driverUsername,
    required this.vehicleType,
    required this.listOfPassengers,
    required this.startLocationName,
    required this.endLocationName,
    required this.departureTime,
    required this.estimatedTripTime,
    required this.estimatedTripDistance,
    required this.seatsAvailable,
    required this.polyline,
    required this.startLocationPoint,
    required this.endLocationPoint,
    required this.closestPickupPoint,
    required this.closestDropoffPoint,
    required this.pickupPolyline,
    required this.dropoffPolyline, // Added for dropoff route
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    print('Parsing trip JSON: $json');
    return Trip(
      id: json['_id'] ?? '',
      driverId: json['driverId'] ?? '',
      driverUsername: json['driverUsername'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      listOfPassengers: (json['listOfPassengers'] as List? ?? [])
          .map((x) => Passenger.fromJson(x))
          .toList(),
      startLocationName: json['startLocationName'] ?? '',
      endLocationName: json['endLocationName'] ?? '',
      departureTime: json['departureTime'] != null
          ? DateTime.parse(json['departureTime'])
          : DateTime.now(), // Default to now if null
      estimatedTripTime: json['estimatedTripTime'] ?? '',
      estimatedTripDistance: json['estimatedTripDistance'] ?? '',
      seatsAvailable: json['seatsAvailable'] ?? 0,
      polyline: json['polyline'] ?? '',
      startLocationPoint: LatLng(
        (json['startLocationPoint']?['coordinates']?[1] as num?)?.toDouble() ??
            0.0,
        (json['startLocationPoint']?['coordinates']?[0] as num?)?.toDouble() ??
            0.0,
      ),
      endLocationPoint: LatLng(
        (json['endLocationPoint']?['coordinates']?[1] as num?)?.toDouble() ??
            0.0,
        (json['endLocationPoint']?['coordinates']?[0] as num?)?.toDouble() ??
            0.0,
      ),
      closestPickupPoint: json['closestPickupPoint'] != null
          ? LatLng(
              json['closestPickupPoint']['latitude'] as double,
              json['closestPickupPoint']['longitude'] as double,
            )
          : null,
      closestDropoffPoint: json['closestDropoffPoint'] != null
          ? LatLng(
              json['closestDropoffPoint']['latitude'] as double,
              json['closestDropoffPoint']['longitude'] as double,
            )
          : null,
      pickupPolyline: json['pickupPolyline'],
      dropoffPolyline: json['dropoffPolyline'], // Added for dropoff route
    );
  }
}

class Passenger {
  final String id;
  final String username;
  final String status;
  final String pickUpLocationName;
  final LatLng pickUpLocationPoint;
  final String dropOffLocationName;
  final LatLng dropOffLocationPoint;

  Passenger({
    required this.id,
    required this.username,
    required this.status,
    required this.pickUpLocationName,
    required this.pickUpLocationPoint,
    required this.dropOffLocationName,
    required this.dropOffLocationPoint,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      status: json['status'] ?? '',
      pickUpLocationName: json['pickupLocationName'] ?? '',
      pickUpLocationPoint: LatLng(
        (json['pickupPoint']?['coordinates']?[1] as num?)?.toDouble() ?? 0.0,
        (json['pickupPoint']?['coordinates']?[0] as num?)?.toDouble() ?? 0.0,
      ),
      dropOffLocationName: json['dropoffLocationName'] ?? '',
      dropOffLocationPoint: LatLng(
        (json['dropoffPoint']?['coordinates']?[1] as num?)?.toDouble() ?? 0.0,
        (json['dropoffPoint']?['coordinates']?[0] as num?)?.toDouble() ?? 0.0,
      ),
    );
  }
}
