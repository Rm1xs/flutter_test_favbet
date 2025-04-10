import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_service.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_top_rated_movies.dart';

final apiServiceProvider = Provider((ref) => ApiService());
final movieRepositoryProvider = Provider(
  (ref) => MovieRepositoryImpl(ref.watch(apiServiceProvider)),
);

final topRatedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final repository = ref.watch(movieRepositoryProvider);
  return GetTopRatedMovies(repository).call();
});
