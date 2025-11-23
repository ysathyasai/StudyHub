import 'api_service.dart';
import '../models/scholarship_model.dart';

class ScholarshipService {
  final ApiService _apiService = ApiService();
  static const String _cx = '759f2bfedcd554276';

  Future<List<Scholarship>> searchScholarships(String query) async {
    if (query.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> results = await _apiService.search(query, _cx);
      return results.map((item) {
        return Scholarship(
          id: item['cacheId'] ?? DateTime.now().toIso8601String(),
          title: item['title'] ?? 'No Title',
          description: item['snippet'] ?? 'No Description',
          eligibility: 'Varies', // Placeholder
          deadline: 'N/A', // Placeholder
          link: item['link'] ?? '',
        );
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error searching scholarships: $e');
      return [];
    }
  }
}
