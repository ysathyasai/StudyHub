import 'package:flutter/material.dart';
import 'package:studyhub/models/task_model.dart';
import 'package:studyhub/services/task_service.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _taskService = TaskService();
  final _authService = AuthService();
  bool _showCompleted = true;

  Future<void> _toggleTaskCompletion(TaskModel task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await _taskService.saveTask(updatedTask);
  }

  Future<void> _showAddTaskDialog() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    TaskPriority priority = TaskPriority.medium;
    TaskCategory category = TaskCategory.personal;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description (optional)', border: OutlineInputBorder()), maxLines: 2),
                const SizedBox(height: 12),
                DropdownButtonFormField<TaskPriority>(
                  value: priority,
                  decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
                  items: TaskPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name.toUpperCase()))).toList(),
                  onChanged: (val) => setDialogState(() => priority = val ?? TaskPriority.medium),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TaskCategory>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                  items: TaskCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name.toUpperCase()))).toList(),
                  onChanged: (val) => setDialogState(() => category = val ?? TaskCategory.personal),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty) return;
                final user = await _authService.getCurrentUser();
                if (user == null) return;
                final now = DateTime.now();
                final task = TaskModel(id: const Uuid().v4(), userId: user.uid, title: titleController.text, description: descController.text.isEmpty ? null : descController.text, priority: priority, category: category, createdAt: now, updatedAt: now);
                await _taskService.saveTask(task);
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
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(icon: Icon(_showCompleted ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _showCompleted = !_showCompleted)),
        ],
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: _authService.getCurrentUser().then((user) => 
          user != null ? _taskService.getTasksStream(user.uid) : Stream.value(<TaskModel>[])
        ).asStream().asyncExpand((stream) => stream),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final tasks = snapshot.data ?? [];
          final displayTasks = _showCompleted ? tasks : tasks.where((t) => !t.isCompleted).toList();
          final pendingCount = tasks.where((t) => !t.isCompleted).length;

          return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pending Tasks', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                              const SizedBox(height: 4),
                              Text('$pendingCount', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Completed', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                              const SizedBox(height: 4),
                              Text('${tasks.length - pendingCount}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: displayTasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline, size: 64, color: Theme.of(context).colorScheme.secondary),
                              const SizedBox(height: 16),
                              Text('No tasks', style: Theme.of(context).textTheme.titleLarge),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: displayTasks.length,
                          itemBuilder: (context, index) {
                            final task = displayTasks[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Checkbox(value: task.isCompleted, onChanged: (_) => _toggleTaskCompletion(task)),
                                title: Text(task.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (task.description != null) ...[
                                      const SizedBox(height: 4),
                                      Text(task.description!, style: Theme.of(context).textTheme.bodySmall),
                                    ],
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _getPriorityColor(task.priority).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(task.priority.name.toUpperCase(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: _getPriorityColor(task.priority), fontWeight: FontWeight.w600))),
                                        const SizedBox(width: 8),
                                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(8)), child: Text(task.category.name.toUpperCase(), style: Theme.of(context).textTheme.bodySmall)),
                                        if (task.dueDate != null) ...[
                                          const SizedBox(width: 8),
                                          Icon(Icons.calendar_today, size: 12, color: Theme.of(context).colorScheme.secondary),
                                          const SizedBox(width: 4),
                                          Text(DateFormat('MMM d').format(task.dueDate!), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddTaskDialog, child: const Icon(Icons.add)),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }
}

