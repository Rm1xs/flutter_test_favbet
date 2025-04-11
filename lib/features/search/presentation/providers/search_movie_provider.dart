import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_service.dart';
import '../../data/repositories/search_movie_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_search_movies.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final movieRepositoryProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return SearchMovieRepositoryImpl(apiService);
});

class SearchMoviesState {
  SearchMoviesState({
    this.movies = const [],
    this.currentPage = 1,
    this.isLoading = false,
    this.totalPages = 1,
    this.query = '',
  });
  final List<Movie> movies;
  final int currentPage;
  final bool isLoading;
  final int totalPages;
  final String query;

  SearchMoviesState copyWith({
    List<Movie>? movies,
    int? currentPage,
    bool? isLoading,
    int? totalPages,
    String? query,
  }) {
    return SearchMoviesState(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      totalPages: totalPages ?? this.totalPages,
      query: query ?? this.query,
    );
  }
}

class SearchMoviesNotifier extends StateNotifier<SearchMoviesState> {
  SearchMoviesNotifier(this._searchMovies) : super(SearchMoviesState());
  final GetSearchMovies _searchMovies;

  Future<void> searchMovies({required String query, int page = 1}) async {
    if (state.isLoading || query.isEmpty || page < 1) {
      return;
    }

    state = state.copyWith(isLoading: true, query: query);

    try {
      final response = await _searchMovies(query: query, page: page);
      final totalPages = await _fetchTotalPages(query);
      state = state.copyWith(
        movies: response,
        currentPage: page,
        totalPages: totalPages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<int> _fetchTotalPages(String query) async {
    final response = await _searchMovies(query: query, page: 1);
    final totalResults = response.isNotEmpty ? response.length : 0;
    return (totalResults / 20).ceil();
  }

  void clearSearch() {
    state = state.copyWith(
      movies: [],
      currentPage: 1,
      totalPages: 1,
      query: '',
      isLoading: false,
    );
  }
}

final searchMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, SearchMoviesState>((ref) {
      final repository = ref.watch(movieRepositoryProvider);
      return SearchMoviesNotifier(GetSearchMovies(repository));
    });
