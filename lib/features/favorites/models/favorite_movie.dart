class FavoriteMovie {
  FavoriteMovie({
    required this.id,
    required this.title,
    required this.posterPath,
  });

  factory FavoriteMovie.fromJson(Map<String, dynamic> json) => FavoriteMovie(
    id: json['id'],
    title: json['title'],
    posterPath: json['posterPath'],
  );
  final int id;
  final String title;
  final String posterPath;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'posterPath': posterPath,
  };
}
