import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  late IO.Socket socket;

  ChatSocketService() {
    socket = IO.io(
      'http://10.0.2.2:3000', // Replace with your server URL
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .build(),
    );

    // Set up connection event handlers
    socket.onConnect((_) {
      print('Connected to socket: ${socket.id}');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });
  }

  void connect() {
    print('Connecting to socket...');
    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void joinTrip(String tripId, String userId) {
    socket.emit('joinTrip', {
      'tripId': tripId,
      'userId': userId,
    });
  }

  void leaveTrip(String tripId) {
    socket.emit('leaveTrip', tripId);
  }

  void sendMessage(String tripId, String senderId, String content) {
    socket.emit('sendMessage', {
      'tripId': tripId,
      'senderId': senderId, // Changed from userId to senderId to match backend
      'content': content,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  void sendTypingStatus(String tripId, String userId, bool isTyping) {
    socket.emit('typing', {
      'tripId': tripId,
      'userId': userId,
      'isTyping': isTyping,
    });
  }

  // Event listeners
  void onPreviousMessages(Function(dynamic) callback) {
    socket.on('previousMessages', callback);
  }

  void onMessageDelivered(Function(dynamic) callback) {
    socket.on('messageDelivered', callback);
  }

  void onError(Function(dynamic) callback) {
    socket.on('error', callback);
  }

  void onNewMessage(Function(dynamic) callback) {
    socket.on('newMessage', callback);
  }

  void onTyping(Function(dynamic) callback) {
    socket.on('userTyping', callback);
  }

  void onUserJoined(Function(dynamic) callback) {
    socket.on('userJoined', callback);
  }

  void onUserOnline(Function(dynamic) callback) {
    socket.on('userOnline', callback);
  }

  void onUserOffline(Function(dynamic) callback) {
    socket.on('userOffline', callback);
  }
}
