import 'package:studyhub/models/flashcard_model.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:studyhub/services/flashcard_service.dart';
import 'package:studyhub/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// pdf_text dependency is disabled for Android build compatibility.
// import 'package:pdf_text/pdf_text.dart';
import 'package:uuid/uuid.dart';

class GenerateFlashcardsScreen extends StatefulWidget {
  const GenerateFlashcardsScreen({super.key});

  @override
  _GenerateFlashcardsScreenState createState() =>
      _GenerateFlashcardsScreenState();
}

class _GenerateFlashcardsScreenState extends State<GenerateFlashcardsScreen> {
  final TextEditingController _textController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  final FlashcardService _flashcardService = FlashcardService();
  final AuthService _authService = AuthService();
  String? _filePath;
  bool _isLoading = false;

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        if (_filePath != null) {
          _textController.text = 'PDF selected: ${_filePath!.split('\\').last}';
        }
      });
    }
  }

  Future<void> _generateFlashcards() async {
    setState(() {
      _isLoading = true;
    });

    String content = _textController.text;
    if (_filePath != null) {
      // Inform user PDF extraction is unavailable in this build
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF text extraction is temporarily unavailable.'),
        ),
      );
    }

    if (content.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide text or a PDF')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final user = await _authService.getCurrentUser();
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to generate flashcards.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final flashcardData = await _geminiService.generateFlashcards(content);

    if (flashcardData.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Could not generate flashcards from the provided text.')),
      );
    } else {
      final deckName = _textController.text.substring(
          0,
          (_textController.text.length > 50)
              ? 50
              : _textController.text.length);
      for (var card in flashcardData) {
        final newFlashcard = FlashcardModel(
          id: const Uuid().v4(),
          userId: user.uid,
          question: card['question'] ?? '',
          answer: card['answer'] ?? '',
          deckName: deckName,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _flashcardService.saveFlashcard(newFlashcard);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${flashcardData.length} flashcards generated and saved to deck "$deckName"')),
      );
      Navigator.pop(context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Flashcards')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Paste your text here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickPDF,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Or Upload a PDF'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateFlashcards,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Generate Flashcards'),
            ),
          ],
        ),
      ),
    );
  }
}

