import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../session/app_session.dart';
import '../services/auth_service.dart';
import '../theme/eventhub_colors.dart';

/// Redireciona para Home ou Login conforme sessão Firebase.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: EventHubColors.scaffoldBg,
            body: Center(
              child: CircularProgressIndicator(
                color: EventHubColors.orangeButton,
              ),
            ),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          AuthService.instance.syncSessionFromFirebase();
          return const HomeScreen();
        }

        AppSession.clear();
        return const LoginScreen();
      },
    );
  }
}
