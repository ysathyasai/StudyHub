import 'package:flutter/material.dart';
import 'package:studyhub/models/note_model.dart';
import 'package:studyhub/services/note_service.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:uuid/uuid.dart';

class NoteEditorScreen extends StatefulWidget {
  final NoteModel? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _noteService = NoteService();
  final _authService = AuthService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _isFavorite = widget.note!.isFavorite;
    }
  }

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    final user = await _authService.getCurrentUser();
    if (user == null) return;

    final now = DateTime.now();
    final note = widget.note?.copyWith(
          title: _titleController.text,
          content: _contentController.text,
          isFavorite: _isFavorite,
          updatedAt: now,
        ) ??
        NoteModel(
          id: const Uuid().v4(),
          userId: user.uid,
          title: _titleController.text,
          content: _contentController.text,
          isFavorite: _isFavorite,
          createdAt: now,
          updatedAt: now,
        );

    await _noteService.saveNote(note);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteNote() async {
    if (widget.note == null) return;
    final user = await _authService.getCurrentUser();
    if (user == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await _noteService.deleteNote(user.uid, widget.note!.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(icon: Icon(_isFavorite ? Icons.star : Icons.star_border, color: _isFavorite ? Colors.amber : null), onPressed: () => setState(() => _isFavorite = !_isFavorite)),
          if (widget.note != null) IconButton(icon: const Icon(Icons.delete_outline), onPressed: _deleteNote),
          IconButton(icon: const Icon(Icons.check), onPressed: _saveNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Note title', border: InputBorder.none, contentPadding: EdgeInsets.zero),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(hintText: 'Start typing...', border: InputBorder.none, contentPadding: EdgeInsets.zero),
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

