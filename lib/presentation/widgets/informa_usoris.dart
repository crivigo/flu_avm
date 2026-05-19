import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class InformaUsoris extends StatelessWidget {
  final String nomen;
  final Color color;
  final Position position;

  const InformaUsoris({
    super.key, 
    required this.nomen, 
    required this.color, 
    required this.position
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      constraints: BoxConstraints(maxWidth: 200) ,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nomen.isEmpty ? '___' : nomen,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6),
          Text(
            'Lat: ${position.lat.toStringAsFixed(4)}',
            style: TextStyle( color: Colors.black54),
          ),
           Text(
            'Lng: ${position.lng.toStringAsFixed(4)}',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}



