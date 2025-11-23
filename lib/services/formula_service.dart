import 'package:studyhub/models/formula_model.dart';

class FormulaService {
  static final List<FormulaModel> _formulas = [
    // Physics
    FormulaModel(id: '1', name: 'Force', formula: 'F = ma', category: 'Physics', description: 'Newton\'s Second Law', usage: 'Calculate force from mass and acceleration'),
    FormulaModel(id: '2', name: 'Velocity', formula: 'v = u + at', category: 'Physics', description: 'First equation of motion', usage: 'Find final velocity'),
    FormulaModel(id: '3', name: 'Displacement', formula: 's = ut + ½at²', category: 'Physics', description: 'Second equation of motion', usage: 'Calculate displacement'),
    FormulaModel(id: '4', name: 'Kinetic Energy', formula: 'KE = ½mv²', category: 'Physics', description: 'Energy of motion', usage: 'Calculate kinetic energy'),
    FormulaModel(id: '5', name: 'Power', formula: 'P = W/t', category: 'Physics', description: 'Rate of work done', usage: 'Calculate power output'),
    
    // Mathematics
    FormulaModel(id: '6', name: 'Quadratic Formula', formula: 'x = (-b ± √(b²-4ac)) / 2a', category: 'Mathematics', description: 'Solve quadratic equations', usage: 'Find roots of ax² + bx + c = 0'),
    FormulaModel(id: '7', name: 'Pythagorean Theorem', formula: 'a² + b² = c²', category: 'Mathematics', description: 'Right triangle relationship', usage: 'Calculate hypotenuse'),
    FormulaModel(id: '8', name: 'Area of Circle', formula: 'A = πr²', category: 'Mathematics', description: 'Circle area', usage: 'Calculate area from radius'),
    FormulaModel(id: '9', name: 'Distance Formula', formula: 'd = √((x₂-x₁)² + (y₂-y₁)²)', category: 'Mathematics', description: 'Distance between points', usage: 'Calculate distance in coordinate plane'),
    
    // Chemistry
    FormulaModel(id: '10', name: 'Ideal Gas Law', formula: 'PV = nRT', category: 'Chemistry', description: 'Gas behavior', usage: 'Relate pressure, volume, and temperature'),
    FormulaModel(id: '11', name: 'Molarity', formula: 'M = n/V', category: 'Chemistry', description: 'Solution concentration', usage: 'Calculate molar concentration'),
    FormulaModel(id: '12', name: 'pH Formula', formula: 'pH = -log[H⁺]', category: 'Chemistry', description: 'Acidity measure', usage: 'Calculate pH from hydrogen ion concentration'),
    
    // Computer Science
    FormulaModel(id: '13', name: 'Big O Notation', formula: 'O(n), O(log n), O(n²)', category: 'Computer Science', description: 'Algorithm complexity', usage: 'Measure algorithm efficiency'),
    FormulaModel(id: '14', name: 'Binary Search', formula: 'mid = (low + high) / 2', category: 'Computer Science', description: 'Search algorithm', usage: 'Find middle element'),
  ];

  List<FormulaModel> getAllFormulas() => _formulas;

  List<FormulaModel> getFormulasByCategory(String category) => _formulas.where((f) => f.category == category).toList();

  List<String> getCategories() => _formulas.map((f) => f.category).toSet().toList();

  List<FormulaModel> searchFormulas(String query) {
    final lowerQuery = query.toLowerCase();
    return _formulas.where((f) => f.name.toLowerCase().contains(lowerQuery) || f.formula.toLowerCase().contains(lowerQuery) || f.category.toLowerCase().contains(lowerQuery)).toList();
  }
}

