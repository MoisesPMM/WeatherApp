import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/climaController.dart';
import '../models/dadosMetereologicos.dart';
import '../services/climaService.dart';
import '../components/graficoClima.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _EstadoPaginaInicial();
}

class _EstadoPaginaInicial extends State<PaginaInicial>
    with SingleTickerProviderStateMixin {
  final _controladorCidade = TextEditingController();
  late final TabController _controladorAbas;

  @override
  void initState() {
    super.initState();
    _controladorAbas = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controladorCidade.dispose();
    _controladorAbas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controlador = context.watch<ControladorClima>();
    final climaAtual = controlador.climaAtual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta meteorológica'),
        bottom: TabBar(
          controller: _controladorAbas,
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
                    controller: _controladorCidade,
                    decoration: const InputDecoration(
                      labelText: 'Buscar cidade',
                      hintText: 'Ex.: Curitiba',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: controlador.buscarPorCidade,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: controlador.estaCarregando
                      ? null
                      : () => controlador.buscarPorCidade(
                            _controladorCidade.text,
                          ),
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (controlador.estaCarregando) const LinearProgressIndicator(),
            if (controlador.mensagemErro != null)
              Text(
                controlador.mensagemErro!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            if (climaAtual != null) _ResumoClima(dados: climaAtual),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _controladorAbas,
                children: [
                  GraficoClima(
                    titulo: 'Temperatura por cidade',
                    pontos: controlador.obterDadosGraficoCidade(),
                  ),
                  FutureBuilder<List<PontoGrafico>>(
                    future: climaAtual == null
                        ? null
                        : controlador.obterDadosGraficoUf('UF'),
                    builder: (contexto, resultado) {
                      return GraficoClima(
                        titulo: 'Temperatura média por UF',
                        pontos: resultado.data ?? const [],
                      );
                    },
                  ),
                  FutureBuilder<List<PontoGrafico>>(
                    future: climaAtual == null
                        ? null
                        : controlador.obterDadosGraficoRegiao(
                            climaAtual.idCidade,
                          ),
                    builder: (contexto, resultado) {
                      return GraficoClima(
                        titulo: 'Temperatura agregada por região',
                        pontos: resultado.data ?? const [],
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

class _ResumoClima extends StatelessWidget {
  const _ResumoClima({required this.dados});

  final DadosMeteorologicos dados;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.thermostat),
        title: Text(
          '${dados.nomeCidade}: '
          '${dados.temperaturaCelsius.toStringAsFixed(1)} °C',
        ),
        subtitle: Text(
          '${dados.descricao} • Umidade '
          '${dados.percentualUmidade.toStringAsFixed(0)}% • Vento '
          '${dados.velocidadeVentoKmh.toStringAsFixed(1)} km/h',
        ),
      ),
    );
  }
}
