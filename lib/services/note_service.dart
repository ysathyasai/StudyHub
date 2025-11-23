import 'package:studyhub/models/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<NoteModel>> getNotesStream(String userId) {
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final notes = snapshot.docs
              .map((doc) => NoteModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
          // Sort in memory while index builds
          notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return notes;
        });
  }

  Future<List<NoteModel>> getAllNotes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NoteModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting notes: $e');
      return [];
    }
  }

  Future<void> saveNote(NoteModel note) async {
    try {
      await _firestore.collection('notes').doc(note.id).set(note.toJson());
    } catch (e) {
      print('Error saving note: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(String userId, String noteId) async {
    try {
      await _firestore.collection('notes').doc(noteId).delete();
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }
}

