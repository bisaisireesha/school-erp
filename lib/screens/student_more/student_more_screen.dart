import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class StudentMoreScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String screenKey) onNavigate;

  const StudentMoreScreen({
    super.key,
    required this.data,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final modules = [
      {
        'key': 'subjects',
        'title': 'Subjects',
        'subtitle': 'Syllabus & Topics',
        'icon': LucideIcons.bookOpen,
        'color': const Color(0xFF6C4CF1),
      },
      {
        'key': 'attendance',
        'title': 'Attendance',
        'subtitle': 'Monthly Stats',
        'icon': LucideIcons.userCheck,
        'color': const Color(0xFF10B981),
      },
      {
        'key': 'homework',
        'title': 'Homework',
        'subtitle': 'Assignments & Tasks',
        'icon': LucideIcons.fileText,
        'color': const Color(0xFFF59E0B),
      },
      {
        'key': 'exams',
        'title': 'Exams & Results',
        'subtitle': 'Report Cards',
        'icon': LucideIcons.award,
        'color': const Color(0xFFEC4899),
      },
      {
        'key': 'timetable',
        'title': 'Timetable',
        'subtitle': 'Daily Schedule',
        'icon': LucideIcons.calendar,
        'color': const Color(0xFF3B82F6),
      },
      {
        'key': 'school',
        'title': 'School Notice',
        'subtitle': 'Announcements',
        'icon': LucideIcons.building2,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'key': 'fees',
        'title': 'Fee Payments',
        'subtitle': 'Dues & Receipts',
        'icon': LucideIcons.creditCard,
        'color': const Color(0xFF059669),
      },
      {
        'key': 'messages',
        'title': 'Messages',
        'subtitle': 'Teachers & Staff',
        'icon': LucideIcons.messageSquare,
        'color': const Color(0xFF06B6D4),
      },
      {
        'key': 'events',
        'title': 'Events & Calendar',
        'subtitle': 'Activities & Holidays',
        'icon': LucideIcons.partyPopper,
        'color': const Color(0xFFF43F5E),
      },
      {
        'key': 'library',
        'title': 'Library',
        'subtitle': 'Borrowed Books',
        'icon': LucideIcons.library,
        'color': const Color(0xFF84CC16),
      },
      {
        'key': 'leave',
        'title': 'Leave Request',
        'subtitle': 'Apply Leave',
        'icon': LucideIcons.fileQuestion,
        'color': const Color(0xFFD97706),
      },
      {
        'key': 'transport',
        'title': 'Transport',
        'subtitle': 'Bus Tracking',
        'icon': LucideIcons.bus,
        'color': const Color(0xFF6366F1),
      },
      {
        'key': 'hostel',
        'title': 'Hostel & Mess',
        'subtitle': 'Room & Menu',
        'icon': LucideIcons.home,
        'color': const Color(0xFF14B8A6),
      },
      {
        'key': 'services',
        'title': 'Services',
        'subtitle': 'Student Support',
        'icon': LucideIcons.grid,
        'color': const Color(0xFF64748B),
      },
      {
        'key': 'study_material',
        'title': 'Study Material',
        'subtitle': 'PDFs & E-Books',
        'icon': LucideIcons.fileCode,
        'color': const Color(0xFFA855F7),
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student Modules',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Access all academic services and tools',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7A7A9D),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C4CF1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '15 Modules',
                  style: TextStyle(
                    color: Color(0xFF6C4CF1),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3-Column Clean Grid Layout
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modules.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.88,
            ),
            itemBuilder: (context, index) {
              final mod = modules[index];
              final Color color = mod['color'] as Color;
              return GestureDetector(
                onTap: () => onNavigate(mod['key'] as String),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                    boxShadow: AppShadows.soft,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          mod['icon'] as IconData,
                          color: color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mod['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mod['subtitle'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF7A7A9D),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 90), // Bottom navbar gap
        ],
      ),
    );
  }
}
