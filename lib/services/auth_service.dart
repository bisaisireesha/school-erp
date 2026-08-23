import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class AuthService {
  Future<UserModel?> login(String email, String password) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/mock/auth.json',
        cache: false,
      );
      final data = await json.decode(response);
      final users = data['users'] as List;

      dynamic foundUser;

      // Temporary hardcoded check so Hot Reload works without needing a full restart to sync assets
      if (email == 'student@school.edu' && password == 'Student@123') {
        foundUser = {
          "id": "4",
          "name": "Student",
          "email": "student@school.edu",
          "password": "Student@123",
          "role": "student",
        };
      } else if (email == 'frontdesk@school.edu' &&
          password == 'Frontdesk@123') {
        foundUser = {
          "id": "6",
          "name": "Front Desk",
          "email": "frontdesk@school.edu",
          "password": "Frontdesk@123",
          "role": "front_desk",
        };
      } else if (email == 'accountant@school.edu' &&
          password == 'Accountant@123') {
        foundUser = {
          "id": "7",
          "name": "Accountant",
          "email": "accountant@school.edu",
          "password": "Accountant@123",
          "role": "accountant",
        };
      } else {
        for (var u in users) {
          if (u['email'] == email && u['password'] == password) {
            foundUser = u;
            break;
          }
        }
      }

      if (foundUser != null) {
        return UserModel.fromJson(foundUser);
      }
      throw Exception('User not found');
    } catch (e) {
      throw Exception('Login Error: $e');
    }
  }
}
