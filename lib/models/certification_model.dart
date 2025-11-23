class CertificationModel {
  final String id;
  final String userId;
  final String name;
  final String issuer;
  final String? credentialId;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String? credentialUrl;
  final String category;
  final DateTime createdAt;
  final String? imagePath;
  final String? filePath;

  CertificationModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.issuer,
    this.credentialId,
    required this.issueDate,
    this.expiryDate,
    this.credentialUrl,
    required this.category,
    required this.createdAt,
    this.imagePath,
    this.filePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'issuer': issuer,
        'credentialId': credentialId,
        'issueDate': issueDate.toIso8601String(),
        'expiryDate': expiryDate?.toIso8601String(),
        'credentialUrl': credentialUrl,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
        'imagePath': imagePath,
        'filePath': filePath,
      };

  factory CertificationModel.fromJson(Map<String, dynamic> json) => CertificationModel(
        id: json['id'],
        userId: json['userId'],
        name: json['name'],
        issuer: json['issuer'],
        credentialId: json['credentialId'],
        issueDate: DateTime.parse(json['issueDate']),
        expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
        credentialUrl: json['credentialUrl'],
        category: json['category'],
        createdAt: DateTime.parse(json['createdAt']),
        imagePath: json['imagePath'],
        filePath: json['filePath'],
      );
}
