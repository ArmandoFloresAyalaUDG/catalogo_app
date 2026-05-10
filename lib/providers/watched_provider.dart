import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/movie.dart';

class WatchedProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  List<Movie> _watched = [];
  StreamSubscription<QuerySnapshot>? _sub;
  bool _isLoading = true;

  List<Movie> get watched => List.unmodifiable(_watched);
  bool get isLoading => _isLoading;

  WatchedProvider() {
    _auth.authStateChanges().listen(_onAuthChanged);
  }

  void _onAuthChanged(User? user) {
    _sub?.cancel();
    _watched = [];
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
        .collection('watched')
        .orderBy('watched_at', descending: true)
        .snapshots()
        .listen(_onSnapshot);
  }

  void _onSnapshot(QuerySnapshot snap) {
    _watched = snap.docs
        .map((d) => Movie.fromJson(d.data() as Map<String, dynamic>))
        .toList();
    _isLoading = false;
    notifyListeners();
  }

  bool isWatched(int id) => _watched.any((m) => m.id == id);

  Future<void> toggleWatched(Movie movie) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final ref = _db
        .collection('users')
        .doc(user.uid)
        .collection('watched')
        .doc(movie.id.toString());
    if (isWatched(movie.id)) {
      await ref.delete();
    } else {
      await ref.set({...movie.toJson(), 'watched_at': FieldValue.serverTimestamp()});
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
