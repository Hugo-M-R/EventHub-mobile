import 'package:flutter/material.dart';

import '../theme/eventhub_colors.dart';

class Event {
  final String title;
  final String date;
  final String location;
  final String category;
  final LinearGradient gradient;
  final bool isToday;
  final bool isFree;
  final String? artist;
  final String? neighborhood;

  Event({
    required this.title,
    required this.date,
    required this.location,
    required this.category,
    required this.gradient,
    this.isToday = false,
    this.isFree = false,
    this.artist,
    this.neighborhood,
  });

  bool matchesQuery(String normalizedQuery) {
    final searchable = [
      title,
      date,
      location,
      category,
      ?artist,
      ?neighborhood,
    ];
    return searchable.any(
      (field) => field.toLowerCase().contains(normalizedQuery),
    );
  }

  static List<Event> getMockEvents() {
    return [
      Event(
        title: 'Show independente',
        date: 'Sex, 12 abr - 20h',
        location: 'Centro Cultural',
        category: 'Música',
        artist: 'Banda Aurora',
        neighborhood: 'Centro',
        gradient: const LinearGradient(
          colors: [EventHubColors.purple, EventHubColors.orange],
        ),
      ),
      Event(
        title: 'Peça de teatro local',
        date: 'Hoje, 19h',
        location: 'Teatro Municipal',
        category: 'Teatro',
        artist: 'Companhia Luz',
        neighborhood: 'Jardins',
        isToday: true,
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
        ),
      ),
      Event(
        title: 'Feira de artesanato',
        date: 'Hoje, 10h–18h',
        location: 'Praça da Sé',
        category: 'Feira',
        neighborhood: 'Sé',
        isToday: true,
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
        ),
      ),
      Event(
        title: 'Sarau na praça',
        date: 'Hoje, 18h',
        location: 'Praça Central',
        category: 'Música',
        artist: 'Coletivo Verso',
        neighborhood: 'Bela Vista',
        isToday: true,
        isFree: true,
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
        ),
      ),
    ];
  }
}
