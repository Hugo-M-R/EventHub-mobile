import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../data/event_catalog.dart';
import '../session/app_session.dart';
import 'google_sign_in_helper.dart';
import 'institutional_email_policy.dart';

/// Autenticação via Firebase Auth (e-mail/senha e Google).
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
    final normalized = email.trim().toLowerCase();
    _requireInstitutionalEmail(normalized);

    await _auth.signInWithEmailAndPassword(
      email: normalized,
      password: password,
    );
    await _finalizeAuthenticatedSession();
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final normalized = email.trim().toLowerCase();
    _requireInstitutionalEmail(normalized);

    final credential = await _auth.createUserWithEmailAndPassword(
      email: normalized,
      password: password,
    );

    final name = fullName.trim();
    if (name.isNotEmpty) {
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
    }

    await _finalizeAuthenticatedSession();
  }

  Future<void> signInWithGoogle() async {
    final credential = await GoogleSignInHelper.signIn(_auth);
    await _ensureInstitutionalUser(credential.user);
    await _finalizeAuthenticatedSession();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final normalized = email.trim().toLowerCase();
    _requireInstitutionalEmail(normalized);
    await _auth.sendPasswordResetEmail(email: normalized);
  }

  /// Valida domínio e encerra sessão se o e-mail não for institucional.
  Future<bool> enforceInstitutionalAccess() async {
    final user = _auth.currentUser;
    if (user == null) return true;

    if (InstitutionalEmailPolicy.isAllowed(user.email)) {
      return true;
    }

    await signOut();
    return false;
  }

  Future<void> signOut() async {
    await EventCatalog.stopSavedEventsSync();
    if (!kIsWeb) {
      await GoogleSignIn().signOut();
    }
    await _auth.signOut();
    AppSession.clear();
  }

  Future<void> _finalizeAuthenticatedSession() async {
    await _ensureInstitutionalUser(_auth.currentUser);
    syncSessionFromFirebase();
    await EventCatalog.startSavedEventsSync();
  }

  Future<void> _ensureInstitutionalUser(User? user) async {
    if (!InstitutionalEmailPolicy.isAllowed(user?.email)) {
      await signOut();
      throw InstitutionalEmailException();
    }
  }

  void _requireInstitutionalEmail(String email) {
    final message = InstitutionalEmailPolicy.validationMessage(email);
    if (message != null) {
      throw InstitutionalEmailException(message);
    }
  }
}
