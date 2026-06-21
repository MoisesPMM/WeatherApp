import 'macroregion.dart';

class StateUf {
  const StateUf({
    required this.id,
    required this.name,
    required this.acronym,
    required this.macroregion,
  });

  factory StateUf.fromJson(Map<String, dynamic> json) {
    return StateUf(
      id: json['id'] as int,
      name: json['name'] as String,
      acronym: json['acronym'] as String,
      macroregion: Macroregion.fromJson(
        json['macroregion'] as Map<String, dynamic>,
      ),
    );
  }

  final int id;
  final String name;
  final String acronym;
  final Macroregion macroregion;
}
