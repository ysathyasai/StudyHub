import 'package:studyhub/models/calendar_event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CalendarEventModel>> getEventsStream(String userId) {
    return _firestore
        .collection('calendar_events')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final events = snapshot.docs
              .map((doc) => CalendarEventModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
          // Sort in memory while index builds
          events.sort((a, b) => a.startTime.compareTo(b.startTime));
          return events;
        });
  }

  Future<List<CalendarEventModel>> getAllEvents(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('calendar_events')
          .where('userId', isEqualTo: userId)
          .orderBy('startTime', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => CalendarEventModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting events: $e');
      return [];
    }
  }

  Future<void> saveEvent(CalendarEventModel event) async {
    try {
      await _firestore.collection('calendar_events').doc(event.id).set(event.toJson());
    } catch (e) {
      print('Error saving event: $e');
      rethrow;
    }
  }

  Future<void> deleteEvent(String userId, String eventId) async {
    try {
      await _firestore.collection('calendar_events').doc(eventId).delete();
    } catch (e) {
      print('Error deleting event: $e');
      rethrow;
    }
  }
}

