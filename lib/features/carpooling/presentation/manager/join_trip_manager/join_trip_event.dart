part of 'join_trip_bloc.dart';

abstract class JoinTripEvent {}

class JoinTripRequested extends JoinTripEvent {
  final String tripId;
  final String passengerId;
  final String username;
  final String passengerPickup;
  final String passengerDropoff;

  JoinTripRequested({
    required this.tripId,
    required this.passengerId,
    required this.username,
    required this.passengerPickup,
    required this.passengerDropoff,
  });
}
