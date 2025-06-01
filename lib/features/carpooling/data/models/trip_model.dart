import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {
  final String id;
  final String driverId;
  final String vehicleType;
  final List<Passenger>
      listOfPassengers; // or another structure if you know what the passenger object looks like
  final String startLocationName;
  final String endLocationName;
  final DateTime departureTime;
  final String estimatedTripTime;
  final String estimatedTripDistance;
  final int seatsAvailable;
  final String polyline;
  final LatLng startLocationPoint;
  final LatLng endLocationPoint;

  Trip({
    required this.id,
    required this.driverId,
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
  });

  // fromJson method to map the data
  factory Trip.fromJson(Map<String, dynamic> json) {
    print(json);
    return Trip(
      id: json['_id'],
      driverId: json['driverId'],
      vehicleType: json['vehicleType'],
      listOfPassengers: (json['listOfPassengers'] as List)
          .map((x) => Passenger.fromJson(x))
          .toList(),
      startLocationName: json['startLocationName'],
      endLocationName: json['endLocationName'],
      departureTime: DateTime.parse(json['departureTime']),
      estimatedTripTime: json['estimatedTripTime'],
      estimatedTripDistance: json['estimatedTripDistance'],
      seatsAvailable: json['seatsAvailable'],
      polyline: json['polyline'],
      startLocationPoint: LatLng(
        json['startLocationPoint']['coordinates'][1],
        json['startLocationPoint']['coordinates'][0],
      ),
      endLocationPoint: LatLng(
        json['endLocationPoint']['coordinates'][1],
        json['endLocationPoint']['coordinates'][0],
      ),
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
      id: json['_id'],
      username: json['username'],
      status: json['status'],
      pickUpLocationName: json['pickupLocationName'], // fixed key
      pickUpLocationPoint: LatLng(
        json['pickupPoint']['coordinates'][1], // fixed key
        json['pickupPoint']['coordinates'][0],
      ),
      dropOffLocationName: json['dropoffLocationName'], // fixed key
      dropOffLocationPoint: LatLng(
        json['dropoffPoint']['coordinates'][1], // fixed key
        json['dropoffPoint']['coordinates'][0],
      ),
    );
  }
}
