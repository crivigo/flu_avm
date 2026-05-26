import 'package:flu_avm/presentation/providers/iconastory_provider.dart';
import 'package:flu_avm/presentation/providers/saved_historiconicas_provider.dart';
import 'package:flu_avm/presentation/screens/iconastory/saved_historiconicas_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class IconaStoryScreen extends ConsumerStatefulWidget {
  const IconaStoryScreen({super.key});

  @override
  ConsumerState<IconaStoryScreen> createState() => _IconaStoryScreenState();
}

class _IconaStoryScreenState extends ConsumerState<IconaStoryScreen> {
  final _phraseController = TextEditingController();
  final _aliasController = TextEditingController();

  @override
  void dispose() {
    _phraseController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historiconicaProvider);
    final notifier = ref.read(historiconicaProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Histori\u00f3nica',
          style: GoogleFonts.anton(fontSize: 22, letterSpacing: 1),
        ),
        actions: [
          if (state.phase != GamePhase.start)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Nueva partida',
              onPressed: notifier.reset,
            ),
        ],
      ),
      body: switch (state.phase) {
        GamePhase.start => _StartView(
            onStart: notifier.startGame,
            onViewSaved: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SavedHistoriconicasScreen(),
              ),
            ),
          ),
        GamePhase.showingIcons => _ShowingIconsView(
            state: state,
            onAddPhrase: () {
              _phraseController.clear();
              _aliasController.clear();
              notifier.startAddingPhrase();
            },
            onFinish: notifier.finishWriting,
          ),
        GamePhase.addingPhrase => _AddPhraseView(
            phraseController: _phraseController,
            aliasController: _aliasController,
            icons: state.icons,
            onSave: (phrase, alias) => notifier.savePhrase(phrase, alias),
            onCancel: notifier.cancelAddingPhrase,
          ),
        GamePhase.voting => _VotingView(
            state: state,
            onAddVote: notifier.addVote,
            onRemoveVote: notifier.removeVote,
            onNext: notifier.nextPhrase,
          ),
        GamePhase.results => _ResultsView(
            state: state,
            onReset: notifier.reset,
            onSave: () {
              ref
                  .read(savedHistoriconicasProvider.notifier)
                  .save(state.icons, state.phrases);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Historia guardada'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
      },
    );
  }
}

class _IconsRow extends StatelessWidget {
  final List<MapEntry<String, IconData>> icons;
  final double iconSize;

  const _IconsRow({required this.icons, this.iconSize = 52});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: icons
          .map((e) => Tooltip(message: e.key, child: Icon(e.value, size: iconSize)))
          .toList(),
    );
  }
}

class _StartView extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onViewSaved;
  const _StartView({required this.onStart, required this.onViewSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.auto_stories_outlined, size: 80),
          const SizedBox(height: 20),
          Text(
            'Histori\u00f3nica',
            textAlign: TextAlign.center,
            style: GoogleFonts.anton(fontSize: 40, letterSpacing: 2),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Aparecen unos iconos. Cada jugador escribe la frase que le inspiran.\n\n'
              'Despues todos votan quien escribio cada frase. Puedes votar varias veces al mismo jugador.\n\n'
              'Gana el jugador cuya frase menos gente identifica como suya.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
          ),
          const SizedBox(height: 40),
          FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.casino_outlined),
            label: const Text('Empezar partida'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onViewSaved,
            icon: const Icon(Icons.bookmark_outline),
            label: const Text('Historiónicas guardadas'),
          ),
        ],
      ),
    );
  }
}

class _ShowingIconsView extends StatelessWidget {
  final HistoriconicaState state;
  final VoidCallback onAddPhrase;
  final VoidCallback onFinish;

