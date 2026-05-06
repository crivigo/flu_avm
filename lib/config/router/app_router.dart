
import 'package:go_router/go_router.dart';
import 'package:flu_avm/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => DomusScreen(),
    ),
    GoRoute(
      path: '/numerator-river',
      builder: (context, state) => NumeratorScreen(),
    ),
  ]
); 