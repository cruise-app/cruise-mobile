import '../../domain/repositories/user_repository.dart' as domain;
import '../../domain/entities/user.dart';
import '../../domain/entities/trip.dart';
import '../datasources/chatbot_api.dart';
import '../datasources/local_storage.dart';

class UserRepositoryImpl implements domain.UserRepository {
  final ChatbotApi _chatbotApi;
  final LocalStorage _localStorage;

  UserRepositoryImpl(this._chatbotApi, this._localStorage);

  @override
  Future<User> getUserProfile(String userId) async {
    // Try to get from local storage first
    final localUser = _localStorage.getUser();
    if (localUser != null) {
      return User(
        id: localUser['id'],
        name: localUser['name'],
        avatarUrl: localUser['avatarUrl'],
        preferences: localUser['preferences'],
      );
    }

    // If not in local storage, get from API and save
    final user = await _chatbotApi.getUserProfile(userId);
    await _localStorage.saveUser(user.toJson());
    return user;
  }

  @override
  Future<List<Trip>> getRideHistory(String userId) async {
    return await _chatbotApi.getRideHistory(userId);
  }

  @override
  Future<void> updateUserPreferences(String userId, Map<String, dynamic> preferences) async {
    // Get current user from local storage
    final userData = _localStorage.getUser();
    if (userData != null) {
      // Update preferences
      userData['preferences'] = {
        ...userData['preferences'] as Map<String, dynamic>,
        ...preferences,
      };
      // Save back to local storage
      await _localStorage.saveUser(userData);
    }
    // In a real app, would also send to backend API
  }

  @override
  Future<void> saveUserSession(String userId, String token) async {
    await _localStorage.saveSession(userId, token);
  }

  @override
  Future<String?> getActiveUserSession() async {
    return _localStorage.getActiveUserId();
  }
}
