import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';
import '../fees/fees_screen.dart';
import '../exams/exams_screen.dart';
import '../attendance/attendance_screen.dart';
import '../timetable/timetable_screen.dart';
import '../transport/transport_screen.dart';
import '../calendar/calendar_screen.dart';
import '../leave/leave_request_screen.dart';
import '../library/library_screen.dart';

class NotificationsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const NotificationsScreen({super.key, required this.onBack});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Fee Payment Due',
      'message': 'Term 2 fees of ₹12,500 are due by this Friday. Avoid late charges!',
      'time': 'Just now',
      'icon': LucideIcons.creditCard,
      'color': const Color(0xFFF59E0B),
      'bgColor': const Color(0xFFFFFBEB),
      'isRead': false,
      'route': 'fees',
    },
    {
      'title': 'Exam Results Published',
      'message': 'Mid-term results for Class 10 are now available. Check your grades.',
      'time': '5 mins ago',
      'icon': LucideIcons.fileText,
      'color': const Color(0xFF16A34A),
      'bgColor': const Color(0xFFF0FDF4),
      'isRead': false,
      'route': 'exams',
    },
    {
      'title': 'Attendance Alert',
      'message': 'Your attendance dropped below 80% this month. Please maintain regularity.',
      'time': '30 mins ago',
      'icon': LucideIcons.userCheck,
      'color': const Color(0xFFF59E0B),
      'bgColor': const Color(0xFFFFFBEB),
      'isRead': false,
      'route': 'attendance',
    },
    {
      'title': 'Timetable Updated',
      'message': 'Monday\'s timetable has been changed. Physics and Chemistry are swapped.',
      'time': '1 hour ago',
      'icon': LucideIcons.calendarClock,
      'color': const Color(0xFF6C4CF1),
      'bgColor': const Color(0xFFF3EEFF),
      'isRead': false,
      'route': 'timetable',
    },
    {
      'title': 'Bus Route Changed',
      'message': 'Route #5 will take a detour via MG Road from tomorrow due to construction.',
      'time': '2 hours ago',
      'icon': LucideIcons.bus,
      'color': const Color(0xFF6C4CF1),
      'bgColor': const Color(0xFFF3EEFF),
      'isRead': true,
      'route': 'transport',
    },
    {
      'title': 'Library Book Due',
      'message': '"The Great Gatsby" is due for return tomorrow. Renew or return to avoid fines.',
      'time': '5 hours ago',
      'icon': LucideIcons.bookOpen,
      'color': const Color(0xFF16A34A),
      'bgColor': const Color(0xFFF0FDF4),
      'isRead': true,
      'route': 'library',
    },
    {
      'title': 'Leave Request Approved',
      'message': 'Your leave request for Aug 18–19 has been approved by class teacher.',
      'time': '1 day ago',
      'icon': LucideIcons.checkCircle,
      'color': const Color(0xFF16A34A),
      'bgColor': const Color(0xFFF0FDF4),
      'isRead': true,
      'route': 'leave',
    },
    {
      'title': 'School Event Tomorrow',
      'message': 'Annual Sports Day is tomorrow. Report to the ground by 8:00 AM.',
      'time': '1 day ago',
      'icon': LucideIcons.trophy,
      'color': const Color(0xFFF59E0B),
      'bgColor': const Color(0xFFFFFBEB),
      'isRead': true,
      'route': 'calendar',
    },
  ];

  int get _unreadCount => _notifications.where((n) => n['isRead'] == false).length;

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n['isRead'] = true;
      }
    });
  }

  void _navigateToScreen(String route) {
    switch (route) {
      case 'fees':
        MainLayout.pushSubScreen(context, const FeesScreen());
        break;
      case 'exams':
        MainLayout.pushSubScreen(context, ExamsScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
      case 'attendance':
        MainLayout.pushSubScreen(context, AttendanceScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
      case 'timetable':
        MainLayout.pushSubScreen(context, TimetableScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
      case 'transport':
        MainLayout.pushSubScreen(context, TransportScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
      case 'library':
        MainLayout.pushSubScreen(context, LibraryScreen(onBack: () => MainLayout.popSubScreen(context), isStudentPortal: true));
        break;
      case 'leave':
        MainLayout.pushSubScreen(context, LeaveRequestScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
      case 'calendar':
        MainLayout.pushSubScreen(context, CalendarScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: MainLayout.globalSearchQuery,
      builder: (context, searchQuery, child) {
        final query = searchQuery.toLowerCase();
        final filtered = _notifications.where((n) {
          if (query.isEmpty) return true;
          return n['title'].toString().toLowerCase().contains(query) ||
                 n['message'].toString().toLowerCase().contains(query);
        }).toList();

        final unreadFiltered = filtered.where((n) => n['isRead'] == false).toList();
        final readFiltered = filtered.where((n) => n['isRead'] == true).toList();

        return Container(
          color: const Color(0xFFF8F9FA),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onBack,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const Spacer(),
                      if (_unreadCount > 0)
                        GestureDetector(
                          onTap: _markAllRead,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3EEFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(LucideIcons.checkCheck, size: 14, color: Color(0xFF6C4CF1)),
                                const SizedBox(width: 6),
                                Text(
                                  'Read All',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Unread section
                if (unreadFiltered.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: Text('NEW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF6C4CF1), letterSpacing: 1.2)),
                  ),
                  _buildNotificationsList(unreadFiltered),
                  const SizedBox(height: 16),
                ],

                // Read section
                if (readFiltered.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: Text('EARLIER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF9090A7), letterSpacing: 1.2)),
                  ),
                  _buildNotificationsList(readFiltered),
                ],

                // Empty state
                if (filtered.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F0FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.bellOff, color: Color(0xFF6C4CF1), size: 36),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No Notifications',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'You are all caught up! No notifications to display right now.',
                            style: TextStyle(fontSize: 13, color: Color(0xFF7A7A9D)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final isRead = notification['isRead'] == true;

        return GestureDetector(
          onTap: () {
            // Mark as read
            setState(() {
              notification['isRead'] = true;
            });
            // Navigate to related screen
            final route = notification['route'] as String?;
            if (route != null) {
              _navigateToScreen(route);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: isRead ? Colors.white : const Color(0xFFF8F3FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isRead ? const Color(0xFFF3EEFF) : const Color(0xFFD8C8FF),
                width: isRead ? 1.5 : 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isRead 
                    ? const Color(0xFFE8E3F8).withValues(alpha: 0.3)
                    : const Color(0xFFD8C8FF).withValues(alpha: 0.4),
                  blurRadius: isRead ? 8 : 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: notification['bgColor'],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(notification['icon'], color: notification['color'], size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      if (!isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          margin: const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            color: notification['color'],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      Expanded(
                                        child: Text(
                                          notification['title'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                                            color: const Color(0xFF1E1E2D),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  notification['time'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isRead ? const Color(0xFF9090A7) : notification['color'],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              notification['message'],
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: isRead ? const Color(0xFF9090A7) : const Color(0xFF4A4A68),
                                fontWeight: isRead ? FontWeight.w400 : FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(LucideIcons.arrowRight, size: 12, color: isRead ? const Color(0xFFBDBDD0) : const Color(0xFF6C4CF1)),
                                const SizedBox(width: 4),
                                Text(
                                  'Tap to view',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isRead ? const Color(0xFFBDBDD0) : const Color(0xFF6C4CF1),
                                  ),
                                ),
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
      },
    );
  }
}
