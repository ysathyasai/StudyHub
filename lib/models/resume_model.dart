class ResumeModel {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String? phone;
  final String? address;
  final String? summary;
  final List<EducationEntry> education;
  final List<ExperienceEntry> experience;
  final List<String> skills;
  final List<ProjectEntry> projects;
  final DateTime createdAt;
  final DateTime updatedAt;

  ResumeModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    this.phone,
    this.address,
    this.summary,
    required this.education,
    required this.experience,
    required this.skills,
    required this.projects,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'address': address,
        'summary': summary,
        'education': education.map((e) => e.toJson()).toList(),
        'experience': experience.map((e) => e.toJson()).toList(),
        'skills': skills,
        'projects': projects.map((p) => p.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ResumeModel.fromJson(Map<String, dynamic> json) => ResumeModel(
        id: json['id'],
        userId: json['userId'],
        fullName: json['fullName'],
        email: json['email'],
        phone: json['phone'],
        address: json['address'],
        summary: json['summary'],
        education: (json['education'] as List).map((e) => EducationEntry.fromJson(e)).toList(),
        experience: (json['experience'] as List).map((e) => ExperienceEntry.fromJson(e)).toList(),
        skills: List<String>.from(json['skills']),
        projects: (json['projects'] as List).map((p) => ProjectEntry.fromJson(p)).toList(),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}

class EducationEntry {
  final String institution;
  final String degree;
  final String? field;
  final String? startDate;
  final String? endDate;

  EducationEntry({
    required this.institution,
    required this.degree,
    this.field,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() => {
        'institution': institution,
        'degree': degree,
        'field': field,
        'startDate': startDate,
        'endDate': endDate,
      };

  factory EducationEntry.fromJson(Map<String, dynamic> json) => EducationEntry(
        institution: json['institution'],
        degree: json['degree'],
        field: json['field'],
        startDate: json['startDate'],
        endDate: json['endDate'],
      );
}

class ExperienceEntry {
  final String company;
  final String position;
  final String? startDate;
  final String? endDate;
  final String? description;

  ExperienceEntry({
    required this.company,
    required this.position,
    this.startDate,
    this.endDate,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'company': company,
        'position': position,
        'startDate': startDate,
        'endDate': endDate,
        'description': description,
      };

  factory ExperienceEntry.fromJson(Map<String, dynamic> json) => ExperienceEntry(
        company: json['company'],
        position: json['position'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        description: json['description'],
      );
}

class ProjectEntry {
  final String name;
  final String? description;
  final String? technologies;

  ProjectEntry({
    required this.name,
    this.description,
    this.technologies,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'technologies': technologies,
      };

  factory ProjectEntry.fromJson(Map<String, dynamic> json) => ProjectEntry(
        name: json['name'],
        description: json['description'],
        technologies: json['technologies'],
      );
}
