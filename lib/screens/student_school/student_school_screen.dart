import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class StudentSchoolScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const StudentSchoolScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: onBack),
        title: const Text('School Notices & Info', style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // School Banner Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6C4CF1)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.building2, size: 32, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sunrise International Academy', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('Excellence in Education & Character', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text('Notice Board & Announcements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            const SizedBox(height: 10),

            _buildNoticeItem(
              'Principal\'s Desk: Mid-Term Examination Guidelines',
              'Students are requested to wear full formal uniform and bring valid school ID cards during exam week starting July 31st.',
              'Today, 09:00 AM',
              LucideIcons.bell,
              const Color(0xFF6C4CF1),
            ),
            const SizedBox(height: 8),
            _buildNoticeItem(
              'Annual Athletics & Sports Selection',
              'Registrations open for 100m sprint, long jump, and basketball selection trials. Contact Sports Department by Thursday.',
              'Yesterday',
              LucideIcons.trophy,
              const Color(0xFF10B981),
            ),
            const SizedBox(height: 8),
            _buildNoticeItem(
              'Library Digital Portal Maintenance',
              'The online ebook portal will undergo scheduled maintenance on Saturday between 2 PM - 5 PM.',
              '24 Jul 2024',
              LucideIcons.wrench,
              const Color(0xFFF59E0B),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeItem(String title, String desc, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E1E2D)))),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF4A4A68))),
          const SizedBox(height: 6),
          Text(time, style: const TextStyle(fontSize: 10, color: Color(0xFF7A7A9D))),
        ],
      ),
    );
  }
}
