import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flu_avm/config/helpers/icons_map.dart';
import 'package:flu_avm/presentation/providers/iconastory_provider.dart';

class SavedHistoriconica {
  final String id;
  final DateTime savedAt;
  final List<MapEntry<String, IconData>> icons;
  final List<PhraseEntry> phrases;

  const SavedHistoriconica({
    required this.id,
    required this.savedAt,
    required this.icons,
    required this.phrases,
  });
}

class SavedHistoriconicasNotifier
    extends Notifier<List<SavedHistoriconica>> {
  @override
  List<SavedHistoriconica> build() => _buildSampleData();

  static List<SavedHistoriconica> _buildSampleData() {
    // Pick 6 base icons deterministically from the map
    final sampleIcons = kAllIcons.entries
        .where(
          (e) =>
              !e.key.endsWith('_outlined') &&
              !e.key.endsWith('_rounded') &&
              !e.key.endsWith('_sharp') &&
              !e.key.endsWith('_filled'),
        )
        .take(6)
        .map((e) => MapEntry(e.key, e.value))
        .toList();

    return [
      SavedHistoriconica(
        id: 'sample-1',
        savedAt: DateTime.now().subtract(const Duration(hours: 2)),
        icons: sampleIcons,
        phrases: const [
          PhraseEntry(phrase: 'frase1', alias: 'nick1'),
          PhraseEntry(phrase: 'frase2', alias: 'nick2'),
          PhraseEntry(phrase: 'frase3', alias: 'nick3'),
        ],
      ),
    ];
  }

  void delete(String id) {
    state = state.where((s) => s.id != id).toList();
  }
}

final savedHistoriconicasProvider =
    NotifierProvider<SavedHistoriconicasNotifier, List<SavedHistoriconica>>(
  SavedHistoriconicasNotifier.new,
);
