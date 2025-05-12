import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  SocketService() {
    socket = IO.io(
      'http://10.0.2.2:3000', // Replace with your server URL
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .build(),
    );
  }

  void connect() {
    print('Connecting to socket...');
    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void onEvent(String event, void Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void emitEvent(String event, dynamic data) {
    socket.emit(event, data);
  }

  void offEvent(String event, void Function(dynamic) callback) {
    socket.off(event, callback);
  }
}
