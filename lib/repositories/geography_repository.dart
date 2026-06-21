import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/city.dart';
import '../models/macroregion.dart';
import '../models/state_uf.dart';

/// Repository for read-only geographic queries.
///
/// PostgreSQL persistence must be exposed through a trusted backend/API. Mobile
/// Flutter clients should not connect directly to PostgreSQL in production
/// because that would expose credentials and bypass server-side authorization.
class GeographyRepository {
  GeographyRepository({required this.config, http.Client? client})
      : _client = client ?? http.Client();

  final AppConfig config;
  final http.Client _client;

  Future<List<City>> searchCities(String query) async {
    final uri = Uri.parse('${config.apiBaseUrl}/cities').replace(
      queryParameters: {'q': query},
    );
    final response = await _client.get(uri);
    return _decodeList(response, City.fromJson);
  }

  Future<List<StateUf>> fetchStates() async {
    final response = await _client.get(Uri.parse('${config.apiBaseUrl}/states'));
    return _decodeList(response, StateUf.fromJson);
  }

  Future<List<Macroregion>> fetchMacroregions() async {
    final response = await _client.get(
      Uri.parse('${config.apiBaseUrl}/macroregions'),
    );
    return _decodeList(response, Macroregion.fromJson);
  }

  List<T> _decodeList<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API returned ${response.statusCode}: ${response.body}');
    }
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}
