part of 'create_trip_bloc.dart';

// EVENTS

sealed class CreateTripEvent {}

final class CreateTripSubmitted extends CreateTripEvent {
  final String tripName;
  final String tripDate;
  final String tripTime;
  final String tripLocation;
  final String tripDestination;
  final int availableSeats;

  CreateTripSubmitted({
    required this.tripName,
    required this.tripDate,
    required this.tripTime,
    required this.tripLocation,
    required this.tripDestination,
    required this.availableSeats,
  });
}

final class SearchingLocation extends CreateTripEvent {
  final String location;
  SearchingLocation({required this.location});
}
