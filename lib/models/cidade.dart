import 'microrregiao.dart';
import 'unidadeFederativa.dart';

class Cidade {
  const Cidade({
    required this.id,
    required this.nome,
    required this.unidadeFederativa,
    required this.microrregiao,
  });

  factory Cidade.deJson(Map<String, dynamic> json) {
    return Cidade(
      id: json['id'] as int,
      nome: json['name'] as String,
      unidadeFederativa: UnidadeFederativa.deJson(
        json['stateUf'] as Map<String, dynamic>,
      ),
      microrregiao: Microrregiao.deJson(
        json['microregion'] as Map<String, dynamic>,
      ),
    );
  }

  final int id;
  final String nome;
  final UnidadeFederativa unidadeFederativa;
  final Microrregiao microrregiao;
}
