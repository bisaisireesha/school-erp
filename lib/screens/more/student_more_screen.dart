import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../subjects/subjects_screen.dart';
import '../attendance/attendance_screen.dart';
import '../exams/exams_screen.dart';
import '../timetable/timetable_screen.dart';
import '../calendar/calendar_screen.dart';
import '../cctv/cctv_screen.dart';
import '../resources/resources_screen.dart';
import '../library/library_screen.dart';
import '../leave/leave_request_screen.dart';
import '../transport/transport_screen.dart';
import '../profile/profile_screen.dart';
import '../main_layout.dart';

class StudentMoreScreen extends StatefulWidget {
  const StudentMoreScreen({super.key});

  @override
  State<StudentMoreScreen> createState() => _StudentMoreScreenState();
}

class _StudentMoreScreenState extends State<StudentMoreScreen> {
  List<Map<String, dynamic>> _quickActions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuickActions();
  }

  Future<void> _loadQuickActions() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/mock/student_more_actions.json',
      );
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _quickActions = List<Map<String, dynamic>>.from(data['quickActions']);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  IconData _getIcon(String iconStr) {
    switch (iconStr) {
      case 'bookOpen':
        return LucideIcons.bookOpen;
      case 'calendarCheck':
        return LucideIcons.calendarCheck;
      case 'graduationCap':
        return LucideIcons.graduationCap;
      case 'calendarDays':
        return LucideIcons.calendarDays;
      case 'book':
        return LucideIcons.book;
      case 'bus':
        return LucideIcons.bus;
      case 'folder':
        return LucideIcons.folder;
      case 'calendar':
        return LucideIcons.calendar;
      default:
        return LucideIcons.layoutGrid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildProfileHeader(context),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildQuickActions(context),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F0FF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'AK',
                  style: TextStyle(
                    color: Color(0xFF6C4CF1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Akshara',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Class 10-A | Roll No: 1042',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Student',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16A34A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF6C4CF1)),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quickActions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.90,
            ),
            itemBuilder: (context, index) {
              final item = _quickActions[index];
              return GestureDetector(
                onTap: () => _handleTap(context, item['key'] as String),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFF3EEFF),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE8E3F8).withValues(alpha: 0.45),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIcon(item['icon']),
                          color: const Color(0xFF6C4CF1),
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _handleTap(BuildContext context, String key) {
    switch (key) {
      case 'Subjects':
        MainLayout.pushSubScreen(
          context,
          SubjectsScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Attendance':
        MainLayout.pushSubScreen(
          context,
          AttendanceScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Exams & Results':
        MainLayout.pushSubScreen(
          context,
          ExamsScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Timetable':
        MainLayout.pushSubScreen(
          context,
          TimetableScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Leave Request':
        MainLayout.pushSubScreen(
          context,
          LeaveRequestScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Library':
        MainLayout.pushSubScreen(
          context,
          LibraryScreen(
            onBack: () => MainLayout.popSubScreen(context),
            isStudentPortal: true,
          ),
        );
        break;
      case 'Transport':
        MainLayout.pushSubScreen(
          context,
          TransportScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Study Material':
        MainLayout.pushSubScreen(
          context,
          ResourcesScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Calendar':
        MainLayout.pushSubScreen(
          context,
          CalendarScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'CCTV':
        MainLayout.pushSubScreen(
          context,
          CCTVScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
    }
  }
}
