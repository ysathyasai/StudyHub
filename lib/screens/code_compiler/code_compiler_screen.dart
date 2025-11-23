import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CodeCompilerScreen extends StatefulWidget {
  const CodeCompilerScreen({super.key});

  @override
  State<CodeCompilerScreen> createState() => _CodeCompilerScreenState();
}

class _CodeCompilerScreenState extends State<CodeCompilerScreen> {
  final _codeController = TextEditingController();
  String _output = '';
  String _selectedLanguage = 'Python';
  final List<String> _languages = ['Python', 'Java', 'C++', 'JavaScript', 'C'];
  bool _isLoading = false;
  
  // API key for Judge0 API
  static const String _apiKey = '121d64aac0msh7ec0f7e30fec78dp136cd5jsnb47ed82dd748';
  static const String _apiHost = 'judge0-ce.p.rapidapi.com';
  
  // Language IDs for Judge0 API
  final Map<String, String> _languageIds = {
    'Python': '71',    // Python 3
    'Java': '62',      // Java
    'C++': '54',       // C++ (GCC 9.2.0)
    'JavaScript': '63', // JavaScript (Node.js)
    'C': '50',         // C (GCC 9.2.0)
  };

  Future<void> _runCode() async {
    if (_codeController.text.trim().isEmpty) {
      setState(() {
        _output = 'Please enter some code to run.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _output = 'Compiling and running your code...';
    });

    try {
      // Get language ID
      final languageId = _languageIds[_selectedLanguage] ?? '71'; // Default to Python if not found
      
      // Create submission
      final response = await http.post(
        Uri.parse('https://$_apiHost/submissions'),
        headers: {
          'content-type': 'application/json',
          'X-RapidAPI-Key': _apiKey,
          'X-RapidAPI-Host': _apiHost,
        },
        body: jsonEncode({
          'language_id': languageId,
          'source_code': _codeController.text,
          'stdin': '',
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        // Wait a moment for compilation
        await Future.delayed(const Duration(seconds: 2));
        
        // Get submission result
        final resultResponse = await http.get(
          Uri.parse('https://$_apiHost/submissions/$token'),
          headers: {
            'X-RapidAPI-Key': _apiKey,
            'X-RapidAPI-Host': _apiHost,
          },
        );

        if (resultResponse.statusCode == 200) {
          final resultData = jsonDecode(resultResponse.body);
          
          setState(() {
            _isLoading = false;
            
            if (resultData['status']['id'] == 3) { // Accepted status
              _output = resultData['stdout'] ?? 'Execution successful but no output.';
            } else if (resultData['stderr'] != null && resultData['stderr'].isNotEmpty) {
              _output = 'Error:\n${resultData['stderr']}';
            } else if (resultData['compile_output'] != null && resultData['compile_output'].isNotEmpty) {
              _output = 'Compilation Error:\n${resultData['compile_output']}';
            } else {
              _output = 'Status: ${resultData['status']['description']}\n';
              if (resultData['stdout'] != null) {
                _output += '\nOutput:\n${resultData['stdout']}';
              }
            }
          });
        } else {
          setState(() {
            _isLoading = false;
            _output = 'Failed to get submission result. Status code: ${resultResponse.statusCode}';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _output = 'Failed to create submission. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _output = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Compiler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _runCode,
            tooltip: 'Run Code',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text('Language:', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).colorScheme.outline)),
                    child: DropdownButton<String>(
                      value: _selectedLanguage,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: _languages.map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
                      onChanged: (value) => setState(() => _selectedLanguage = value!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
                      child: TextField(
                        controller: _codeController,
                        decoration: const InputDecoration(hintText: '// Write your code here...', border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
                        style: const TextStyle(fontFamily: 'monospace'),
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Output', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                                if (_isLoading) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(_output.isEmpty ? 'Click the play button to run your code' : _output, style: TextStyle(fontFamily: 'monospace', color: Theme.of(context).colorScheme.onSurface)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _runCode, 
              icon: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.play_arrow), 
              label: Text(_isLoading ? 'Running...' : 'Run Code'), 
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50))
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
