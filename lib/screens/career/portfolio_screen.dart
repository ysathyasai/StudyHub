import 'package:flutter/material.dart';
import 'package:studyhub/models/portfolio_model.dart';
import 'package:studyhub/services/portfolio_service.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final _service = PortfolioService();
  final _authService = AuthService();

  Future<void> _showAddDialog() async {
    final user = await _authService.getCurrentUser();
    if (user == null) return;
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final categoryController = TextEditingController();
    final techController = TextEditingController();
    final githubController = TextEditingController();
    final liveLinkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Project Title')),
              const SizedBox(height: 12),
              TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3),
              const SizedBox(height: 12),
              TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category')),
              const SizedBox(height: 12),
              TextField(
                  controller: techController,
                  decoration: const InputDecoration(
                      labelText: 'Technologies (comma-separated)')),
              const SizedBox(height: 12),
              TextField(
                  controller: githubController,
                  decoration: const InputDecoration(labelText: 'GitHub Link')),
              const SizedBox(height: 12),
              TextField(
                  controller: liveLinkController,
                  decoration: const InputDecoration(labelText: 'Live Link')),
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
              final project = PortfolioModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                userId: user.uid,
                title: titleController.text,
                description: descController.text,
                category: categoryController.text.isEmpty
                    ? 'General'
                    : categoryController.text,
                technologies: techController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
                githubLink: githubController.text.isEmpty ? null : githubController.text,
                liveLink: liveLinkController.text.isEmpty ? null : liveLinkController.text,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              await _service.saveProject(project);
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
      ),
      body: StreamBuilder<List<PortfolioModel>>(
        stream: _authService.getCurrentUser().then((user) => 
          user != null ? _service.getPortfolioStream(user.uid) : Stream.value(<PortfolioModel>[])
        ).asStream().asyncExpand((stream) => stream),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final projects = snapshot.data ?? [];
          
          return projects.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.work_outline, size: 80, color: Colors.grey),
                      const SizedBox(height: 20),
                      const Text(
                        'No projects yet.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Add your first project to showcase your skills.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _showAddDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Project'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return _buildProjectCard(projects[index]);
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProjectCard(PortfolioModel project) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(project.description,
                style: Theme.of(context).textTheme.bodyLarge),
            if (project.technologies.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: project.technologies
                    .map((tech) => Chip(
                          label: Text(tech),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (project.githubLink != null &&
                    project.githubLink!.isNotEmpty)
                  TextButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(project.githubLink!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.code),
                    label: const Text('GitHub'),
                  ),
                if (project.liveLink != null && project.liveLink!.isNotEmpty)
                  TextButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(project.liveLink!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Live'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

