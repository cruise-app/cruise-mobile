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

final class PolylineForReviewState extends CreateTripState {
  final List<LatLng> polyline;
  final LatLng startLocation;
  final LatLng endLocation;
  PolylineForReviewState(
      {required this.polyline,
      required this.startLocation,
      required this.endLocation});
}

final class PolylineSuccessState extends CreateTripState {
  final String message;
  PolylineSuccessState({this.message = "Polyline created successfully"});
}

final class PolylineErrorState extends CreateTripState {
  final String errorMessage;
  PolylineErrorState(this.errorMessage);
}
