import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyhub/models/formula_model.dart';
import 'package:studyhub/services/formula_service.dart';

class FormulaLibraryScreen extends StatefulWidget {
  const FormulaLibraryScreen({super.key});

  @override
  State<FormulaLibraryScreen> createState() => _FormulaLibraryScreenState();
}

class _FormulaLibraryScreenState extends State<FormulaLibraryScreen> {
  final _formulaService = FormulaService();
  List<FormulaModel> _formulas = [];
  String? _selectedCategory;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formulas = _formulaService.getAllFormulas();
  }

  void _filterFormulas() {
    setState(() {
      if (_searchController.text.isEmpty && _selectedCategory == null) {
        _formulas = _formulaService.getAllFormulas();
      } else if (_searchController.text.isNotEmpty) {
        _formulas = _formulaService.searchFormulas(_searchController.text);
      } else if (_selectedCategory != null) {
        _formulas = _formulaService.getFormulasByCategory(_selectedCategory!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = _formulaService.getCategories();

    return Scaffold(
      appBar: AppBar(title: const Text('Formula Library')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search formulas...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                  _searchController.clear();
                  _filterFormulas();
                }) : null,
              ),
              onChanged: (_) => _filterFormulas(),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = null);
                    _filterFormulas();
                  },
                ),
                const SizedBox(width: 8),
                ...categories.map((category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() => _selectedCategory = selected ? category : null);
                          _filterFormulas();
                        },
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _formulas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.secondary),
                        const SizedBox(height: 16),
                        Text('No formulas found', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _formulas.length,
                    itemBuilder: (context, index) {
                      final formula = _formulas[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          backgroundColor: Theme.of(context).cardColor,
                          collapsedBackgroundColor: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
                          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
                          title: Text(formula.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(formula.formula, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontFamily: 'monospace'))),
                                    IconButton(
                                      icon: const Icon(Icons.copy, size: 20),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: formula.formula));
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Formula copied!'), duration: Duration(seconds: 1)));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(8)), child: Text(formula.category, style: Theme.of(context).textTheme.bodySmall)),
                            ],
                          ),
                          children: [
                            if (formula.description != null || formula.usage != null)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (formula.description != null) ...[
                                      Text('Description', style: Theme.of(context).textTheme.labelLarge),
                                      const SizedBox(height: 4),
                                      Text(formula.description!, style: Theme.of(context).textTheme.bodyMedium),
                                      const SizedBox(height: 12),
                                    ],
                                    if (formula.usage != null) ...[
                                      Text('Usage', style: Theme.of(context).textTheme.labelLarge),
                                      const SizedBox(height: 4),
                                      Text(formula.usage!, style: Theme.of(context).textTheme.bodyMedium),
                                    ],
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

