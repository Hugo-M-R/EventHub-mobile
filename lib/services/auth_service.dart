import 'package:firebase_auth/firebase_auth.dart';

import '../session/app_session.dart';

/// Autenticação via Firebase Auth (e-mail e senha).
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  void syncSessionFromFirebase() {
    final user = _auth.currentUser;
    if (user == null) {
      AppSession.clear();
      return;
    }
    AppSession.loginAsUser(
      user.email ?? '',
      fullName: user.displayName,
    );
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    syncSessionFromFirebase();
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final name = fullName.trim();
    if (name.isNotEmpty) {
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
    }

    syncSessionFromFirebase();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await _auth.signOut();
    AppSession.clear();
  }
}
