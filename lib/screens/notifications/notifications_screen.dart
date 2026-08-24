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
  final String role;
  final VoidCallback? onMarkAllRead;

  const NotificationsScreen({
    super.key,
    required this.onBack,
    this.role = 'teacher',
    this.onMarkAllRead,
  });

  static void show(BuildContext context, String role, VoidCallback? onMarkAllRead) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 80,
            left: 64, // More space on left
            right: 16, // Less space on right
          ),
          child: Material(
            type: MaterialType.transparency,
            child: NotificationsScreen(
              role: role,
              onBack: () => Navigator.pop(context),
              onMarkAllRead: onMarkAllRead,
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Fee Receipt Generated',
      'message': 'Term 2 payment of ₹12,500 processed successfully.',
      'time': '20m ago',
      'icon': LucideIcons.wallet,
      'iconColor': const Color(0xFF22C55E),
      'iconBg': const Color(0xFFDCFCE7),
      'isRead': false,
      'route': 'fees',
    },
    {
      'title': 'Attendance Alert',
      'message': 'Arjun was marked absent for Period 1 today.',
      'time': '4h ago',
      'icon': LucideIcons.userX,
      'iconColor': const Color(0xFFE11D48),
      'iconBg': const Color(0xFFFFE4E6),
      'isRead': false,
      'route': 'attendance',
    },
    {
      'title': 'Exams Results Published',
      'message': 'Mid-term examination results are now available.',
      'time': '1d ago',
      'icon': LucideIcons.clipboardCheck,
      'iconColor': const Color(0xFF6C4CF1),
      'iconBg': const Color(0xFFF3EEFF),
      'isRead': false,
      'route': 'exams',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    // Hardcoded mock data as per user instructions
  }

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n['isRead'] = true;
      }
    });
    if (widget.onMarkAllRead != null) {
      widget.onMarkAllRead!();
    }
  }

  void _navigateToScreen(String route) {
    // Capture a stable context before this widget is popped
    final stableContext = MainLayout.currentState!.context;

    void handleBack() {
      MainLayout.popSubScreen(stableContext);
      // Re-open notifications screen when they go back using the stable context
      NotificationsScreen.show(stableContext, widget.role, widget.onMarkAllRead);
    }

    switch (route) {
      case 'fees':
        MainLayout.pushSubScreen(stableContext, FeesScreen(onBack: handleBack));
        break;
      case 'exams':
        MainLayout.pushSubScreen(
          stableContext,
          ExamsScreen(onBack: handleBack),
        );
        break;
      case 'attendance':
        MainLayout.pushSubScreen(
          stableContext,
          AttendanceScreen(onBack: handleBack),
        );
        break;
      case 'timetable':
        MainLayout.pushSubScreen(
          stableContext,
          TimetableScreen(onBack: handleBack),
        );
        break;
      case 'transport':
        MainLayout.pushSubScreen(
          stableContext,
          TransportScreen(onBack: handleBack),
        );
        break;
      case 'library':
        MainLayout.pushSubScreen(
          stableContext,
          LibraryScreen(
            onBack: handleBack,
            isStudentPortal: true,
          ),
        );
        break;
      case 'leave':
        MainLayout.pushSubScreen(
          stableContext,
          LeaveRequestScreen(onBack: handleBack),
        );
        break;
      case 'calendar':
        MainLayout.pushSubScreen(
          stableContext,
          CalendarScreen(onBack: handleBack),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Triangular pointer
          Positioned(
            top: -6,
            right: 68, // Aligned with the bell icon based on 16px right margin
            child: Transform.rotate(
              angle: 3.14159 / 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(-2, -2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Main Popover Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.bellRing,
                  color: Color(0xFF6C4CF1),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _markAllRead,
                  child: const Text(
                    'Mark all read',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          // Notifications List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _buildNotificationItem(_notifications[index]);
              },
            ),
          ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;

    return GestureDetector(
      onTap: () {
        setState(() {
          notification['isRead'] = true;
        });
        widget.onBack();
        final route = notification['route'] as String?;
        if (route != null) {
          _navigateToScreen(route);
        }
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: notification['iconBg'],
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification['icon'],
                color: notification['iconColor'],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E1E2D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification['time'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      if (!isRead) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444), // Red dot for unread
                            shape: BoxShape.circle,
                          ),
                        ),
                      ] else ...[
                        // Invisible placeholder to keep alignment
                        const SizedBox(width: 12),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
