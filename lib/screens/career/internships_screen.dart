import 'package:flutter/material.dart';
import 'package:studyhub/models/internship_model.dart';
import 'package:studyhub/services/internship_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class InternshipsScreen extends StatefulWidget {
  const InternshipsScreen({super.key});

  @override
  State<InternshipsScreen> createState() => _InternshipsScreenState();
}

class _InternshipsScreenState extends State<InternshipsScreen> {
  final _service = InternshipService();
  List<InternshipModel> _internships = [];
  Set<String> _savedIds = {};
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadSavedInternships();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedInternships() async {
    final saved = await _service.getSavedInternships();
    setState(() {
      _savedIds = saved.map((e) => e.id).toSet();
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _searchInternships();
      } else {
        setState(() {
          _internships = [];
        });
      }
    });
  }

  Future<void> _searchInternships() async {
    setState(() => _isLoading = true);
    try {
      final internships = await _service.searchInternships(_searchController.text);
      setState(() {
        _internships = internships;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load internships: ${e.toString()}')),
      );
    }
  }

  Future<void> _toggleSave(InternshipModel internship) async {
    await _service.toggleSave(internship);
    await _loadSavedInternships();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Internships')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter your skills (e.g., "Flutter developer")',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to search:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter keywords for your desired role, skills, or location.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Example: "Software engineering intern remote"',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_internships.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      _searchController.text.isEmpty
                          ? 'Start typing to search for internships'
                          : 'No internships found for your search',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _internships.length,
                itemBuilder: (context, index) {
                  final internship = _internships[index];
                  final isSaved = _savedIds.contains(internship.id);
                  return _buildInternshipCard(internship, isSaved);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInternshipCard(InternshipModel internship, bool isSaved) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary.withOpacity(0.1), Theme.of(context).colorScheme.tertiary.withOpacity(0.1)]),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.business, color: Theme.of(context).colorScheme.primary, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(internship.company, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(internship.position, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                    ],
                  ),
                ),
                IconButton(onPressed: () => _toggleSave(internship), icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: isSaved ? Colors.blue : null)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoChip(Icons.location_on_outlined, internship.location),
                const SizedBox(height: 16),
                Text(internship.description, style: Theme.of(context).textTheme.bodyMedium, maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(internship.applyLink);
                      try {
                        final launched = await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                        if (!launched) {
                          // Try alternative mode
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalNonBrowserApplication,
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Could not open link. Please copy: ${internship.applyLink}'),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      }
                    }, 
                    icon: const Icon(Icons.open_in_new), 
                    label: const Text('Apply Now'), 
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14))
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, [Color? color]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: color ?? Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

