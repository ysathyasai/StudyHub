import 'package:flutter/material.dart';
import 'package:studyhub/models/flashcard_model.dart';
import 'package:studyhub/services/flashcard_service.dart';

class FlashcardStudyScreen extends StatefulWidget {
  final List<FlashcardModel> flashcards;

  const FlashcardStudyScreen({super.key, required this.flashcards});

  @override
  State<FlashcardStudyScreen> createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  final _flashcardService = FlashcardService();

  void _nextCard() {
    setState(() {
      _showAnswer = false;
      _currentIndex = (_currentIndex + 1) % widget.flashcards.length;
    });
  }

  void _previousCard() {
    setState(() {
      _showAnswer = false;
      _currentIndex = (_currentIndex - 1 + widget.flashcards.length) % widget.flashcards.length;
    });
  }

  Future<void> _markAsReviewed() async {
    final card = widget.flashcards[_currentIndex];
    final updatedCard = card.copyWith(reviewCount: card.reviewCount + 1, lastReviewed: DateTime.now());
    await _flashcardService.saveFlashcard(updatedCard);
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentIndex + 1} / ${widget.flashcards.length}'),
        actions: [IconButton(icon: const Icon(Icons.shuffle), onPressed: () => setState(() => widget.flashcards.shuffle()))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showAnswer = !_showAnswer),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    key: ValueKey(_showAnswer),
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: _showAnswer ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_showAnswer ? 'Answer' : 'Question', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                        const SizedBox(height: 24),
                        Text(_showAnswer ? card.answer : card.question, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                        const SizedBox(height: 32),
                        Text('Tap to ${_showAnswer ? 'see question' : 'reveal answer'}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filled(icon: const Icon(Icons.arrow_back), iconSize: 32, onPressed: _previousCard, style: IconButton.styleFrom(padding: const EdgeInsets.all(16))),
                if (_showAnswer)
                  ElevatedButton.icon(
                    onPressed: () {
                      _markAsReviewed();
                      _nextCard();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Got it'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                  ),
                IconButton.filled(icon: const Icon(Icons.arrow_forward), iconSize: 32, onPressed: _nextCard, style: IconButton.styleFrom(padding: const EdgeInsets.all(16))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

