import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../my_child/my_child_screen.dart';
import '../homework/homework_screen.dart';
import '../attendance/attendance_screen.dart';
import '../exams/exams_screen.dart';
import '../timetable/timetable_screen.dart';
import '../fees/fees_screen.dart';
import '../calendar/calendar_screen.dart';
import '../leave/leave_request_screen.dart';
import '../transport/transport_screen.dart';
import '../cctv/cctv_screen.dart';
import '../resources/resources_screen.dart';
import '../activity/activity_screen.dart';
import '../library/library_screen.dart';
import '../main_layout.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  List<Map<String, dynamic>> _quickActions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await MyChildScreen.loadChildrenData();
      final String response = await rootBundle.loadString('assets/mock/parent_more_actions.json');
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
      case 'users': return LucideIcons.users;
      case 'squarePen': return LucideIcons.squarePen;
      case 'calendarCheck': return LucideIcons.calendarCheck;
      case 'graduationCap': return LucideIcons.graduationCap;
      case 'calendarDays': return LucideIcons.calendarDays;
      case 'calendar': return LucideIcons.calendar;
      case 'fileCheck': return LucideIcons.fileCheck;
      case 'bus': return LucideIcons.bus;
      case 'video': return LucideIcons.video;
      case 'folder': return LucideIcons.folder;
      case 'book': return LucideIcons.book;
      case 'activity': return LucideIcons.activity;
      default: return LucideIcons.layoutGrid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: MyChildScreen.selectedChildIndex,
      builder: (context, selectedIndex, child) {
        if (_isLoading || MyChildScreen.childrenData.isEmpty) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8F9FA),
            body: Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
          );
        }
        return SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Profile Header with Switch Child
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildProfileHeader(),
          ),
          const SizedBox(height: 28),
          // Quick Actions Grid Tiles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildQuickActions(context),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
      },
    );
  }

  Widget _buildProfileHeader() {
    final currentChild = MyChildScreen.childrenData[MyChildScreen.selectedChildIndex.value];
    final String firstName = currentChild["firstName"];
    final String lastName = currentChild["lastName"];
    final String fullName = '$firstName $lastName';
    final String grade = '${currentChild["grade"]}-${currentChild["section"]}';
    final String initials = '${firstName[0]}${lastName[0]}';
    final Color color = MyChildScreen.selectedChildIndex.value == 0 ? const Color(0xFF6C4CF1) : const Color(0xFF0EA5E9);
    final Color bgColor = MyChildScreen.selectedChildIndex.value == 0 ? const Color(0xFFF3F0FF) : const Color(0xFFE0F2FE);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: color,
                  fontSize: 19,
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
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Parent • $grade',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7A7A9D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showSwitchChildModal(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.arrowLeftRight,
                    size: 14,
                    color: Color(0xFF6C4CF1),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Switch',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSwitchChildModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Switch Child', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(LucideIcons.x, size: 20, color: Color(0xFF1E1E2D)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...List.generate(MyChildScreen.childrenData.length, (index) {
              final child = MyChildScreen.childrenData[index];
              final isSelected = index == MyChildScreen.selectedChildIndex.value;
              final Color color = index == 0 ? const Color(0xFF6C4CF1) : const Color(0xFF0EA5E9);
              final Color bgColor = index == 0 ? const Color(0xFFF3F0FF) : const Color(0xFFE0F2FE);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildChildSelectOption(
                  name: '${child["firstName"]} ${child["lastName"]}', 
                  grade: '${child["grade"]} - ${child["section"]}', 
                  initials: '${child["firstName"][0]}${child["lastName"][0]}', 
                  color: color, 
                  bgColor: bgColor, 
                  isSelected: isSelected,
                  onTap: () {
                    MyChildScreen.selectedChildIndex.value = index;
                    Navigator.pop(context);
                  }
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildChildSelectOption({
    required String name,
    required String grade,
    required String initials,
    required Color color,
    required Color bgColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F0FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C4CF1)
                : const Color(0xFFF3EEFF),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(0xFF6C4CF1)
                          : const Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    grade,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF6C4CF1).withValues(alpha: 0.7)
                          : const Color(0xFF6C6C80),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF6C4CF1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.check,
                  color: Colors.white,
                  size: 16,
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
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _quickActions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            final item = _quickActions[index];
            return GestureDetector(
              onTap: () => _handleTap(context, item['key'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFF3EEFF),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F0FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIcon(item['icon']),
                        color: const Color(0xFF6C4CF1),
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
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
      case 'My Child':
        MainLayout.pushSubScreen(
          context,
          MyChildScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Homework':
        MainLayout.pushSubScreen(
          context,
          HomeworkScreen(onBack: () => MainLayout.popSubScreen(context)),
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
      case 'Fees & Payments':
        MainLayout.pushSubScreen(context, const FeesScreen());
        break;
      case 'Calendar':
        MainLayout.pushSubScreen(
          context,
          CalendarScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Leave Request':
        MainLayout.pushSubScreen(
          context,
          LeaveRequestScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Transport':
        MainLayout.pushSubScreen(
          context,
          TransportScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'CCTV Cameras':
        MainLayout.pushSubScreen(
          context,
          CCTVScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Resources':
        MainLayout.pushSubScreen(
          context,
          ResourcesScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Library':
        MainLayout.pushSubScreen(
          context,
          LibraryScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'Activity':
        MainLayout.pushSubScreen(
          context,
          ActivityScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
    }
  }
}
