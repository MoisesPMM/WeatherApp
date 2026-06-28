import 'package:flutter/foundation.dart';

import '../models/dadosMetereologicos.dart';
import '../services/climaService.dart';
import '../services/geografiaService.dart';

class ControladorClima extends ChangeNotifier {
  ControladorClima({
    required ServicoClima servicoClima,
    required ServicoGeografia servicoGeografia,
  })  : _servicoClima = servicoClima,
        _servicoGeografia = servicoGeografia;

  final ServicoClima _servicoClima;
  final ServicoGeografia _servicoGeografia;

  bool estaCarregando = false;
  String? mensagemErro;
  List<DadosMeteorologicos> dadosMeteorologicos = const [];

  DadosMeteorologicos? get climaAtual =>
      dadosMeteorologicos.isEmpty ? null : dadosMeteorologicos.first;

  Future<void> buscarPorCidade(String nomeCidade) async {
    await _executar(() async {
      dadosMeteorologicos = await _servicoClima.buscarPorCidade(nomeCidade);
      _servicoGeografia.agruparPorCidade(dadosMeteorologicos);
    });
  }

  List<PontoGrafico> obterDadosGraficoCidade() {
    return _servicoClima.prepararGraficoTemperatura(dadosMeteorologicos);
  }

  Future<List<PontoGrafico>> obterDadosGraficoUf(String sigla) async {
    final dados = await _servicoClima.obterClimaPorUf(sigla);
    _servicoGeografia.agruparPorUf(dados, sigla);
    return _servicoClima.prepararGraficoTemperatura(dados);
  }

  Future<List<PontoGrafico>> obterDadosGraficoRegiao(int idRegiao) async {
    final dados = await _servicoClima.obterClimaPorRegiao(idRegiao);
    _servicoGeografia.agruparPorRegiao(dados, 'Região $idRegiao');
    return _servicoClima.prepararGraficoTemperatura(dados);
  }

  Future<void> _executar(Future<void> Function() acao) async {
    estaCarregando = true;
    mensagemErro = null;
    notifyListeners();
    try {
      await acao();
    } on ArgumentError catch (erro) {
      mensagemErro = erro.message.toString();
    } catch (erro) {
      mensagemErro = 'Não foi possível carregar os dados: $erro';
    } finally {
      estaCarregando = false;
      notifyListeners();
    }
  }
}
