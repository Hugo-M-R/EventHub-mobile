import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/event.dart';
import '../models/event_profile_status.dart';
import '../services/event_service.dart';

/// Catálogo de eventos sincronizado com Firestore (Home, Buscar, Perfil, CRUD).
abstract final class EventCatalog {
  /// Incrementado a cada alteração para atualizar listas nas telas.
  static final ValueNotifier<int> version = ValueNotifier(0);

  static final List<Event> events = [];

  static bool isLoading = true;
  static String? loadError;

  static StreamSubscription<List<Event>>? _subscription;

  /// Eventos marcados com "Tenho interesse" (sessão atual).
  static final List<ProfileEventEntry> savedEvents = [];

  static bool isSaved(String eventId) {
    return savedEvents.any((entry) => entry.eventId == eventId);
  }

  static bool isOwnedByCurrentUser(Event event) {
    final email = FirebaseAuth.instance.currentUser?.email;
    return email != null && event.createdBy == email;
  }

  static void saveInterest(String eventId) {
    if (isSaved(eventId)) return;
    savedEvents.add(
      ProfileEventEntry(
        eventId: eventId,
        status: EventProfileStatus.ativo,
      ),
    );
    _notifyChange();
  }

  static void removeSavedInterest(String eventId) {
    savedEvents.removeWhere((entry) => entry.eventId == eventId);
    _notifyChange();
  }

  static Future<void> initialize() async {
    await _subscription?.cancel();
    isLoading = true;
    loadError = null;
    _notifyChange();

    _subscription = EventService.instance.watchEvents().listen(
      (list) {
        events
          ..clear()
          ..addAll(list);
        isLoading = false;
        loadError = null;
        _notifyChange();
      },
      onError: (Object error) {
        isLoading = false;
        loadError = error.toString();
        _notifyChange();
      },
    );
  }

  static Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  static Event byId(String id) {
    return events.firstWhere((event) => event.id == id);
  }

  /// Eventos que o usuário autenticado pode editar ou excluir.
  static List<Event> get editableEvents {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return [];
    return events.where((event) => event.createdBy == email).toList();
  }

  static List<Event> eventsInCategory(String category) {
    return events.where((event) => event.category == category).toList();
  }

  static List<ProfileEventEntry> get myEvents {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return [];

    return events
        .where((event) => event.createdBy == email)
        .map(
          (event) => ProfileEventEntry(
            eventId: event.id,
            status: event.profileStatus,
          ),
        )
        .toList();
  }

  static String nextId() => EventService.instance.newEventId();

  static Future<void> addEvent(
    Event event, {
    Uint8List? coverBytes,
  }) async {
    await EventService.instance.createEvent(event, coverBytes: coverBytes);
  }

  static Future<void> updateEvent(
    Event updated, {
    Uint8List? coverBytes,
    bool removeCover = false,
  }) async {
    await EventService.instance.updateEvent(
      updated,
      coverBytes: coverBytes,
      removeCover: removeCover,
    );
  }

  static Future<void> removeEvent(String id) async {
    final event = byId(id);
    await EventService.instance.deleteEvent(event);
    savedEvents.removeWhere((entry) => entry.eventId == id);
    _notifyChange();
  }

  static void _notifyChange() {
    version.value++;
  }
}
