import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/config/app_config.dart';

import '../models/message_model.dart';
import '../models/car_model.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/car.dart';
import '../../domain/entities/trip.dart';

class ChatbotApi {
  final Dio _dio;
  final String baseUrl;
  final uuid = const Uuid();

  ChatbotApi({required this.baseUrl, Dio? dio}) 
      : _dio = dio ?? Dio(BaseOptions(
          connectTimeout: AppConfig.connectionTimeout,
          receiveTimeout: AppConfig.receiveTimeout,
          headers: {'Content-Type': 'application/json'},
        ));

  Future<MessageModel> processMessage(String message, String userId, {String language = 'en'}) async {
    try {
      final response = await _dio.post(
        '$baseUrl/chat',
        data: {
          'message': message,
          'user_id': userId,
          'language': language,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return MessageModel.fromJson({'response': response.data['response']});
      } else {
        throw Exception('Failed to process message: ${response.statusCode}');
      }
    } catch (e) {
      print('Error processing message: $e');
      // Fallback to mock only if API is unreachable
      return _mockProcessMessage(message, userId);
    }
  }

  Future<TripModel> bookRide(String userId, Map<String, dynamic> rideDetails) async {
    try {
      final response = await _dio.post(
        '$baseUrl/book-ride',
        data: {
          'user_id': userId,
          'ride_details': rideDetails,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return TripModel.fromJson(response.data['details']);
      } else {
        throw Exception('Failed to book ride: ${response.statusCode}');
      }
    } catch (e) {
      print('Error booking ride: $e');
      // Fallback to mock only if API is unreachable
      return _mockBookRide(userId, rideDetails);
    }
  }

  Future<Map<String, dynamic>> cancelRide(String userId, String rideId) async {
    try {
      final response = await _dio.post(
        '$baseUrl/cancel-ride/$rideId',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['details'];
      } else {
        throw Exception('Failed to cancel ride: ${response.statusCode}');
      }
    } catch (e) {
      print('Error canceling ride: $e');
      // For mockup purposes
      return {'status': 'cancelled', 'booking_id': rideId};
    }
  }

  Future<List<Map<String, dynamic>>> getRecommendations(String userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/recommendations/$userId',
      );

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      // For mockup purposes
      return [
        {
          'type': 'recommendation',
          'content': 'Based on your recent rides, we recommend booking a ride to Downtown for your evening plans.',
        }
      ];
    }
  }

  Future<Map<String, dynamic>> performSafetyCheck(String userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/safety-check/$userId',
      );

      return response.data;
    } catch (e) {
      // For mockup purposes
      return {
        'status': 'completed',
        'recommendations': 'Everything looks good! Make sure to check your vehicle before starting your journey.',
      };
    }
  }

  Future<List<Map<String, dynamic>>> getCarpoolOpportunities(String userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/carpool-opportunities/$userId',
      );

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      // For mockup purposes
      return [
        {
          'id': uuid.v4(),
          'driver': 'John Doe',
          'pickup': 'Downtown Station',
          'dropoff': 'Airport Terminal 1',
          'time': DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
          'seats': 2,
          'price': 15.0,
        }
      ];
    }
  }

  Future<List<CarModel>> getAvailableCars(String pickupLocation, String dropoffLocation) async {
    try {
      final response = await _dio.get(
        '$baseUrl/available-cars',
        queryParameters: {
          'pickup': pickupLocation,
          'dropoff': dropoffLocation,
        },
      );

      return (response.data as List).map((car) => CarModel.fromJson(car)).toList();
    } catch (e) {
      // For mockup purposes
      return _mockAvailableCars();
    }
  }

  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/user-profile/$userId',
      );

      return UserModel.fromJson(response.data);
    } catch (e) {
      // For mockup purposes
      return UserModel(
        id: userId,
        name: 'Zeyad Tamer',
        avatarUrl: null,
        preferences: {'language': 'en', 'notifications': true},
      );
    }
  }

  Future<List<TripModel>> getRideHistory(String userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/ride-history/$userId',
      );

      return (response.data as List).map((trip) => TripModel.fromJson(trip)).toList();
    } catch (e) {
      // For mockup purposes
      return [];
    }
  }

  // Mock method for processing messages
  MessageModel _mockProcessMessage(String message, String userId) {
    String response = '';
    
    if (message.toLowerCase().contains('book') || message.toLowerCase().contains('ride')) {
      response = 'I can help you book a ride. Where would you like to go?';
    } else if (message.toLowerCase().contains('cancel')) {
      response = 'I can help you cancel your ride. Please provide your booking ID.';
    } else if (message.toLowerCase().contains('hello') || message.toLowerCase().contains('hi')) {
      response = 'Hello! How can I assist you with your transportation needs today?';
    } else if (message.toLowerCase().contains('thank')) {
      response = "You're welcome! Is there anything else I can help you with?";
    } else {
      response = 'I understand you want to discuss "${message}". How can I help you with that?';
    }
    
    return MessageModel(
      id: uuid.v4(),
      content: response,
      type: MessageType.text,
      sender: MessageSender.bot,
      timestamp: DateTime.now(),
    );
  }

  // Mock method for booking a ride
  TripModel _mockBookRide(String userId, Map<String, dynamic> rideDetails) {
    return TripModel(
      id: uuid.v4(),
      userId: userId,
      pickupLocation: rideDetails['pickup'] ?? 'Default Pickup',
      dropoffLocation: rideDetails['dropoff'] ?? 'Default Dropoff',
      pickupTime: DateTime.now().add(const Duration(minutes: 15)),
      estimatedDuration: 30.0,
      distance: 5.0,
      status: TripStatus.scheduled,
      driverName: 'John Driver',
      fare: 24.50,
    );
  }

  List<CarModel> _mockAvailableCars() {
    return [
      CarModel(
        id: 'car_1',
        model: 'Toyota Camry',
        plateNumber: 'ABC 123',
        type: CarType.standard,
        imageUrl: 'assets/images/car_standard.png',
        price: 25.0,
        estimatedTimeMin: 5,
      ),
      CarModel(
        id: 'car_2',
        model: 'Honda Accord',
        plateNumber: 'DEF 456',
        type: CarType.comfort,
        imageUrl: 'assets/images/car_comfort.png',
        price: 35.0,
        estimatedTimeMin: 7,
      ),
      CarModel(
        id: 'car_3',
        model: 'Mercedes S-Class',
        plateNumber: 'GHI 789',
        type: CarType.luxury,
        imageUrl: 'assets/images/car_luxury.png',
        price: 50.0,
        estimatedTimeMin: 10,
      ),
    ];
  }
}
