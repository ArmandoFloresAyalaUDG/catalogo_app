import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_details.dart';
import '../constants/api_constants.dart';

class TmdbService {
  TmdbService._();

  static Future<List<Movie>> _fetchMovies(String path, [Map<String, String>? extra]) async {
    final params = {
      'api_key':  ApiConstants.apiKey,
      'language': ApiConstants.language,
      ...?extra,
    };
    final uri = Uri.https('api.themoviedb.org', path, params);
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw TmdbException('Error ${response.statusCode}: no se pudieron cargar las películas.');
    }
    final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return (body['results'] as List)
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Movie>> getPopularMovies({int page = 1}) =>
      _fetchMovies('/3/movie/popular', {'page': page.toString()});

  static Future<List<Movie>> getTrendingMovies() =>
      _fetchMovies('/3/trending/movie/week');

  static Future<List<Movie>> getTopRatedMovies() =>
      _fetchMovies('/3/movie/top_rated');

  static Future<List<Movie>> getUpcomingMovies() =>
      _fetchMovies('/3/movie/upcoming');

  static Future<List<Movie>> searchMovies(String query) =>
      _fetchMovies('/3/search/movie', {'query': query});

  static Future<List<Movie>> getRecommendations(int movieId) =>
      _fetchMovies('/3/movie/$movieId/recommendations');

  static Future<MovieDetails> getMovieDetails(int movieId) async {
    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/movie/$movieId',
      {'api_key': ApiConstants.apiKey, 'language': ApiConstants.language},
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw TmdbException('Error ${response.statusCode}: no se pudieron cargar los detalles.');
    }
    final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return MovieDetails.fromJson(body);
  }
}

class TmdbException implements Exception {
  final String message;
  const TmdbException(this.message);
  @override
  String toString() => message;
}
