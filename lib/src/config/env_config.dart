import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get openWeatherApiKey {
    return dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  }

  static Future<void> load() async {
    await dotenv.load();
  }
} 