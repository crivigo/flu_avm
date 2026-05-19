import 'package:flu_avm/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ChartaScreen extends StatefulWidget {
  const ChartaScreen({super.key});

  @override
  State<ChartaScreen> createState() => _ChartaScreenState();
}

class _ChartaScreenState extends State<ChartaScreen> {

void _initializeCircleAnnotations(MapboxMap mapboxMap) {
    // Aquí puedes agregar cualquier configuración adicional para el mapa si es necesario
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapas'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
            MapWidget(
              key: const ValueKey('main_map'),
              cameraOptions:  CameraOptions(
                center: Point(
                  coordinates: Position(
                    -122.467895, // Longitud
                    37.7749,    // Latitud
                  ),
                ),
                zoom: 12.0,
              ),
              styleUri: MapboxStyles.MAPBOX_STREETS,
              onMapCreated: _initializeCircleAnnotations
            ),
        const Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: ComplereForm()
          ),
        )
        ],
      ),
    );
  }
}