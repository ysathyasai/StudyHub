import 'package:studyhub/screens/ai_tools/ai_tools_screen.dart';
import 'package:studyhub/screens/code_compiler/code_compiler_screen.dart';
import 'package:studyhub/screens/more/profile_screen.dart';
import 'package:studyhub/screens/more/settings_screen.dart';
import 'package:studyhub/screens/qr_tools/qr_tools_screen.dart';
import 'package:flutter/material.dart';
import 'package:studyhub/widgets/hoverable_container.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More Tools')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Productivity Tools',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary)),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildToolCard(
                  context,
                  'QR Generator',
                  'Create QR codes',
                  Icons.qr_code,
                  Colors.teal,
                  () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const QRToolsScreen()))),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildToolCard(
                  context,
                  'Code Compiler',
                  'Run code snippets',
                  Icons.code,
                  Colors.red,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CodeCompilerScreen()))),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildToolCard(
                  context,
                  'AI Tools',
                  'Powered by Gemini',
                  Icons.auto_awesome,
                  Colors.purple,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AiToolsScreen()))),
            ),
          ),
          const SizedBox(height: 24),
          Text('Account',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary)),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildToolCard(
                  context,
                  'Profile',
                  'Edit your profile',
                  Icons.person_outline,
                  Colors.blue,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()))),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildToolCard(
                  context,
                  'Settings',
                  'App preferences',
                  Icons.settings_outlined,
                  Colors.grey,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, String subtitle,
      IconData icon, Color color, VoidCallback onTap) {
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
            border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: Theme.of(context).colorScheme.secondary),
            ],
          ),
        ),
      ),
    );
  }
}

