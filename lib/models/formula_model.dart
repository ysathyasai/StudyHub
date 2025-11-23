class FormulaModel {
  final String id;
  final String name;
  final String formula;
  final String category;
  final String? description;
  final String? usage;

  FormulaModel({
    required this.id,
    required this.name,
    required this.formula,
    required this.category,
    this.description,
    this.usage,
  });

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'formula': formula, 'category': category, 'description': description, 'usage': usage};

  factory FormulaModel.fromJson(Map<String, dynamic> json) => FormulaModel(id: json['id'], name: json['name'], formula: json['formula'], category: json['category'], description: json['description'], usage: json['usage']);
}
