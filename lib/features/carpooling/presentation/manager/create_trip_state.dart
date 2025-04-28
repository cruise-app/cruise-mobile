part of 'create_trip_bloc.dart';

// STATES

sealed class CreateTripState {}

final class CreateTripInitialState extends CreateTripState {}

final class CreateTripSuccessState extends CreateTripState {}

final class LocationSearchingState extends CreateTripState {
  final List<String> suggestions;
  LocationSearchingState(this.suggestions);
}
