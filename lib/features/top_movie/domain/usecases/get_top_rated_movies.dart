import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetTopRatedMovies {
  GetTopRatedMovies(this.repository);
  final MovieRepository repository;

  Future<List<Movie>> call({int page = 1}) async {
    return repository.getTopRatedMovies(page: page);
  }
}
