class AppConfig {
  AppConfig._(); // Private constructor to prevent instantiation
  
  // App info
  static const String appName = 'Cruise Rental';
  static const String appVersion = '1.0.0';
  
  // API Endpoints - Use environment variables for flexible configuration
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');
  static const String chatbotEndpoint = '/chat';
  static const String userEndpoint = '/api/users';
  static const String bookRideEndpoint = '/book-ride';
  static const String cancelRideEndpoint = '/cancel-ride';
  static const String carpoolEndpoint = '/carpool-opportunities';
  static const String recommendationsEndpoint = '/recommendations';
  static const String safetyEndpoint = '/safety-check';
  
  // Feature Flags
  static const bool enableVoiceInput = true;
  static const bool enableLocationSharing = true;
  static const bool enableNotifications = true;
  static const bool enableDebugMode = bool.fromEnvironment('DEBUG_MODE', defaultValue: false);
  
  // Chat Settings
  static const int maxMessageLength = 500;
  static const int messageCacheSize = 100;
  static const Duration typingDelay = Duration(milliseconds: 500);
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  
  // Defaults
  static const String defaultUserName = 'User';
  static const String defaultUserAvatar = '';
  static const String botName = 'RideBot';
  static const String botAvatar = '';
  
  // UI Settings
  static const int animationDurationMs = 300;
  static const double defaultBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
}
