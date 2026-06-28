import 'macrorregiao.dart';

class Mesorregiao {
  const Mesorregiao({
    required this.id,
    required this.nome,
    required this.macrorregiao,
  });

  factory Mesorregiao.deJson(Map<String, dynamic> json) {
    return Mesorregiao(
      id: json['id'] as int,
      nome: json['name'] as String,
      macrorregiao: Macrorregiao.deJson(
        json['macroregion'] as Map<String, dynamic>,
      ),
    );
  }

  final int id;
  final String nome;
  final Macrorregiao macrorregiao;
}
