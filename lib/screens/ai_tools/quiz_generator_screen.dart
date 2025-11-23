import 'package:flutter/material.dart';
import 'package:studyhub/services/gemini_service.dart';

class QuizGeneratorScreen extends StatefulWidget {
  const QuizGeneratorScreen({super.key});

  @override
  State<QuizGeneratorScreen> createState() => _QuizGeneratorScreenState();
}

class _QuizGeneratorScreenState extends State<QuizGeneratorScreen> {
  final TextEditingController _textController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  String _quiz = '';
  bool _isLoading = false;

  void _generateQuiz() async {
    if (_textController.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      // This is a placeholder.
      final quiz = await _geminiService.generateQuiz(_textController.text);
      setState(() {
        _quiz = quiz;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate quiz: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter text to generate a quiz from',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateQuiz,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Quiz'),
            ),
            const SizedBox(height: 16),
            if (_quiz.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _quiz,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
