import 'package:flutter/foundation.dart';

import '../models/weather_data.dart';
import '../services/geography_service.dart';
import '../services/weather_service.dart';

class WeatherController extends ChangeNotifier {
  WeatherController({
    required WeatherService weatherService,
    required GeographyService geographyService,
  })  : _weatherService = weatherService,
        _geographyService = geographyService;

  final WeatherService _weatherService;
  final GeographyService _geographyService;

  bool isLoading = false;
  String? errorMessage;
  List<WeatherData> weather = const [];

  WeatherData? get currentWeather => weather.isEmpty ? null : weather.first;

  Future<void> searchByCity(String cityName) async {
    await _run(() async {
      weather = await _weatherService.searchByCity(cityName);
      _geographyService.aggregateByCity(weather);
    });
  }

  List<ChartPoint> getCityChartData() {
    return _weatherService.prepareTemperatureChart(weather);
  }

  Future<List<ChartPoint>> getUfChartData(String acronym) async {
    final data = await _weatherService.getUfWeather(acronym);
    _geographyService.aggregateByUf(data, acronym);
    return _weatherService.prepareTemperatureChart(data);
  }

  Future<List<ChartPoint>> getRegionChartData(int regionId) async {
    final data = await _weatherService.getRegionWeather(regionId);
    _geographyService.aggregateByRegion(data, 'Região $regionId');
    return _weatherService.prepareTemperatureChart(data);
  }

  Future<void> _run(Future<void> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
    } on ArgumentError catch (error) {
      errorMessage = error.message.toString();
    } catch (error) {
      errorMessage = 'Não foi possível carregar os dados: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
