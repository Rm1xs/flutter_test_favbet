import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel({
    required super.id,
    required super.title,
    required super.posterPath,
    required super.voteAverage,
    required super.overview,
    required super.releaseDate,
    required super.page,
    required super.totalPages,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'No Title',
      posterPath: json['poster_path'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      overview: json['overview'] as String? ?? 'No Overview',
      releaseDate: json['release_date'] as String? ?? 'Unknown',
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'vote_average': voteAverage,
      'overview': overview,
      'release_date': releaseDate,
      'page': page,
      'total_pages': totalPages,
    };
  }
}
