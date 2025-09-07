class AppConstants {
  // App Info
  static const String appName = 'Shoporia';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'https://api.example.com';
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String categoriesCollection = 'categories';
  static const String cartCollection = 'cart';

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError =
      'No internet connection. Please check your network.';
  static const String serverError = 'Server error. Please try again later.';
  static const String validationError =
      'Please check your input and try again.';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
}
