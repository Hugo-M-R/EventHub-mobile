import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

/// Login com Google — popup na web, fluxo nativo no mobile.
abstract final class GoogleSignInHelper {
  static Future<UserCredential> signIn(FirebaseAuth auth) async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      return auth.signInWithPopup(provider);
    }

    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw StateError('Login com Google cancelado.');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return auth.signInWithCredential(credential);
  }
}
