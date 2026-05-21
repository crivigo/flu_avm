

//import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:flu_avm/config/entities/position.dart';

class Usor {
  final String id;
  final String nomen;
  final String colorhex;
  final Position positio;

  const Usor({
    required this.id, 
    required this.nomen, 
    required this.colorhex, 
    required this.positio
    });

  Usor copyWith({
    String? id,
    String? nomen,
    String? colorhex,
    Position? positio,
  }) {
    return Usor(
      id: id ?? this.id,
      nomen: nomen ?? this.nomen,
      colorhex: colorhex ?? this.colorhex,
      positio: positio ?? this.positio,
    );
  }

    static Usor fromJson(Map<String, dynamic> json) {

        final lat = json['lat'] as double? ?? 0.0;
        final lng = json['lng'] as double? ?? 0.0;
        final nomen = json['nomen'] as String? ?? '';

      return Usor(
        id: json['id'] as String? ?? '',
        nomen: nomen,
        colorhex: json['color'] as String? ?? '#FF0000',
        positio: Position(lng, lat)
      );
    }
}