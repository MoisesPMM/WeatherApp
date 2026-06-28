import 'macrorregiao.dart';

class UnidadeFederativa {
  const UnidadeFederativa({
    required this.id,
    required this.nome,
    required this.sigla,
    required this.macrorregiao,
  });

  factory UnidadeFederativa.deJson(Map<String, dynamic> json) {
    return UnidadeFederativa(
      id: json['id'] as int,
      nome: json['name'] as String,
      sigla: json['acronym'] as String,
      macrorregiao: Macrorregiao.deJson(
        json['macroregion'] as Map<String, dynamic>,
      ),
    );
  }

  final int id;
  final String nome;
  final String sigla;
  final Macrorregiao macrorregiao;
}
