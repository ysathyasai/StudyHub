import 'dart:io';
import 'package:studyhub/models/timetable_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class TimetableService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<TimetableEntry>> getEntriesStream(String userId) {
    return _firestore
        .collection('timetables')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final entries = snapshot.docs
          .map((doc) => TimetableEntry.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      // Sort in memory
      entries.sort((a, b) {
        final dayCompare = a.dayOfWeek.compareTo(b.dayOfWeek);
        if (dayCompare != 0) return dayCompare;
        return a.startTime.compareTo(b.startTime);
      });
      return entries;
    });
  }

  Future<List<TimetableEntry>> getAllEntries(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('timetables')
          .where('userId', isEqualTo: userId)
          .get();

      final entries = snapshot.docs
          .map((doc) => TimetableEntry.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      // Sort in memory
      entries.sort((a, b) {
        final dayCompare = a.dayOfWeek.compareTo(b.dayOfWeek);
        if (dayCompare != 0) return dayCompare;
        return a.startTime.compareTo(b.startTime);
      });
      return entries;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveEntry(TimetableEntry entry) async {
    await _firestore.collection('timetables').doc(entry.id).set(entry.toJson());
  }

  Future<void> deleteEntry(String userId, String entryId) async {
    // Delete associated files from local storage
    final entry = await _firestore.collection('timetables').doc(entryId).get();
    if (entry.exists) {
      final data = entry.data();
      if (data?['pdfPath'] != null) {
        try {
          final file = File(data!['pdfPath']);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // File might not exist
        }
      }
      if (data?['imagePath'] != null) {
        try {
          final file = File(data!['imagePath']);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // File might not exist
        }
      }
    }
    await _firestore.collection('timetables').doc(entryId).delete();
  }

  Future<String?> saveFileLocally(String userId, String entryId, File file, String type) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final extension = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      final folderPath = '${directory.path}/timetables/$userId/$entryId/$type';
      
      // Create directory if it doesn't exist
      await Directory(folderPath).create(recursive: true);
      
      final newPath = '$folderPath/$fileName';
      await file.copy(newPath);
      
      return newPath;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteLocalFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // File might not exist
    }
  }
}

