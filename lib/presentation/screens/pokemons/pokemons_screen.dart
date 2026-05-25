import 'package:flu_avm/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PokemonsScreen extends StatelessWidget {
  const PokemonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  PokemonsVisum(),
    );
  }
}

class PokemonsVisum extends ConsumerStatefulWidget {
  const PokemonsVisum({super.key});

  @override
  ConsumerState<PokemonsVisum> createState() => _PokemonsVisumState();
}

class _PokemonsVisumState extends ConsumerState<PokemonsVisum> {

  bool oneratusEst = false;

final scrollController = ScrollController();

@override
void initState() {
scrollController.addListener(() {
  if (scrollController.position.pixels + 200 > scrollController.position.maxScrollExtent) {
    vadeProximamPagina();
  } 
});

  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          title: const Text('Pokemons'),
          floating: true,
          backgroundColor: Theme.of(context).secondaryHeaderColor.withValues(  alpha: 150),
        ),
        _PokemonGrid()
        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //     (context, index) => ListTile(
        //       title: Text('Pokemon #$index'),
        //     ),
        //     childCount: 100,
        //   ),
        // )
      ],
      
    );
  }

Future vadeProximamPagina() async {

    if (oneratusEst) return;

    oneratusEst = true;

    await Future.delayed(const Duration(seconds: 2));

  ref.read(pokemonIdsProvider.notifier).update((state) => [
        ...state,
        ...List.generate(30, (index) => state.length + index + 1)
  ]);
  oneratusEst = false;

  movereScrollAdDescendit();
}

void movereScrollAdDescendit(){
  if (scrollController.position.pixels + 100 <= scrollController.position.maxScrollExtent) {
    return;
  }
  scrollController.animateTo(
    scrollController.position.pixels + 200,
    duration: const Duration(milliseconds: 300),
    curve: Curves.fastOutSlowIn
  );
}

}

class _PokemonGrid extends ConsumerWidget {
  const _PokemonGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final pokemonIds = ref.watch(pokemonIdsProvider);

    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
        itemCount: pokemonIds.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.push('/request/${index + 1}'); 
          },
          child: Image.network(
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png',
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}