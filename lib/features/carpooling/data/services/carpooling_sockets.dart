import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class SocketService {
  late IO.Socket socket;
  Timer? _locationTimer;
  Timer? _audioTimer;
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecording = false;

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
    disconnect();
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

  Future<void> startAudioRecordingLoop(String userId, String tripId) async {
    print(
        '[AUDIO] Initializing audio recording loop for userId: $userId, tripId: $tripId');
    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openRecorder();
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('[AUDIO] Microphone permission not granted');
      return;
    }

    _audioTimer?.cancel();
    _audioTimer = Timer.periodic(const Duration(seconds: 45), (timer) async {
      final dir = await getTemporaryDirectory();
      final String path =
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      print('[AUDIO] Starting recording to $path');
      try {
        await _audioRecorder!.startRecorder(toFile: path, codec: Codec.aacADTS);
      } catch (e) {
        print('[AUDIO] Error starting recorder: $e');
        return;
      }
      _isRecording = true;
      await Future.delayed(const Duration(seconds: 15));
      await _audioRecorder!.stopRecorder();
      _isRecording = false;
      print('[AUDIO] Stopped recording. Checking file: $path');

      final File audioFile = File(path);
      if (await audioFile.exists()) {
        print('[AUDIO] Audio file exists. Reading bytes...');
        final List<int> audioBytes = await audioFile.readAsBytes();
        final String base64Audio = base64Encode(audioBytes);
        print(
            '[AUDIO] Sending audio to backend. Size: ${audioBytes.length} bytes');
        final dio = Dio();
        try {
          final response = await dio.post(
            'http://localhost:5002/voiceData',
            data: {
              'userId': userId,
              'tripId': tripId,
              'audio': base64Audio,
              'format': 'mp3',
              'timestamp': DateTime.now().toIso8601String(),
            },
            options: Options(headers: {'Content-Type': 'application/json'}),
          );
          print(
              '[AUDIO] Audio sent to backend. Response: \\${response.statusCode}');
        } catch (e) {
          print('[AUDIO] Failed to send audio to backend: \\${e.toString()}');
        }
        await audioFile.delete(); // Clean up
        print('[AUDIO] Audio file deleted after sending.');
      } else {
        print('[AUDIO] Audio file does not exist: $path');
      }
    });
  }

  Future<void> stopAudioRecordingLoop() async {
    _audioTimer?.cancel();
    if (_isRecording) {
      await _audioRecorder?.stopRecorder();
      _isRecording = false;
    }
    await _audioRecorder?.closeRecorder();
    _audioRecorder = null;
    disconnect();
  }
}
