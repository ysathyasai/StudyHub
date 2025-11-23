import 'package:studyhub/services/flashcard_service.dart';
import 'package:studyhub/services/note_service.dart';
import 'package:studyhub/services/task_service.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:studyhub/widgets/quick_action_tile.dart';
import 'package:studyhub/widgets/stat_card.dart';
import 'package:studyhub/screens/notes/notes_screen.dart';
import 'package:studyhub/screens/flashcards/flashcards_screen.dart';
import 'package:studyhub/screens/tasks/tasks_screen.dart';
import 'package:studyhub/screens/timetable/timetable_screen.dart';
import 'package:studyhub/screens/study_timer/study_timer_screen.dart';
import 'package:studyhub/screens/more/more_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = true;
  int _taskCount = 0;
  int _dueTodayCount = 0;
  double _studyHours = 0;
  int _notesCount = 0;
  int _recentNotesCount = 0;
  int _flashcardsCount = 0;
  int _reviewFlashcardsCount = 0;

  final _taskService = TaskService();
  final _noteService = NoteService();
  final _flashcardService = FlashcardService();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      final user = await authService.getCurrentUser();
      
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }
      
      final userId = user.uid;
      final tasks = await _taskService.getAllTasks(userId);
      final notes = await _noteService.getAllNotes(userId);
      final flashcards = await _flashcardService.getAllFlashcards(userId);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final dueToday = tasks
          .where((task) =>
              task.dueDate != null &&
              !task.isCompleted &&
              DateTime(task.dueDate!.year, task.dueDate!.month,
                      task.dueDate!.day)
                  .isAtSameMomentAs(today))
          .length;

      final recentNotes = notes
          .where((note) =>
              note.updatedAt.isAfter(now.subtract(const Duration(days: 7))))
          .length;

      // TODO: Implement logic for study hours and flashcards to review
      const studyHours = 0.0;
      const reviewFlashcards = 0;

      if (mounted) {
        setState(() {
          _taskCount = tasks.length;
          _dueTodayCount = dueToday;
          _studyHours = studyHours;
          _notesCount = notes.length;
          _recentNotesCount = recentNotes;
          _flashcardsCount = flashcards.length;
          _reviewFlashcardsCount = reviewFlashcards;
          _isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Optionally show an error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: false,
                snap: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('StudyHub',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                    Text('Your Academic Companion',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.search), onPressed: () {}),
                  IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {}),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Text('Overview',
                              style: Theme.of(context).textTheme.headlineSmall),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const TasksScreen())),
                                            child: StatCard(
                                                title: 'Tasks',
                                                value: '$_taskCount',
                                                subtitle:
                                                    '$_dueTodayCount due today',
                                                icon: Icons.check_circle_outline,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const StudyTimerScreen())),
                                            child: StatCard(
                                                title: 'Study Hours',
                                                value: '${_studyHours}h',
                                                subtitle: 'this week',
                                                icon: Icons.timer_outlined,
                                                color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const NotesScreen())),
                                            child: StatCard(
                                                title: 'Notes',
                                                value: '$_notesCount',
                                                subtitle:
                                                    '$_recentNotesCount recent',
                                                icon: Icons.note_outlined,
                                                color: Colors.orange),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const FlashcardsScreen())),
                                            child: StatCard(
                                                title: 'Flashcards',
                                                value: '$_flashcardsCount',
                                                subtitle:
                                                    '$_reviewFlashcardsCount to review',
                                                icon: Icons.style_outlined,
                                                color: Colors.purple),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Text('Quick Actions',
                              style: Theme.of(context).textTheme.headlineSmall),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.9,
                            children: [
                              QuickActionTile(
                                  icon: Icons.note_add_outlined,
                                  label: 'New Note',
                                  color: Colors.blue,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const NotesScreen()))),
                              QuickActionTile(
                                  icon: Icons.check_box_outlined,
                                  label: 'Tasks',
                                  color: Colors.green,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const TasksScreen()))),
                              QuickActionTile(
                                  icon: Icons.schedule_outlined,
                                  label: 'Timetable',
                                  color: Colors.orange,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const TimetableScreen()))),
                              QuickActionTile(
                                  icon: Icons.style_outlined,
                                  label: 'Flashcards',
                                  color: Colors.purple,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const FlashcardsScreen()))),
                              QuickActionTile(
                                  icon: Icons.timer_outlined,
                                  label: 'Study Timer',
                                  color: Colors.red,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const StudyTimerScreen()))),
                              QuickActionTile(
                                  icon: Icons.more_horiz,
                                  label: 'More',
                                  color: Colors.teal,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const MoreScreen()))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  
}

