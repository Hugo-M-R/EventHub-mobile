import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/event.dart';
import '../models/event_profile_status.dart';
import '../services/event_service.dart';
import '../services/saved_event_service.dart';

/// Catálogo de eventos sincronizado com Firestore (Home, Buscar, Perfil, CRUD).
abstract final class EventCatalog {
  /// Incrementado a cada alteração para atualizar listas nas telas.
  static final ValueNotifier<int> version = ValueNotifier(0);

  static final List<Event> events = [];

  static bool isLoading = true;
  static String? loadError;

  static StreamSubscription<List<Event>>? _eventsSubscription;
  static StreamSubscription<List<String>>? _savedSubscription;

  /// Eventos marcados com "Tenho interesse" (Firestore em tempo real).
  static final List<ProfileEventEntry> savedEvents = [];

  static bool isSaved(String eventId) {
    return savedEvents.any((entry) => entry.eventId == eventId);
  }

  static bool isOwnedByCurrentUser(Event event) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return uid != null && event.createdBy == uid;
  }

  static Future<void> saveInterest(String eventId) async {
    if (isSaved(eventId)) return;
    await SavedEventService.instance.saveInterest(eventId);
  }

  static Future<void> removeSavedInterest(String eventId) async {
    await SavedEventService.instance.removeInterest(eventId);
  }

  static Future<void> initialize() async {
    await _eventsSubscription?.cancel();
    isLoading = true;
    loadError = null;
    _notifyChange();

    _eventsSubscription = EventService.instance.watchEvents().listen(
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

  static Future<void> startSavedEventsSync() async {
    await _savedSubscription?.cancel();
    savedEvents.clear();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _notifyChange();
      return;
    }

    _savedSubscription =
        SavedEventService.instance.watchSavedEventIds(uid).listen(
      (eventIds) {
        savedEvents
          ..clear()
          ..addAll(
            eventIds.map(
              (id) => ProfileEventEntry(
                eventId: id,
                status: EventProfileStatus.ativo,
              ),
            ),
          );
        _notifyChange();
      },
      onError: (_) {
        _notifyChange();
      },
    );
  }

  static Future<void> stopSavedEventsSync() async {
    await _savedSubscription?.cancel();
    _savedSubscription = null;
    savedEvents.clear();
    _notifyChange();
  }

  static Future<void> dispose() async {
    await _eventsSubscription?.cancel();
    await stopSavedEventsSync();
    _eventsSubscription = null;
  }

  static Event byId(String id) {
    return events.firstWhere((event) => event.id == id);
  }

  /// Eventos que o usuário autenticado pode editar ou excluir.
  static List<Event> get editableEvents {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];
    return events.where((event) => event.createdBy == uid).toList();
  }

  static List<Event> eventsInCategory(String category) {
    return events.where((event) => event.category == category).toList();
  }

  static List<ProfileEventEntry> get myEvents {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    return events
        .where((event) => event.createdBy == uid)
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
    if (isSaved(id)) {
      await removeSavedInterest(id);
    }
  }

  static void _notifyChange() {
    version.value++;
  }
}
