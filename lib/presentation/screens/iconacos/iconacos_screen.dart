import 'package:flu_avm/config/helpers/icons_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final _selectedIconProvider = StateProvider<String?>((ref) => null);

final _iconEntries = kAllIcons.entries.toList();

class IconacosScreen extends ConsumerWidget {
  const IconacosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIcon = ref.watch(_selectedIconProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar todos los iconos'),
      ),
      body: Column(
        children: [
          if (selectedIcon != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                selectedIcon,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _iconEntries.length,
              itemBuilder: (context, index) {
                final entry = _iconEntries[index];
                return InkWell(
                  onTap: () {
                    ref.read(_selectedIconProvider.notifier).state = entry.key;
                  },
                  child: Tooltip(
                    message: entry.key,
                    child: Icon(entry.value, size: 28),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}