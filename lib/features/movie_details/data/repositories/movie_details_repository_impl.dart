import '../../../../core/services/api_service.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_details_repository.dart';
import '../datasources/remote_movie_details_datasource.dart';

class MovieDetailsRepositoryImpl implements MovieDetailsRepository {
  MovieDetailsRepositoryImpl(ApiService apiService)
    : _dataSource = RemoteMovieDetailsDataSource(apiService);
  final RemoteMovieDetailsDataSource _dataSource;

  @override
  Future<MovieDetails> getMovieDetails(int movieId) {
    return _dataSource.getMovieDetails(movieId: movieId);
  }
}
