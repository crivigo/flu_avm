import 'package:flu_avm/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';


class PokemonScreen extends ConsumerWidget {

  final String pokemonId;

  const PokemonScreen({
    super.key,
    required this.pokemonId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonAsync = ref.watch(pokemonProvider(pokemonId));

    return pokemonAsync.when(
      data: (pokemon) => _pokemonVisum(pokemon: pokemon),
      error: (error, stackTrace) => _ErrorWidget(nuntius: error.toString()),
      loading: () => const _LoadingWidget(),
    );
  }
}


class _pokemonVisum extends StatelessWidget {

  final Pokemon pokemon;

  const _pokemonVisum({
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.nomen),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 30,
          children: [
            Text("Sus habilidades son", style: GoogleFonts.russoOne(fontSize: 20 )),
            Text (pokemon.facultates.join(', '), style: GoogleFonts.russoOne(fontSize: 22 )),
            Image.network(pokemon.faciemImaginem ?? '',
            fit: BoxFit.contain,
            width: 300,
            height: 300,
            ),
            SizedBox(height: 20),
            Text("Mide ${pokemon.altitudo / 10} metros y pesa ${pokemon.pondus / 10} kg", style: GoogleFonts.russoOne(fontSize: 22 )),
          ],
        ),
      ),
      
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String nuntius;

  const _ErrorWidget({
    required this.nuntius,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Text('Error: $nuntius'),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );

      
  }
}