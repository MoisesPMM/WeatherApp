class Macroregion {
  const Macroregion({required this.id, required this.name, required this.code});

  factory Macroregion.fromJson(Map<String, dynamic> json) {
    return Macroregion(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }

  final int id;
  final String name;
  final String code;
}
