import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _muteAll = false;

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
          'Notifications',
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
            _buildSectionTitle('Alert Preferences'),
            const SizedBox(height: 16),
            _buildSwitchTile(
              LucideIcons.bellRing,
              'Push Notifications',
              'Receive alerts on your device',
              _pushNotifications,
              (val) => setState(() => _pushNotifications = val),
            ),
            _buildSwitchTile(
              LucideIcons.mail,
              'Email Notifications',
              'Receive daily summary emails',
              _emailNotifications,
              (val) => setState(() => _emailNotifications = val),
            ),
            _buildSwitchTile(
              LucideIcons.messageSquare,
              'SMS Notifications',
              'Receive urgent alerts via SMS',
              _smsNotifications,
              (val) => setState(() => _smsNotifications = val),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Do Not Disturb'),
            const SizedBox(height: 16),
            _buildSwitchTile(
              LucideIcons.bellOff,
              'Mute All Notifications',
              'Temporarily pause all alerts',
              _muteAll,
              (val) => setState(() => _muteAll = val),
            ),
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

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF0EA5E9), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E1E2D),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Color(0xFF9090A7)),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: const Color(0xFF0EA5E9).withValues(alpha: 0.5),
        activeThumbColor: const Color(0xFF0EA5E9),
      ),
    );
  }
}
