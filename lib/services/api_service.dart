import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://www.googleapis.com/customsearch/v1';
  static const String _apiKey = 'AIzaSyAywbc5Ptz9sfhMytzg6YsDMxKCRBH5QZg';

  Future<List<dynamic>> search(String query, String cx) async {
    final queryParams = {
      'key': _apiKey,
      'cx': cx,
      'q': query,
    };

    try {
      final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('items')) {
          return data['items'];
        }
        return [];
      } else {
        print('API Error: ${response.statusCode} ${response.reasonPhrase}');
        // Consider logging the response body for more details
        // print(response.body);
        return [];
      }
    } catch (e) {
      print('Network Error: $e');
      return [];
    }
  }
}
