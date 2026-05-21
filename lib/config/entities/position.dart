// TEMPORAL - Sustituye Position de mapbox_maps_flutter para desarrollo web
// Cuando se reactive Mapbox, eliminar este archivo y restaurar los imports originales en:
//   - usor.dart, positio_fortuita.dart, charta_provider.dart,
//     charta_service.dart, informa_usoris.dart

class Position {
  final double lng;
  final double lat;

  const Position(this.lng, this.lat);
}