import 'package:flu_avm/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChartaScreen extends StatefulWidget {
  const ChartaScreen({super.key});

  @override
  State<ChartaScreen> createState() => _ChartaScreenState();
}

class _ChartaScreenState extends State<ChartaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapas'),
      ),
      body: const Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color:   Colors.blueGrey,
          child: Center(
            child: Text(
              'Mapa a pantalla completa',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
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