import 'dart:convert';
import 'package:studyhub/models/internship_model.dart';
import 'package:studyhub/services/api_service.dart';
import 'package:studyhub/services/storage_service.dart';

class InternshipService {
  static const String _savedKey = 'saved_internships';
  final ApiService _apiService = ApiService();
  static const String _cx = 'b634d735a64db4c52';

  Future<List<InternshipModel>> searchInternships(String query) async {
    if (query.isEmpty) {
      return [];
    }
    
    final String searchQuery = '$query internship';
    final List<dynamic> results = await _apiService.search(searchQuery, _cx);

    return results.map((item) {
      final snippet = item['snippet'] ?? '';
      final pagemap = item['pagemap'];
      final metatags = pagemap != null && pagemap['metatags'] != null ? pagemap['metatags'][0] : {};

      return InternshipModel(
        id: item['link'], // Use link as a unique ID
        company: metatags['og:site_name'] ?? 'N/A',
        position: item['title'],
        location: metatags['og:locality'] ?? 'Remote',
        type: 'Full-time', // Placeholder, as this info is not always available
        description: snippet,
        requirements: [], // Placeholder
        duration: '', // Placeholder
        stipend: '', // Placeholder
        applyLink: item['link'],
        postedDate: DateTime.now(), // Placeholder
      );
    }).toList();
  }

  Future<List<InternshipModel>> getSavedInternships() async {
    final data = await StorageService.getString(_savedKey);
    if (data == null) return [];
    try {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => InternshipModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> toggleSave(InternshipModel internship) async {
    final saved = await getSavedInternships();
    final index = saved.indexWhere((i) => i.id == internship.id);
    if (index >= 0) {
      saved.removeAt(index);
    } else {
      internship.isSaved = true;
      saved.add(internship);
    }
    await StorageService.setString(_savedKey, jsonEncode(saved.map((e) => e.toJson()).toList()));
  }
}


