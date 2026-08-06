import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _twoFactor = true;
  bool _biometrics = false;

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
          'Privacy & Security',
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
            _buildSectionTitle('Security'),
            const SizedBox(height: 16),
            _buildListTile(LucideIcons.lock, 'Change Password', 'Update your password regularly', onTap: () {}),
            _buildSwitchTile(LucideIcons.shieldCheck, 'Two-Factor Authentication', 'Add an extra layer of security', _twoFactor, (val) => setState(() => _twoFactor = val)),
            _buildSwitchTile(LucideIcons.fingerprint, 'Biometric Login', 'Use Face ID or Fingerprint', _biometrics, (val) => setState(() => _biometrics = val)),
            const SizedBox(height: 32),
            _buildSectionTitle('Privacy'),
            const SizedBox(height: 16),
            _buildListTile(LucideIcons.eyeOff, 'Profile Visibility', 'Manage who can see your profile', onTap: () {}),
            _buildListTile(LucideIcons.smartphone, 'Active Sessions', 'Manage your logged-in devices', onTap: () {}),
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
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFFF59E0B), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF9090A7))),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF9090A7)),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFFF59E0B), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF9090A7))),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: const Color(0xFFF59E0B).withValues(alpha: 0.5),
        activeThumbColor: const Color(0xFFF59E0B),
      ),
    );
  }
}
