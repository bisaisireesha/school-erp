import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TeacherSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const TeacherSettingsScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<TeacherSettingsScreen> createState() => _TeacherSettingsScreenState();
}

class _TeacherSettingsScreenState extends State<TeacherSettingsScreen> {
  bool _pushNotifications = true;
  bool _attendanceReminders = true;
  bool _assignmentAlerts = true;
  bool _biometricLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 120.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'App Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Notification Preferences
              const Text('Notifications & Alerts', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      icon: LucideIcons.bell,
                      title: 'Push Notifications',
                      subtitle: 'Receive real-time alerts for parent chats',
                      value: _pushNotifications,
                      onChanged: (val) => setState(() => _pushNotifications = val),
                    ),
                    const Divider(height: 16, color: Color(0xFFF0EDF8)),
                    _buildSwitchTile(
                      icon: LucideIcons.calendarClock,
                      title: 'Attendance Submission Reminders',
                      subtitle: 'Alert 15 mins before period deadline',
                      value: _attendanceReminders,
                      onChanged: (val) => setState(() => _attendanceReminders = val),
                    ),
                    const Divider(height: 16, color: Color(0xFFF0EDF8)),
                    _buildSwitchTile(
                      icon: LucideIcons.fileCheck2,
                      title: 'Homework & Assignment Alerts',
                      subtitle: 'Notify when student submits homework',
                      value: _assignmentAlerts,
                      onChanged: (val) => setState(() => _assignmentAlerts = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Security & Privacy
              const Text('Security & Access', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      icon: LucideIcons.fingerprint,
                      title: 'Biometric Login / Face ID',
                      subtitle: 'Use fingerprint or Face ID to sign in',
                      value: _biometricLogin,
                      onChanged: (val) => setState(() => _biometricLogin = val),
                    ),
                    const Divider(height: 16, color: Color(0xFFF0EDF8)),
                    _buildActionTile(
                      icon: LucideIcons.lock,
                      title: 'Change Portal Password',
                      subtitle: 'Update your ERP password',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password change verification code sent to registered email.', style: TextStyle(fontWeight: FontWeight.bold)),
                            backgroundColor: Color(0xFF6C4CF1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // About & System Info
              const Text('About System', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                  boxShadow: AppShadows.soft,
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('App Version', style: TextStyle(fontSize: 13.5, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
                        Text('v2.4.0 (Enterprise Build)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Color(0xFF1E1E2D))),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('School ERP Instance', style: TextStyle(fontSize: 13.5, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
                        Text('Sunrise Academy Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Color(0xFF6C4CF1))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 19, color: const Color(0xFF6C4CF1)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1E1E2D)),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: const Color(0xFF6C4CF1),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 19, color: const Color(0xFF6C4CF1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF64748B)),
        ],
      ),
    );
  }
}
