import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/main.dart';

void main() {
  testWidgets('exibe a tela de abertura do aplicativo', (testador) async {
    await testador.pumpWidget(const AplicativoClima());

    expect(find.text('WeatherApp'), findsOneWidget);
    expect(find.byIcon(Icons.cloud), findsOneWidget);

    // Descarta a tela antes de concluir o temporizador de navegação.
    await testador.pumpWidget(const SizedBox.shrink());
    await testador.pump(const Duration(seconds: 2));
  });
}
