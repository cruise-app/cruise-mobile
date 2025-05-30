import '../entities/user.dart';
import '../entities/trip.dart';

abstract class UserRepository {
  Future<User> getUserProfile(String userId);
  
  Future<List<Trip>> getRideHistory(String userId);
  
  Future<void> updateUserPreferences(String userId, Map<String, dynamic> preferences);
  
  Future<void> saveUserSession(String userId, String token);
  
  Future<String?> getActiveUserSession();
}
