import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? true;
  bool get isSignedIn => _auth.currentUser != null;

  Future<String?> signUpWithEmail(String email, String password) async {
    try {
      final current = _auth.currentUser;
      if (current != null && current.isAnonymous) {
        final credential =
            EmailAuthProvider.credential(email: email, password: password);
        await current.linkWithCredential(credential);
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return _authError(e.code);
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return _authError(e.code);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _auth.signInAnonymously();
    notifyListeners();
  }

  String _authError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'invalid-email':
        return 'Correo electrónico inválido.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'user-not-found':
        return 'No existe una cuenta con ese correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      default:
        return 'Ocurrió un error. Intenta de nuevo.';
    }
  }
}
