part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Map<String, dynamic>> messages;
  final Map<String, bool> typingUsers;

  ChatLoaded({
    required this.messages,
    required this.typingUsers,
  });

  ChatLoaded copyWith({
    List<Map<String, dynamic>>? messages,
    Map<String, bool>? typingUsers,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      typingUsers: typingUsers ?? this.typingUsers,
    );
  }
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}
