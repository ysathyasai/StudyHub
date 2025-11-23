import 'dart:convert';
import 'package:studyhub/models/certification_model.dart';
import 'package:studyhub/services/storage_service.dart';

class CertificationService {
  static const String _certKey = 'certifications';

  Future<List<CertificationModel>> getCertifications() async {
    final data = await StorageService.getString(_certKey);
    if (data == null) return [];
    try {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => CertificationModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }



  Future<void> saveCertification(CertificationModel cert) async {
    final certs = await getCertifications();
    final index = certs.indexWhere((c) => c.id == cert.id);
    if (index >= 0) {
      certs[index] = cert;
    } else {
      certs.add(cert);
    }
    await StorageService.setString(_certKey, jsonEncode(certs.map((e) => e.toJson()).toList()));
  }

  Future<void> deleteCertification(String id) async {
    final certs = await getCertifications();
    certs.removeWhere((c) => c.id == id);
    await StorageService.setString(_certKey, jsonEncode(certs.map((e) => e.toJson()).toList()));
  }
}

