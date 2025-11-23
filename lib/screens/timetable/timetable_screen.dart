import 'dart:io';
import 'package:flutter/material.dart';
import 'package:studyhub/models/timetable_model.dart';
import 'package:studyhub/services/timetable_service.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:studyhub/screens/timetable/add_timetable_entry_screen.dart';
import 'package:open_filex/open_filex.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final _timetableService = TimetableService();
  final _authService = AuthService();
  final List<String> _weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  Future<void> _deleteEntry(TimetableEntry entry) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Class'),
        content: Text('Are you sure you want to delete ${entry.courseName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        await _timetableService.deleteEntry(user.uid, entry.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Class deleted')),
          );
        }
      }
    }
  }

  void _showEntryDetails(TimetableEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.courseName, style: Theme.of(context).textTheme.headlineSmall),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          Navigator.pop(context);
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddTimetableEntryScreen(entry: entry)),
                          );

                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteEntry(entry);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              if (entry.courseCode != null) _buildInfoRow(Icons.tag, 'Code', entry.courseCode!),
              if (entry.instructor != null) _buildInfoRow(Icons.person, 'Instructor', entry.instructor!),
              if (entry.room != null) _buildInfoRow(Icons.location_on, 'Room', entry.room!),
              _buildInfoRow(Icons.calendar_today, 'Day', _weekDays[entry.dayOfWeek - 1]),
              _buildInfoRow(Icons.access_time, 'Time', '${entry.startTime} - ${entry.endTime}'),
              if (entry.notes != null) ...[
                const SizedBox(height: 16),
                Text('Notes', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(entry.notes!),
              ],
              if (entry.pdfPath != null || entry.imagePath != null) ...[
                const SizedBox(height: 16),
                Text('Attachments', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
              ],
              if (entry.pdfPath != null)
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: const Text('View PDF'),
                  trailing: const Icon(Icons.open_in_new),
                  tileColor: Colors.red.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onTap: () async {
                    final file = File(entry.pdfPath!);
                    if (await file.exists()) {
                      await OpenFilex.open(entry.pdfPath!);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('File not found'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                ),
              if (entry.imagePath != null) ...[
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.image, color: Colors.blue),
                  title: const Text('View Image'),
                  trailing: const Icon(Icons.open_in_new),
                  tileColor: Colors.blue.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onTap: () async {
                    final file = File(entry.imagePath!);
                    if (await file.exists()) {
                      await OpenFilex.open(entry.imagePath!);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('File not found'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTimetableEntryScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<TimetableEntry>>(
        stream: _authService.getCurrentUser().then((user) => 
          user != null ? _timetableService.getEntriesStream(user.uid) : Stream.value(<TimetableEntry>[])
        ).asStream().asyncExpand((stream) => stream),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final entries = snapshot.data ?? [];
          
          return entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_view_week_outlined, size: 64, color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(height: 16),
                      Text('No classes scheduled', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Tap + to add your first class', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _weekDays.length,
                  itemBuilder: (context, dayIndex) {
                    final dayEntries = entries.where((e) => e.dayOfWeek == dayIndex + 1).toList();
                    if (dayEntries.isEmpty) return const SizedBox.shrink();
                    dayEntries.sort((a, b) => a.startTime.compareTo(b.startTime));

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(_weekDays[dayIndex], style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          ),
                          ...dayEntries.map((entry) => GestureDetector(
                                onTap: () => _showEntryDetails(entry),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Color(int.parse(entry.color!.substring(1), radix: 16) + 0xFF000000).withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 60,
                                        decoration: BoxDecoration(color: Color(int.parse(entry.color!.substring(1), radix: 16) + 0xFF000000), borderRadius: BorderRadius.circular(2)),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(entry.courseName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                                ),
                                                if (entry.pdfPath != null || entry.imagePath != null)
                                                  Icon(Icons.attach_file, size: 16, color: Theme.of(context).colorScheme.secondary),
                                              ],
                                            ),
                                            if (entry.courseCode != null) Text(entry.courseCode!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(Icons.access_time, size: 14, color: Theme.of(context).colorScheme.secondary),
                                                const SizedBox(width: 4),
                                                Text('${entry.startTime} - ${entry.endTime}', style: Theme.of(context).textTheme.bodySmall),
                                                const SizedBox(width: 16),
                                                if (entry.room != null) ...[
                                                  Icon(Icons.location_on_outlined, size: 14, color: Theme.of(context).colorScheme.secondary),
                                                  const SizedBox(width: 4),
                                                  Expanded(child: Text(entry.room!, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
                                                ],
                                              ],
                                            ),
                                            if (entry.instructor != null) ...[
                                              const SizedBox(height: 4),
                                              Text(entry.instructor!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      );
                  },
                );
        },
      ),
    );
  }
}

