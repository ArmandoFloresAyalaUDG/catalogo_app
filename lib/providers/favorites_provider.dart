import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _key = 'favorites';
  List<Movie> _favorites = [];

  List<Movie> get favorites => List.unmodifiable(_favorites);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    final list = jsonDecode(raw) as List;
    _favorites = list.map((item) => Movie.fromJson(item as Map<String, dynamic>)).toList();
    notifyListeners();
  }

  bool isFavorite(int id) => _favorites.any((m) => m.id == id);

  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie.id)) {
      _favorites.removeWhere((m) => m.id == movie.id);
    } else {
      _favorites.add(movie);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _favorites.map((m) => {
      'id': m.id,
      'title': m.title,
      'overview': m.overview,
      'poster_path': m.posterPath,
      'backdrop_path': m.backdropPath,
      'vote_average': m.voteAverage,
      'release_date': m.releaseDate,
      'genre_ids': m.genreIds,
    }).toList();
    await prefs.setString(_key, jsonEncode(data));
  }
}
