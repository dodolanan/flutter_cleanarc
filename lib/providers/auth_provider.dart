import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/appwrite_service.dart';
import '../models/user_model.dart';
import 'package:appwrite/models.dart' as models;

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier(AppwriteService());
});

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier(this._appwriteService) : super(null);

  final AppwriteService _appwriteService;

  Future<void> login(String email, String password) async {
    try {
      final models.User user = await _appwriteService.login(email, password);
      state = UserModel(id: user.$id, name: user.name, email: user.email);
    } catch (e) {
      rethrow; // Re-throw error agar dapat ditangkap oleh UI
    }
  }

  Future<void> register(String name,String email, String password) async {
    try {
      final models.User user = await _appwriteService.register(name,email, password);
      state = UserModel(id: user.$id, name: user.name, email: user.email);
    } catch (e) {
      rethrow; // Re-throw error agar dapat ditangkap oleh UI
    }
  }

  Future<void> logout() async {
    try {
      await _appwriteService.logout();
      state = null;
    } catch (e) {
      rethrow; // Re-throw error agar dapat ditangkap oleh UI
    }
  }

  Future<void> checkAuth() async {
    try {
      final models.User user = await _appwriteService.getCurrentUser();
      state = UserModel(id: user.$id, name: user.name, email: user.email);
    } catch (e) {
      state = null; // User tidak terautentikasi
    }
  }
}
