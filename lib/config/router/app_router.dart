import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flu_avm/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => DomusScreen(),
    ),
    GoRoute(
      path: '/numerator-river',
      builder: (context, state) => NumeratorScreen(),
    ),
    GoRoute(
      path: '/bands',
      builder: (context, state) => BandsScreen(),
    ),
    GoRoute(
      path: '/charta',
      builder: (context, state) => ChartaScreen(),
    ),
    GoRoute(
      path: '/request',
      builder: (context, state) => PokemonsScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state){
            final id = state.pathParameters['id']??'1';
            return PokemonScreen(pokemonId: id);
          }
        ),
      ]
        // GoRoute(
    ),
    GoRoute(
      path: '/iconacos',
      builder: (context, state) => IconacosScreen(),
    ),
    GoRoute(
      path: '/iconastory',
      builder: (context, state) => IconaStoryScreen(),
    ),
  ]
); 