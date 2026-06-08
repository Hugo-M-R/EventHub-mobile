import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../session/app_session.dart';

/// Autenticação via Firebase Auth (e-mail/senha e Google) com restrição
/// de domínio institucional.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  /// Domínio institucional obrigatório (regra da Atividade 3).
  static const String allowedDomain = '@souunit.com.br';

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
    await _enforceDomainOrSignOut();
    syncSessionFromFirebase();
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final trimmedEmail = email.trim();
    if (!trimmedEmail.toLowerCase().endsWith(allowedDomain)) {
      throw StateError(
        'Use seu e-mail institucional ($allowedDomain) para criar a conta.',
      );
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: trimmedEmail,
      password: password,
    );

    final name = fullName.trim();
    if (name.isNotEmpty) {
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
    }

    syncSessionFromFirebase();
  }

  Future<void> signInWithGoogle() async {
    final provider = GoogleAuthProvider();
    if (kIsWeb) {
      await _auth.signInWithPopup(provider);
    } else {
      await _auth.signInWithProvider(provider);
    }
    await _enforceDomainOrSignOut();
    syncSessionFromFirebase();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await _auth.signOut();
    AppSession.clear();
  }

  /// Verifica se o e-mail do usuário pertence ao domínio institucional.
  /// Se não pertencer, desloga e lança erro com mensagem amigável.
  Future<void> _enforceDomainOrSignOut() async {
    final email = _auth.currentUser?.email?.toLowerCase();
    if (email == null || !email.endsWith(allowedDomain)) {
      await _auth.signOut();
      AppSession.clear();
      throw StateError(
        'Acesso restrito a contas institucionais ($allowedDomain).',
      );
    }
  }
}
