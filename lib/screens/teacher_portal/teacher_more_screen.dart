import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TeacherMoreScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? activeModuleKey;
  final Function(String key) onNavigate;

  const TeacherMoreScreen({
    super.key,
    required this.data,
    this.activeModuleKey,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // 8 Specialized non-duplicated modules (Excluding Bottom Nav, Top Bar, Settings & Announcements)
    final modules = [
      {
        'key': 'homework',
        'title': 'Homework',
        'icon': LucideIcons.bookOpen,
        'color': const Color(0xFF8B5CF6),
        'subtitle': 'Daily Exercises',
      },
      {
        'key': 'assignments',
        'title': 'Assignments',
        'icon': LucideIcons.fileCheck2,
        'color': const Color(0xFFF59E0B),
        'subtitle': 'Projects & Rubrics',
      },
      {
        'key': 'exams',
        'title': 'Exams & Gradebook',
        'icon': LucideIcons.award,
        'color': const Color(0xFFEF4444),
        'subtitle': 'Marks & Results',
      },
      {
        'key': 'timetable',
        'title': 'Timetable',
        'icon': LucideIcons.calendarDays,
        'color': const Color(0xFF06B6D4),
        'subtitle': 'Weekly Periods',
      },
      {
        'key': 'my_attendance',
        'title': 'My Attendance',
        'icon': LucideIcons.clipboardCheck,
        'color': const Color(0xFF10B981),
        'subtitle': 'Leaves & Calendar',
      },
      {
        'key': 'resources',
        'title': 'Resources',
        'icon': LucideIcons.folderClosed,
        'color': const Color(0xFF6C4CF1),
        'subtitle': 'Files & Class Folders',
      },
      {
        'key': 'transport',
        'title': 'Transport',
        'icon': LucideIcons.bus,
        'color': const Color(0xFFF97316),
        'subtitle': 'Routes & Tracking',
      },
      {
        'key': 'payroll',
        'title': 'Payslips',
        'icon': LucideIcons.receipt,
        'color': const Color(0xFF84CC16),
        'subtitle': 'Salary & Earnings',
      },
      {
        'key': 'calendar',
        'title': 'Calendar',
        'icon': LucideIcons.calendar,
        'color': const Color(0xFF0EA5E9),
        'subtitle': 'Events & Holidays',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 120.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Faculty Tools',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${modules.length} Modules',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Clean 2-Column Module Grid Layout with Active Highlight
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: modules.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.22,
                ),
                itemBuilder: (context, index) {
                  final mod = modules[index];
                  final String key = mod['key'] as String;
                  final Color color = mod['color'] as Color;
                  final bool isActive = activeModuleKey == key;

                  return GestureDetector(
                    onTap: () => onNavigate(key),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFF3EEFF) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFFF0EDF8),
                          width: isActive ? 1.8 : 1.0,
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF6C4CF1).withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : AppShadows.soft,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isActive ? const Color(0xFF6C4CF1) : color.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  mod['icon'] as IconData,
                                  color: isActive ? Colors.white : color,
                                  size: 22,
                                ),
                              ),
                              if (isActive)
                                Container(
                                  width: 9,
                                  height: 9,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mod['title'] as String,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D),
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            isActive ? 'Active Module' : (mod['subtitle'] as String),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                              color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
