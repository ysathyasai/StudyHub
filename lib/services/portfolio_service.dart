import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyhub/models/portfolio_model.dart';

class PortfolioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PortfolioModel>> getPortfolioStream(String userId) {
    return _firestore
        .collection('portfolio')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final projects = snapshot.docs
          .map((doc) => PortfolioModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return projects;
    });
  }

  Future<List<PortfolioModel>> getProjects(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('portfolio')
          .where('userId', isEqualTo: userId)
          .get();

      final projects = snapshot.docs
          .map((doc) => PortfolioModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return projects;
    } catch (e) {
      print('Error getting portfolio: $e');
      return [];
    }
  }

  Future<void> saveProject(PortfolioModel project) async {
    try {
      await _firestore.collection('portfolio').doc(project.id).set(project.toJson());
    } catch (e) {
      print('Error saving project: $e');
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection('portfolio').doc(projectId).delete();
    } catch (e) {
      print('Error deleting project: $e');
      rethrow;
    }
  }
}
