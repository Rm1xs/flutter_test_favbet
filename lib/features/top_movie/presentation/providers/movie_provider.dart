import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_service.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_top_rated_movies.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final movieRepositoryProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MovieRepositoryImpl(apiService);
});

class TopRatedMoviesState {
  TopRatedMoviesState({
    this.movies = const [],
    this.currentPage = 1,
    this.isLoading = false,

    ///totalPages > 500 = Error
    this.totalPages = 500,
  });
  final List<Movie> movies;
  final int currentPage;
  final bool isLoading;
  final int totalPages;

  TopRatedMoviesState copyWith({
    List<Movie>? movies,
    int? currentPage,
    bool? isLoading,
    int? totalPages,
  }) {
    return TopRatedMoviesState(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class TopRatedMoviesNotifier extends StateNotifier<TopRatedMoviesState> {
  TopRatedMoviesNotifier(this._getTopRatedMovies)
    : super(TopRatedMoviesState()) {
    fetchMovies();
  }
  final GetTopRatedMovies _getTopRatedMovies;

  Future<void> fetchMovies({int page = 1}) async {
    if (state.isLoading || page < 1 || page > state.totalPages) {
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final newMovies = await _getTopRatedMovies(page: page);
      state = state.copyWith(
        movies: newMovies,
        currentPage: page,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}

final topRatedMoviesProvider =
    StateNotifierProvider<TopRatedMoviesNotifier, TopRatedMoviesState>((ref) {
      final repository = ref.watch(movieRepositoryProvider);
      return TopRatedMoviesNotifier(GetTopRatedMovies(repository));
    });
