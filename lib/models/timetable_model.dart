class TimetableEntry {
  final String id;
  final String userId;
  final String courseName;
  final String? courseCode;
  final String? instructor;
  final String? room;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String? color;
  final String? pdfPath;
  final String? imagePath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  TimetableEntry({
    required this.id,
    required this.userId,
    required this.courseName,
    this.courseCode,
    this.instructor,
    this.room,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.color,
    this.pdfPath,
    this.imagePath,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'courseName': courseName,
        'courseCode': courseCode,
        'instructor': instructor,
        'room': room,
        'dayOfWeek': dayOfWeek,
        'startTime': startTime,
        'endTime': endTime,
        'color': color,
        'pdfPath': pdfPath,
        'imagePath': imagePath,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory TimetableEntry.fromJson(Map<String, dynamic> json) => TimetableEntry(
        id: json['id'],
        userId: json['userId'],
        courseName: json['courseName'],
        courseCode: json['courseCode'],
        instructor: json['instructor'],
        room: json['room'],
        dayOfWeek: json['dayOfWeek'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        color: json['color'],
        pdfPath: json['pdfPath'],
        imagePath: json['imagePath'],
        notes: json['notes'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  TimetableEntry copyWith({
    String? courseName,
    String? courseCode,
    String? instructor,
    String? room,
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    String? color,
    String? pdfPath,
    String? imagePath,
    String? notes,
    DateTime? updatedAt,
  }) =>
      TimetableEntry(
        id: id,
        userId: userId,
        courseName: courseName ?? this.courseName,
        courseCode: courseCode ?? this.courseCode,
        instructor: instructor ?? this.instructor,
        room: room ?? this.room,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        color: color ?? this.color,
        pdfPath: pdfPath ?? this.pdfPath,
        imagePath: imagePath ?? this.imagePath,
        notes: notes ?? this.notes,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now(),
      );
}
