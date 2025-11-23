import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyhub/models/resume_model.dart';

class ResumeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ResumeModel>> getResumesStream(String userId) {
    return _firestore
        .collection('resumes')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final resumes = snapshot.docs
          .map((doc) => ResumeModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      resumes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return resumes;
    });
  }

  Future<List<ResumeModel>> getAllResumes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('resumes')
          .where('userId', isEqualTo: userId)
          .get();

      final resumes = snapshot.docs
          .map((doc) => ResumeModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      resumes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return resumes;
    } catch (e) {
      print('Error getting resumes: $e');
      return [];
    }
  }

  Future<void> saveResume(ResumeModel resume) async {
    try {
      await _firestore.collection('resumes').doc(resume.id).set(resume.toJson());
    } catch (e) {
      print('Error saving resume: $e');
      rethrow;
    }
  }

  Future<void> deleteResume(String resumeId) async {
    try {
      await _firestore.collection('resumes').doc(resumeId).delete();
    } catch (e) {
      print('Error deleting resume: $e');
      rethrow;
    }
  }
}
