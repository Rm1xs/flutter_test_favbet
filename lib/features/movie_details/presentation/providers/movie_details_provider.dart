import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_service.dart';
import '../../data/repositories/movie_details_repository_impl.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/usecases/get_movie_details.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final movieRepositoryProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MovieDetailsRepositoryImpl(apiService);
});

class MovieDetailsState {
  MovieDetailsState({this.movieDetails, this.isLoading = false, this.error});

  final MovieDetails? movieDetails;
  final bool isLoading;
  final Object? error;

  MovieDetailsState copyWith({
    MovieDetails? movieDetails,
    bool? isLoading,
    Object? error,
  }) {
    return MovieDetailsState(
      movieDetails: movieDetails ?? this.movieDetails,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class MovieDetailsNotifier extends StateNotifier<MovieDetailsState> {
  MovieDetailsNotifier(this._getMovieDetails, this.movieId)
    : super(MovieDetailsState()) {
    fetchMovieDetails();
  }

  final GetMovieDetails _getMovieDetails;
  final int movieId;

  Future<void> fetchMovieDetails() async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final movieDetails = await _getMovieDetails(movieId);
      state = state.copyWith(movieDetails: movieDetails, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
      rethrow;
    }
  }
}

final movieDetailsProvider =
    StateNotifierProvider.family<MovieDetailsNotifier, MovieDetailsState, int>((
      ref,
      movieId,
    ) {
      final repository = ref.watch(movieRepositoryProvider);
      return MovieDetailsNotifier(GetMovieDetails(repository), movieId);
    });
