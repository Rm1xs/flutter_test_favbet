import '../../../../core/services/api_service.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/search_movie_repository.dart';
import '../datasources/remote_search_movie_datasource.dart';

class SearchMovieRepositoryImpl implements SearchMovieRepository {
  SearchMovieRepositoryImpl(ApiService apiService)
    : _dataSource = RemoteSearchMovieDataSource(apiService);
  final RemoteSearchMovieDataSource _dataSource;

  @override
  Future<List<Movie>> getSearchMovies({int page = 1, String query = ''}) {
    return _dataSource.getSearchMovies(page: page, query: query);
  }
}
