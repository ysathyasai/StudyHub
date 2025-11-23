class CalendarEventModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final bool isAllDay;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  CalendarEventModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.isAllDay = false,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'description': description,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'location': location,
        'isAllDay': isAllDay,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) => CalendarEventModel(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        description: json['description'],
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        location: json['location'],
        isAllDay: json['isAllDay'] ?? false,
        category: json['category'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
