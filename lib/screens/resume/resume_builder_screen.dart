import 'package:flutter/material.dart';
import 'package:studyhub/models/resume_model.dart';
import 'package:studyhub/services/resume_service.dart';
import 'package:studyhub/services/auth_service.dart';

class ResumeBuilderScreen extends StatefulWidget {
  const ResumeBuilderScreen({super.key});

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  final _service = ResumeService();
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _summaryController = TextEditingController();
  final List<EducationEntry> _education = [];
  final List<ExperienceEntry> _experience = [];
  final List<String> _skills = [];
  final List<ProjectEntry> _projects = [];
  String? _editingResumeId;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Builder'),
        actions: [
          if (_editingResumeId != null)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Create New Resume',
              onPressed: _clearForm,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<List<ResumeModel>>(
                stream: _authService.getCurrentUser().then((user) => 
                  user != null ? _service.getResumesStream(user.uid) : Stream.value(<ResumeModel>[])
                ).asStream().asyncExpand((stream) => stream),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 12),
                            Text('Previous Resumes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...snapshot.data!.map((resume) => _buildResumeCard(resume)),
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 32),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1)]), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Icon(Icons.description_outlined, size: 48, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_editingResumeId != null ? 'Edit Resume' : 'Build Your Resume', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(_editingResumeId != null ? 'Update your resume details' : 'Create a professional resume in minutes', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text('Personal Information', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline))),
              const SizedBox(height: 16),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
              const SizedBox(height: 16),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined))),
              const SizedBox(height: 32),
              Text('Professional Summary', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextFormField(controller: _summaryController, decoration: const InputDecoration(labelText: 'Brief summary about yourself', prefixIcon: Icon(Icons.text_snippet_outlined)), maxLines: 4),
              const SizedBox(height: 32),
              _buildSectionHeader('Education', Icons.school_outlined),
              const SizedBox(height: 16),
              if (_education.isNotEmpty) ..._education.map((edu) => _buildEducationItem(edu)),
              _buildAddButton('Add Education', () => _addEducation()),
              const SizedBox(height: 32),
              _buildSectionHeader('Experience', Icons.work_outline),
              const SizedBox(height: 16),
              if (_experience.isNotEmpty) ..._experience.map((exp) => _buildExperienceItem(exp)),
              _buildAddButton('Add Experience', () => _addExperience()),
              const SizedBox(height: 32),
              _buildSectionHeader('Skills', Icons.stars_outlined),
              const SizedBox(height: 16),
              if (_skills.isNotEmpty) Wrap(spacing: 8, runSpacing: 8, children: _skills.map((skill) => Chip(label: Text(skill), onDeleted: () => setState(() => _skills.remove(skill)))).toList()),
              const SizedBox(height: 8),
              _buildAddButton('Add Skill', () => _addSkill()),
              const SizedBox(height: 32),
              _buildSectionHeader('Projects', Icons.folder_outlined),
              const SizedBox(height: 16),
              if (_projects.isNotEmpty) ..._projects.map((proj) => _buildProjectItem(proj)),
              _buildAddButton('Add Project', () => _addProject()),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: OutlinedButton.icon(onPressed: _previewResume, icon: const Icon(Icons.visibility), label: const Text('Preview'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton.icon(onPressed: _saveResume, icon: const Icon(Icons.save), label: const Text('Save Resume'))),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildAddButton(String label, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: Text(label),
      style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
    );
  }

  void _addEducation() {
    final schoolController = TextEditingController();
    final degreeController = TextEditingController();
    final fieldController = TextEditingController();
    final startController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Education'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: schoolController, decoration: const InputDecoration(labelText: 'School/University')),
            const SizedBox(height: 8),
            TextField(controller: degreeController, decoration: const InputDecoration(labelText: 'Degree')),
            const SizedBox(height: 8),
            TextField(controller: fieldController, decoration: const InputDecoration(labelText: 'Field of Study')),
            const SizedBox(height: 8),
            TextField(controller: startController, decoration: const InputDecoration(labelText: 'Start Year')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (schoolController.text.isNotEmpty && degreeController.text.isNotEmpty) {
                setState(() => _education.add(EducationEntry(institution: schoolController.text, degree: degreeController.text, field: fieldController.text, startDate: startController.text)));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addExperience() {
    final companyController = TextEditingController();
    final positionController = TextEditingController();
    final startController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Experience'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: companyController, decoration: const InputDecoration(labelText: 'Company')),
            const SizedBox(height: 8),
            TextField(controller: positionController, decoration: const InputDecoration(labelText: 'Position')),
            const SizedBox(height: 8),
            TextField(controller: startController, decoration: const InputDecoration(labelText: 'Start Date')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (companyController.text.isNotEmpty && positionController.text.isNotEmpty) {
                setState(() => _experience.add(ExperienceEntry(company: companyController.text, position: positionController.text, startDate: startController.text)));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addSkill() {
    final skillController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Skill'),
        content: TextField(controller: skillController, decoration: const InputDecoration(labelText: 'Skill Name'), autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (skillController.text.isNotEmpty) {
                setState(() => _skills.add(skillController.text));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addProject() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Project Name')),
            const SizedBox(height: 8),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 2),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() => _projects.add(ProjectEntry(name: nameController.text, description: descController.text)));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationItem(EducationEntry edu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(edu.degree, style: const TextStyle(fontWeight: FontWeight.w600)), Text(edu.institution, style: const TextStyle(fontSize: 12))])),
          IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: () => setState(() => _education.remove(edu))),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(ExperienceEntry exp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(exp.position, style: const TextStyle(fontWeight: FontWeight.w600)), Text(exp.company, style: const TextStyle(fontSize: 12))])),
          IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: () => setState(() => _experience.remove(exp))),
        ],
      ),
    );
  }

  Widget _buildProjectItem(ProjectEntry proj) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(proj.name, style: const TextStyle(fontWeight: FontWeight.w600)), if (proj.description != null) Text(proj.description!, style: const TextStyle(fontSize: 12))])),
          IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: () => setState(() => _projects.remove(proj))),
        ],
      ),
    );
  }

  Widget _buildResumeCard(ResumeModel resume) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _editingResumeId == resume.id ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(Icons.description, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(resume.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(resume.email, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text('Updated: ${_formatDate(resume.updatedAt)}', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.secondary)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
              onPressed: () => _loadResume(resume),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _deleteResume(resume),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _loadResume(ResumeModel resume) {
    setState(() {
      _editingResumeId = resume.id;
      _nameController.text = resume.fullName;
      _emailController.text = resume.email;
      _phoneController.text = resume.phone ?? '';
      _summaryController.text = resume.summary ?? '';
      _education.clear();
      _education.addAll(resume.education);
      _experience.clear();
      _experience.addAll(resume.experience);
      _skills.clear();
      _skills.addAll(resume.skills);
      _projects.clear();
      _projects.addAll(resume.projects);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing: ${resume.fullName}')),
    );
  }

  void _clearForm() {
    setState(() {
      _editingResumeId = null;
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _summaryController.clear();
      _education.clear();
      _experience.clear();
      _skills.clear();
      _projects.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ready to create new resume')),
    );
  }

  Future<void> _deleteResume(ResumeModel resume) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resume'),
        content: Text('Are you sure you want to delete "${resume.fullName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _service.deleteResume(resume.id);
      if (_editingResumeId == resume.id) {
        _clearForm();
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resume deleted')),
        );
      }
    }
  }

  Future<void> _saveResume() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in name and email')));
      return;
    }
    
    final user = await _authService.getCurrentUser();
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please sign in to save resume')));
      }
      return;
    }
    
    final resume = ResumeModel(
      id: _editingResumeId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.uid,
      fullName: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text.isEmpty ? null : _phoneController.text,
      summary: _summaryController.text.isEmpty ? null : _summaryController.text,
      education: _education,
      experience: _experience,
      skills: _skills,
      projects: _projects,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _service.saveResume(resume);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_editingResumeId != null ? 'Resume updated successfully!' : 'Resume saved successfully!')),
      );
      _clearForm();
    }
  }

  void _previewResume() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resume Preview'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_nameController.text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(_emailController.text),
              if (_phoneController.text.isNotEmpty) Text(_phoneController.text),
              const SizedBox(height: 16),
              if (_summaryController.text.isNotEmpty) ...[const Text('Summary', style: TextStyle(fontWeight: FontWeight.bold)), Text(_summaryController.text), const SizedBox(height: 16)],
              if (_education.isNotEmpty) ...[const Text('Education', style: TextStyle(fontWeight: FontWeight.bold)), ..._education.map((e) => Text('${e.degree} - ${e.institution}')), const SizedBox(height: 16)],
              if (_experience.isNotEmpty) ...[const Text('Experience', style: TextStyle(fontWeight: FontWeight.bold)), ..._experience.map((e) => Text('${e.position} at ${e.company}')), const SizedBox(height: 16)],
              if (_skills.isNotEmpty) ...[const Text('Skills', style: TextStyle(fontWeight: FontWeight.bold)), Text(_skills.join(', '))],
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _summaryController.dispose();
    super.dispose();
  }
}

