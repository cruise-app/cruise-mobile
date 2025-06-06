import 'package:equatable/equatable.dart';
import 'car.dart';

enum TripStatus {
  scheduled,
  inProgress,
  completed,
  cancelled
}

class Trip extends Equatable {
  final String id;
  final String userId;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime pickupTime;
  final double estimatedDuration;
  final double distance;
  final TripStatus status;
  final Car? car;
  final String? driverId;
  final String? driverName;
  final double? fare;
  
  const Trip({
    required this.id,
    required this.userId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupTime,
    required this.estimatedDuration,
    required this.distance,
    required this.status,
    this.car,
    this.driverId,
    this.driverName,
    this.fare,
  });
  
  @override
  List<Object?> get props => [
    id, 
    userId, 
    pickupLocation, 
    dropoffLocation, 
    pickupTime,
    estimatedDuration,
    distance,
    status,
    car,
    driverId,
    driverName,
    fare
  ];
}
