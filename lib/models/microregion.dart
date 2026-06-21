import 'mesoregion.dart';

class Microregion {
  const Microregion({
    required this.id,
    required this.name,
    required this.mesoregion,
  });

  factory Microregion.fromJson(Map<String, dynamic> json) {
    return Microregion(
      id: json['id'] as int,
      name: json['name'] as String,
      mesoregion: Mesoregion.fromJson(json['mesoregion'] as Map<String, dynamic>),
    );
  }

  final int id;
  final String name;
  final Mesoregion mesoregion;
}
