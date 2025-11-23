import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../../models/certification_model.dart';
import '../../services/certification_service.dart';

class CertificationsScreen extends StatefulWidget {
  const CertificationsScreen({super.key});

  @override
  State<CertificationsScreen> createState() => _CertificationsScreenState();
}

class _CertificationsScreenState extends State<CertificationsScreen> {
  final _service = CertificationService();
  List<CertificationModel> _certifications = [];

  @override
  void initState() {
    super.initState();
    _loadCertifications();
  }

  Future<void> _loadCertifications() async {
    final certs = await _service.getCertifications();
    setState(() => _certifications = certs);
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final issuerController = TextEditingController();
    final credIdController = TextEditingController();
    final categoryController = TextEditingController();
    String? imagePath;
    String? filePath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Certification'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Certification Name')),
                const SizedBox(height: 12),
                TextField(controller: issuerController, decoration: const InputDecoration(labelText: 'Issuing Organization')),
                const SizedBox(height: 12),
                TextField(controller: credIdController, decoration: const InputDecoration(labelText: 'Credential ID (optional)')),
                const SizedBox(height: 12),
                TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() => imagePath = pickedFile.path);
                            }
                          },
                          icon: const Icon(Icons.photo),
                          color: imagePath != null ? Colors.green : null,
                        ),
                        Text('Add Photo', style: TextStyle(fontSize: 12, color: imagePath != null ? Colors.green : null)),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles();
                            if (result != null) {
                              setState(() => filePath = result.files.single.path);
                            }
                          },
                          icon: const Icon(Icons.file_present),
                          color: filePath != null ? Colors.green : null,
                        ),
                        Text('Add File', style: TextStyle(fontSize: 12, color: filePath != null ? Colors.green : null)),
                      ],
                    ),
                  ],
                ),
                if (imagePath != null || filePath != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      imagePath != null 
                        ? 'Image selected: ${path.basename(imagePath!)}'
                        : 'File selected: ${path.basename(filePath!)}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || issuerController.text.isEmpty) return;
                final cert = CertificationModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: 'user1',
                  name: nameController.text,
                  issuer: issuerController.text,
                  credentialId: credIdController.text.isEmpty ? null : credIdController.text,
                  issueDate: DateTime.now(),
                  category: categoryController.text.isEmpty ? 'General' : categoryController.text,
                  createdAt: DateTime.now(),
                  imagePath: imagePath,
                  filePath: filePath,
                );
                await _service.saveCertification(cert);
                if (mounted) Navigator.pop(context);
                _loadCertifications();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Certifications')),
      body: _certifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_outlined, size: 80, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: 16),
                  Text('No certifications yet', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Add your first certification', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _certifications.length,
              itemBuilder: (context, index) => _buildCertCard(_certifications[index]),
            ),
      floatingActionButton: FloatingActionButton.extended(onPressed: _showAddDialog, icon: const Icon(Icons.add), label: const Text('Add Certification')),
    );
  }

  Widget _buildCertCard(CertificationModel cert) {
    final isExpired = cert.expiryDate != null && cert.expiryDate!.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isExpired ? Colors.red.withValues(alpha: 0.3) : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: isExpired ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(isExpired ? Icons.cancel : Icons.verified, color: isExpired ? Colors.red : Colors.green, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cert.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(cert.issuer, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(cert.category, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w500)),
            ),
            if (cert.credentialId != null) ...[              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.badge, size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 8),
                  Text('ID: ${cert.credentialId}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8),
                Text('Issued: ${DateFormat('MMM dd, yyyy').format(cert.issueDate)}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            if (cert.expiryDate != null) ...[              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.event_busy, size: 16, color: isExpired ? Colors.red : Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 8),
                  Text('Expires: ${DateFormat('MMM dd, yyyy').format(cert.expiryDate!)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: isExpired ? Colors.red : null)),
                ],
              ),
            ],
            if (cert.credentialUrl != null) ...[              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.open_in_new, size: 18), label: const Text('View Certificate'))),
            ],
            if (cert.imagePath != null || cert.filePath != null) ...[              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (cert.imagePath != null)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppBar(
                                    title: const Text('Certificate Image'),
                                    leading: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                  Image.file(File(cert.imagePath!)),
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.photo, color: Colors.blue),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'View Image',
                                style: TextStyle(color: Colors.blue),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (cert.imagePath != null && cert.filePath != null)
                    const SizedBox(width: 16),
                  if (cert.filePath != null)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          try {
                            final file = File(cert.filePath!);
                            if (file.existsSync()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Opening file: ${path.basename(cert.filePath!)}')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error opening file: $e')),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.file_present, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'View File: ${path.basename(cert.filePath!)}',
                                style: const TextStyle(color: Colors.green),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
