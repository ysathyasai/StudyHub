import 'dart:async';
import 'package:flutter/material.dart';

class StudyTimerScreen extends StatefulWidget {
  const StudyTimerScreen({super.key});

  @override
  State<StudyTimerScreen> createState() => _StudyTimerScreenState();
}

class _StudyTimerScreenState extends State<StudyTimerScreen> {
  int _minutes = 25;
  int _seconds = 0;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  Timer? _timer;
  int _completedSessions = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _remainingSeconds = _minutes * 60 + _seconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _completedSessions++;
          _showCompletionDialog();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _minutes * 60 + _seconds;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Session Complete!'),
        content: const Text('Great job! Time for a break.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
              _startTimer();
            },
            child: const Text('Start Another'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Timer')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
              child: Column(
                children: [
                  Text('Sessions Completed Today', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                  const SizedBox(height: 8),
                  Text('$_completedSessions', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            if (!_isRunning)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('Minutes', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).colorScheme.outline)),
                        child: DropdownButton<int>(
                          value: _minutes,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: [5, 10, 15, 20, 25, 30, 45, 60].map((m) => DropdownMenuItem(value: m, child: Text('$m'))).toList(),
                          onChanged: (val) => setState(() {
                            _minutes = val ?? 25;
                            _remainingSeconds = _minutes * 60 + _seconds;
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      Text('Seconds', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).colorScheme.outline)),
                        child: DropdownButton<int>(
                          value: _seconds,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: [0, 15, 30, 45].map((s) => DropdownMenuItem(value: s, child: Text('$s'))).toList(),
                          onChanged: (val) => setState(() {
                            _seconds = val ?? 0;
                            _remainingSeconds = _minutes * 60 + _seconds;
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 40),
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).colorScheme.primary, width: 8),
              ),
              child: Center(
                child: Text(_formatTime(_remainingSeconds), style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 64)),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning) ...[
                  ElevatedButton.icon(onPressed: _startTimer, icon: const Icon(Icons.play_arrow), label: const Text('Start'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16))),
                ] else ...[
                  ElevatedButton.icon(onPressed: _pauseTimer, icon: const Icon(Icons.pause), label: const Text('Pause'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16))),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(onPressed: _resetTimer, icon: const Icon(Icons.refresh), label: const Text('Reset'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16))),
                ],
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
