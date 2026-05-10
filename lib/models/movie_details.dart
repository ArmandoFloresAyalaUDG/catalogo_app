import '../constants/api_constants.dart';

class Genre {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) =>
      Genre(id: json['id'] as int, name: json['name'] as String);
}

class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String? releaseDate;
  final String? tagline;
  final String? status;
  final int? runtime;
  final List<Genre> genres;

  const MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    this.releaseDate,
    this.tagline,
    this.status,
    this.runtime,
    required this.genres,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      id:           json['id']           as int,
      title:        json['title']        as String,
      overview:     json['overview']     as String,
      posterPath:   json['poster_path']  as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage:  (json['vote_average'] as num).toDouble(),
      releaseDate:  json['release_date']  as String?,
      tagline:      json['tagline']       as String?,
      status:       json['status']        as String?,
      runtime:      json['runtime']       as int?,
      genres: (json['genres'] as List)
          .map((g) => Genre.fromJson(g as Map<String, dynamic>))
          .toList(),
    );
  }

  String? get posterUrl =>
      posterPath != null ? '${ApiConstants.imageBaseUrl}$posterPath' : null;

  String? get backdropUrl =>
      backdropPath != null ? '${ApiConstants.backdropBaseUrl}$backdropPath' : null;

  int get year {
    if (releaseDate == null || releaseDate!.length < 4) return 0;
    return int.tryParse(releaseDate!.substring(0, 4)) ?? 0;
  }

  String get ratingLabel => voteAverage.toStringAsFixed(1);

  String get formattedRuntime {
    if (runtime == null || runtime == 0) return '';
    final h = runtime! ~/ 60;
    final m = runtime! % 60;
    if (h == 0) return '${m}min';
    return '${h}h ${m}min';
  }

  List<String> get genreLabels => genres.map((g) => g.name).toList();
}
