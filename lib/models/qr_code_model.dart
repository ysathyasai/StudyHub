class QRCodeModel {
  final String id;
  final String userId;
  final String data;
  final String title;
  final String? description;
  final DateTime createdAt;

  QRCodeModel({
    required this.id,
    required this.userId,
    required this.data,
    required this.title,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'data': data,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
      };

  factory QRCodeModel.fromJson(Map<String, dynamic> json) => QRCodeModel(
        id: json['id'],
        userId: json['userId'],
        data: json['data'],
        title: json['title'],
        description: json['description'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
