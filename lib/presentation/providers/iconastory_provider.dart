import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flu_avm/config/helpers/icons_map.dart';

class PhraseEntry {
  final String phrase;
  final String alias;
  const PhraseEntry({required this.phrase, required this.alias});
}

enum GamePhase { start, showingIcons, addingPhrase, voting, results }

class HistoriconicaState {
  final GamePhase phase;
  final List<MapEntry<String, IconData>> icons;
  final List<PhraseEntry> phrases;
  final int currentVotingIndex;
  final List<List<String>> votes;

  const HistoriconicaState({
    this.phase = GamePhase.start,
    this.icons = const [],
    this.phrases = const [],
    this.currentVotingIndex = 0,
    this.votes = const [],
  });

  HistoriconicaState copyWith({
    GamePhase? phase,
    List<MapEntry<String, IconData>>? icons,
    List<PhraseEntry>? phrases,
    int? currentVotingIndex,
    List<List<String>>? votes,
  }) {
    return HistoriconicaState(
      phase: phase ?? this.phase,
      icons: icons ?? this.icons,
      phrases: phrases ?? this.phrases,
      currentVotingIndex: currentVotingIndex ?? this.currentVotingIndex,
      votes: votes ?? this.votes,
    );
  }

  List<String> get allAliases =>
      phrases.map((p) => p.alias).toSet().toList()..sort();

  PhraseEntry? get currentVotingPhrase =>
      currentVotingIndex < phrases.length ? phrases[currentVotingIndex] : null;

  List<String> get currentPhraseVotes =>
      currentVotingIndex < votes.length ? votes[currentVotingIndex] : [];

  Map<String, int> get correctGuessesPerPlayer {
    final result = <String, int>{};
    for (final alias in allAliases) {
      result[alias] = 0;
    }
    for (var i = 0; i < phrases.length; i++) {
      final author = phrases[i].alias;
      if (i < votes.length) {
        final correct = votes[i].where((v) => v == author).length;
        result[author] = (result[author] ?? 0) + correct;
      }
    }
    return result;
  }

  List<String> get winners {
    final scores = correctGuessesPerPlayer;
    if (scores.isEmpty) return [];
    final minScore = scores.values.reduce((a, b) => a < b ? a : b);
    return scores.entries
        .where((e) => e.value == minScore)
        .map((e) => e.key)
        .toList();
  }
}

class HistoriconicaNotifier extends Notifier<HistoriconicaState> {
  static const int _iconCount = 6;

  @override
  HistoriconicaState build() => const HistoriconicaState();

  void startGame() {
    final rng = Random();
    final baseKeys = kAllIcons.keys
        .where((k) =>
            !k.endsWith('_outlined') &&
            !k.endsWith('_rounded') &&
            !k.endsWith('_sharp') &&
            !k.endsWith('_filled'))
        .toList()
      ..shuffle(rng);

    final picked = baseKeys
        .take(_iconCount)
        .map((k) => MapEntry(k, kAllIcons[k]!))
        .toList();

    state = HistoriconicaState(
      phase: GamePhase.showingIcons,
      icons: picked,
    );
  }

  void startAddingPhrase() =>
      state = state.copyWith(phase: GamePhase.addingPhrase);

  void cancelAddingPhrase() =>
      state = state.copyWith(phase: GamePhase.showingIcons);

  void savePhrase(String phrase, String alias) {
    state = state.copyWith(
      phrases: [
        ...state.phrases,
        PhraseEntry(phrase: phrase.trim(), alias: alias.trim()),
      ],
      phase: GamePhase.showingIcons,
    );
  }

  void finishWriting() {
    final shuffled = [...state.phrases]..shuffle(Random());
    state = state.copyWith(
      phrases: shuffled,
      phase: GamePhase.voting,
      currentVotingIndex: 0,
      votes: List.generate(shuffled.length, (_) => []),
    );
  }

  void addVote(String alias) {
    final updatedVotes = state.votes.map((v) => [...v]).toList();
    updatedVotes[state.currentVotingIndex].add(alias);
    state = state.copyWith(votes: updatedVotes);
  }

  void removeVote(String alias) {
    final updatedVotes = state.votes.map((v) => [...v]).toList();
    final current = updatedVotes[state.currentVotingIndex];
    final idx = current.lastIndexOf(alias);
    if (idx >= 0) current.removeAt(idx);
    state = state.copyWith(votes: updatedVotes);
  }

  void nextPhrase() {
    final nextIndex = state.currentVotingIndex + 1;
    state = state.copyWith(
      currentVotingIndex: nextIndex,
      phase: nextIndex >= state.phrases.length
          ? GamePhase.results
          : GamePhase.voting,
    );
  }

  void reset() => state = const HistoriconicaState();
}

final historiconicaProvider =
    NotifierProvider<HistoriconicaNotifier, HistoriconicaState>(
  HistoriconicaNotifier.new,
);
