import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/weather_controller.dart';
import '../models/weather_data.dart';
import '../widgets/weather_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final _cityController = TextEditingController();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WeatherController>();
    final current = controller.currentWeather;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta meteorológica'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Cidade'),
            Tab(text: 'UF'),
            Tab(text: 'Regiões'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar cidade',
                      hintText: 'Ex.: Curitiba',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: controller.searchByCity,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: controller.isLoading
                      ? null
                      : () => controller.searchByCity(_cityController.text),
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (controller.isLoading) const LinearProgressIndicator(),
            if (controller.errorMessage != null)
              Text(
                controller.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            if (current != null) _WeatherSummary(data: current),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  WeatherChart(
                    title: 'Temperatura por cidade',
                    points: controller.getCityChartData(),
                  ),
                  FutureBuilder(
                    future: current == null
                        ? null
                        : controller.getUfChartData('UF'),
                    builder: (context, snapshot) {
                      return WeatherChart(
                        title: 'Temperatura média por UF',
                        points: snapshot.data ?? const [],
                      );
                    },
                  ),
                  FutureBuilder(
                    future: current == null
                        ? null
                        : controller.getRegionChartData(current.cityId),
                    builder: (context, snapshot) {
                      return WeatherChart(
                        title: 'Temperatura agregada por região',
                        points: snapshot.data ?? const [],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherSummary extends StatelessWidget {
  const _WeatherSummary({required this.data});

  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.thermostat),
        title: Text('${data.cityName}: ${data.temperatureCelsius.toStringAsFixed(1)} °C'),
        subtitle: Text(
          '${data.description} • Umidade ${data.humidityPercent.toStringAsFixed(0)}% • Vento ${data.windSpeedKmh.toStringAsFixed(1)} km/h',
        ),
      ),
    );
  }
}
