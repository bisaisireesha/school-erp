import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class AuthService {
  Future<UserModel?> login(String email, String password) async {
    try {
      final String response = await rootBundle.loadString('assets/mock/auth.json');
      final data = await json.decode(response);
      final users = data['users'] as List;
      
      final user = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null,
      );

      if (user != null) {
        return UserModel.fromJson(user);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
