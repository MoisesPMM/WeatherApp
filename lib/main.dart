import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_config.dart';
import 'controllers/geography_controller.dart';
import 'controllers/weather_controller.dart';
import 'pages/splash_page.dart';
import 'repositories/geography_repository.dart';
import 'repositories/weather_repository.dart';
import 'services/geography_service.dart';
import 'services/weather_service.dart';

void main() {
  final config = AppConfig.fromEnvironment();
  final geographyRepository = GeographyRepository(config: config);
  final weatherRepository = WeatherRepository(config: config);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: config),
        Provider.value(value: geographyRepository),
        Provider.value(value: weatherRepository),
        Provider(
          create: (_) => GeographyService(repository: geographyRepository),
        ),
        Provider(
          create: (_) => WeatherService(repository: weatherRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => GeographyController(
            service: context.read<GeographyService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherController(
            weatherService: context.read<WeatherService>(),
            geographyService: context.read<GeographyService>(),
          ),
        ),
      ],
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
