import 'package:flutter/material.dart';
import 'package:studyhub/models/note_model.dart';
import 'package:studyhub/services/note_service.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:studyhub/screens/notes/note_editor_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _noteService = NoteService();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: StreamBuilder<List<NoteModel>>(
        stream: _authService.getCurrentUser().then((user) => 
          user != null ? _noteService.getNotesStream(user.uid) : Stream.value(<NoteModel>[])
        ).asStream().asyncExpand((stream) => stream),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final notes = snapshot.data ?? [];
          
          return notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_outlined, size: 64, color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(height: 16),
                      Text('No notes yet', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Tap + to create your first note', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note))),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(note.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600))),
                                  if (note.isFavorite) const Icon(Icons.star, color: Colors.amber, size: 20),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(note.content, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                              if (note.tags.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  children: note.tags.take(3).map((tag) => Chip(label: Text(tag), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0), labelStyle: Theme.of(context).textTheme.bodySmall)).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NoteEditorScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}

