import '../../domain/entities/trip.dart';
import 'car_model.dart';

class TripModel extends Trip {
  const TripModel({
    required String id,
    required String userId,
    required String pickupLocation,
    required String dropoffLocation,
    required DateTime pickupTime,
    required double estimatedDuration,
    required double distance,
    required TripStatus status,
    CarModel? car,
    String? driverId,
    String? driverName,
    double? fare,
  }) : super(
          id: id,
          userId: userId,
          pickupLocation: pickupLocation,
          dropoffLocation: dropoffLocation,
          pickupTime: pickupTime,
          estimatedDuration: estimatedDuration,
          distance: distance,
          status: status,
          car: car,
          driverId: driverId,
          driverName: driverName,
          fare: fare,
        );

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      userId: json['userId'],
      pickupLocation: json['pickupLocation'],
      dropoffLocation: json['dropoffLocation'],
      pickupTime: DateTime.parse(json['pickupTime']),
      estimatedDuration: json['estimatedDuration'].toDouble(),
      distance: json['distance'].toDouble(),
      status: _mapTripStatus(json['status']),
      car: json['car'] != null ? CarModel.fromJson(json['car']) : null,
      driverId: json['driverId'],
      driverName: json['driverName'],
      fare: json['fare']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'pickupTime': pickupTime.toIso8601String(),
      'estimatedDuration': estimatedDuration,
      'distance': distance,
      'status': status.toString().split('.').last,
      'car': car != null ? (car as CarModel).toJson() : null,
      'driverId': driverId,
      'driverName': driverName,
      'fare': fare,
    };
  }

  static TripStatus _mapTripStatus(String? status) {
    switch (status) {
      case 'scheduled':
        return TripStatus.scheduled;
      case 'inProgress':
        return TripStatus.inProgress;
      case 'completed':
        return TripStatus.completed;
      case 'cancelled':
        return TripStatus.cancelled;
      default:
        return TripStatus.scheduled;
    }
  }
}
