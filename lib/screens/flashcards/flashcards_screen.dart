import 'package:studyhub/screens/flashcards/generate_flashcards_screen.dart';
import 'package:flutter/material.dart';
import 'package:studyhub/models/flashcard_model.dart';
import 'package:studyhub/services/flashcard_service.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:studyhub/screens/flashcards/flashcard_study_screen.dart';
import 'package:uuid/uuid.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  final _flashcardService = FlashcardService();
  final _authService = AuthService();

  Future<void> _showAddFlashcardDialog() async {
    final questionController = TextEditingController();
    final answerController = TextEditingController();
    final deckController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Flashcard'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: questionController, decoration: const InputDecoration(labelText: 'Question', border: OutlineInputBorder()), maxLines: 2),
              const SizedBox(height: 12),
              TextField(controller: answerController, decoration: const InputDecoration(labelText: 'Answer', border: OutlineInputBorder()), maxLines: 3),
              const SizedBox(height: 12),
              TextField(controller: deckController, decoration: const InputDecoration(labelText: 'Deck Name (optional)', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (questionController.text.isEmpty || answerController.text.isEmpty) return;
              final user = await _authService.getCurrentUser();
              if (user == null) return;
              final now = DateTime.now();
              final flashcard = FlashcardModel(id: const Uuid().v4(), userId: user.uid, question: questionController.text, answer: answerController.text, deckName: deckController.text.isEmpty ? null : deckController.text, createdAt: now, updatedAt: now);
              await _flashcardService.saveFlashcard(flashcard);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        actions: [
          StreamBuilder<List<FlashcardModel>>(
            stream: _authService.getCurrentUser().then((user) => 
              user != null ? _flashcardService.getFlashcardsStream(user.uid) : Stream.value(<FlashcardModel>[])
            ).asStream().asyncExpand((stream) => stream),
            builder: (context, snapshot) {
              final flashcards = snapshot.data ?? [];
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: flashcards.isEmpty 
                  ? null 
                  : () => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => FlashcardStudyScreen(flashcards: flashcards))
                    ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<FlashcardModel>>(
        stream: _authService.getCurrentUser().then((user) => 
          user != null ? _flashcardService.getFlashcardsStream(user.uid) : Stream.value(<FlashcardModel>[])
        ).asStream().asyncExpand((stream) => stream),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final flashcards = snapshot.data ?? [];
          final decks = flashcards.map((f) => f.deckName ?? 'Uncategorized').toSet().toList();

          return flashcards.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.style_outlined, size: 64, color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(height: 16),
                      Text('No flashcards yet', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Create your first flashcard', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GenerateFlashcardsScreen())),
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Generate with AI'),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('${flashcards.length}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                              Text('Total Cards', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                            ],
                          ),
                          Container(width: 1, height: 40, color: Theme.of(context).colorScheme.outline),
                          Column(
                            children: [
                              Text('${decks.length}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                              Text('Decks', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...decks.map((deck) {
                      final deckCards = flashcards.where((f) => (f.deckName ?? 'Uncategorized') == deck).toList();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(deck, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600))),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)), child: Text('${deckCards.length} cards', style: Theme.of(context).textTheme.bodySmall)),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => FlashcardStudyScreen(flashcards: deckCards))
                                  ),
                                  tooltip: 'Study this deck',
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...deckCards.map((flashcard) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Q: ${flashcard.question}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 8),
                                      Text('A: ${flashcard.answer}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                                      if (flashcard.reviewCount > 0) ...[
                                        const SizedBox(height: 8),
                                        Text('Reviewed ${flashcard.reviewCount}x', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                                      ],
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      );
                    }),
                  ],
                );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GenerateFlashcardsScreen())),
            heroTag: 'generate',
            child: const Icon(Icons.auto_awesome),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _showAddFlashcardDialog,
            heroTag: 'add',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

