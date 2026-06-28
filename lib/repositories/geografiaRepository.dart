import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/appConfig.dart';
import '../models/cidade.dart';
import '../models/macrorregiao.dart';
import '../models/unidadeFederativa.dart';

class RepositorioGeografia {
  RepositorioGeografia({
    required this.configuracao,
    http.Client? cliente,
  }) : _cliente = cliente ?? http.Client();

  final ConfiguracaoAplicativo configuracao;
  final http.Client _cliente;

  Future<List<Cidade>> buscarCidades(String consulta) async {
    final uri = Uri.parse('${configuracao.urlBaseApi}/cities').replace(
      queryParameters: {'q': consulta},
    );
    final resposta = await _cliente.get(uri);
    return _decodificarLista(resposta, Cidade.deJson);
  }

  Future<List<UnidadeFederativa>> buscarUnidadesFederativas() async {
    final resposta = await _cliente.get(
      Uri.parse('${configuracao.urlBaseApi}/states'),
    );
    return _decodificarLista(resposta, UnidadeFederativa.deJson);
  }

  Future<List<Macrorregiao>> buscarMacrorregioes() async {
    final resposta = await _cliente.get(
      Uri.parse('${configuracao.urlBaseApi}/macroregions'),
    );
    return _decodificarLista(resposta, Macrorregiao.deJson);
  }

  List<T> _decodificarLista<T>(
    http.Response resposta,
    T Function(Map<String, dynamic>) deJson,
  ) {
    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception(
        'A API retornou ${resposta.statusCode}: ${resposta.body}',
      );
    }
    final dadosDecodificados = jsonDecode(resposta.body) as List<dynamic>;
    return dadosDecodificados
        .map((item) => deJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}
