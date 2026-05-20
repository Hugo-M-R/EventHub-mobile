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
  final String? description;

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
    this.description,
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
        description: 'Uma noite especial com a Banda Aurora, trazendo seus maiores sucessos e músicas inéditas do novo álbum. Venha curtir ao vivo!',
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
        description: 'A Companhia Luz apresenta sua nova montagem teatral, explorando temas contemporâneos com linguagem acessível e impactante.',
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
        description: 'Feira com mais de 50 expositores locais. Encontre peças únicas de cerâmica, tecido, bijuteria e muito mais.',
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
        description: 'Sarau gratuito e aberto ao público com poesia, música e performance. Traga sua cadeira e aproveite a tarde.',
        isToday: true,
        isFree: true,
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
        ),
      ),
    ];
  }
}
