class Macrorregiao {
  const Macrorregiao(
      {required this.id, required this.nome, required this.codigo});

  factory Macrorregiao.deJson(Map<String, dynamic> json) {
    return Macrorregiao(
      id: json['id'] as int,
      nome: json['name'] as String,
      codigo: json['code'] as String,
    );
  }

  final int id;
  final String nome;
  final String codigo;
}
