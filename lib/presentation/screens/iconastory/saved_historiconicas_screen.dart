import 'package:flu_avm/presentation/providers/saved_historiconicas_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedHistoriconicasScreen extends ConsumerWidget {
  const SavedHistoriconicasScreen({super.key});
  static const _deepGreen = Color(0xFF0B5D49);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseTheme = Theme.of(context);
    final historionicaTheme = ThemeData(
      useMaterial3: true,
      brightness: baseTheme.brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _deepGreen,
        brightness: baseTheme.brightness,
      ),
      textTheme: baseTheme.textTheme,
    );
    final saved = ref.watch(savedHistoriconicasProvider);
    final notifier = ref.read(savedHistoriconicasProvider.notifier);

    return Theme(
      data: historionicaTheme,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: historionicaTheme.colorScheme.primaryContainer,
          foregroundColor: historionicaTheme.colorScheme.onPrimaryContainer,
          title: Text(
            'Histori\u00f3nicas guardadas',
            style: GoogleFonts.anton(fontSize: 18, letterSpacing: 1),
          ),
        ),
        body: saved.isEmpty
            ? _EmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: saved.length,
                itemBuilder: (context, i) => _SavedCard(
                  entry: saved[i],
                  onDelete: () => _confirmDelete(context, notifier, saved[i].id),
                ),
              ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SavedHistoriconicasNotifier notifier,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Borrar historia'),
        content: const Text('\u00bfSeguro que quieres borrar esta historia?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await notifier.delete(id);
    }
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_stories_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay historias guardadas',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  final SavedHistoriconica entry;
  final VoidCallback onDelete;

  const _SavedCard({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final d = entry.savedAt;
    final dateStr =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: colorScheme.error,
                  tooltip: 'Borrar',
                  onPressed: onDelete,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: entry.icons
                  .map(
                    (e) => Tooltip(
                      message: e.key,
                      child: Icon(e.value, size: 36),
                    ),
                  )
                  .toList(),
            ),
            const Divider(height: 24),
            Text(
              'Frases',
              style: GoogleFonts.anton(fontSize: 13, letterSpacing: 0.5),
            ),
            const SizedBox(height: 6),
            ...entry.phrases.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2, right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        p.alias,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        p.phrase,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
