import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/scholarship_model.dart';
import '../../services/scholarship_service.dart';

class ScholarshipsScreen extends StatefulWidget {
  const ScholarshipsScreen({super.key});

  @override
  State<ScholarshipsScreen> createState() => _ScholarshipsScreenState();
}

class _ScholarshipsScreenState extends State<ScholarshipsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScholarshipService _scholarshipService = ScholarshipService();
  List<Scholarship> _scholarships = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  Future<void> _searchScholarships(String query) async {
    if (query.isEmpty) {
      setState(() {
        _scholarships = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final results = await _scholarshipService.searchScholarships(query);
      setState(() {
        _scholarships = results;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load scholarships: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarship Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for scholarships',
                hintText: 'e.g., "computer science scholarship"',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchScholarships('');
                  },
                ),
              ),
              onSubmitted: _searchScholarships,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Powered by Google Custom Search",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildScholarshipList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScholarshipList() {
    if (!_hasSearched) {
      return const Center(
        child: Text('Enter a query to search for scholarships.'),
      );
    }

    if (_scholarships.isEmpty) {
      return const Center(
        child: Text('No scholarships found. Try a different search term.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _scholarships.length,
      itemBuilder: (context, index) {
        final scholarship = _scholarships[index];
        return _buildScholarshipCard(scholarship);
      },
    );
  }

  Widget _buildScholarshipCard(Scholarship scholarship) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scholarship.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              scholarship.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(scholarship.link);
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
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Could not open link. Please copy: ${scholarship.link}'),
                          duration: const Duration(seconds: 5),
                          action: SnackBarAction(
                            label: 'Copy',
                            onPressed: () {
                              // Copy to clipboard functionality would go here
                            },
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
