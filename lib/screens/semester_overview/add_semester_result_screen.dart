import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyhub/models/semester_result_model.dart';
import 'package:studyhub/services/semester_service.dart';
import 'package:studyhub/services/auth_service.dart';
import 'package:uuid/uuid.dart';

class AddSemesterResultScreen extends StatefulWidget {
  final SemesterResult? result;

  const AddSemesterResultScreen({super.key, this.result});

  @override
  State<AddSemesterResultScreen> createState() => _AddSemesterResultScreenState();
}

class _AddSemesterResultScreenState extends State<AddSemesterResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final _semesterService = SemesterService();
  final _authService = AuthService();

  late TextEditingController _pinController;
  late TextEditingController _nameController;
  late TextEditingController _branchController;
  late TextEditingController _semesterController;
  late TextEditingController _collegeCodeController;
  late TextEditingController _collegeNameController;
  late TextEditingController _examMonthController;
  late TextEditingController _examYearController;
  late TextEditingController _sgpaController;
  late TextEditingController _cgpaController;

  List<SubjectResultInput> _subjects = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController(text: widget.result?.pin);
    _nameController = TextEditingController(text: widget.result?.studentName);
    _branchController = TextEditingController(text: widget.result?.branch);
    _semesterController = TextEditingController(text: widget.result?.semester);
    _collegeCodeController = TextEditingController(text: widget.result?.collegeCode);
    _collegeNameController = TextEditingController(text: widget.result?.collegeName);
    _examMonthController = TextEditingController(text: widget.result?.examMonth);
    _examYearController = TextEditingController(text: widget.result?.examYear);
    _sgpaController = TextEditingController(text: widget.result?.sgpa.toString());
    _cgpaController = TextEditingController(text: widget.result?.cgpa.toString());

    if (widget.result != null) {
      _subjects = widget.result!.subjects
          .map((s) => SubjectResultInput.fromSubjectResult(s))
          .toList();
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _nameController.dispose();
    _branchController.dispose();
    _semesterController.dispose();
    _collegeCodeController.dispose();
    _collegeNameController.dispose();
    _examMonthController.dispose();
    _examYearController.dispose();
    _sgpaController.dispose();
    _cgpaController.dispose();
    super.dispose();
  }

  void _addSubject() {
    setState(() {
      _subjects.add(SubjectResultInput());
    });
  }

  void _removeSubject(int index) {
    setState(() {
      _subjects.removeAt(index);
    });
  }

  Future<void> _saveResult() async {
    if (!_formKey.currentState!.validate()) return;
    if (_subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one subject'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.getCurrentUser();
      if (user == null) throw 'User not logged in';

      final subjects = _subjects.map((s) => s.toSubjectResult()).toList();
      final totalCredits = subjects.fold<double>(0, (sum, s) => sum + s.courseCredits).toInt();
      final creditsEarned = subjects.fold<double>(0, (sum, s) => sum + s.creditsEarned).toInt();
      final totalGradePoints = subjects.fold<double>(0, (sum, s) => sum + s.totalGradePoints);

      final result = SemesterResult(
        id: widget.result?.id ?? const Uuid().v4(),
        userId: user.uid,
        pin: _pinController.text.trim(),
        studentName: _nameController.text.trim(),
        branch: _branchController.text.trim(),
        semester: _semesterController.text.trim(),
        collegeCode: _collegeCodeController.text.trim(),
        collegeName: _collegeNameController.text.trim(),
        examMonth: _examMonthController.text.trim(),
        examYear: _examYearController.text.trim(),
        subjects: subjects,
        sgpa: double.parse(_sgpaController.text.trim()),
        cgpa: double.parse(_cgpaController.text.trim()),
        totalCredits: totalCredits,
        creditsEarned: creditsEarned,
        totalGradePoints: totalGradePoints,
        result: creditsEarned == totalCredits ? 'Promoted' : 'Pass',
        uploadedAt: widget.result?.uploadedAt ?? DateTime.now(),
      );

      await _semesterService.saveResult(result);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.result == null ? 'Result added successfully' : 'Result updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.result == null ? 'Add Semester Result' : 'Edit Semester Result'),
        actions: [
          IconButton(
            icon: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
            onPressed: _isLoading ? null : _saveResult,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Student Information', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'PIN/Roll Number *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _branchController,
                    decoration: const InputDecoration(
                      labelText: 'Branch *',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., AI, CSE',
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _semesterController,
                    decoration: const InputDecoration(
                      labelText: 'Semester *',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., 1SEM',
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('College Information', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _collegeCodeController,
              decoration: const InputDecoration(
                labelText: 'College Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _collegeNameController,
              decoration: const InputDecoration(
                labelText: 'College Name',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _examMonthController,
                    decoration: const InputDecoration(
                      labelText: 'Exam Month',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., DEC',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _examYearController,
                    decoration: const InputDecoration(
                      labelText: 'Exam Year',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., 2023',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subjects', style: Theme.of(context).textTheme.titleLarge),
                ElevatedButton.icon(
                  onPressed: _addSubject,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subject'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._subjects.asMap().entries.map((entry) {
              return _buildSubjectCard(entry.key, entry.value);
            }),
            const SizedBox(height: 24),
            Text('Performance Summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _sgpaController,
                    decoration: const InputDecoration(
                      labelText: 'SGPA *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cgpaController,
                    decoration: const InputDecoration(
                      labelText: 'CGPA *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(int index, SubjectResultInput subject) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subject ${index + 1}', style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeSubject(index),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: subject.subjectCode,
              decoration: const InputDecoration(
                labelText: 'Subject Code *',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) => subject.subjectCode = value,
              validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: subject.subjectName,
              decoration: const InputDecoration(
                labelText: 'Subject Name *',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) => subject.subjectName = value,
              validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: subject.courseCredits?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Credits *',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) => subject.courseCredits = double.tryParse(value),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: subject.subjectTotal?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Total (100) *',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => subject.subjectTotal = int.tryParse(value),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: subject.grade,
                    decoration: const InputDecoration(
                      labelText: 'Grade *',
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'A+, A, B+, etc.',
                    ),
                    onChanged: (value) => subject.grade = value,
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: subject.gradePoints?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Grade Points *',
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: '0-10',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => subject.gradePoints = int.tryParse(value),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectResultInput {
  String? subjectCode;
  String? subjectName;
  double? courseCredits;
  int? subjectTotal;
  String? grade;
  int? gradePoints;

  SubjectResultInput({
    this.subjectCode,
    this.subjectName,
    this.courseCredits,
    this.subjectTotal,
    this.grade,
    this.gradePoints,
  });

  factory SubjectResultInput.fromSubjectResult(SubjectResult subject) {
    return SubjectResultInput(
      subjectCode: subject.subjectCode,
      subjectName: subject.subjectName,
      courseCredits: subject.courseCredits,
      subjectTotal: subject.subjectTotal,
      grade: subject.grade,
      gradePoints: subject.gradePoints,
    );
  }

  SubjectResult toSubjectResult() {
    final credits = courseCredits ?? 0;
    final gp = gradePoints ?? 0;
    final creditsEarned = gp > 0 ? credits : 0.0;

    return SubjectResult(
      subjectCode: subjectCode ?? '',
      subjectName: subjectName ?? '',
      courseCredits: credits,
      subjectTotal: subjectTotal ?? 0,
      grade: grade ?? '',
      gradePoints: gp,
      creditsEarned: creditsEarned,
      totalGradePoints: creditsEarned * gp,
    );
  }
}
