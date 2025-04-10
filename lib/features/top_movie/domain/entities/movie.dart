class Movie {
  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.overview,
    required this.releaseDate,
  });
  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;
  final String overview;
  final String releaseDate;
}
