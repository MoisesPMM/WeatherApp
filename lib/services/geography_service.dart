import '../models/city.dart';
import '../models/macroregion.dart';
import '../models/state_uf.dart';
import '../models/weather_data.dart';
import '../repositories/geography_repository.dart';

class GeographyService {
  GeographyService({required GeographyRepository repository})
      : _repository = repository;

  final GeographyRepository _repository;

  Future<List<City>> searchCities(String query) {
    return _repository.searchCities(query.trim());
  }

  Future<List<StateUf>> getStates() {
    return _repository.fetchStates();
  }

  Future<List<Macroregion>> getMacroregions() {
    return _repository.fetchMacroregions();
  }

  Map<String, List<WeatherData>> aggregateByCity(List<WeatherData> data) {
    return _groupBy(data, (item) => item.cityName);
  }

  Map<String, List<WeatherData>> aggregateByUf(
    List<WeatherData> data,
    String acronym,
  ) {
    return {acronym.toUpperCase(): data};
  }

  Map<String, List<WeatherData>> aggregateByRegion(
    List<WeatherData> data,
    String regionName,
  ) {
    return {regionName: data};
  }

  Map<String, List<WeatherData>> _groupBy(
    List<WeatherData> data,
    String Function(WeatherData) keySelector,
  ) {
    final grouped = <String, List<WeatherData>>{};
    for (final item in data) {
      grouped.putIfAbsent(keySelector(item), () => []).add(item);
    }
    return grouped;
  }
}
