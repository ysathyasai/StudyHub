import 'package:flutter/material.dart';
import 'package:studyhub/models/calendar_event_model.dart';
import 'package:studyhub/services/calendar_service.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _calendarService = CalendarService();
  final _authService = AuthService();
  DateTime _selectedDate = DateTime.now();

  List<CalendarEventModel> _getEventsForDate(DateTime date, List<CalendarEventModel> events) {
    return events.where((event) {
      final eventDate = DateTime(
          event.startTime.year, event.startTime.month, event.startTime.day);
      final selectedDate = DateTime(date.year, date.month, date.day);
      return eventDate.isAtSameMomentAs(selectedDate);
    }).toList();
  }

  Future<void> _showAddEventDialog() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final locationController = TextEditingController();
    DateTime startTime = _selectedDate.copyWith(hour: 10, minute: 0);
    DateTime endTime = _selectedDate.copyWith(hour: 11, minute: 0);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('New Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        labelText: 'Title', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        border: OutlineInputBorder()),
                    maxLines: 2),
                const SizedBox(height: 12),
                TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                        labelText: 'Location (optional)',
                        border: OutlineInputBorder())),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Start Time'),
                  subtitle:
                      Text(DateFormat('MMM d, y - HH:mm').format(startTime)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final date = await showDatePicker(
                        context: context,
                        initialDate: startTime,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)));
                    if (date != null) {
                      final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(startTime));
                      if (time != null) {
                        setDialogState(() => startTime = date.copyWith(
                            hour: time.hour, minute: time.minute));
                      }
                    }
                  },
                ),
                ListTile(
                  title: const Text('End Time'),
                  subtitle:
                      Text(DateFormat('MMM d, y - HH:mm').format(endTime)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final date = await showDatePicker(
                        context: context,
                        initialDate: endTime,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)));
                    if (date != null) {
                      final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(endTime));
                      if (time != null) {
                        setDialogState(() => endTime = date.copyWith(
                            hour: time.hour, minute: time.minute));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty) return;
                final user = await _authService.getCurrentUser();
                if (user == null) return;
                final now = DateTime.now();
                final event = CalendarEventModel(
                    id: const Uuid().v4(),
                    userId: user.uid,
                    title: titleController.text,
                    description: descController.text.isEmpty
                        ? null
                        : descController.text,
                    startTime: startTime,
                    endTime: endTime,
                    location: locationController.text.isEmpty
                        ? null
                        : locationController.text,
                    createdAt: now,
                    updatedAt: now);
                await _calendarService.saveEvent(event);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: StreamBuilder<List<CalendarEventModel>>(
        stream: _authService.getCurrentUser().then((user) => 
          user != null ? _calendarService.getEventsStream(user.uid) : Stream.value(<CalendarEventModel>[])
        ).asStream().asyncExpand((stream) => stream),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final events = snapshot.data ?? [];
          final selectedEvents = _getEventsForDate(_selectedDate, events);

          return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => setState(() => _selectedDate =
                              DateTime(_selectedDate.year,
                                  _selectedDate.month - 1))),
                      Text(DateFormat('MMMM yyyy').format(_selectedDate),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () => setState(() => _selectedDate =
                              DateTime(_selectedDate.year,
                                  _selectedDate.month + 1))),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      final date =
                          DateTime(_selectedDate.year, _selectedDate.month, 1)
                              .add(Duration(days: index));
                      final isSelected = date.day == _selectedDate.day &&
                          date.month == _selectedDate.month;
                      final hasEvents = _getEventsForDate(date, events).isNotEmpty;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = date),
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withValues(alpha: 0.3))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(DateFormat('EEE').format(date),
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Text('${date.day}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              if (hasEvents)
                                Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: BoxShape.circle)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: selectedEvents.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_outlined,
                                  size: 64,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              const SizedBox(height: 16),
                              Text('No events on this day',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: selectedEvents.length,
                          itemBuilder: (context, index) {
                            final event = selectedEvents[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withValues(alpha: 0.3))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(event.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600))),
                                      if (event.category != null)
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Text(event.category!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          size: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      const SizedBox(width: 4),
                                      Text(
                                          '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ],
                                  ),
                                  if (event.location != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            size: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        const SizedBox(width: 4),
                                        Text(event.location!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                      ],
                                    ),
                                  ],
                                  if (event.description != null) ...[
                                    const SizedBox(height: 8),
                                    Text(event.description!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _showAddEventDialog, child: const Icon(Icons.add)),
    );
  }
}
