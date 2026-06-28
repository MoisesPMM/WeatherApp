import 'mesorregiao.dart';

class Microrregiao {
  const Microrregiao({
    required this.id,
    required this.nome,
    required this.mesorregiao,
  });

  factory Microrregiao.deJson(Map<String, dynamic> json) {
    return Microrregiao(
      id: json['id'] as int,
      nome: json['name'] as String,
      mesorregiao: Mesorregiao.deJson(
        json['mesoregion'] as Map<String, dynamic>,
      ),
    );
  }

  final int id;
  final String nome;
  final Mesorregiao mesorregiao;
}
