class FlashcardModel {
  final String id;
  final String userId;
  final String question;
  final String answer;
  final String? deckName;
  final List<String> tags;
  final int reviewCount;
  final DateTime? lastReviewed;
  final DateTime createdAt;
  final DateTime updatedAt;

  FlashcardModel({
    required this.id,
    required this.userId,
    required this.question,
    required this.answer,
    this.deckName,
    this.tags = const [],
    this.reviewCount = 0,
    this.lastReviewed,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'question': question,
        'answer': answer,
        'deckName': deckName,
        'tags': tags,
        'reviewCount': reviewCount,
        'lastReviewed': lastReviewed?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory FlashcardModel.fromJson(Map<String, dynamic> json) => FlashcardModel(
        id: json['id'],
        userId: json['userId'],
        question: json['question'],
        answer: json['answer'],
        deckName: json['deckName'],
        tags: List<String>.from(json['tags'] ?? []),
        reviewCount: json['reviewCount'] ?? 0,
        lastReviewed: json['lastReviewed'] != null ? DateTime.parse(json['lastReviewed']) : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  FlashcardModel copyWith({
    String? question,
    String? answer,
    String? deckName,
    List<String>? tags,
    int? reviewCount,
    DateTime? lastReviewed,
    DateTime? updatedAt,
  }) =>
      FlashcardModel(
        id: id,
        userId: userId,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        deckName: deckName ?? this.deckName,
        tags: tags ?? this.tags,
        reviewCount: reviewCount ?? this.reviewCount,
        lastReviewed: lastReviewed ?? this.lastReviewed,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now(),
      );
}
