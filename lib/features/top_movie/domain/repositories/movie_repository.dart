import '../entities/movie.dart';

mixin MovieRepository {
  Future<List<Movie>> getTopRatedMovies({int page = 1});
}
