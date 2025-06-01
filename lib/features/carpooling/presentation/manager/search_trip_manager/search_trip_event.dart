part of 'search_trip_bloc.dart';

// EVENTS

sealed class SearchTripEvent {}

final class SearchingLocation extends SearchTripEvent {
  final String location;
  SearchingLocation({required this.location});
}

final class ClearSuggestions extends SearchTripEvent {}

final class GetTrips extends SearchTripEvent {
  final String startLocation;
  final String endLocation;
  final DateTime? dateTime;
  final int? maxDistance;

  GetTrips({
    required this.startLocation,
    required this.endLocation,
    required this.dateTime,
    this.maxDistance,
  });
}
