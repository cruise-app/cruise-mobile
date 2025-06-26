part of 'chat_bloc.dart';

abstract class ChatEvent {}

class JoinTripChat extends ChatEvent {
  final String tripId;
  final String userId;

  JoinTripChat({required this.tripId, required this.userId});
}

class SendChatMessage extends ChatEvent {
  final String tripId;
  final String userId;
  final String content;

  SendChatMessage({
    required this.tripId,
    required this.userId,
    required this.content,
  });
}

class UpdateTypingStatus extends ChatEvent {
  final String tripId;
  final String userId;
  final bool isTyping;

  UpdateTypingStatus({
    required this.tripId,
    required this.userId,
    required this.isTyping,
  });
}

class PreviousMessagesReceived extends ChatEvent {
  final List<Map<String, dynamic>> messages;

  PreviousMessagesReceived({required this.messages});
}

class NewMessageReceived extends ChatEvent {
  final Map<String, dynamic> message;

  NewMessageReceived({required this.message});
}

class TypingStatusUpdated extends ChatEvent {
  final String userId;
  final bool isTyping;

  TypingStatusUpdated({required this.userId, required this.isTyping});
}
