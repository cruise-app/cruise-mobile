import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:geolocator/geolocator.dart';

class SocketService {
  late IO.Socket socket;
  Timer? _locationTimer;

  SocketService() {
    socket = IO.io(
      'http://10.0.2.2:3000', // Replace with your server URL
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .build(),
    );

    // Add connection event listeners for debugging
    socket.onConnect((_) {
      print('Socket connected successfully');
    });
    socket.onConnectError((error) {
      print('Socket connection error: $error');
    });
    socket.onError((error) {
      print('Socket error: $error');
    });
    socket.onDisconnect((_) {
      print('Socket disconnected');
    });
  }

  void connect() {
    print('Connecting to socket...');
    if (!socket.connected) {
      socket.connect();
    }
  }

  void disconnect() {
    _locationTimer?.cancel();
    socket.disconnect();
    print('Socket disconnected manually');
  }

  void onEvent(String event, void Function(dynamic) callback) {
    socket.on(event, (data) {
      print('Received event $event with data: $data'); // Debug log
      callback(data);
    });
  }

  void emitEvent(String event, dynamic data) {
    print('Emitting event $event with data: $data'); // Debug log
    if (socket.connected) {
      socket.emit(event, data);
    } else {
      print('Cannot emit $event: Socket is not connected');
    }
  }

  void offEvent(String event, void Function(dynamic) callback) {
    socket.off(event, callback);
  }

  void joinTrip(String tripId, String userId) {
    emitEvent('joinTrip', {'tripId': tripId, 'userId': userId});
  }

  void startSendingLocation(String userId, String tripId, String role) async {
    _locationTimer?.cancel();
    print("Hellooooooooooo");
    if (!socket.connected) {
      print('Socket not connected, attempting to reconnect...');
      reconnect();
    }
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        print('Fetching location for userId: $userId, tripId: $tripId');
        Position pos = await Geolocator.getCurrentPosition();
        emitEvent('locationUpdate', {
          'userId': userId,
          'tripId': tripId,
          'lat': pos.latitude,
          'lng': pos.longitude,
          'timestamp': DateTime.now().toIso8601String(),
          'role': role,
        });
      } catch (e) {
        print('Error fetching location: $e');
      }
    });
  }

  void stopSendingLocation() {
    _locationTimer?.cancel();
    print('Stopped sending location updates');
  }

  void listenToUserLocations(void Function(dynamic) callback) {
    onEvent('userLocation', callback);
  }

  void reconnect() {
    if (!socket.connected) {
      print('Attempting to reconnect...');
      socket.connect();
    }
  }
}
