import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Effective Date: August 1, 2026', style: TextStyle(fontSize: 14, color: Color(0xFF9090A7))),
            const SizedBox(height: 24),
            _buildSectionTitle('1. Information We Collect'),
            _buildSectionText(
              'We may collect personal information such as your name, email address, phone number, and student data when you register or use the app.',
            ),
            _buildSectionTitle('2. How We Use Your Information'),
            _buildSectionText(
              'The information we collect is used to provide, maintain, protect, and improve our services, as well as to develop new features.',
            ),
            _buildSectionTitle('3. Data Security'),
            _buildSectionText(
              'We use reasonable administrative, logical, physical and managerial measures to safeguard your personal information against loss, theft and unauthorized access, use and modification.',
            ),
            _buildSectionTitle('4. Sharing of Information'),
            _buildSectionText(
              'We do not share your personal information with companies, organizations, or individuals outside of our institution unless one of the following circumstances applies: with your consent, for legal reasons, or with domain administrators.',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E1E2D),
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF6C6C80),
        height: 1.5,
      ),
    );
  }
}
