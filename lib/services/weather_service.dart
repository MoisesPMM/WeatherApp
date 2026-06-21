import '../models/weather_data.dart';
import '../repositories/weather_repository.dart';

class ChartPoint {
  const ChartPoint({required this.label, required this.value});

  final String label;
  final double value;
}

class WeatherService {
  WeatherService({required WeatherRepository repository})
      : _repository = repository;

  final WeatherRepository _repository;

  String? validateCityQuery(String query) {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return 'Informe uma cidade para consultar o clima.';
    }
    if (normalized.length < 2) {
      return 'Digite ao menos 2 caracteres.';
    }
    return null;
  }

  Future<List<WeatherData>> searchByCity(String cityName) {
    final error = validateCityQuery(cityName);
    if (error != null) {
      throw ArgumentError(error);
    }
    return _repository.fetchByCity(cityName.trim());
  }

  Future<List<WeatherData>> getUfWeather(String acronym) {
    return _repository.fetchByUf(acronym.trim().toUpperCase());
  }

  Future<List<WeatherData>> getRegionWeather(int regionId) {
    return _repository.fetchByRegion(regionId);
  }

  List<ChartPoint> prepareTemperatureChart(List<WeatherData> data) {
    return data
        .map(
          (item) => ChartPoint(
            label: '${item.observedAt.day}/${item.observedAt.month}',
            value: item.temperatureCelsius,
          ),
        )
        .toList(growable: false);
  }

  double averageTemperature(List<WeatherData> data) {
    if (data.isEmpty) {
      return 0;
    }
    final total = data.fold<double>(
      0,
      (sum, item) => sum + item.temperatureCelsius,
    );
    return total / data.length;
  }
}
