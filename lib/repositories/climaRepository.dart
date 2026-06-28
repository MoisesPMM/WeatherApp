import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/appConfig.dart';
import '../models/dadosMetereologicos.dart';

class RepositorioClima {
  static const _urlGeocodingOpenMeteo =
      'https://geocoding-api.open-meteo.com/v1/search';
  static const _urlForecastOpenMeteo =
      'https://api.open-meteo.com/v1/forecast';

  RepositorioClima({
    required this.configuracao,
    http.Client? cliente,
  }) : _cliente = cliente ?? http.Client();

  final ConfiguracaoAplicativo configuracao;
  final http.Client _cliente;

  Future<List<DadosMeteorologicos>> buscarPorCidade(String nomeCidade) async {
    final uriGeocoding = Uri.parse(_urlGeocodingOpenMeteo).replace(
      queryParameters: {
        'name': nomeCidade,
        'count': '1',
        'language': 'pt',
        'format': 'json',
      },
    );
    final respostaGeocoding = await _cliente.get(uriGeocoding);
    final cidade = _decodificarCidadeOpenMeteo(respostaGeocoding);

    final uriForecast = Uri.parse(_urlForecastOpenMeteo).replace(
      queryParameters: {
        'latitude': cidade.latitude.toString(),
        'longitude': cidade.longitude.toString(),
        'current': 'temperature_2m,relative_humidity_2m,wind_speed_10m,'
            'weather_code',
        'timezone': 'auto',
      },
    );
    final respostaForecast = await _cliente.get(uriForecast);
    return [_decodificarClimaOpenMeteo(respostaForecast, cidade)];
  }

  Future<List<DadosMeteorologicos>> buscarPorUf(String sigla) async {
    final uri = Uri.parse(
      '${configuracao.urlBaseApi}/weather/states/$sigla',
    );
    final resposta = await _cliente.get(uri);
    return _decodificarListaMeteorologica(resposta);
  }

  Future<List<DadosMeteorologicos>> buscarPorRegiao(int idRegiao) async {
    final uri = Uri.parse(
      '${configuracao.urlBaseApi}/weather/regions/$idRegiao',
    );
    final resposta = await _cliente.get(uri);
    return _decodificarListaMeteorologica(resposta);
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

  _CidadeOpenMeteo _decodificarCidadeOpenMeteo(http.Response resposta) {
    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception(
        'A API retornou ${resposta.statusCode}: ${resposta.body}',
      );
    }
    final dadosDecodificados = jsonDecode(resposta.body) as Map<String, dynamic>;
    final resultados = dadosDecodificados['results'] as List<dynamic>?;
    if (resultados == null || resultados.isEmpty) {
      throw Exception('Cidade não encontrada na API Open-Meteo.');
    }
    final cidade = resultados.first as Map<String, dynamic>;
    return _CidadeOpenMeteo(
      id: cidade['id'] as int,
      nome: cidade['name'] as String,
      latitude: (cidade['latitude'] as num).toDouble(),
      longitude: (cidade['longitude'] as num).toDouble(),
    );
  }

  DadosMeteorologicos _decodificarClimaOpenMeteo(
    http.Response resposta,
    _CidadeOpenMeteo cidade,
  ) {
    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception(
        'A API retornou ${resposta.statusCode}: ${resposta.body}',
      );
    }
    final dadosDecodificados = jsonDecode(resposta.body) as Map<String, dynamic>;
    final climaAtual = dadosDecodificados['current'] as Map<String, dynamic>;
    final codigoClima = climaAtual['weather_code'] as int? ?? -1;
    return DadosMeteorologicos(
      idCidade: cidade.id,
      nomeCidade: cidade.nome,
      observadoEm: DateTime.parse(climaAtual['time'] as String),
      temperaturaCelsius: (climaAtual['temperature_2m'] as num).toDouble(),
      percentualUmidade:
          (climaAtual['relative_humidity_2m'] as num).toDouble(),
      velocidadeVentoKmh: (climaAtual['wind_speed_10m'] as num).toDouble(),
      descricao: _descreverCodigoClima(codigoClima),
    );
  }

  String _descreverCodigoClima(int codigo) {
    return switch (codigo) {
      0 => 'Céu limpo',
      1 || 2 || 3 => 'Parcialmente nublado',
      45 || 48 => 'Nevoeiro',
      51 || 53 || 55 || 56 || 57 => 'Garoa',
      61 || 63 || 65 || 66 || 67 => 'Chuva',
      71 || 73 || 75 || 77 => 'Neve',
      80 || 81 || 82 => 'Pancadas de chuva',
      85 || 86 => 'Pancadas de neve',
      95 || 96 || 99 => 'Tempestade',
      _ => 'Condição meteorológica não informada',
    };
  }
}

class _CidadeOpenMeteo {
  const _CidadeOpenMeteo({
    required this.id,
    required this.nome,
    required this.latitude,
    required this.longitude,
  });

  final int id;
  final String nome;
  final double latitude;
  final double longitude;
}
