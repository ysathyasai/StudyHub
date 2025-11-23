class StudySessionModel {
  final String id;
  final String userId;
  final int durationMinutes;
  final String? subject;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudySessionModel({
    required this.id,
    required this.userId,
    required this.durationMinutes,
    this.subject,
    required this.startTime,
    this.endTime,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'durationMinutes': durationMinutes,
        'subject': subject,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory StudySessionModel.fromJson(Map<String, dynamic> json) => StudySessionModel(
        id: json['id'],
        userId: json['userId'],
        durationMinutes: json['durationMinutes'],
        subject: json['subject'],
        startTime: DateTime.parse(json['startTime']),
        endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
        isCompleted: json['isCompleted'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  StudySessionModel copyWith({
    int? durationMinutes,
    String? subject,
    DateTime? endTime,
    bool? isCompleted,
    DateTime? updatedAt,
  }) =>
      StudySessionModel(
        id: id,
        userId: userId,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        subject: subject ?? this.subject,
        startTime: startTime,
        endTime: endTime ?? this.endTime,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now(),
      );
}
