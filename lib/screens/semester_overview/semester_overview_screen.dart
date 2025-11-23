import 'package:flutter/material.dart';
import 'package:studyhub/models/semester_result_model.dart';
import 'package:studyhub/services/semester_service.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:studyhub/screens/semester_overview/add_semester_result_screen.dart';

class SemesterOverviewScreen extends StatefulWidget {
  const SemesterOverviewScreen({super.key});

  @override
  State<SemesterOverviewScreen> createState() => _SemesterOverviewScreenState();
}

class _SemesterOverviewScreenState extends State<SemesterOverviewScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _semesterService = SemesterService();
  final _authService = AuthService();
  
  List<SemesterResult> _results = [];
  bool _isLoading = true;
  Map<String, dynamic> _statistics = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadResults();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadResults() async {
    setState(() => _isLoading = true);
    
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        final results = await _semesterService.getAllResults(user.uid);
        final stats = _semesterService.calculateStatistics(results);
        
        if (mounted) {
          setState(() {
            _results = results;
            _statistics = stats;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      print('Error loading results: $e');
      if (mounted) {
        setState(() {
          _results = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addResult() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddSemesterResultScreen()),
    );
    
    if (result == true) {
      _loadResults();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semester Overview'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addResult,
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Results'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading results...'),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildResultsTab(),
                _buildAnalyticsTab(),
              ],
            ),
      floatingActionButton: !_isLoading && _results.isNotEmpty
          ? FloatingActionButton(
              onPressed: _addResult,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildResultsTab() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No Semester Results',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Add your semester results to track performance'),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _addResult,
              icon: const Icon(Icons.add),
              label: const Text('Add Result'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadResults,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final result = _results[index];
          final passedSubjects = result.subjects.where((s) => s.isPassed).length;
          final totalSubjects = result.subjects.length;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${result.semester} - ${result.branch}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text('${result.examMonth} ${result.examYear}'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('SGPA', result.sgpa.toStringAsFixed(2)),
                      _buildStat('CGPA', result.cgpa.toStringAsFixed(2)),
                      _buildStat('Credits', '${result.creditsEarned}/${result.totalCredits}'),
                      _buildStat('Passed', '$passedSubjects/$totalSubjects'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            const Text('No Analytics Available'),
            const SizedBox(height: 8),
            const Text('Add semester results to see analytics'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadResults,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Performance',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Overall CGPA',
                            _statistics['overallCGPA']?.toStringAsFixed(2) ?? '0.00',
                            Icons.school,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Total Credits',
                            _statistics['totalCredits']?.toString() ?? '0',
                            Icons.credit_card,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Avg %',
                            '${_statistics['averagePercentage']?.toStringAsFixed(1) ?? '0.0'}%',
                            Icons.percent,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Subjects',
                            _statistics['totalSubjects']?.toString() ?? '0',
                            Icons.book,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Semester Comparison',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ..._results.map((result) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                result.semester,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              child: Text('SGPA: ${result.sgpa.toStringAsFixed(2)}'),
                            ),
                            Expanded(
                              child: Text('${result.creditsEarned} credits'),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