  const _ShowingIconsView({
    required this.state,
    required this.onAddPhrase,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final phraseCount = state.phrases.length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            'Iconos de la ronda',
            textAlign: TextAlign.center,
            style: GoogleFonts.anton(fontSize: 20, letterSpacing: 1),
          ),
          const SizedBox(height: 28),
          _IconsRow(icons: state.icons, iconSize: 64),
          const Spacer(),
          if (phraseCount > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$phraseCount frase${phraseCount == 1 ? '' : 's'} '
                'a\u00f1adida${phraseCount == 1 ? '' : 's'}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          FilledButton.icon(
            onPressed: onAddPhrase,
            icon: const Icon(Icons.add_comment_outlined),
            label: const Text('A\u00f1adir frase'),
          ),
          if (phraseCount > 0) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onFinish,
              icon: const Icon(Icons.how_to_vote_outlined),
              label: const Text('Terminar de escribir, pasar a votaciones'),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _AddPhraseView extends StatelessWidget {
  final TextEditingController phraseController;
  final TextEditingController aliasController;
  final List<MapEntry<String, IconData>> icons;
  final void Function(String phrase, String alias) onSave;
  final VoidCallback onCancel;

  const _AddPhraseView({
    required this.phraseController,
    required this.aliasController,
    required this.icons,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          _IconsRow(icons: icons, iconSize: 40),
          const SizedBox(height: 24),
          Text(
            'Tu frase para estos iconos',
            textAlign: TextAlign.center,
            style: GoogleFonts.anton(fontSize: 18, letterSpacing: 1),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: phraseController,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Tu frase',
              hintText: 'Escribe lo que ves en los iconos...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: aliasController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Tu nombre o alias',
              hintText: 'Ej: Pepito, El Misterioso...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              final phrase = phraseController.text.trim();
              final alias = aliasController.text.trim();
              if (phrase.isEmpty || alias.isEmpty) return;
              onSave(phrase, alias);
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('Guardar frase'),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onCancel, child: const Text('Cancelar')),
        ],
      ),
    );
  }
}

class _VotingView extends StatelessWidget {
  final HistoriconicaState state;
  final void Function(String alias) onAddVote;
  final void Function(String alias) onRemoveVote;
  final VoidCallback onNext;

  const _VotingView({
    required this.state,
    required this.onAddVote,
    required this.onRemoveVote,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final total = state.phrases.length;
    final current = state.currentVotingIndex + 1;
    final phrase = state.currentVotingPhrase!;
    final aliases = state.allAliases;
    final currentVotes = state.currentPhraseVotes;
    final isLast = state.currentVotingIndex == total - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Frase $current de $total',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 12),
          _IconsRow(icons: state.icons, iconSize: 36),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '"${phrase.phrase}"',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Votad quien la escribi\u00f3',
            textAlign: TextAlign.center,
            style: GoogleFonts.anton(fontSize: 17, letterSpacing: 1),
          ),
          const SizedBox(height: 4),
          Text(
            'Cada jugador vota. Se puede votar varias veces al mismo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 16),
          ...aliases.map((alias) {
            final count = currentVotes.where((v) => v == alias).length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => onAddVote(alias),
                      child: Text(alias, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => onRemoveVote(alias),
                      child: Chip(
                        label: Text(
                          '$count',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: onNext,
            icon: Icon(isLast ? Icons.bar_chart : Icons.arrow_forward),
            label: Text(isLast ? 'Ver resultados' : 'Siguiente frase'),
          ),
        ],
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  final HistoriconicaState state;
  final VoidCallback onReset;
  final VoidCallback onSave;

  const _ResultsView({
    required this.state,
    required this.onReset,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scores = state.correctGuessesPerPlayer;
    final winnerList = state.winners;
    final sortedAliases = state.allAliases
      ..sort((a, b) => (scores[a] ?? 0).compareTo(scores[b] ?? 0));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Resultados',
            textAlign: TextAlign.center,
            style: GoogleFonts.anton(fontSize: 36, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          _IconsRow(icons: state.icons, iconSize: 32),
          const SizedBox(height: 20),
          if (winnerList.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text(
                    winnerList.length == 1 ? '\ud83c\udfc6 Ganador' : '\ud83c\udfc6 Empate',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    winnerList.join(' y '),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.anton(
                      fontSize: 26,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    'Menos adivinados: ${scores[winnerList.first]} voto${scores[winnerList.first] == 1 ? '' : 's'} correctos',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            'Clasificaci\u00f3n',
            style: GoogleFonts.anton(fontSize: 18, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          ...sortedAliases.map((alias) {
            final isWinner = winnerList.contains(alias);
            final score = scores[alias] ?? 0;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isWinner
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  if (isWinner) const Text('\ud83c\udfc6 ', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: Text(
                      alias,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isWinner
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    '$score voto${score == 1 ? '' : 's'} correcto${score == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 13,
                      color: isWinner
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          Text(
            'Detalle por frase',
            style: GoogleFonts.anton(fontSize: 18, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          ...List.generate(state.phrases.length, (i) {
            final phrase = state.phrases[i];
            final phraseVotes = state.votes[i];
            final correctCount =
                phraseVotes.where((v) => v == phrase.alias).length;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${phrase.phrase}"',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Escrita por: ${phrase.alias}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phraseVotes.isEmpty
                        ? 'Sin votos'
                        : 'Votos: ${phraseVotes.join(', ')} ($correctCount correcto${correctCount == 1 ? '' : 's'})',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('Guardar historia'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.replay),
            label: const Text('Nueva partida'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
