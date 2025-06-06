import '../entities/message.dart';
import '../entities/car.dart';
import '../entities/trip.dart';

abstract class ChatbotRepository {
  Future<Message> processMessage(String message, String userId, {String language = 'en'});
  
  Future<Trip> bookRide(String userId, Map<String, dynamic> rideDetails);
  
  Future<Map<String, dynamic>> cancelRide(String userId, String rideId);
  
  Future<List<Map<String, dynamic>>> getRecommendations(String userId);
  
  Future<Map<String, dynamic>> performSafetyCheck(String userId);
  
  Future<List<Map<String, dynamic>>> getCarpoolOpportunities(String userId);
  
  Future<List<Car>> getAvailableCars(String pickupLocation, String dropoffLocation);
}
