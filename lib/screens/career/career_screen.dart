import 'package:flutter/material.dart';
import 'package:studyhub/screens/resume/resume_builder_screen.dart';
import 'package:studyhub/screens/career/internships_screen.dart';
import 'package:studyhub/screens/career/portfolio_screen.dart';
import 'package:studyhub/screens/career/certifications_screen.dart';
import 'package:studyhub/screens/career/scholarships_screen.dart';
import 'package:studyhub/widgets/hoverable_container.dart';

class CareerScreen extends StatelessWidget {
  const CareerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Career')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildToolCard(context, 'Internships', 'Find opportunities', Icons.work_outline, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InternshipsScreen()))),
          _buildToolCard(context, 'Resume Builder', 'Create professional resumes', Icons.description_outlined, Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResumeBuilderScreen()))),
          _buildToolCard(context, 'Portfolio', 'Showcase your projects', Icons.folder_outlined, Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PortfolioScreen()))),
          _buildToolCard(context, 'Certifications', 'Store certificates', Icons.verified_outlined, Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CertificationsScreen()))),
          _buildToolCard(context, 'Scholarships', 'Funding opportunities', Icons.school_outlined, Colors.red, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScholarshipsScreen()))),
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

