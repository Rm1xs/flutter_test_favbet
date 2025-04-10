import 'package:dio/dio.dart';

import '../../../../core/errors/remote_exception.dart';
import '../../../../core/services/api_service.dart';
import '../models/movie_model.dart';

class RemoteMovieDataSource {
  RemoteMovieDataSource(this._apiService);
  final ApiService _apiService;

  Future<List<MovieModel>> getTopRatedMovies() async {
    try {
      final response = await _apiService.dio.get('movie/top_rated');
      return (response.data['results'] as List)
          .map((json) => MovieModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw RemoteException.fromDioException(e);
    } catch (e) {
      throw RemoteException(
        message: 'Unexpected error occurred while fetching top rated movies.',
        errorDetails: e.toString(),
      );
    }
  }
}
