import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PokemonScreen extends StatelessWidget {

  final String pokemonId;

  const PokemonScreen({
    super.key,
    required this.pokemonId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon #$pokemonId'),
      ),
      body: Center(
        child: Text(
          'Datos del Pokémon: $pokemonId',
          style: GoogleFonts.russoOne(fontSize: 22),
        ),
      ),
    );
  }
}