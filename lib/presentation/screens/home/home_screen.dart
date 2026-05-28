import 'package:flu_avm/config/menu/menu_item.dart';
import 'package:flu_avm/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estTenebrisModus = ref.watch(estTenebrisModusProvider);
    final numerusPantallarum = appMenuItems.length;
    const numerusWebSockets = 2;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Primera row: icono + título + toggle light/dark
              Row(
                children: [
                  const Icon(Icons.data_object_rounded, size: 32),
                  const SizedBox(width: 8),
                  Text(
                    'Flu Avm',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      estTenebrisModus
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                    ),
                    onPressed: () {
                      ref.read(estTenebrisModusProvider.notifier).state =
                          !estTenebrisModus;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ColorFiltered(
                      colorFilter: estTenebrisModus
                          ? const ColorFilter.matrix([
                              -1, 0, 0, 0, 255,
                              0, -1, 0, 0, 255,
                              0, 0, -1, 0, 255,
                              0, 0, 0, 1, 0,
                            ])
                          : const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.dst,
                            ),
                      child: const Image(
                        image: AssetImage('assets/images/movil.png'),
                        fit: BoxFit.contain,
                        height: 80,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ColorFiltered(
                      colorFilter: estTenebrisModus
                          ? const ColorFilter.matrix([
                              -1, 0, 0, 0, 255,
                              0, -1, 0, 0, 255,
                              0, 0, -1, 0, 255,
                              0, 0, 0, 1, 0,
                            ])
                          : const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.dst,
                            ),
                      child: const Image(
                        image: AssetImage('assets/images/puntos.png'),
                        fit: BoxFit.contain,
                        height: 80,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ColorFiltered(
                      colorFilter: estTenebrisModus
                          ? const ColorFilter.matrix([
                              -1, 0, 0, 0, 255,
                              0, -1, 0, 0, 255,
                              0, 0, -1, 0, 255,
                              0, 0, 0, 1, 0,
                            ])
                          : const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.dst,
                            ),
                      child: const Image(
                        image: AssetImage('assets/images/servidor.png'),
                        fit: BoxFit.contain,
                        height: 80,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      child: Text(
                        'conectado',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'WebSockets en vivo',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Aprende a construir apps con datos en tiempo real en Flutter. Dos ejemplos prácticos te esperan dentro.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(18),
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: const Image(
                                image: AssetImage('assets/images/mapa.jpg'),
                                fit: BoxFit.cover,
                                height: 90,
                                width: double.infinity,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Mapas',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ubicacion en tiempo real',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(18),
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: const Image(
                                image: AssetImage('assets/images/votaciones.jpg'),
                                fit: BoxFit.cover,
                                height: 90,
                                width: double.infinity,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Votaciones',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Grafico que se actualiza',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$numerusPantallarum',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PANTALLAS',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$numerusWebSockets',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'websockets',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'CV',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Cristian Vilar',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Botón Comenzar
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Comenzar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
