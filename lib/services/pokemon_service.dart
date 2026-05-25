import 'package:dio/dio.dart';
import 'package:flu_avm/mappers/pokemon_mapper.dart';


class PokemonService {

  static getPokemon<String>(String pokemonID) async {
    
    final dio = Dio();

    try {
      final responsio = await dio.get('https://pokeapi.co/api/v2/pokemon/$pokemonID');

      final pokemon = PokemonMapper.pokeApiPokemonToEntity(responsio.data);
      return (pokemon, 'Data obtenida correctamente');
    } catch (e) {
      
      return (null, 'No se pudo obtener el pokemon');
    }

  }
}

