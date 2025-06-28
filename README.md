# 📱 Cruise Rental Mobile App

A Flutter-based mobile application for the Cruise Rental car sharing platform, featuring car rentals, carpooling, and AI chatbot assistance.

## 🚀 **Features**

- **🚗 Car Rental**: Browse, filter, and book rental cars
- **👥 Carpooling**: Create and join carpool trips
- **🤖 AI Chatbot**: Get assistance with bookings and recommendations
- **📍 Real-time Location**: GPS integration for pickup/dropoff
- **💳 Secure Payments**: Integrated payment processing
- **📱 Cross-platform**: iOS, Android, and Web support
- **🔔 Push Notifications**: Real-time updates and reminders

## 📋 **Prerequisites**

- **Flutter** >= 3.0.0
- **Dart** >= 3.0.0
- **Android Studio** / **Xcode** (for mobile development)
- **Chrome** (for web development)
- **Git**

## ⚡ **Quick Start**

### 1. **Clone & Setup**
```bash
cd cruise-mobile
flutter pub get
```

### 2. **Environment Configuration**
The app supports environment variables for flexible configuration:

```bash
# For development
flutter run --dart-define=API_BASE_URL=http://localhost:3000 --dart-define=DEBUG_MODE=true

# For production
flutter run --dart-define=API_BASE_URL=https://your-api.com --dart-define=DEBUG_MODE=false
```

### 3. **Platform-Specific Setup**

#### **🌐 Web Development**
```bash
flutter run -d chrome -t lib/rental_demo_main.dart
```

#### **📱 Mobile Development**
```bash
# Android
flutter run -d android

# iOS
flutter run -d ios
```

## 🛠 **Available Scripts**

- `flutter run` - Start development server
- `flutter run -t lib/rental_demo_main.dart` - Run rental demo
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter build web` - Build web app
- `flutter test` - Run test suite
- `flutter doctor` - Check development environment

## 🔧 **Environment Variables**

| Variable | Default | Description |
|----------|---------|-------------|
| `API_BASE_URL` | `http://localhost:3000` | Backend API URL |
| `DEBUG_MODE` | `false` | Enable debug features |

## 🏗 **Architecture**

The app follows **Clean Architecture** principles:

```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── di/                 # Dependency injection
│   ├── theme/              # App theming
│   └── utils/              # Utilities
├── features/               # Feature modules
│   ├── rental/             # Car rental feature
│   │   ├── data/          # Data layer
│   │   ├── domain/        # Domain layer
│   │   └── presentation/  # UI layer
│   ├── carpooling/        # Carpooling feature
│   ├── chatbot/           # AI chatbot feature
│   ├── login/             # Authentication
│   └── register/          # User registration
└── util/                   # Shared utilities
    ├── shared/             # Shared components
    └── responsive_manager/ # Responsive design
```

## 📚 **Key Features**

### **🚗 Car Rental**
- Browse available cars by category (Electric, Sedan, SUV, Compact)
- Real-time availability checking
- Calendar-based booking system
- Reservation overlap prevention
- Multiple reservation periods display

### **👥 Carpooling**
- Create and search trips
- Real-time location integration
- In-trip chat functionality
- Route visualization with polylines

### **🤖 AI Chatbot**
- Natural language processing
- Booking assistance
- Recommendations engine
- Multi-language support

## 🎨 **UI/UX Features**

- **Material Design 3** components
- **Responsive design** for all screen sizes
- **Dark/Light theme** support
- **Custom animations** and transitions
- **Accessibility** features built-in

## 🔌 **API Integration**

The app connects to the Cruise Rental backend API:

```dart
// Example API call
final response = await ApiService().get(
  endPoint: '/api/rentals',
  data: {'category': 'Electric'},
);
```

## 🧪 **Testing**

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 🚨 **Troubleshooting**

### **Web Platform Issues**

#### Path Provider Error
If you encounter `MissingPluginException` for `path_provider` on web:
- This is expected behavior - the app automatically handles this
- No action required, the app will work normally

#### CORS Issues
Ensure your backend allows requests from `http://localhost:*` during development.

### **Mobile Platform Issues**

#### Android Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter build apk
```

#### iOS Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ios
```

### **Common Fixes**

#### Dependencies Issues
```bash
flutter clean
flutter pub get
flutter packages get
```

#### Build Issues
```bash
flutter doctor
# Fix any issues reported
```

## 📱 **Supported Platforms**

| Platform | Status | Notes |
|----------|--------|-------|
| **Android** | ✅ | API 21+ |
| **iOS** | ✅ | iOS 11+ |
| **Web** | ✅ | Chrome, Firefox, Safari |
| **Windows** | 🚧 | In development |
| **macOS** | 🚧 | In development |
| **Linux** | 🚧 | In development |

## 🎯 **Development Commands**

```bash
# Hot reload development
flutter run --hot

# Profile mode (performance testing)
flutter run --profile

# Release mode
flutter run --release

# Build for specific platform
flutter build [apk|ios|web|windows|macos|linux]

# Analyze code quality
flutter analyze

# Format code
flutter format .
```

## 🤝 **Contributing**

1. **Create a feature branch** from `main`
2. **Follow the existing architecture** patterns
3. **Add tests** for new functionality
4. **Update documentation** as needed
5. **Ensure all tests pass**
6. **Submit a pull request**

### **Code Style**
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting

## 📄 **License**

This project is licensed under the MIT License.

---

## 🆘 **Need Help?**

- Check the [Flutter documentation](https://docs.flutter.dev/)
- Visit the [Dart language tour](https://dart.dev/guides/language/language-tour)
- Join the [Flutter community](https://flutter.dev/community)
- Review our [troubleshooting guide](#-troubleshooting) above
