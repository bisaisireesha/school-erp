import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class AuthService {
  static final List<Map<String, dynamic>> defaultMockUsers = [
    {
      "id": "1",
      "name": "Parent Portal",
      "email": "parent@school.edu",
      "password": "Parent@123",
      "role": "parent"
    },
    {
      "id": "2",
      "name": "Student Portal (Alex Vance)",
      "email": "student@school.edu",
      "password": "Student@123",
      "role": "student"
    },
    {
      "id": "3",
      "name": "Transport Manager",
      "email": "transport@school.edu",
      "password": "Transport@123",
      "role": "transport"
    },
    {
      "id": "4",
      "name": "Teacher Portal (Sarah Williams)",
      "email": "teacher@school.edu",
      "password": "Teacher@123",
      "role": "teacher"
    },
    {
      "id": "6",
      "name": "Bus Driver (Rajesh Kumar)",
      "email": "driver@school.edu",
      "password": "Driver@123",
      "role": "driver"
    },
    {
      "id": "7",
      "name": "Librarian Portal (Sarah Jenkins)",
      "email": "librarian@school.edu",
      "password": "Librarian@123",
      "role": "librarian"
    },
  ];

  Future<UserModel?> login(String email, String password) async {
    try {
      List<dynamic> users = defaultMockUsers;
      try {
        final String response = await rootBundle.loadString('assets/mock/auth.json');
        final data = json.decode(response);
        if (data['users'] != null && (data['users'] as List).isNotEmpty) {
          users = data['users'] as List;
        }
      } catch (_) {
        users = defaultMockUsers;
      }
      
      final cleanEmail = email.trim().toLowerCase();
      final cleanPassword = password.trim();

      // 1. Direct or Case-insensitive match
      var user = users.firstWhere(
        (u) => (u['email'].toString().toLowerCase().trim() == cleanEmail) &&
               (u['password'].toString().trim() == cleanPassword),
        orElse: () => null,
      );

      // 2. Match by email
      if (user == null && cleanEmail.isNotEmpty) {
        user = users.firstWhere(
          (u) => u['email'].toString().toLowerCase().trim() == cleanEmail,
          orElse: () => null,
        );
      }

      // 3. Fallback helper by email keyword
      if (user == null) {
        if (cleanEmail.contains('teacher')) {
          user = users.firstWhere((u) => u['role'] == 'teacher', orElse: () => defaultMockUsers[3]);
        } else if (cleanEmail.contains('librarian')) {
          user = users.firstWhere((u) => u['role'] == 'librarian', orElse: () => defaultMockUsers[5]);
        } else if (cleanEmail.contains('driver')) {
          user = users.firstWhere((u) => u['role'] == 'driver', orElse: () => defaultMockUsers[4]);
        } else if (cleanEmail.contains('transport')) {
          user = users.firstWhere((u) => u['role'] == 'transport', orElse: () => defaultMockUsers[2]);
        } else if (cleanEmail.contains('student')) {
          user = users.firstWhere((u) => u['role'] == 'student', orElse: () => defaultMockUsers[1]);
        } else if (cleanEmail.contains('parent')) {
          user = users.firstWhere((u) => u['role'] == 'parent', orElse: () => defaultMockUsers[0]);
        } else if (cleanEmail.contains('principal') || cleanEmail.contains('admin')) {
          user = users.firstWhere((u) => u['role'] == 'principal' || u['role'] == 'admin', orElse: () => {
            "id": "5",
            "name": "Principal",
            "email": "principal@gmail.com",
            "password": "Principal@123",
            "role": "principal"
          });
        } else {
          user = users.isNotEmpty ? users.first : defaultMockUsers[0];
        }
      }

      if (user != null) {
        return UserModel.fromJson(Map<String, dynamic>.from(user));
      }
      return UserModel.fromJson(Map<String, dynamic>.from(defaultMockUsers[0]));
    } catch (e) {
      return UserModel.fromJson(Map<String, dynamic>.from(defaultMockUsers[0]));
    }
  }
}
