import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/appConfig.dart';
import '../models/dadosMetereologicos.dart';

class RepositorioClima {
  RepositorioClima({
    required this.configuracao,
    http.Client? cliente,
  }) : _cliente = cliente ?? http.Client();

  final ConfiguracaoAplicativo configuracao;
  final http.Client _cliente;

  Future<List<DadosMeteorologicos>> buscarPorCidade(String nomeCidade) async {
    final uri = Uri.parse(
      '${configuracao.urlBaseApi}/weather/cities',
    ).replace(queryParameters: {'name': nomeCidade});
    final resposta = await _cliente.get(uri);
    return _decodificarListaMeteorologica(resposta);
  }

  Future<List<DadosMeteorologicos>> buscarPorUf(String sigla) async {
    throw UnsupportedError(
      'Consulta por UF não está disponível na Open-Meteo. Busque por cidade.',
    );
  }

  Future<List<DadosMeteorologicos>> buscarPorRegiao(int idRegiao) async {
    throw UnsupportedError(
      'Consulta por região não está disponível na Open-Meteo. Busque por cidade.',
    );
  }

  List<DadosMeteorologicos> _decodificarListaMeteorologica(
    http.Response resposta,
  ) {
    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception(
        'A API retornou ${resposta.statusCode}: ${resposta.body}',
      );
    }
    final dadosDecodificados = jsonDecode(resposta.body) as List<dynamic>;
    return dadosDecodificados
        .map(
          (item) => DadosMeteorologicos.deJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }
}
