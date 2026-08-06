import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'contact_support_screen.dart';
import 'faqs_screen.dart';
import 'terms_of_service_screen.dart';
import 'privacy_policy_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          'Help & Support',
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
            _buildSectionTitle('Need Help?'),
            const SizedBox(height: 16),
            _buildListTile(LucideIcons.messageCircle, 'Contact Support', 'Chat with our support team', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactSupportScreen()));
            }),
            _buildListTile(LucideIcons.helpCircle, 'FAQs', 'Frequently asked questions', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqsScreen()));
            }),
            const SizedBox(height: 32),
            _buildSectionTitle('About'),
            const SizedBox(height: 16),
            _buildListTile(LucideIcons.info, 'App Version', 'v1.0.0 (Build 42)', onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'School ERP Parent',
                applicationVersion: 'v1.0.0 (Build 42)',
                applicationIcon: const Icon(LucideIcons.graduationCap, size: 48, color: Color(0xFF6C4CF1)),
                children: const [
                  SizedBox(height: 16),
                  Text('A comprehensive platform for parents to track and manage their children\'s academic progress, attendance, and activities.', style: TextStyle(fontSize: 14)),
                ],
              );
            }),
            _buildListTile(LucideIcons.fileText, 'Terms of Service', 'Read our terms and conditions', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()));
            }),
            _buildListTile(LucideIcons.shield, 'Privacy Policy', 'Review our privacy policy', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E1E2D),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle, {required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF16A34A), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF9090A7))),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF9090A7)),
      onTap: onTap,
    );
  }
}
