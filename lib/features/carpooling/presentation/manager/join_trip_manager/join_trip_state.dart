part of 'join_trip_bloc.dart';

abstract class JoinTripState {}

class JoinTripInitial extends JoinTripState {}

class JoinTripLoading extends JoinTripState {}

class JoinTripSuccess extends JoinTripState {
  final Map<String, dynamic> data;

  JoinTripSuccess({required this.data});
}

class JoinTripFailure extends JoinTripState {
  final String message;

  JoinTripFailure({required this.message});
}
