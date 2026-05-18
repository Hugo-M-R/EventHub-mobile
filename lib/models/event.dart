import 'package:flutter/material.dart';

import '../theme/eventhub_colors.dart';

class Event {
  final String title;
  final String date;
  final String location;
  final String category;
  final LinearGradient gradient;

  Event({
    required this.title,
    required this.date,
    required this.location,
    required this.category,
    required this.gradient,
  });

  static List<Event> getMockEvents() {
    return [
      Event(
        title: 'Show independente',
        date: 'Sex, 12 abr - 20h',
        location: 'Centro Cultural',
        category: 'Música',
        gradient: const LinearGradient(
          colors: [EventHubColors.purple, EventHubColors.orange],
        ),
      ),
      Event(
        title: 'Peça de teatro local',
        date: 'Sáb, 13 abr - 19h',
        location: 'Teatro Municipal',
        category: 'Teatro',
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
        ),
      ),
      Event(
        title: 'Feira de artesanato',
        date: 'Dom, 14 abr - 10h',
        location: 'Praça da Sé',
        category: 'Feira',
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
        ),
      ),
    ];
  }
}
