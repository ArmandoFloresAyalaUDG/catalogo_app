import '../constants/api_constants.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id:           json['id']             as int,
      title:        json['title']          as String,
      overview:     json['overview']       as String,
      posterPath:   json['poster_path']    as String?,
      backdropPath: json['backdrop_path']  as String?,
      voteAverage:  (json['vote_average']  as num).toDouble(),
      releaseDate:  json['release_date']   as String? ?? '',
      genreIds:     List<int>.from(json['genre_ids'] as List),
    );
  }

  String? get posterUrl =>
      posterPath != null ? '${ApiConstants.imageBaseUrl}$posterPath' : null;

  String? get backdropUrl =>
      backdropPath != null ? '${ApiConstants.backdropBaseUrl}$backdropPath' : null;

  int get year {
    if (releaseDate.length < 4) return 0;
    return int.tryParse(releaseDate.substring(0, 4)) ?? 0;
  }

  String get genre {
    if (genreIds.isEmpty) return 'Desconocido';
    return ApiConstants.genreNames[genreIds.first] ?? 'Desconocido';
  }

  String get ratingLabel => voteAverage.toStringAsFixed(1);

  String get posterColor {
    const colors = [
      'sand', 'dark', 'noir', 'pastel', 'blue', 'earth', 'green', 'grey'
    ];
    return colors[id % colors.length];
  }

  Map<String, dynamic> toJson() => {
    'id':           id,
    'title':        title,
    'overview':     overview,
    'poster_path':  posterPath,
    'backdrop_path': backdropPath,
    'vote_average': voteAverage,
    'release_date': releaseDate,
    'genre_ids':    genreIds,
  };
}
