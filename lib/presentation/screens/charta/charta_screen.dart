import 'package:flu_avm/presentation/providers/charta_provider.dart';
import 'package:flu_avm/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


class ChartaScreen extends ConsumerStatefulWidget {
  const ChartaScreen({super.key});

  @override
  ConsumerState<ChartaScreen> createState() => _ChartaScreenState();
}

class _ChartaScreenState extends ConsumerState<ChartaScreen> {

  CircleAnnotationManager? _circleAnnotationManager; 

  Cancelable? _dragCancelable;

void _initiareCircleAnnotations(MapboxMap mapboxMap) {
    mapboxMap.annotations.createCircleAnnotationManager().then((manager) {
      _circleAnnotationManager = manager;

      _setupDragListener(manager);
      _addereVelRenovaMarker();
    });
  }


  void _setupDragListener(CircleAnnotationManager manager) {


     _dragCancelable?.cancel(); 

    _dragCancelable = manager.dragEvents(
        onChanged: (CircleAnnotation annotation) {
          final pos = annotation.geometry.coordinates;
          ref.read(coordsMarkerProvider.notifier).state = pos;
        },
        onEnd: (CircleAnnotation annotation) {
          final pos = annotation.geometry.coordinates;
          ref.read(coordsMarkerProvider.notifier).state = pos;
        }

    );
   
  }

  Future<void> _addereVelRenovaMarker() async {
    final manager = _circleAnnotationManager;

    if (manager == null) return;

    await manager.deleteAll();

    final placed = ref.read(markerPositumProvider);

    if (!placed) {
      await manager.deleteAll();
      return;
    }

     ref.read(markerPositumProvider.notifier).state = true;

    final situs = ref.read(coordsMarkerProvider);
    
     final color = ref.read(formColorProvider);

     final optiones = CircleAnnotationOptions(
      geometry: Point(coordinates: situs),
      circleColor: color.toARGB32(),
      circleRadius: 14.0,
      circleStrokeColor: Colors.white.toARGB32(),
      isDraggable: true
      );

    try {
    await manager.create(optiones);
    } catch (e) {
      debugPrint('Error al crear la anotación: $e');
    }
  }

@override
  void dispose() {
    _dragCancelable?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    ref.listen<bool>(markerPositumProvider, (prev, next) {
      if (next == true) {
        _addereVelRenovaMarker();
      }
    });

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
                  coordinates: initialisMarkerPositio,
                ),
                zoom: 12.0,
              ),
              styleUri: MapboxStyles.MAPBOX_STREETS,
              onMapCreated: _initiareCircleAnnotations
            ),
         Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: ref.watch(markerPositumProvider) ? InformaUsoris(
              nomen: ref.watch(formNomenProvider),
              color: ref.watch(formColorProvider),
              position: ref.watch(coordsMarkerProvider)
            ) : ComplereForm(),
          ),
        )
        ],
      ),
    );
  }
}