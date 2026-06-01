import 'package:flutter/material.dart';

import '../models/event.dart';
import '../models/event_profile_status.dart';
/// Catálogo único de eventos — mesma lista em Home, Buscar e Perfil.
abstract final class EventCatalog {
  /// Incrementado a cada alteração para atualizar listas nas telas.
  static final ValueNotifier<int> version = ValueNotifier(0);

  static final List<Event> events = _buildEvents();

  static final List<ProfileEventEntry> savedEvents = [
    const ProfileEventEntry(
      eventId: 'evt_jazz',
      status: EventProfileStatus.ativo,
    ),
    const ProfileEventEntry(
      eventId: 'evt_oficina',
      status: EventProfileStatus.alterado,
    ),
    const ProfileEventEntry(
      eventId: 'evt_cinema',
      status: EventProfileStatus.cancelado,
    ),
  ];

  static final List<ProfileEventEntry> myEvents = [
    const ProfileEventEntry(
      eventId: 'evt_show',
      status: EventProfileStatus.ativo,
    ),
  ];

  static Event byId(String id) {
    return events.firstWhere((event) => event.id == id);
  }

  /// Eventos que o usuário pode editar ou excluir (meus eventos).
  static List<Event> get editableEvents {
    return myEvents.map((entry) => byId(entry.eventId)).toList();
  }

  static List<Event> eventsInCategory(String category) {
    return events.where((event) => event.category == category).toList();
  }

  static String nextId() => 'evt_${DateTime.now().millisecondsSinceEpoch}';

  static void addEvent(Event event) {
    events.add(event);
    final alreadyMine = myEvents.any((entry) => entry.eventId == event.id);
    if (!alreadyMine) {
      myEvents.add(
        ProfileEventEntry(
          eventId: event.id,
          status: EventProfileStatus.ativo,
        ),
      );
    }
    _notifyChange();
  }

  static void updateEvent(Event updated) {
    final index = events.indexWhere((event) => event.id == updated.id);
    if (index == -1) return;
    events[index] = updated;

    final hasStatus = myEvents.any((entry) => entry.eventId == updated.id);
    if (hasStatus) {
      _markAsAlterado(updated.id);
    }
    _notifyChange();
  }

  static void removeEvent(String id) {
    events.removeWhere((event) => event.id == id);
    myEvents.removeWhere((entry) => entry.eventId == id);
    savedEvents.removeWhere((entry) => entry.eventId == id);
    _notifyChange();
  }

  static void _notifyChange() {
    version.value++;
  }

  static void _markAsAlterado(String eventId) {
    final index = myEvents.indexWhere((entry) => entry.eventId == eventId);
    if (index == -1) return;
    final current = myEvents[index];
    if (current.status == EventProfileStatus.cancelado) return;
    myEvents[index] = ProfileEventEntry(
      eventId: eventId,
      status: EventProfileStatus.alterado,
    );
  }

  static List<Event> _buildEvents() {
    final year = DateTime.now().year;

    final showDate = DateTime(year, 4, 12, 20);
    final teatroDate = _todayAt(19);
    final feiraDate = _todayAt(10);
    final sarauDate = _todayAt(18);
    final jazzDate = _daysFromNow(7, 20);
    final oficinaDate = _daysFromNow(3, 14);
    final cinemaDate = _daysFromNow(5, 20);

    return [
      Event(
        id: 'evt_show',
        title: 'Show independente',
        date: Event.formatDisplayDate(showDate),
        location: 'Centro Cultural',
        category: 'Música',
        artist: 'Banda Aurora',
        neighborhood: 'Centro',
        description:
            'Uma noite especial com a Banda Aurora, trazendo seus maiores sucessos e músicas inéditas do novo álbum. Venha curtir ao vivo!',
        startsAt: showDate,
        gradient: Event.gradientForCategory('Música'),
      ),
      Event(
        id: 'evt_teatro',
        title: 'Peça de teatro local',
        date: Event.formatDisplayDate(teatroDate),
        location: 'Teatro Municipal',
        category: 'Teatro',
        artist: 'Companhia Luz',
        neighborhood: 'Jardins',
        description:
            'A Companhia Luz apresenta sua nova montagem teatral, explorando temas contemporâneos com linguagem acessível e impactante.',
        startsAt: teatroDate,
        gradient: Event.gradientForCategory('Teatro'),
      ),
      Event(
        id: 'evt_feira',
        title: 'Feira de artesanato',
        date: Event.formatDisplayDate(feiraDate, endHour: 18),
        location: 'Praça da Sé',
        category: 'Feira',
        neighborhood: 'Sé',
        description:
            'Feira com mais de 50 expositores locais. Encontre peças únicas de cerâmica, tecido, bijuteria e muito mais.',
        startsAt: feiraDate,
        gradient: Event.gradientForCategory('Feira'),
      ),
      Event(
        id: 'evt_sarau',
        title: 'Sarau na praça',
        date: Event.formatDisplayDate(sarauDate),
        location: 'Praça Central',
        category: 'Música',
        artist: 'Coletivo Verso',
        neighborhood: 'Bela Vista',
        description:
            'Sarau gratuito e aberto ao público com poesia, música e performance. Traga sua cadeira e aproveite a tarde.',
        startsAt: sarauDate,
        isFree: true,
        gradient: Event.gradientForCategory('Música'),
      ),
      Event(
        id: 'evt_jazz',
        title: 'Jazz na praça',
        date: Event.formatDisplayDate(jazzDate),
        location: 'Praça das Artes',
        category: 'Música',
        artist: 'Trio Blue Note',
        neighborhood: 'Pinheiros',
        description:
            'Apresentação gratuita de jazz ao ar livre com o Trio Blue Note.',
        startsAt: jazzDate,
        isFree: true,
        gradient: Event.gradientForCategory('Música'),
      ),
      Event(
        id: 'evt_oficina',
        title: 'Oficina de cerâmica',
        date: Event.formatDisplayDate(oficinaDate),
        location: 'Ateliê Coletivo',
        category: 'Workshop',
        neighborhood: 'Vila Madalena',
        description:
            'Oficina prática de modelagem e esmaltação para iniciantes. Materiais inclusos.',
        startsAt: oficinaDate,
        gradient: Event.gradientForCategory('Workshop'),
      ),
      Event(
        id: 'evt_cinema',
        title: 'Cinema ao ar livre',
        date: Event.formatDisplayDate(cinemaDate),
        location: 'Parque Ibirapuera',
        category: 'Cinema',
        neighborhood: 'Moema',
        description:
            'Sessão especial ao pôr do sol com filme brasileiro premiado.',
        startsAt: cinemaDate,
        gradient: Event.gradientForCategory('Cinema'),
      ),
    ];
  }

  static DateTime _todayAt(int hour, [int minute = 0]) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  static DateTime _daysFromNow(int days, int hour, [int minute = 0]) {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day).add(Duration(days: days));
    return DateTime(day.year, day.month, day.day, hour, minute);
  }
}
