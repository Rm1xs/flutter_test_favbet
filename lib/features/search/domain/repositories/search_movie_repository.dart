import '../entities/movie.dart';

mixin SearchMovieRepository {
  Future<List<Movie>> getSearchMovies({int page = 1, String query = ''});
}
