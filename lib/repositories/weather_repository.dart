import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/weather_data.dart';

/// Repository for weather queries served by an HTTP backend.
///
/// If data is stored in PostgreSQL, keep the database connection in the backend
/// layer and expose only authenticated HTTPS endpoints to the Flutter app.
class WeatherRepository {
  WeatherRepository({required this.config, http.Client? client})
      : _client = client ?? http.Client();

  final AppConfig config;
  final http.Client _client;

  Future<List<WeatherData>> fetchByCity(String cityName) async {
    final uri = Uri.parse('${config.apiBaseUrl}/weather/cities').replace(
      queryParameters: {'name': cityName},
    );
    final response = await _client.get(uri);
    return _decodeWeatherList(response);
  }

  Future<List<WeatherData>> fetchByUf(String acronym) async {
    final uri = Uri.parse('${config.apiBaseUrl}/weather/states/$acronym');
    final response = await _client.get(uri);
    return _decodeWeatherList(response);
  }

  Future<List<WeatherData>> fetchByRegion(int regionId) async {
    final uri = Uri.parse('${config.apiBaseUrl}/weather/regions/$regionId');
    final response = await _client.get(uri);
    return _decodeWeatherList(response);
  }

  List<WeatherData> _decodeWeatherList(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API returned ${response.statusCode}: ${response.body}');
    }
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => WeatherData.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}
