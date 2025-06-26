import 'package:bloc/bloc.dart';
import 'package:cruise/features/carpooling/data/services/chat_socekt.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatSocketService chatService = ChatSocketService();
  bool _isConnected = false;

  ChatBloc() : super(ChatInitial()) {
    on<JoinTripChat>(_onJoinTripChat);
    on<SendChatMessage>(_onSendMessage);
    on<UpdateTypingStatus>(_onUpdateTypingStatus);
    on<PreviousMessagesReceived>(_onPreviousMessagesReceived);
    on<NewMessageReceived>(_onNewMessageReceived);
    on<TypingStatusUpdated>(_onTypingStatusUpdated);

    // Set up socket connection listeners
    chatService.socket.on('connect', (_) {
      _isConnected = true;
      print('Socket connected');
    });

    chatService.socket.on('disconnect', (_) {
      _isConnected = false;
      print('Socket disconnected');
    });

    chatService.socket.on('error', (error) {
      print('Socket error: $error');
      emit(ChatError('Connection error: $error'));
    });

    chatService.socket.on('connect_error', (error) {
      print('Socket connect error: $error');
      emit(ChatError('Failed to connect: $error'));
    });
  }

  Future<void> _onJoinTripChat(
      JoinTripChat event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());

      // Ensure socket is connected
      if (!_isConnected) {
        chatService.connect();
        // Wait for connection
        await Future.delayed(const Duration(seconds: 1));
      }

      // Join trip room
      chatService.joinTrip(event.tripId, event.userId);

      // Set up message listeners
      chatService.socket.on('previousMessages', (data) {
        if (!isClosed) {
          add(PreviousMessagesReceived(
              messages: List<Map<String, dynamic>>.from(data)));
        }
      });

      chatService.socket.on('newMessage', (data) {
        if (!isClosed) {
          add(NewMessageReceived(message: Map<String, dynamic>.from(data)));
        }
      });

      chatService.socket.on('userTyping', (data) {
        if (!isClosed && data != null) {
          add(TypingStatusUpdated(
            userId: data['userId']?.toString() ?? '',
            isTyping: data['isTyping'] as bool? ?? false,
          ));
        }
      });

      // Initialize with empty state
      emit(ChatLoaded(messages: [], typingUsers: {}));
    } catch (e) {
      print('Error joining trip chat: $e');
      emit(ChatError('Failed to join chat: $e'));
    }
  }

  void _onSendMessage(SendChatMessage event, Emitter<ChatState> emit) {
    try {
      if (_isConnected) {
        chatService.sendMessage(event.tripId, event.userId, event.content);
      } else {
        emit(ChatError('Not connected to chat'));
      }
    } catch (e) {
      print('Error sending message: $e');
      emit(ChatError('Failed to send message: $e'));
    }
  }

  void _onUpdateTypingStatus(
      UpdateTypingStatus event, Emitter<ChatState> emit) {
    try {
      if (_isConnected) {
        chatService.socket.emit('typing', {
          'tripId': event.tripId,
          'userId': event.userId,
          'isTyping': event.isTyping,
        });
      }
    } catch (e) {
      print('Error updating typing status: $e');
    }
  }

  void _onPreviousMessagesReceived(
      PreviousMessagesReceived event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      emit(currentState.copyWith(
        messages: [...event.messages, ...currentState.messages],
      ));
    } else {
      emit(ChatLoaded(
        messages: event.messages,
        typingUsers: {},
      ));
    }
  }

  void _onNewMessageReceived(
      NewMessageReceived event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      emit(currentState.copyWith(
        messages: [...currentState.messages, event.message],
      ));
    }
  }

  void _onTypingStatusUpdated(
      TypingStatusUpdated event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final updatedTypingUsers =
          Map<String, bool>.from(currentState.typingUsers);

      if (event.isTyping) {
        updatedTypingUsers[event.userId] = true;
      } else {
        updatedTypingUsers.remove(event.userId);
      }

      emit(currentState.copyWith(typingUsers: updatedTypingUsers));
    }
  }

  @override
  Future<void> close() async {
    // Clean up socket listeners
    chatService.socket.off('previousMessages');
    chatService.socket.off('newMessage');
    chatService.socket.off('userTyping');
    chatService.disconnect();
    return super.close();
  }
}
