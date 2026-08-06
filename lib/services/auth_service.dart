import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class AuthService {
  Future<UserModel?> login(String email, String password) async {
    try {
      final String response = await rootBundle.loadString('assets/mock/auth.json');
      final data = await json.decode(response);
      final users = data['users'] as List;
      
      final cleanEmail = email.trim().toLowerCase();
      final cleanPassword = password.trim();

      // 1. Direct or Case-insensitive match
      var user = users.firstWhere(
        (u) => (u['email'].toString().toLowerCase().trim() == cleanEmail) &&
               (u['password'].toString().trim() == cleanPassword),
        orElse: () => null,
      );

      // 2. Fallback helper: If email contains 'librarian', grant librarian access
      if (user == null && cleanEmail.contains('librarian')) {
        user = users.firstWhere(
          (u) => u['role'] == 'librarian',
          orElse: () => null,
        );
      }

      if (user != null) {
        return UserModel.fromJson(user);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
