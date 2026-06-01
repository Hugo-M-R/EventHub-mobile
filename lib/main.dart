import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/eventhub_app.dart';
import 'config/env_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.load();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: EnvConfig.firebaseOptions);
  }

  runApp(const EventHubApp());
}
