import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<WeatherModel> getWeather(String city) async {
    if (apiKey.isEmpty) {
      throw Exception('API key is not configured. Please add your OpenWeather API key to the .env file.');
    }
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?q=$city&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to load weather data';
        debugPrint('API Error: $errorMessage (${response.statusCode})');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Weather Service Error: $e');
      throw Exception('Failed to fetch weather data. Please check your internet connection.');
    }
  }
}