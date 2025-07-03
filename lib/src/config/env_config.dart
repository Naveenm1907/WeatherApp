import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // This is a placeholder API key for development purposes only
  // In production, always use environment variables or secure storage
  static const String _devApiKey = ''; // Add your dev API key here for testing
  
  static String get openWeatherApiKey {
    final key = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    if (key.isEmpty) {
      debugPrint('WARNING: OpenWeather API key not found in .env file');
      // Only use dev key in debug mode, never in production
      return kDebugMode ? _devApiKey : '';
    }
    return key;
  }

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
      debugPrint('Environment configuration loaded successfully');
    } catch (e) {
      debugPrint('Failed to load .env file: $e');
      // Continue without .env file in debug mode
      if (!kDebugMode) {
        throw Exception('Failed to load environment configuration');
      }
    }
  }
} 