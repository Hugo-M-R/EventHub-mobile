import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Carrega variáveis do arquivo `.env` na raiz do projeto.
abstract final class EnvConfig {
  static bool get isLoaded => dotenv.isInitialized;

  static Future<void> load() async {
    if (dotenv.isInitialized) return;
    await dotenv.load(fileName: '.env');
  }

  static String require(String key) {
    final value = dotenv.env[key]?.trim();
    if (value == null || value.isEmpty) {
      throw StateError(
        'Variável $key ausente no .env. Copie .env.example para .env e preencha.',
      );
    }
    return value;
  }

  static String? optional(String key) {
    final value = dotenv.env[key]?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  /// Web usa `FIREBASE_WEB_APP_ID`; Android usa `FIREBASE_ANDROID_APP_ID`.
  /// Se só existir `FIREBASE_APP_ID`, ele é usado como fallback.
  static String get firebaseAppId {
    if (kIsWeb) {
      return optional('FIREBASE_WEB_APP_ID') ?? require('FIREBASE_APP_ID');
    }
    return optional('FIREBASE_ANDROID_APP_ID') ?? require('FIREBASE_APP_ID');
  }

  static FirebaseOptions get firebaseOptions {
    return FirebaseOptions(
      apiKey: require('FIREBASE_API_KEY'),
      authDomain: require('FIREBASE_AUTH_DOMAIN'),
      projectId: require('FIREBASE_PROJECT_ID'),
      storageBucket: require('FIREBASE_STORAGE_BUCKET'),
      messagingSenderId: require('FIREBASE_MESSAGING_SENDER_ID'),
      appId: firebaseAppId,
      measurementId: optional('FIREBASE_MEASUREMENT_ID'),
    );
  }
}
