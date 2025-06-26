part of 'carpool_screen_bloc.dart';

sealed class CarpoolScreenEvent {}

class LoadCarpoolData extends CarpoolScreenEvent {}

class RefreshCarpoolData extends CarpoolScreenEvent {}

class FetchUpcomingTrips extends CarpoolScreenEvent {
  final String userId;

  FetchUpcomingTrips({required this.userId});
}

class UpcomingTripsReceived extends CarpoolScreenEvent {
  final dynamic data;
  UpcomingTripsReceived({required this.data});
}

class DeleteUpcomingTrip extends CarpoolScreenEvent {
  final String tripId;
  final String userId;
  DeleteUpcomingTrip({required this.tripId, required this.userId});
}

class LeaveUpcomingTrip extends CarpoolScreenEvent {
  final String tripId;
  final String userId;
  LeaveUpcomingTrip({required this.tripId, required this.userId});
}
