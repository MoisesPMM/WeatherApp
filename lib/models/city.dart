import 'microregion.dart';
import 'state_uf.dart';

class City {
  const City({
    required this.id,
    required this.name,
    required this.stateUf,
    required this.microregion,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      name: json['name'] as String,
      stateUf: StateUf.fromJson(json['stateUf'] as Map<String, dynamic>),
      microregion: Microregion.fromJson(
        json['microregion'] as Map<String, dynamic>,
      ),
    );
  }

  final int id;
  final String name;
  final StateUf stateUf;
  final Microregion microregion;
}
