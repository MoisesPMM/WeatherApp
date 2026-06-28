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
    final uriGeocoding = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search',
    ).replace(
      queryParameters: {
        'name': nomeCidade,
        'count': '1',
        'language': 'pt',
        'format': 'json',
      },
    );
    final respostaGeocoding = await _cliente.get(uriGeocoding);
    final dadosGeocoding = _decodificarGeocoding(respostaGeocoding);
    final resultados = dadosGeocoding['results'] as List<dynamic>?;

    if (resultados == null || resultados.isEmpty) {
      throw Exception('Cidade não encontrada na Open-Meteo.');
    }

    final cidade = resultados.first as Map<String, dynamic>;
    final latitude = cidade['latitude'] as num;
    final longitude = cidade['longitude'] as num;
    final nome = cidade['name'] as String;

    final uriPrevisao = Uri.parse(
      'https://api.open-meteo.com/v1/forecast',
    ).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current':
            'temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code',
        'timezone': 'auto',
      },
    );
    final respostaPrevisao = await _cliente.get(uriPrevisao);
    final dadosPrevisao = _decodificarPrevisaoAtual(respostaPrevisao);
    final atual = dadosPrevisao['current'] as Map<String, dynamic>;
    final codigoClima = atual['weather_code'] as num;

    return [
      DadosMeteorologicos(
        idCidade: (cidade['id'] as num?)?.toInt() ?? 0,
        nomeCidade: nome,
        observadoEm: DateTime.parse(atual['time'] as String),
        temperaturaCelsius: (atual['temperature_2m'] as num).toDouble(),
        percentualUmidade: (atual['relative_humidity_2m'] as num).toDouble(),
        velocidadeVentoKmh: (atual['wind_speed_10m'] as num).toDouble(),
        descricao: _descricaoCodigoClima(codigoClima.toInt()),
      ),
    ];
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

  Map<String, dynamic> _decodificarGeocoding(http.Response resposta) {
    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception(
        'A API de geocoding retornou ${resposta.statusCode}: ${resposta.body}',
      );
    }

    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  Map<String, dynamic> _decodificarPrevisaoAtual(http.Response resposta) {
    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception(
        'A API de previsão retornou ${resposta.statusCode}: ${resposta.body}',
      );
    }

    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  String _descricaoCodigoClima(int codigo) {
    switch (codigo) {
      case 0:
        return 'Céu limpo';
      case 1:
        return 'Principalmente limpo';
      case 2:
        return 'Parcialmente nublado';
      case 3:
        return 'Nublado';
      case 45:
      case 48:
        return 'Nevoeiro';
      case 51:
      case 53:
      case 55:
        return 'Garoa';
      case 56:
      case 57:
        return 'Garoa congelante';
      case 61:
      case 63:
      case 65:
        return 'Chuva';
      case 66:
      case 67:
        return 'Chuva congelante';
      case 71:
      case 73:
      case 75:
        return 'Neve';
      case 77:
        return 'Grãos de neve';
      case 80:
      case 81:
      case 82:
        return 'Pancadas de chuva';
      case 85:
      case 86:
        return 'Pancadas de neve';
      case 95:
        return 'Trovoada';
      case 96:
      case 99:
        return 'Trovoada com granizo';
      default:
        return 'Condição climática desconhecida';
    }
  }
}
