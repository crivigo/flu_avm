import 'package:flu_avm/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estTenebrisModus = ref.watch(estTenebrisModusProvider);

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
