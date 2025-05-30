import '../../domain/repositories/chatbot_repository.dart' as domain;
import '../../domain/entities/message.dart';
import '../../domain/entities/car.dart';
import '../../domain/entities/trip.dart';
import '../datasources/chatbot_api.dart';
import '../datasources/local_storage.dart';

class ChatbotRepositoryImpl implements domain.ChatbotRepository {
  final ChatbotApi _chatbotApi;
  final LocalStorage _localStorage;

  ChatbotRepositoryImpl(this._chatbotApi, this._localStorage);

  @override
  Future<Message> processMessage(String message, String userId, {String language = 'en'}) async {
    final response = await _chatbotApi.processMessage(message, userId, language: language);
    
    // Save user message to local storage
    await _localStorage.addMessage({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': message,
      'type': 'text',
      'sender': 'user',
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    // Save bot response to local storage
    await _localStorage.addMessage(response.toJson());
    
    return response;
  }

  @override
  Future<Trip> bookRide(String userId, Map<String, dynamic> rideDetails) async {
    return await _chatbotApi.bookRide(userId, rideDetails);
  }

  @override
  Future<Map<String, dynamic>> cancelRide(String userId, String rideId) async {
    return await _chatbotApi.cancelRide(userId, rideId);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String userId) async {
    return await _chatbotApi.getRecommendations(userId);
  }

  @override
  Future<Map<String, dynamic>> performSafetyCheck(String userId) async {
    return await _chatbotApi.performSafetyCheck(userId);
  }

  @override
  Future<List<Map<String, dynamic>>> getCarpoolOpportunities(String userId) async {
    return await _chatbotApi.getCarpoolOpportunities(userId);
  }

  @override
  Future<List<Car>> getAvailableCars(String pickupLocation, String dropoffLocation) async {
    return await _chatbotApi.getAvailableCars(pickupLocation, dropoffLocation);
  }
}
