import 'package:flutter/material.dart';
import 'package:studyhub/services/gemini_service.dart';

class SummarizerScreen extends StatefulWidget {
  const SummarizerScreen({super.key});

  @override
  State<SummarizerScreen> createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  final TextEditingController _textController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  String _summary = '';
  bool _isLoading = false;

  void _summarizeText() async {
    if (_textController.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      // This is a placeholder.
      // In a real implementation, you would call the Gemini API.
      final summary = await _geminiService.summarizeText(_textController.text);
      setState(() {
        _summary = summary;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to summarize: ${e.toString()}')),
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
        title: const Text('Document Summarizer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter text to summarize',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _summarizeText,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Summarize'),
            ),
            const SizedBox(height: 16),
            if (_summary.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _summary,
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
