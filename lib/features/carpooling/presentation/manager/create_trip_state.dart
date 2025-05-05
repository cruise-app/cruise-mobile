part of 'create_trip_bloc.dart';

// STATES

sealed class CreateTripState {}

final class CreateTripInitialState extends CreateTripState {}

final class CreateTripSuccessState extends CreateTripState {
  final String message;
  CreateTripSuccessState({this.message = "Trip created successfully"});
}

final class CreateTripErrorState extends CreateTripState {
  final String errorMessage;
  CreateTripErrorState(this.errorMessage);
}

final class LocationSearchingState extends CreateTripState {
  final List<String> suggestions;
  LocationSearchingState(this.suggestions);
}
