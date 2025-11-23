class PortfolioModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String? imageUrl;
  final String? liveLink;
  final String? githubLink;
  final List<String> technologies;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  PortfolioModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.imageUrl,
    this.liveLink,
    this.githubLink,
    required this.technologies,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'liveLink': liveLink,
        'githubLink': githubLink,
        'technologies': technologies,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory PortfolioModel.fromJson(Map<String, dynamic> json) => PortfolioModel(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        liveLink: json['liveLink'],
        githubLink: json['githubLink'],
        technologies: List<String>.from(json['technologies']),
        category: json['category'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
