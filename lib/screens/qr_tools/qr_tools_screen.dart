import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRToolsScreen extends StatefulWidget {
  const QRToolsScreen({super.key});

  @override
  State<QRToolsScreen> createState() => _QRToolsScreenState();
}

class _QRToolsScreenState extends State<QRToolsScreen> {
  final _textController = TextEditingController();
  String _qrData = '';
  bool _showQR = false;

  void _generateQR() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _qrData = _textController.text;
        _showQR = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.qr_code, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Text('Generate QR Code', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(labelText: 'Enter text or URL', hintText: 'https://example.com'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(onPressed: _generateQR, icon: const Icon(Icons.create), label: const Text('Generate QR Code')),
                  ),
                ],
              ),
            ),
            if (_showQR) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
                child: Column(
                  children: [
                    Text('Your QR Code', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: QrImageView(data: _qrData, version: QrVersions.auto, size: 250),
                    ),
                    const SizedBox(height: 20),
                    Text('Scan this code with your phone', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 12),
                  Text('QR Code Uses', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Share contact info, URLs, WiFi passwords, text messages, and more with QR codes!', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
