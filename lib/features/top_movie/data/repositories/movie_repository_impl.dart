import '../../../../core/services/api_service.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/remote_movie_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(ApiService apiService)
    : _dataSource = RemoteMovieDataSource(apiService);
  final RemoteMovieDataSource _dataSource;

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    return _dataSource.getTopRatedMovies(page: page);
  }
}
