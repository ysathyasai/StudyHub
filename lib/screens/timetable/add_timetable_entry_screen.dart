import 'dart:io';
import 'package:flutter/material.dart';
import 'package:studyhub/models/timetable_model.dart';
import 'package:studyhub/services/timetable_service.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class AddTimetableEntryScreen extends StatefulWidget {
  final TimetableEntry? entry;

  const AddTimetableEntryScreen({super.key, this.entry});

  @override
  State<AddTimetableEntryScreen> createState() => _AddTimetableEntryScreenState();
}

class _AddTimetableEntryScreenState extends State<AddTimetableEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _timetableService = TimetableService();
  final _authService = AuthService();
  
  late TextEditingController _courseNameController;
  late TextEditingController _courseCodeController;
  late TextEditingController _instructorController;
  late TextEditingController _roomController;
  late TextEditingController _notesController;
  
  int _selectedDay = 1;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  Color _selectedColor = Colors.blue;
  
  File? _pdfFile;
  File? _imageFile;
  String? _existingPdfPath;
  String? _existingImagePath;
  bool _isLoading = false;

  final List<String> _weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<Color> _colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal, Colors.pink];

  @override
  void initState() {
    super.initState();
    _courseNameController = TextEditingController(text: widget.entry?.courseName);
    _courseCodeController = TextEditingController(text: widget.entry?.courseCode);
    _instructorController = TextEditingController(text: widget.entry?.instructor);
    _roomController = TextEditingController(text: widget.entry?.room);
    _notesController = TextEditingController(text: widget.entry?.notes);
    
    if (widget.entry != null) {
      _selectedDay = widget.entry!.dayOfWeek;
      _startTime = _parseTime(widget.entry!.startTime);
      _endTime = _parseTime(widget.entry!.endTime);
      if (widget.entry!.color != null) {
        _selectedColor = Color(int.parse(widget.entry!.color!.substring(1), radix: 16) + 0xFF000000);
      }
      _existingPdfPath = widget.entry!.pdfPath;
      _existingImagePath = widget.entry!.imagePath;
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _instructorController.dispose();
    _roomController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      setState(() {
        _imageFile = File(result.path);
      });
    }
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await _authService.getCurrentUser();
      if (user == null) throw 'User not logged in';

      final entryId = widget.entry?.id ?? const Uuid().v4();
      String? pdfPath = _existingPdfPath;
      String? imagePath = _existingImagePath;

      // Save PDF locally if selected
      if (_pdfFile != null) {
        pdfPath = await _timetableService.saveFileLocally(user.uid, entryId, _pdfFile!, 'pdf');
      }

      // Save image locally if selected
      if (_imageFile != null) {
        imagePath = await _timetableService.saveFileLocally(user.uid, entryId, _imageFile!, 'image');
      }

      final entry = TimetableEntry(
        id: entryId,
        userId: user.uid,
        courseName: _courseNameController.text.trim(),
        courseCode: _courseCodeController.text.trim().isEmpty ? null : _courseCodeController.text.trim(),
        instructor: _instructorController.text.trim().isEmpty ? null : _instructorController.text.trim(),
        room: _roomController.text.trim().isEmpty ? null : _roomController.text.trim(),
        dayOfWeek: _selectedDay,
        startTime: _formatTime(_startTime),
        endTime: _formatTime(_endTime),
        color: '#${_selectedColor.value.toRadixString(16).substring(2)}',
        pdfPath: pdfPath,
        imagePath: imagePath,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        createdAt: widget.entry?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _timetableService.saveEntry(entry);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.entry == null ? 'Class added successfully' : 'Class updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Add Class' : 'Edit Class'),
        actions: [
          IconButton(
            icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check),
            onPressed: _isLoading ? null : _saveEntry,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _courseNameController,
              decoration: const InputDecoration(
                labelText: 'Course Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
              validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _courseCodeController,
              decoration: const InputDecoration(
                labelText: 'Course Code',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.tag),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _instructorController,
              decoration: const InputDecoration(
                labelText: 'Instructor',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roomController,
              decoration: const InputDecoration(
                labelText: 'Room/Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 24),
            Text('Day of Week', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(_weekDays.length, (index) {
                return ChoiceChip(
                  label: Text(_weekDays[index].substring(0, 3)),
                  selected: _selectedDay == index + 1,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedDay = index + 1);
                  },
                );
              }),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Start Time'),
                    subtitle: Text(_formatTime(_startTime)),
                    trailing: const Icon(Icons.access_time),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: _startTime);
                      if (time != null) setState(() => _startTime = time);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListTile(
                    title: const Text('End Time'),
                    subtitle: Text(_formatTime(_endTime)),
                    trailing: const Icon(Icons.access_time),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: _endTime);
                      if (time != null) setState(() => _endTime = time);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Color', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: _colors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: _selectedColor == color
                          ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2)]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Text('Attachments', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickPDF,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: Text(_pdfFile != null ? 'PDF Selected' : _existingPdfPath != null ? 'Change PDF' : 'Add PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: Text(_imageFile != null ? 'Image Selected' : _existingImagePath != null ? 'Change Image' : 'Add Image'),
                  ),
                ),
              ],
            ),
            if (_pdfFile != null || _existingPdfPath != null) ...[
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(_pdfFile?.path.split('/').last ?? 'Existing PDF'),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() {
                    _pdfFile = null;
                    _existingPdfPath = null;
                  }),
                ),
                tileColor: Colors.red.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ],
            if (_imageFile != null || _existingImagePath != null) ...[
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.image, color: Colors.blue),
                title: Text(_imageFile?.path.split('/').last ?? 'Existing Image'),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() {
                    _imageFile = null;
                    _existingImagePath = null;
                  }),
                ),
                tileColor: Colors.blue.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
