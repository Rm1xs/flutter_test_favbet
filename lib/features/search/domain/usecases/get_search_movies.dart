import '../entities/movie.dart';
import '../repositories/search_movie_repository.dart';

class GetSearchMovies {
  GetSearchMovies(this.repository);
  final SearchMovieRepository repository;

  Future<List<Movie>> call({required String query, int page = 1}) async {
    return repository.getSearchMovies(page: page, query: query);
  }
}
