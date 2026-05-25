import 'package:dio/dio.dart';


class PokemonService {

  static getPokemon<String>(String pokemonID) async {
    
    final dio = Dio();

    try {
      final responsio = await dio.get('https://pokeapi.co/api/v2/pokemon/$pokemonID');
      
    } catch (e) {
      print('Error fetching pokemon: $e');
      return null;
    }

  }
}

