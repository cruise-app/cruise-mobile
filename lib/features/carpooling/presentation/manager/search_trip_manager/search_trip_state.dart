part of 'search_trip_bloc.dart';

// STATES

sealed class SearchTripState {}

final class SearchTripInitialState extends SearchTripState {}

final class SearchTripLoadingState extends SearchTripState {}

final class LocationSearchingState extends SearchTripState {
  final List<String> suggestions;
  LocationSearchingState(this.suggestions);
}

final class SearchTripFailure extends SearchTripState {
  final String message;
  SearchTripFailure(
      {this.message = "An error occurred while searching for trips."});
}

final class GetTripsSuccess extends SearchTripState {
  final List<Trip> trips;

  GetTripsSuccess({
    required this.trips,
  });
}
