import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyhub/models/qr_code_model.dart';

class QRCodeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<QRCodeModel>> getQRCodesStream(String userId) {
    return _firestore
        .collection('qr_codes')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final qrCodes = snapshot.docs
          .map((doc) => QRCodeModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      qrCodes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return qrCodes;
    });
  }

  Future<List<QRCodeModel>> getAllQRCodes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('qr_codes')
          .where('userId', isEqualTo: userId)
          .get();

      final qrCodes = snapshot.docs
          .map((doc) => QRCodeModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      qrCodes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return qrCodes;
    } catch (e) {
      print('Error getting QR codes: $e');
      return [];
    }
  }

  Future<void> saveQRCode(QRCodeModel qrCode) async {
    try {
      await _firestore.collection('qr_codes').doc(qrCode.id).set(qrCode.toJson());
    } catch (e) {
      print('Error saving QR code: $e');
      rethrow;
    }
  }

  Future<void> deleteQRCode(String qrCodeId) async {
    try {
      await _firestore.collection('qr_codes').doc(qrCodeId).delete();
    } catch (e) {
      print('Error deleting QR code: $e');
      rethrow;
    }
  }
}
