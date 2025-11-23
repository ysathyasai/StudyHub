import 'package:flutter/material.dart';
import 'package:studyhub/screens/timetable/timetable_screen.dart';
import 'package:studyhub/screens/tasks/tasks_screen.dart';
import 'package:studyhub/screens/calendar/calendar_screen.dart';
import 'package:studyhub/screens/semester_overview/semester_overview_screen.dart';
import 'package:studyhub/widgets/hoverable_container.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildToolCard(context, 'Timetable', 'Weekly class schedule', Icons.calendar_view_week_outlined, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimetableScreen()))),
          _buildToolCard(context, 'Calendar', 'Events and deadlines', Icons.calendar_today_outlined, Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen()))),
          _buildToolCard(context, 'To-Do Lists', 'Manage your tasks', Icons.check_box_outlined, Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TasksScreen()))),
          _buildToolCard(context, 'Semester Overview', 'Track grades and GPA', Icons.school_outlined, Colors.purple, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SemesterOverviewScreen()),
      );
    }),
        ],
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: HoverableContainer(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        color: color,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
          ),
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
      ),
    );
  }
}

