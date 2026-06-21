class WeatherData {
  const WeatherData({
    required this.cityId,
    required this.cityName,
    required this.observedAt,
    required this.temperatureCelsius,
    required this.humidityPercent,
    required this.windSpeedKmh,
    required this.description,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityId: json['cityId'] as int,
      cityName: json['cityName'] as String,
      observedAt: DateTime.parse(json['observedAt'] as String),
      temperatureCelsius: (json['temperatureCelsius'] as num).toDouble(),
      humidityPercent: (json['humidityPercent'] as num).toDouble(),
      windSpeedKmh: (json['windSpeedKmh'] as num).toDouble(),
      description: json['description'] as String,
    );
  }

  final int cityId;
  final String cityName;
  final DateTime observedAt;
  final double temperatureCelsius;
  final double humidityPercent;
  final double windSpeedKmh;
  final String description;
}
