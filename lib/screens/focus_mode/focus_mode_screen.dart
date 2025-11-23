import 'package:flutter/material.dart';

class FocusModeScreen extends StatefulWidget {
  const FocusModeScreen({super.key});

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen> {
  bool _isFocusMode = false;
  final List<String> _motivationalQuotes = [
    'Success is the sum of small efforts repeated day in and day out.',
    'Don\'t watch the clock; do what it does. Keep going.',
    'The expert in anything was once a beginner.',
    'Education is the passport to the future.',
    'Your limitation—it\'s only your imagination.',
  ];

  int _currentQuoteIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Mode')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: _isFocusMode ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(_isFocusMode ? Icons.remove_red_eye : Icons.visibility_off, color: _isFocusMode ? Colors.green : Colors.grey, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_isFocusMode ? 'Focus Mode Active' : 'Focus Mode Inactive', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(_isFocusMode ? 'Distractions blocked' : 'Tap to activate', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                      ],
                    ),
                  ),
                  Switch(value: _isFocusMode, onChanged: (val) => setState(() => _isFocusMode = val)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Daily Motivation', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Icon(Icons.format_quote, size: 48, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(_motivationalQuotes[_currentQuoteIndex], style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  IconButton.filled(onPressed: () => setState(() => _currentQuoteIndex = (_currentQuoteIndex + 1) % _motivationalQuotes.length), icon: const Icon(Icons.refresh)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Focus Tips', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildTipCard('Eliminate distractions', 'Turn off notifications and close unnecessary apps', Icons.notifications_off),
                  _buildTipCard('Take regular breaks', 'Use the Pomodoro technique: 25 min work, 5 min break', Icons.timer),
                  _buildTipCard('Stay hydrated', 'Keep water nearby and take sips regularly', Icons.local_drink),
                  _buildTipCard('Set clear goals', 'Define what you want to accomplish in this session', Icons.flag),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
