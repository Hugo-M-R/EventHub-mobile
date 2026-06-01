import 'package:flutter/material.dart';

import '../theme/eventhub_colors.dart';
import '../widgets/auth_gate.dart';

class EventHubApp extends StatelessWidget {
  const EventHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventHub',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: EventHubColors.orangeButton,
          primary: EventHubColors.orangeButton,
        ),
        scaffoldBackgroundColor: EventHubColors.scaffoldBg,
      ),
      home: const AuthGate(),
    );
  }
}
