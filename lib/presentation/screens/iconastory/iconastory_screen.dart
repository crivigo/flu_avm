import 'package:flu_avm/presentation/providers/iconastory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final state = ref.watch(iconaStoryProvider);
    final notifier = ref.read(iconaStoryProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IconaStory'),
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
        GamePhase.start => _StartView(onStart: notifier.startGame),
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
            onVote: notifier.castVote,
          ),
        GamePhase.results => _ResultsView(
            state: state,
            onReset: notifier.reset,
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
      children: icons.map((e) {
        return Tooltip(
          message: e.key,
          child: Icon(e.value, size: iconSize),
        );
      }).toList(),
    );
  }
}

class _StartView extends StatelessWidget {
  final VoidCallback onStart;
  const _StartView({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.auto_stories_outlined, size: 80),
          const SizedBox(height: 24),
          const Text(
            'IconaStory',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Aparecen unos iconos.\nCada jugador escribe una frase que los represente.\nLuego todos votan quien escribio cada frase.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 48),
          FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.casino_outlined),
            label: const Text('Empezar partida'),
          ),
        ],
      ),
    );
  }
}

class _ShowingIconsView extends StatelessWidget {
  final IconaStoryState state;
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
          const Text(
            'Estos son los iconos de la ronda',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 32),
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
                'añadida${phraseCount == 1 ? '' : 's'}',
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
            label: const Text('Añadir frase'),
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
          const Text(
            'Escribe tu frase para estos iconos',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}

class _VotingView extends StatelessWidget {
  final IconaStoryState state;
  final void Function(String alias) onVote;

  const _VotingView({required this.state, required this.onVote});

  @override
  Widget build(BuildContext context) {
    final total = state.phrases.length;
    final current = state.currentVotingIndex + 1;
    final phrase = state.currentVotingPhrase!;
    final aliases = state.allAliases;

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
          const SizedBox(height: 16),
          _IconsRow(icons: state.icons, iconSize: 40),
          const SizedBox(height: 20),
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
          const SizedBox(height: 24),
          const Text(
            'Quien escribio esta frase?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...aliases.map((alias) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OutlinedButton(
                  onPressed: () => onVote(alias),
                  child: Text(alias, style: const TextStyle(fontSize: 16)),
                ),
              )),
        ],
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  final IconaStoryState state;
  final VoidCallback onReset;

  const _ResultsView({required this.state, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final phrases = state.phrases;
    final votes = state.votes;
    final colorScheme = Theme.of(context).colorScheme;

    int correct = 0;
    for (var i = 0; i < phrases.length; i++) {
      if (votes[i] == phrases[i].alias) correct++;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.emoji_events_outlined, size: 64),
          const SizedBox(height: 12),
          const Text(
            'Resultados',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            '$correct de ${phrases.length} acertadas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _IconsRow(icons: state.icons, iconSize: 36),
          const SizedBox(height: 24),
          ...List.generate(phrases.length, (i) {
            final phrase = phrases[i];
            final voted = votes[i];
            final isCorrect = voted == phrase.alias;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCorrect
                    ? colorScheme.primaryContainer
                    : colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '"${phrase.phrase}"',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                            color: isCorrect
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _ResultRow(
                    label: 'Escrita por',
                    value: phrase.alias,
                    color: isCorrect
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onErrorContainer,
                  ),
                  _ResultRow(
                    label: 'Votado',
                    value: voted ?? '-',
                    color: isCorrect
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onErrorContainer,
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          FilledButton.icon(
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

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 13, color: color),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
