class DadosMeteorologicos {
  const DadosMeteorologicos({
    required this.idCidade,
    required this.nomeCidade,
    required this.observadoEm,
    required this.temperaturaCelsius,
    required this.percentualUmidade,
    required this.velocidadeVentoKmh,
    required this.descricao,
  });

  factory DadosMeteorologicos.deJson(Map<String, dynamic> json) {
    return DadosMeteorologicos(
      idCidade: json['cityId'] as int,
      nomeCidade: json['cityName'] as String,
      observadoEm: DateTime.parse(json['observedAt'] as String),
      temperaturaCelsius: (json['temperatureCelsius'] as num).toDouble(),
      percentualUmidade: (json['humidityPercent'] as num).toDouble(),
      velocidadeVentoKmh: (json['windSpeedKmh'] as num).toDouble(),
      descricao: json['description'] as String,
    );
  }

  final int idCidade;
  final String nomeCidade;
  final DateTime observadoEm;
  final double temperaturaCelsius;
  final double percentualUmidade;
  final double velocidadeVentoKmh;
  final String descricao;
}
