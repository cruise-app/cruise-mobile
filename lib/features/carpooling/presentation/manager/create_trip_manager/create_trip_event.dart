part of 'create_trip_bloc.dart';

// EVENTS

sealed class CreateTripEvent {}

final class CreateTripSubmitted extends CreateTripEvent {
  final String driverID;
  final String driverUsername;
  final String departureTime;
  final String startLocationName;
  final String endLocationName;
  final String vehicleType;

  CreateTripSubmitted({
    required this.driverID,
    required this.driverUsername,
    required this.departureTime,
    required this.startLocationName,
    required this.endLocationName,
    required this.vehicleType,
  });
}

final class FetchPolylineForReview extends CreateTripEvent {
  final String startLocationName;
  final String endLocationName;
  FetchPolylineForReview(
      {required this.startLocationName, required this.endLocationName});
}

final class SearchingLocation extends CreateTripEvent {
  final String location;
  SearchingLocation({required this.location});
}
