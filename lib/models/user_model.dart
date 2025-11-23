class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? university;
  final String? major;
  final int? currentYear;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.university,
    this.major,
    this.currentYear,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'university': university,
        'major': major,
        'currentYear': currentYear,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        photoUrl: json['photoUrl'],
        university: json['university'],
        major: json['major'],
        currentYear: json['currentYear'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  UserModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? university,
    String? major,
    int? currentYear,
    DateTime? updatedAt,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        photoUrl: photoUrl ?? this.photoUrl,
        university: university ?? this.university,
        major: major ?? this.major,
        currentYear: currentYear ?? this.currentYear,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now(),
      );
}
