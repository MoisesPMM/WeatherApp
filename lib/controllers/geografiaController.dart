import 'package:flutter/foundation.dart';

import '../models/cidade.dart';
import '../models/macrorregiao.dart';
import '../models/unidadeFederativa.dart';
import '../services/geografiaService.dart';

class ControladorGeografia extends ChangeNotifier {
  ControladorGeografia({required ServicoGeografia servico})
      : _servico = servico;

  final ServicoGeografia _servico;

  List<Cidade> cidades = const [];
  List<UnidadeFederativa> unidadesFederativas = const [];
  List<Macrorregiao> macrorregioes = const [];
  bool estaCarregando = false;
  String? mensagemErro;

  Future<void> buscarCidades(String consulta) async {
    await _executar(() async {
      cidades = await _servico.buscarCidades(consulta);
    });
  }

  Future<void> carregarRegioes() async {
    await _executar(() async {
      unidadesFederativas = await _servico.obterUnidadesFederativas();
      macrorregioes = await _servico.obterMacrorregioes();
    });
  }

  Future<void> _executar(Future<void> Function() acao) async {
    estaCarregando = true;
    mensagemErro = null;
    notifyListeners();
    try {
      await acao();
    } catch (erro) {
      mensagemErro = 'Não foi possível carregar geografias: $erro';
    } finally {
      estaCarregando = false;
      notifyListeners();
    }
  }
}
