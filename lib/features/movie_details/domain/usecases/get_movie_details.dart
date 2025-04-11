import '../entities/movie_details.dart';
import '../repositories/movie_details_repository.dart';

class GetMovieDetails {
  GetMovieDetails(this.repository);
  final MovieDetailsRepository repository;

  Future<MovieDetails> call(int movieId) {
    return repository.getMovieDetails(movieId);
  }
}
