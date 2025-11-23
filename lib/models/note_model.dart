class NoteModel {
  final String id;
  final String userId;
  final String title;
  final String content;
  final List<String> tags;
  final String? folderId;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.tags = const [],
    this.folderId,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'content': content,
        'tags': tags,
        'folderId': folderId,
        'isFavorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        content: json['content'],
        tags: List<String>.from(json['tags'] ?? []),
        folderId: json['folderId'],
        isFavorite: json['isFavorite'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  NoteModel copyWith({
    String? title,
    String? content,
    List<String>? tags,
    String? folderId,
    bool? isFavorite,
    DateTime? updatedAt,
  }) =>
      NoteModel(
        id: id,
        userId: userId,
        title: title ?? this.title,
        content: content ?? this.content,
        tags: tags ?? this.tags,
        folderId: folderId ?? this.folderId,
        isFavorite: isFavorite ?? this.isFavorite,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now(),
      );
}
