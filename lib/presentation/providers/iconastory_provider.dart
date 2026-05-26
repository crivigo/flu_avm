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

class IconaStoryState {
  final GamePhase phase;
  final List<MapEntry<String, IconData>> icons;
  final List<PhraseEntry> phrases;
  final int currentVotingIndex;
  final List<String?> votes;

  const IconaStoryState({
    this.phase = GamePhase.start,
    this.icons = const [],
    this.phrases = const [],
    this.currentVotingIndex = 0,
    this.votes = const [],
  });

  IconaStoryState copyWith({
    GamePhase? phase,
    List<MapEntry<String, IconData>>? icons,
    List<PhraseEntry>? phrases,
    int? currentVotingIndex,
    List<String?>? votes,
  }) {
    return IconaStoryState(
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
}

class IconaStoryNotifier extends Notifier<IconaStoryState> {
  static const int _iconCount = 6;

  @override
  IconaStoryState build() => const IconaStoryState();

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

    state = IconaStoryState(
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
        PhraseEntry(phrase: phrase.trim(), alias: alias.trim())
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
      votes: List.filled(shuffled.length, null),
    );
  }

  void castVote(String alias) {
    final updatedVotes = [...state.votes];
    updatedVotes[state.currentVotingIndex] = alias;
    final nextIndex = state.currentVotingIndex + 1;
    state = state.copyWith(
      votes: updatedVotes,
      currentVotingIndex: nextIndex,
      phase: nextIndex >= state.phrases.length
          ? GamePhase.results
          : GamePhase.voting,
    );
  }

  void reset() => state = const IconaStoryState();
}

final iconaStoryProvider =
    NotifierProvider<IconaStoryNotifier, IconaStoryState>(
  IconaStoryNotifier.new,
);
