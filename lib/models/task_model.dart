enum TaskPriority { low, medium, high }

enum TaskCategory { personal, academic, work, other }

class TaskModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final bool isCompleted;
  final TaskPriority priority;
  final TaskCategory category;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.personal,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'priority': priority.name,
        'category': category.name,
        'dueDate': dueDate?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        description: json['description'],
        isCompleted: json['isCompleted'] ?? false,
        priority: TaskPriority.values.firstWhere((e) => e.name == json['priority'], orElse: () => TaskPriority.medium),
        category: TaskCategory.values.firstWhere((e) => e.name == json['category'], orElse: () => TaskCategory.personal),
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  TaskModel copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? dueDate,
    DateTime? updatedAt,
  }) =>
      TaskModel(
        id: id,
        userId: userId,
        title: title ?? this.title,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        priority: priority ?? this.priority,
        category: category ?? this.category,
        dueDate: dueDate ?? this.dueDate,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now(),
      );
}
