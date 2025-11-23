import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyhub/models/semester_result_model.dart';

class SemesterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SemesterResult>> getAllResults(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('semester_results')
          .where('userId', isEqualTo: userId)
          .orderBy('uploadedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SemesterResult.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<SemesterResult?> getResultBySemester(String userId, String semester) async {
    try {
      final snapshot = await _firestore
          .collection('semester_results')
          .where('userId', isEqualTo: userId)
          .where('semester', isEqualTo: semester)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return SemesterResult.fromJson({...snapshot.docs.first.data(), 'id': snapshot.docs.first.id});
    } catch (e) {
      return null;
    }
  }

  Future<void> saveResult(SemesterResult result) async {
    await _firestore.collection('semester_results').doc(result.id).set(result.toJson());
  }

  Future<void> deleteResult(String resultId) async {
    await _firestore.collection('semester_results').doc(resultId).delete();
  }

  // Calculate statistics
  Map<String, dynamic> calculateStatistics(List<SemesterResult> results) {
    if (results.isEmpty) {
      return {
        'overallCGPA': 0.0,
        'totalCredits': 0,
        'totalSubjects': 0,
        'passedSubjects': 0,
        'failedSubjects': 0,
        'averagePercentage': 0.0,
      };
    }

    double totalCGPA = 0;
    int totalCredits = 0;
    int totalSubjects = 0;
    int passedSubjects = 0;
    int failedSubjects = 0;
    double totalPercentage = 0;

    for (var result in results) {
      totalCGPA += result.cgpa;
      totalCredits += result.creditsEarned;
      
      for (var subject in result.subjects) {
        totalSubjects++;
        totalPercentage += subject.subjectTotal;
        if (subject.isPassed) {
          passedSubjects++;
        } else {
          failedSubjects++;
        }
      }
    }

    return {
      'overallCGPA': totalCGPA / results.length,
      'totalCredits': totalCredits,
      'totalSubjects': totalSubjects,
      'passedSubjects': passedSubjects,
      'failedSubjects': failedSubjects,
      'averagePercentage': totalSubjects > 0 ? totalPercentage / totalSubjects : 0.0,
    };
  }

  // Get grade distribution
  Map<String, int> getGradeDistribution(List<SemesterResult> results) {
    Map<String, int> distribution = {
      'A+': 0,
      'A': 0,
      'B+': 0,
      'B': 0,
      'C': 0,
      'E': 0,
      'F': 0,
      'P': 0,
    };

    for (var result in results) {
      for (var subject in result.subjects) {
        if (distribution.containsKey(subject.grade)) {
          distribution[subject.grade] = distribution[subject.grade]! + 1;
        }
      }
    }

    return distribution;
  }
}
