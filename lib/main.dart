import 'package:flu_avm/config/config.dart';
import 'package:flu_avm/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(mapboxAccessToken);
  

  runApp(
    const ProviderScope(
    child: MainApp(),
    )
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estTenebrisModus = ref.watch(estTenebrisModusProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme(
        tenebrisModusEts: estTenebrisModus,
        electusColor: Colors.pink.shade900
        ).getTheme(),
      routerConfig: appRouter,
    );
  }
}
