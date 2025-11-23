import 'package:flutter/material.dart';
import 'package:studyhub/screens/notes/notes_screen.dart';
import 'package:studyhub/screens/flashcards/flashcards_screen.dart';
import 'package:studyhub/screens/study_timer/study_timer_screen.dart';
import 'package:studyhub/screens/focus_mode/focus_mode_screen.dart';
import 'package:studyhub/screens/formula_library/formula_library_screen.dart';
import 'package:studyhub/widgets/hoverable_container.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Tools')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildToolCard(context, 'Notes', 'Create and organize study notes', Icons.note_outlined, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotesScreen()))),
          _buildToolCard(context, 'Flashcards', 'Study with digital flashcards', Icons.style_outlined, Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardsScreen()))),
          _buildToolCard(context, 'Study Timer', 'Pomodoro technique timer', Icons.timer_outlined, Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudyTimerScreen()))),
          _buildToolCard(context, 'Focus Mode', 'Distraction-free studying', Icons.remove_red_eye_outlined, Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FocusModeScreen()))),
          _buildToolCard(context, 'Formula Library', 'Quick formula reference', Icons.calculate_outlined, Colors.red, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormulaLibraryScreen()))),
        ],
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: HoverableContainer(
        color: color,
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.secondary),
          ],
        ),
      ),
    );
  }
}

