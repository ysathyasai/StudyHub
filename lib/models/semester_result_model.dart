import 'package:flutter/material.dart';

class SemesterResult {
  final String id;
  final String userId;
  final String pin;
  final String studentName;
  final String branch;
  final String semester;
  final String collegeCode;
  final String collegeName;
  final String examMonth;
  final String examYear;
  final List<SubjectResult> subjects;
  final double sgpa;
  final double cgpa;
  final int totalCredits;
  final int creditsEarned;
  final double totalGradePoints;
  final String result; // Promoted, Pass, Fail
  final DateTime uploadedAt;
  final String? pdfPath;

  SemesterResult({
    required this.id,
    required this.userId,
    required this.pin,
    required this.studentName,
    required this.branch,
    required this.semester,
    required this.collegeCode,
    required this.collegeName,
    required this.examMonth,
    required this.examYear,
    required this.subjects,
    required this.sgpa,
    required this.cgpa,
    required this.totalCredits,
    required this.creditsEarned,
    required this.totalGradePoints,
    required this.result,
    required this.uploadedAt,
    this.pdfPath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'pin': pin,
        'studentName': studentName,
        'branch': branch,
        'semester': semester,
        'collegeCode': collegeCode,
        'collegeName': collegeName,
        'examMonth': examMonth,
        'examYear': examYear,
        'subjects': subjects.map((s) => s.toJson()).toList(),
        'sgpa': sgpa,
        'cgpa': cgpa,
        'totalCredits': totalCredits,
        'creditsEarned': creditsEarned,
        'totalGradePoints': totalGradePoints,
        'result': result,
        'uploadedAt': uploadedAt.toIso8601String(),
        'pdfPath': pdfPath,
      };

  factory SemesterResult.fromJson(Map<String, dynamic> json) => SemesterResult(
        id: json['id'],
        userId: json['userId'],
        pin: json['pin'],
        studentName: json['studentName'],
        branch: json['branch'],
        semester: json['semester'],
        collegeCode: json['collegeCode'],
        collegeName: json['collegeName'],
        examMonth: json['examMonth'],
        examYear: json['examYear'],
        subjects: (json['subjects'] as List).map((s) => SubjectResult.fromJson(s)).toList(),
        sgpa: json['sgpa'].toDouble(),
        cgpa: json['cgpa'].toDouble(),
        totalCredits: json['totalCredits'],
        creditsEarned: json['creditsEarned'],
        totalGradePoints: json['totalGradePoints'].toDouble(),
        result: json['result'],
        uploadedAt: DateTime.parse(json['uploadedAt']),
        pdfPath: json['pdfPath'],
      );
}

class SubjectResult {
  final String subjectCode;
  final String subjectName;
  final double courseCredits;
  final int? midSem1; // out of 20
  final int? midSem2; // out of 20
  final int? internal; // out of 20
  final int? endSem; // out of 40
  final int subjectTotal; // out of 100
  final String grade; // A+, A, B+, B, C, E, F, P
  final int gradePoints; // 0-10
  final double creditsEarned;
  final double totalGradePoints;

  SubjectResult({
    required this.subjectCode,
    required this.subjectName,
    required this.courseCredits,
    this.midSem1,
    this.midSem2,
    this.internal,
    this.endSem,
    required this.subjectTotal,
    required this.grade,
    required this.gradePoints,
    required this.creditsEarned,
    required this.totalGradePoints,
  });

  Map<String, dynamic> toJson() => {
        'subjectCode': subjectCode,
        'subjectName': subjectName,
        'courseCredits': courseCredits,
        'midSem1': midSem1,
        'midSem2': midSem2,
        'internal': internal,
        'endSem': endSem,
        'subjectTotal': subjectTotal,
        'grade': grade,
        'gradePoints': gradePoints,
        'creditsEarned': creditsEarned,
        'totalGradePoints': totalGradePoints,
      };

  factory SubjectResult.fromJson(Map<String, dynamic> json) => SubjectResult(
        subjectCode: json['subjectCode'],
        subjectName: json['subjectName'],
        courseCredits: json['courseCredits'].toDouble(),
        midSem1: json['midSem1'],
        midSem2: json['midSem2'],
        internal: json['internal'],
        endSem: json['endSem'],
        subjectTotal: json['subjectTotal'],
        grade: json['grade'],
        gradePoints: json['gradePoints'],
        creditsEarned: json['creditsEarned'].toDouble(),
        totalGradePoints: json['totalGradePoints'].toDouble(),
      );

  Color getGradeColor() {
    switch (grade) {
      case 'A+':
      case 'O':
        return const Color(0xFF4CAF50); // Green
      case 'A':
        return const Color(0xFF8BC34A); // Light Green
      case 'B+':
        return const Color(0xFFFFEB3B); // Yellow
      case 'B':
        return const Color(0xFFFFC107); // Amber
      case 'C':
        return const Color(0xFFFF9800); // Orange
      case 'E':
      case 'F':
        return const Color(0xFFF44336); // Red
      case 'P':
        return const Color(0xFF2196F3); // Blue
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  bool get isPassed => grade != 'F' && grade != 'E';
}
