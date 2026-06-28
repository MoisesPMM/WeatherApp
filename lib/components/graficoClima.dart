import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/climaService.dart';

class GraficoClima extends StatelessWidget {
  const GraficoClima({
    super.key,
    required this.pontos,
    required this.titulo,
  });

  final List<PontoGrafico> pontos;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    if (pontos.isEmpty) {
      return const Center(child: Text('Sem dados para o gráfico.'));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var indice = 0; indice < pontos.length; indice++)
                          FlSpot(indice.toDouble(), pontos[indice].valor),
                      ],
                      isCurved: true,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
