import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flu_avm/config/helpers/icons_map.dart';
import 'package:flu_avm/presentation/providers/iconastory_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'savedAt': savedAt.toIso8601String(),
      'icons': icons.map((e) => e.key).toList(),
      'phrases': phrases
          .map(
            (p) => {
              'phrase': p.phrase,
              'alias': p.alias,
            },
          )
          .toList(),
    };
  }

  factory SavedHistoriconica.fromJson(Map<String, dynamic> json) {
    final iconKeys = (json['icons'] as List<dynamic>? ?? <dynamic>[])
        .map((e) => e.toString())
        .toList();

    final decodedIcons = iconKeys
        .map(
          (key) => MapEntry(
            key,
            kAllIcons[key] ?? Icons.help_outline,
          ),
        )
        .toList();

    final decodedPhrases = (json['phrases'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(
          (p) => PhraseEntry(
            phrase: (p['phrase'] ?? '').toString(),
            alias: (p['alias'] ?? '').toString(),
          ),
        )
        .toList();

    return SavedHistoriconica(
      id: (json['id'] ?? '').toString(),
      savedAt: DateTime.tryParse((json['savedAt'] ?? '').toString()) ??
          DateTime.now(),
      icons: decodedIcons,
      phrases: decodedPhrases,
    );
  }
}

class SavedHistoriconicasNotifier
    extends Notifier<List<SavedHistoriconica>> {
  static const _storageKey = 'saved_historiconicas_v1';
  Future<void>? _hydrateFuture;

  @override
  List<SavedHistoriconica> build() {
    _hydrateFuture = _loadFromStorage();
    return const [];
  }

  Future<void> _ensureHydrated() async {
    await _hydrateFuture;
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      final loaded = decoded
          .whereType<Map<String, dynamic>>()
          .map(SavedHistoriconica.fromJson)
          .toList();

      loaded.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      state = loaded;
    } catch (_) {
      state = const [];
    }
  }

  Future<void> _persist(List<SavedHistoriconica> value) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(value.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, payload);
  }

  Future<void> save(
    List<MapEntry<String, IconData>> icons,
    List<PhraseEntry> phrases,
  ) async {
    await _ensureHydrated();

    final entry = SavedHistoriconica(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      savedAt: DateTime.now(),
      icons: icons,
      phrases: phrases,
    );
    final nextState = [entry, ...state];
    state = nextState;
    await _persist(nextState);
  }

  Future<void> delete(String id) async {
    await _ensureHydrated();

    final nextState = state.where((s) => s.id != id).toList();
    state = nextState;
    await _persist(nextState);
  }
}

final savedHistoriconicasProvider =
    NotifierProvider<SavedHistoriconicasNotifier, List<SavedHistoriconica>>(
  SavedHistoriconicasNotifier.new,
);
