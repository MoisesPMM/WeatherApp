import 'macroregion.dart';

class Mesoregion {
  const Mesoregion({
    required this.id,
    required this.name,
    required this.macroregion,
  });

  factory Mesoregion.fromJson(Map<String, dynamic> json) {
    return Mesoregion(
      id: json['id'] as int,
      name: json['name'] as String,
      macroregion: Macroregion.fromJson(
        json['macroregion'] as Map<String, dynamic>,
      ),
    );
  }

  final int id;
  final String name;
  final Macroregion macroregion;
}
