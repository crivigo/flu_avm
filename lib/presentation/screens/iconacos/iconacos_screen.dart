import 'package:flu_avm/config/helpers/icons_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final _selectedIconProvider = StateProvider<String?>((ref) => null);
final _selectedLetterProvider = StateProvider<String?>((ref) => null);

final _iconEntries = kAllIcons.entries.toList();

final _availableLetters = kAllIcons.keys
    .map((k) => k[0].toUpperCase())
    .toSet()
    .toList()
  ..sort();

class IconacosScreen extends ConsumerWidget {
  const IconacosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIcon = ref.watch(_selectedIconProvider);
    final selectedLetter = ref.watch(_selectedLetterProvider);

    final filtered = selectedLetter == null
        ? _iconEntries
        : _iconEntries
            .where((e) => e.key[0].toUpperCase() == selectedLetter)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar todos los iconos'),
      ),
      body: Column(
        children: [
          // Alphabet filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                _LetterChip(
                  label: 'Todas',
                  selected: selectedLetter == null,
                  onTap: () =>
                      ref.read(_selectedLetterProvider.notifier).state = null,
                ),
                ..._availableLetters.map((letter) => _LetterChip(
                      label: letter,
                      selected: selectedLetter == letter,
                      onTap: () => ref
                          .read(_selectedLetterProvider.notifier)
                          .state = letter,
                    )),
              ],
            ),
          ),
          // Selected icon display
          if (selectedIcon != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(kAllIcons[selectedIcon], size: 28),
                  const SizedBox(width: 8),
                  Text(
                    selectedIcon,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final entry = filtered[index];
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

class _LetterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LetterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? color.primary : color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? color.onPrimary : color.onSurface,
          ),
        ),
      ),
    );
  }
}