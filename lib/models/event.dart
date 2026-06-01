import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../theme/eventhub_colors.dart';

class Event {
  final String id;
  final String title;
  final String date;
  final String location;
  final String category;
  final LinearGradient gradient;
  final DateTime startsAt;
  final bool isFree;
  final String? artist;
  final String? neighborhood;
  final String? description;
  final Uint8List? coverImageBytes;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.category,
    required this.gradient,
    required this.startsAt,
    this.isFree = false,
    this.artist,
    this.neighborhood,
    this.description,
    this.coverImageBytes,
  });

  Event copyWith({
    String? id,
    String? title,
    String? date,
    String? location,
    String? category,
    LinearGradient? gradient,
    DateTime? startsAt,
    bool? isFree,
    String? artist,
    String? neighborhood,
    String? description,
    Uint8List? coverImageBytes,
    bool clearCoverImage = false,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      location: location ?? this.location,
      category: category ?? this.category,
      gradient: gradient ?? this.gradient,
      startsAt: startsAt ?? this.startsAt,
      isFree: isFree ?? this.isFree,
      artist: artist ?? this.artist,
      neighborhood: neighborhood ?? this.neighborhood,
      description: description ?? this.description,
      coverImageBytes: clearCoverImage
          ? null
          : (coverImageBytes ?? this.coverImageBytes),
    );
  }

  bool get isToday {
    final now = DateTime.now();
    return occursOn(DateTime(now.year, now.month, now.day));
  }

  bool occursOn(DateTime day) {
    return startsAt.year == day.year &&
        startsAt.month == day.month &&
        startsAt.day == day.day;
  }

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

  static LinearGradient gradientForCategory(String category) {
    return switch (category) {
      'Música' => const LinearGradient(
          colors: [EventHubColors.purple, EventHubColors.orange],
        ),
      'Teatro' => const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
        ),
      'Feira' => const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
        ),
      'Exposição' => const LinearGradient(
          colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
        ),
      'Workshop' => const LinearGradient(
          colors: [Color(0xFF8D6E63), Color(0xFF6D4C41)],
        ),
      'Cinema' => const LinearGradient(
          colors: [Color(0xFF263238), Color(0xFF455A64)],
        ),
      _ => const LinearGradient(
          colors: [EventHubColors.purple, EventHubColors.orange],
        ),
    };
  }

  /// Rótulo exibido nos cards (ex.: "Hoje, 19h" ou "Sex, 12 abr - 20h").
  static String formatDisplayDate(
    DateTime startsAt, {
    int? endHour,
  }) {
    final now = DateTime.now();
    final eventDay = DateTime(startsAt.year, startsAt.month, startsAt.day);
    final today = DateTime(now.year, now.month, now.day);
    final time = _formatTime(startsAt);

    if (eventDay == today) {
      if (endHour != null) {
        return 'Hoje, $time–${endHour}h';
      }
      return 'Hoje, $time';
    }

    const weekdaysShort = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    const monthsShort = [
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez',
    ];
    final weekday = weekdaysShort[startsAt.weekday - 1];
    final month = monthsShort[startsAt.month - 1];
    return '$weekday, ${startsAt.day} $month - $time';
  }

  /// Título de seção na busca por data.
  static String formatDayLabel(DateTime day) {
    final now = DateTime.now();
    final selected = DateTime(day.year, day.month, day.day);
    final today = DateTime(now.year, now.month, now.day);

    if (selected == today) return 'hoje';

    const weekdays = [
      'segunda-feira',
      'terça-feira',
      'quarta-feira',
      'quinta-feira',
      'sexta-feira',
      'sábado',
      'domingo',
    ];
    const months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];

    return '${weekdays[day.weekday - 1]}, ${day.day} de ${months[day.month - 1]}';
  }

  static String _formatTime(DateTime dateTime) {
    if (dateTime.minute == 0) {
      return '${dateTime.hour}h';
    }
    return '${dateTime.hour}h${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Filtra eventos que ocorrem na data selecionada (ignora horário).
List<Event> filterEventsByDate(List<Event> events, DateTime date) {
  return events.where((event) => event.occursOn(date)).toList();
}

/// Datas (sem horário) que possuem ao menos um evento.
Set<DateTime> datesWithEvents(List<Event> events) {
  return events
      .map(
        (e) => DateTime(e.startsAt.year, e.startsAt.month, e.startsAt.day),
      )
      .toSet();
}
