import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/event_catalog.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import '../services/institutional_email_policy.dart';
import '../session/app_session.dart';
import '../theme/eventhub_colors.dart';

/// Redireciona para Home ou Login conforme sessão Firebase e domínio institucional.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _accessDeniedMessage;
  bool _enforcingLogout = false;

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
          if (!InstitutionalEmailPolicy.isAllowed(user.email)) {
            if (!_enforcingLogout) {
              _enforcingLogout = true;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await AuthService.instance.signOut();
                if (!mounted) return;
                setState(() {
                  _accessDeniedMessage =
                      'Acesso restrito a contas @souunit.com.br.';
                  _enforcingLogout = false;
                });
              });
            }
            return LoginScreen(accessDeniedMessage: _accessDeniedMessage);
          }

          AuthService.instance.syncSessionFromFirebase();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            EventCatalog.startSavedEventsSync();
          });
          return const HomeScreen();
        }

        AppSession.clear();
        EventCatalog.stopSavedEventsSync();
        return LoginScreen(accessDeniedMessage: _accessDeniedMessage);
      },
    );
  }
}
