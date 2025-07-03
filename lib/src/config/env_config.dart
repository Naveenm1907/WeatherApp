import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static const String _devApiKey = ''; 
  
  static String get openWeatherApiKey {
    final key = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    if (key.isEmpty) {
      debugPrint('WARNING: OpenWeather API key not found in .env file');
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
      if (!kDebugMode) {
        throw Exception('Failed to load environment configuration');
      }
    }
  }
} 