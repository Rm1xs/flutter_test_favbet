import '../entities/movie_details.dart';

mixin MovieDetailsRepository {
  Future<MovieDetails> getMovieDetails(int movieId);
}
