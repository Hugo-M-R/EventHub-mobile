import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Eventos salvos ("Tenho interesse") no Firestore por usuário.
class SavedEventService {
  SavedEventService._();

  static final SavedEventService instance = SavedEventService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _savedCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('saved_events');
  }

  Stream<List<String>> watchSavedEventIds(String userId) {
    return _savedCollection(userId)
        .orderBy('savedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Future<void> saveInterest(String eventId) async {
    final user = _requireUser();
    await _savedCollection(user.uid).doc(eventId).set({
      'eventId': eventId,
      'usuario_logado': user.email,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeInterest(String eventId) async {
    final user = _requireUser();
    await _savedCollection(user.uid).doc(eventId).delete();
  }

  User _requireUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      throw StateError('É necessário estar autenticado para salvar eventos.');
    }
    return user;
  }
}
