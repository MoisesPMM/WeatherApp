import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/appConfig.dart';
import 'controllers/climaController.dart';
import 'controllers/geografiaController.dart';
import 'page/splashPage.dart';
import 'repositories/climaRepository.dart';
import 'repositories/geografiaRepository.dart';
import 'services/climaService.dart';
import 'services/geografiaService.dart';

void main() {
  final configuracao = ConfiguracaoAplicativo.doAmbiente();
  final repositorioGeografia = RepositorioGeografia(configuracao: configuracao);
  final repositorioClima = RepositorioClima(configuracao: configuracao);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: configuracao),
        Provider.value(value: repositorioGeografia),
        Provider.value(value: repositorioClima),
        Provider(
          create: (_) => ServicoGeografia(repositorio: repositorioGeografia),
        ),
        Provider(
          create: (_) => ServicoClima(repositorio: repositorioClima),
        ),
        ChangeNotifierProvider(
          create: (contexto) => ControladorGeografia(
            servico: contexto.read<ServicoGeografia>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (contexto) => ControladorClima(
            servicoClima: contexto.read<ServicoClima>(),
            servicoGeografia: contexto.read<ServicoGeografia>(),
          ),
        ),
      ],
      child: const AplicativoClima(),
    ),
  );
}

class AplicativoClima extends StatelessWidget {
  const AplicativoClima({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PaginaAbertura(),
    );
  }
}
