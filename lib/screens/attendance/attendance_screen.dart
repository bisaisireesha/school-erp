import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class AttendanceScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AttendanceScreen({super.key, required this.onBack});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                AppBackButton(onPressed: widget.onBack),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: Text(
                    'Attendance',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(LucideIcons.calendarCheck, size: 48, color: Color(0xFF6C4CF1)),
                    SizedBox(height: 16),
                    Text(
                      'Attendance records will appear here.',
                      style: TextStyle(fontSize: 16, color: Color(0xFF1E1E2D)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 120), // Bottom padding for navbar
        ],
      ),
    );
  }
}
