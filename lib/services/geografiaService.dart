import '../models/cidade.dart';
import '../models/dadosMetereologicos.dart';
import '../models/macrorregiao.dart';
import '../models/unidadeFederativa.dart';
import '../repositories/geografiaRepository.dart';

class ServicoGeografia {
  ServicoGeografia({required RepositorioGeografia repositorio})
      : _repositorio = repositorio;

  final RepositorioGeografia _repositorio;

  Future<List<Cidade>> buscarCidades(String consulta) {
    return _repositorio.buscarCidades(consulta.trim());
  }

  Future<List<UnidadeFederativa>> obterUnidadesFederativas() {
    return _repositorio.buscarUnidadesFederativas();
  }

  Future<List<Macrorregiao>> obterMacrorregioes() {
    return _repositorio.buscarMacrorregioes();
  }

  Map<String, List<DadosMeteorologicos>> agruparPorCidade(
    List<DadosMeteorologicos> dados,
  ) {
    return _agruparPor(dados, (item) => item.nomeCidade);
  }

  Map<String, List<DadosMeteorologicos>> agruparPorUf(
    List<DadosMeteorologicos> dados,
    String sigla,
  ) {
    return {sigla.toUpperCase(): dados};
  }

  Map<String, List<DadosMeteorologicos>> agruparPorRegiao(
    List<DadosMeteorologicos> dados,
    String nomeRegiao,
  ) {
    return {nomeRegiao: dados};
  }

  Map<String, List<DadosMeteorologicos>> _agruparPor(
    List<DadosMeteorologicos> dados,
    String Function(DadosMeteorologicos) seletorChave,
  ) {
    final agrupados = <String, List<DadosMeteorologicos>>{};
    for (final item in dados) {
      agrupados.putIfAbsent(seletorChave(item), () => []).add(item);
    }
    return agrupados;
  }
}
