import 'dart:convert';
import 'package:studyhub/models/user_model.dart';
import 'package:studyhub/services/storage_service.dart';

class UserService {
  static const String _userKey = 'user_profile';

  Future<UserModel> getUser() async {
    final data = await StorageService.getString(_userKey);
    if (data == null) {
      // Return a default user if none is saved
      return UserModel(
        id: 'user1',
        name: 'AuraLearner',
        email: 'user@auralearn.com',
        university: 'Not Set',
        major: 'Not Set',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    try {
      final Map<String, dynamic> decoded = jsonDecode(data);
      return UserModel.fromJson(decoded);
    } catch (e) {
      // Handle potential errors, return default
      return UserModel(
        id: 'user1',
        name: 'AuraLearner',
        email: 'user@auralearn.com',
        university: 'Not Set',
        major: 'Not Set',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<void> saveUser(UserModel user) async {
    await StorageService.setString(_userKey, jsonEncode(user.toJson()));
  }
}

