import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String _apiKey = "AIzaSyD5A4f-wwY_LI9_Z1Z-o65B54KUaQuI9Tc";
  final String _modelName = "gemini-2.5-flash";

  Future<List<Map<String, String>>> generateFlashcards(String text) async {
    final model = GenerativeModel(model: _modelName, apiKey: _apiKey);
    final prompt =
        'Create a series of flashcards from the following text. Each flashcard should have a question and an answer. Format the output as a JSON array of objects, where each object has a "question" and "answer" key. For example: [{"question": "What is Flutter?", "answer": "A UI toolkit."}].\n\nText: """$text"""';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    if (response.text != null) {
      try {
        // The response might be enclosed in ```json ... ```, so we need to extract it.
        final jsonString = response.text!
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.map((e) => Map<String, String>.from(e)).toList();
      } catch (e) {
        // ignore: avoid_print
        print('Error parsing flashcards JSON: $e');
        return [];
      }
    }
    return [];
  }

  Future<String> summarizeText(String text) async {
    final model = GenerativeModel(model: _modelName, apiKey: _apiKey);
    final prompt = 'Summarize the following text:\n\n$text';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text ?? 'Failed to summarize text.';
  }

  Future<String> generateQuiz(String text) async {
    final model = GenerativeModel(model: _modelName, apiKey: _apiKey);
    final prompt =
        'Create a multiple-choice quiz from the following text. Provide 4 options and indicate the correct answer. Format as:\n[Question]\nA) [Option]\nB) [Option]\nC) [Option]\nD) [Option]\nAnswer: [Correct Letter]\n\n---\n\n$text';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text ?? 'Failed to generate quiz.';
  }
}
