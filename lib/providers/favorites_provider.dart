import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class FavoritesProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  List<Movie> _favorites = [];
  StreamSubscription<QuerySnapshot>? _sub;
  bool _isLoading = true;
  bool _migrationDone = false;

  List<Movie> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;

  FavoritesProvider() {
    _auth.authStateChanges().listen(_onAuthChanged);
  }

  void _onAuthChanged(User? user) {
    _sub?.cancel();
    _favorites = [];
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    _sub = _db
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .orderBy('added_at', descending: true)
        .snapshots()
        .listen(_onSnapshot);
  }

  void _onSnapshot(QuerySnapshot snap) {
    _favorites = snap.docs
        .map((d) => Movie.fromJson(d.data() as Map<String, dynamic>))
        .toList();
    _isLoading = false;
    notifyListeners();

    if (snap.docs.isEmpty && !_migrationDone) {
      _migrateFromSharedPreferences();
    }
  }

  Future<void> _migrateFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('migration_v1_done') == true) {
      _migrationDone = true;
      return;
    }
    final raw = prefs.getString('favorites');
    _migrationDone = true;
    await prefs.setBool('migration_v1_done', true);
    if (raw == null) return;
    final list = jsonDecode(raw) as List;
    if (list.isEmpty) return;
    final user = _auth.currentUser;
    if (user == null) return;
    final batch = _db.batch();
    for (final item in list) {
      final movie = Movie.fromJson(item as Map<String, dynamic>);
      final ref = _db
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(movie.id.toString());
      batch.set(ref, {...movie.toJson(), 'added_at': FieldValue.serverTimestamp()});
    }
    await batch.commit();
    await prefs.remove('favorites');
  }

  bool isFavorite(int id) => _favorites.any((m) => m.id == id);

  Future<void> toggleFavorite(Movie movie) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final ref = _db
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(movie.id.toString());
    if (isFavorite(movie.id)) {
      await ref.delete();
    } else {
      await ref.set({...movie.toJson(), 'added_at': FieldValue.serverTimestamp()});
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
