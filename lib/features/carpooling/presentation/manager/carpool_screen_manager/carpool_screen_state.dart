// States

part of 'carpool_screen_bloc.dart';

sealed class CarpoolScreenState {}

class CarpoolScreenInitial extends CarpoolScreenState {}

class CarpoolScreenLoading extends CarpoolScreenState {}

class CarpoolScreenLoaded extends CarpoolScreenState {
  final List<String> carpools; // Replace with your actual data model

  CarpoolScreenLoaded(this.carpools);
}

class CarpoolScreenError extends CarpoolScreenState {
  final String message;

  CarpoolScreenError({required this.message});
}

class UpcomingTripsLoaded extends CarpoolScreenState {
  final List<Trip> upcomingTrips; // Replace with your actual data model

  UpcomingTripsLoaded(this.upcomingTrips);
}

class UpcomingTripsLoading extends CarpoolScreenState {}

class UpcomingTripsError extends CarpoolScreenState {
  final String message;

  UpcomingTripsError(this.message);
}
