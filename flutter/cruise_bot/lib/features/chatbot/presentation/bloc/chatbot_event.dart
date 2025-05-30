import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatbotEvent {
  final String message;
  final String userId;
  final String language;

  const SendMessageEvent({
    required this.message,
    required this.userId,
    this.language = 'en',
  });

  @override
  List<Object?> get props => [message, userId, language];
}

class GetRecommendationsEvent extends ChatbotEvent {
  final String userId;

  const GetRecommendationsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetCarpoolOpportunitiesEvent extends ChatbotEvent {
  final String userId;

  const GetCarpoolOpportunitiesEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class PerformSafetyCheckEvent extends ChatbotEvent {
  final String userId;

  const PerformSafetyCheckEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BookRideEvent extends ChatbotEvent {
  final String userId;
  final Map<String, dynamic> rideDetails;

  const BookRideEvent({
    required this.userId,
    required this.rideDetails,
  });

  @override
  List<Object?> get props => [userId, rideDetails];
}

class CancelRideEvent extends ChatbotEvent {
  final String userId;
  final String rideId;

  const CancelRideEvent({
    required this.userId,
    required this.rideId,
  });

  @override
  List<Object?> get props => [userId, rideId];
}

class GetAvailableCarsEvent extends ChatbotEvent {
  final String pickupLocation;
  final String dropoffLocation;

  const GetAvailableCarsEvent({
    required this.pickupLocation,
    required this.dropoffLocation,
  });

  @override
  List<Object?> get props => [pickupLocation, dropoffLocation];
}

class InitChatbotEvent extends ChatbotEvent {
  const InitChatbotEvent();
}
