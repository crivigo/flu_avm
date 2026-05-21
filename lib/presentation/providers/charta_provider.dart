import 'dart:developer';

import 'package:flu_avm/services/charta_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../config/config.dart';


final formNomenProvider = StateProvider<String>((ref) => '');

final formColorProvider = StateProvider<Color>((ref) => Colors.red);

final markerPositumProvider = StateProvider<bool>((ref) => false);

final Position initialisMarkerPositio = Position(-122.467895, 37.7749);

final coordsMarkerProvider = StateProvider<Position>((ref) => initialisMarkerPositio);


final socketServiceProvider = Provider<ChartaServices>((ref){
  final service = ChartaServices();

  ref.onDispose(() => service.finire());
  return service;
});

final aliiUsoresProvider = StreamProvider<List<Usor>>((ref) {
  final service = ref.watch(socketServiceProvider);
  return service.usoresStream;
});