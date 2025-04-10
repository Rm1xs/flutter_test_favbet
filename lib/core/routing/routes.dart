import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/top_movie/presentation/screens/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MovieListScreen()),
      // GoRoute(
      //   path: '/movie/:id',
      //   builder: (context, state) {
      //     final movieId = int.parse(state.pathParameters['id']!);
      //     return MovieDetailsScreen(movieId: movieId);
      //   },
      // ),
      // GoRoute(
      //   path: '/search',
      //   builder: (context, state) => const SearchScreen(),
      // ),
    ],
  );
});
