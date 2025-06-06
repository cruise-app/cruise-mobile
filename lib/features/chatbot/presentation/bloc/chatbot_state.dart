import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/car.dart';
import '../../domain/entities/trip.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {
  const ChatbotInitial();
}

class ChatbotLoading extends ChatbotState {
  const ChatbotLoading();
}

class MessageSending extends ChatbotState {
  const MessageSending();
}

class MessageSent extends ChatbotState {
  final Message message;
  final List<Message> allMessages;

  const MessageSent({required this.message, required this.allMessages});

  @override
  List<Object?> get props => [message, allMessages];
}

class RecommendationsLoading extends ChatbotState {
  const RecommendationsLoading();
}

class RecommendationsLoaded extends ChatbotState {
  final List<Map<String, dynamic>> recommendations;

  const RecommendationsLoaded({required this.recommendations});

  @override
  List<Object?> get props => [recommendations];
}

class CarpoolOpportunitiesLoading extends ChatbotState {
  const CarpoolOpportunitiesLoading();
}

class CarpoolOpportunitiesLoaded extends ChatbotState {
  final List<Map<String, dynamic>> opportunities;

  const CarpoolOpportunitiesLoaded({required this.opportunities});

  @override
  List<Object?> get props => [opportunities];
}

class SafetyCheckLoading extends ChatbotState {
  const SafetyCheckLoading();
}

class SafetyCheckLoaded extends ChatbotState {
  final Map<String, dynamic> safetyCheck;

  const SafetyCheckLoaded({required this.safetyCheck});

  @override
  List<Object?> get props => [safetyCheck];
}

class BookingRide extends ChatbotState {
  const BookingRide();
}

class RideBooked extends ChatbotState {
  final Trip trip;

  const RideBooked({required this.trip});

  @override
  List<Object?> get props => [trip];
}

class CancellingRide extends ChatbotState {
  const CancellingRide();
}

class RideCancelled extends ChatbotState {
  final Map<String, dynamic> result;

  const RideCancelled({required this.result});

  @override
  List<Object?> get props => [result];
}

class CarsLoading extends ChatbotState {
  const CarsLoading();
}

class CarsLoaded extends ChatbotState {
  final List<Car> cars;

  const CarsLoaded({required this.cars});

  @override
  List<Object?> get props => [cars];
}

class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError({required this.message});

  @override
  List<Object?> get props => [message];
}
