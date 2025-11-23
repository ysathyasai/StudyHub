class InternshipModel {
  final String id;
  final String company;
  final String position;
  final String location;
  final String type;
  final String description;
  final List<String> requirements;
  final String duration;
  final String stipend;
  final String applyLink;
  final DateTime postedDate;
  bool isSaved;

  InternshipModel({
    required this.id,
    required this.company,
    required this.position,
    required this.location,
    required this.type,
    required this.description,
    required this.requirements,
    required this.duration,
    required this.stipend,
    required this.applyLink,
    required this.postedDate,
    this.isSaved = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'company': company,
        'position': position,
        'location': location,
        'type': type,
        'description': description,
        'requirements': requirements,
        'duration': duration,
        'stipend': stipend,
        'applyLink': applyLink,
        'postedDate': postedDate.toIso8601String(),
        'isSaved': isSaved,
      };

  factory InternshipModel.fromJson(Map<String, dynamic> json) => InternshipModel(
        id: json['id'],
        company: json['company'],
        position: json['position'],
        location: json['location'],
        type: json['type'],
        description: json['description'],
        requirements: List<String>.from(json['requirements'] ?? []),
        duration: json['duration'],
        stipend: json['stipend'],
        applyLink: json['applyLink'],
        postedDate: DateTime.parse(json['postedDate']),
        isSaved: json['isSaved'] ?? false,
      );
}
