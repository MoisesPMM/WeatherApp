import '../models/dadosMetereologicos.dart';
import '../repositories/climaRepository.dart';

class PontoGrafico {
  const PontoGrafico({required this.rotulo, required this.valor});

  final String rotulo;
  final double valor;
}

class ServicoClima {
  ServicoClima({required RepositorioClima repositorio})
      : _repositorio = repositorio;

  final RepositorioClima _repositorio;

  String? validarConsultaCidade(String consulta) {
    final consultaNormalizada = consulta.trim();
    if (consultaNormalizada.isEmpty) {
      return 'Informe uma cidade para consultar o clima.';
    }
    if (consultaNormalizada.length < 2) {
      return 'Digite ao menos 2 caracteres.';
    }
    return null;
  }

  Future<List<DadosMeteorologicos>> buscarPorCidade(String nomeCidade) {
    final erro = validarConsultaCidade(nomeCidade);
    if (erro != null) {
      throw ArgumentError(erro);
    }
    return _repositorio.buscarPorCidade(nomeCidade.trim());
  }

  Future<List<DadosMeteorologicos>> obterClimaPorUf(String sigla) {
    return _repositorio.buscarPorUf(sigla.trim().toUpperCase());
  }

  Future<List<DadosMeteorologicos>> obterClimaPorRegiao(int idRegiao) {
    return _repositorio.buscarPorRegiao(idRegiao);
  }

  List<PontoGrafico> prepararGraficoTemperatura(
    List<DadosMeteorologicos> dados,
  ) {
    return dados
        .map(
          (item) => PontoGrafico(
            rotulo: '${item.observadoEm.day}/${item.observadoEm.month}',
            valor: item.temperaturaCelsius,
          ),
        )
        .toList(growable: false);
  }

  double calcularTemperaturaMedia(List<DadosMeteorologicos> dados) {
    if (dados.isEmpty) {
      return 0;
    }
    final total = dados.fold<double>(
      0,
      (soma, item) => soma + item.temperaturaCelsius,
    );
    return total / dados.length;
  }
}
