import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          'Terms of Service',
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
            const Text(
              'Last Updated: August 1, 2026',
              style: TextStyle(fontSize: 14, color: Color(0xFF9090A7)),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('1. Acceptance of Terms'),
            _buildSectionText(
              'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement. '
              'In addition, when using these particular services, you shall be subject to any posted guidelines or rules applicable to such services.',
            ),
            _buildSectionTitle('2. User Conduct'),
            _buildSectionText(
              'You agree to use our services only for lawful purposes. You may not use our services in any way that breaches any applicable '
              'local, national, or international law or regulation.',
            ),
            _buildSectionTitle('3. Privacy Policy'),
            _buildSectionText(
              'Our Privacy Policy, which sets out how we will use your information, can be found at the Privacy Policy section. '
              'By using this app, you consent to the processing described therein and warrant that all data provided by you is accurate.',
            ),
            _buildSectionTitle('4. Modifications to Service'),
            _buildSectionText(
              'We reserve the right to modify or discontinue, temporarily or permanently, the Service (or any part thereof) with or without notice at any time.',
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
