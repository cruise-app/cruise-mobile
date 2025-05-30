import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  static const String _userKey = 'user_key';
  static const String _messagesKey = 'messages_key';
  static const String _sessionKey = 'session_key';

  // User methods
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs.setString(_userKey, jsonEncode(user));
  }

  Map<String, dynamic>? getUser() {
    final userStr = _prefs.getString(_userKey);
    if (userStr == null) return null;
    return jsonDecode(userStr) as Map<String, dynamic>;
  }

  // Messages methods
  Future<void> saveMessages(List<Map<String, dynamic>> messages) async {
    await _prefs.setString(_messagesKey, jsonEncode(messages));
  }

  Future<void> addMessage(Map<String, dynamic> message) async {
    final messages = getMessages();
    messages.add(message);
    await saveMessages(messages);
  }

  List<Map<String, dynamic>> getMessages() {
    final messagesStr = _prefs.getString(_messagesKey);
    if (messagesStr == null) return [];
    return List<Map<String, dynamic>>.from(
      jsonDecode(messagesStr) as List,
    );
  }

  Future<void> clearMessages() async {
    await _prefs.remove(_messagesKey);
  }

  // Session methods
  Future<void> saveSession(String userId, String token) async {
    await _prefs.setString(_sessionKey, jsonEncode({
      'userId': userId,
      'token': token,
      'timestamp': DateTime.now().toIso8601String(),
    }));
  }

  Map<String, dynamic>? getSession() {
    final sessionStr = _prefs.getString(_sessionKey);
    if (sessionStr == null) return null;
    return jsonDecode(sessionStr) as Map<String, dynamic>;
  }

  String? getActiveUserId() {
    final session = getSession();
    return session?['userId'] as String?;
  }

  Future<void> clearSession() async {
    await _prefs.remove(_sessionKey);
  }

  // Preferences
  Future<void> savePreference(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      await _prefs.setString(key, jsonEncode(value));
    }
  }

  dynamic getPreference(String key) {
    return _prefs.get(key);
  }

  Future<void> removePreference(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
