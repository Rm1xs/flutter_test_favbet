import 'package:dio/dio.dart';

import '../../../../core/errors/remote_exception.dart';
import '../../../../core/services/api_service.dart';
import '../models/movie_details_model.dart';

class RemoteMovieDetailsDataSource {
  RemoteMovieDetailsDataSource(this._apiService);
  final ApiService _apiService;

  Future<MovieDetailsModel> getMovieDetails({required int movieId}) async {
    try {
      final response = await _apiService.dio.get('movie/$movieId');
      return MovieDetailsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw RemoteException.fromDioException(e);
    } catch (e) {
      throw RemoteException(
        message: 'Unexpected error occurred while fetching movie details.',
        errorDetails: e.toString(),
      );
    }
  }
}
