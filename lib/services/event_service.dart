import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/event.dart';
import '../models/event_profile_status.dart';

/// Persistência de eventos no Firestore (capas em base64, sem Storage).
class EventService {
  EventService._();

  static final EventService instance = EventService._();

  static const _eventsCollection = 'events';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _events =>
      _firestore.collection(_eventsCollection);

  Stream<List<Event>> watchEvents() {
    return _events
        .orderBy('startsAt')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList(),
        );
  }

  String newEventId() => _events.doc().id;

  static String? _encodeCover(Uint8List? bytes) {
    if (bytes == null) return null;
    return base64Encode(bytes);
  }

  Future<void> createEvent(
    Event event, {
    Uint8List? coverBytes,
  }) async {
    final user = _requireCurrentUser();

    await _events.doc(event.id).set(
          event.toFirestore(
            createdBy: user.uid,
            usuarioLogado: user.email!,
            coverImageBase64: _encodeCover(coverBytes),
            isCreate: true,
          ),
        );
  }

  Future<void> updateEvent(
    Event event, {
    Uint8List? coverBytes,
    bool removeCover = false,
  }) async {
    final user = _requireCurrentUser();
    _assertOwnership(event, user.uid);

    await _events.doc(event.id).update(
          event.toFirestore(
            createdBy: event.createdBy!,
            usuarioLogado: event.usuarioLogado ?? user.email!,
            coverImageBase64: removeCover ? null : _encodeCover(coverBytes),
            profileStatus: EventProfileStatus.alterado,
            deleteCoverImage: removeCover,
            includeCover: removeCover || coverBytes != null,
          ),
        );
  }

  Future<void> deleteEvent(Event event) async {
    final user = _requireCurrentUser();
    _assertOwnership(event, user.uid);
    await _events.doc(event.id).delete();
  }

  User _requireCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      throw StateError('É necessário estar autenticado para gerenciar eventos.');
    }
    return user;
  }

  void _assertOwnership(Event event, String uid) {
    if (event.createdBy != uid) {
      throw StateError('Você só pode alterar eventos que você criou.');
    }
  }
}
