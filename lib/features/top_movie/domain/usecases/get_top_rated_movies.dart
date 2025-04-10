import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetTopRatedMovies {
  GetTopRatedMovies(this.repository);
  final MovieRepository repository;

  Future<List<Movie>> call() async {
    return repository.getTopRatedMovies();
  }
}
