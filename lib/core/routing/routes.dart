import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/movie_details/presentation/screens/movie_details_screen.dart';
import '../../features/search/presentation/screens/search_movies_screen.dart';
import '../../features/top_movie/presentation/screens/movie_list_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MovieListScreen()),
      GoRoute(
        path: '/search',
        builder:
            (context, state) =>
                SearchMoviesScreen(initialQuery: state.extra as String? ?? ''),
      ),
      GoRoute(
        path: '/movie/:movieId',
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['movieId']!);
          return MovieDetailsScreen(movieId: movieId);
        },
      ),
    ],
  );
});
