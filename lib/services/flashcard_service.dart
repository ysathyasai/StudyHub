import 'package:studyhub/models/flashcard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlashcardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<FlashcardModel>> getFlashcardsStream(String userId) {
    return _firestore
        .collection('flashcards')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final flashcards = snapshot.docs
              .map((doc) => FlashcardModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
          // Sort in memory while index builds
          flashcards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return flashcards;
        });
  }

  Future<List<FlashcardModel>> getAllFlashcards(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('flashcards')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FlashcardModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting flashcards: $e');
      return [];
    }
  }

  Future<void> saveFlashcard(FlashcardModel flashcard) async {
    try {
      await _firestore.collection('flashcards').doc(flashcard.id).set(flashcard.toJson());
    } catch (e) {
      print('Error saving flashcard: $e');
      rethrow;
    }
  }

  Future<void> deleteFlashcard(String userId, String flashcardId) async {
    try {
      await _firestore.collection('flashcards').doc(flashcardId).delete();
    } catch (e) {
      print('Error deleting flashcard: $e');
      rethrow;
    }
  }
}

