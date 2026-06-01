import 'package:flutter/material.dart';

import '../models/event.dart';
import '../screens/event_detail_screen.dart';
import '../screens/home_screen.dart';

void openEventDetail(BuildContext context, Event event) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
  );
}

void openSimilarEvents(BuildContext context, Event event) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const HomeScreen()),
    (route) => false,
  );
}
