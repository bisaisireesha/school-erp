import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class NotificationsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const NotificationsScreen({super.key, required this.onBack});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'School Holiday',
      'message': 'Tomorrow is a holiday due to heavy rain forecast.',
      'time': 'Just now',
      'icon': LucideIcons.cloudRain,
      'color': const Color(0xFF0EA5E9),
      'bgColor': const Color(0xFFE0F2FE),
      'isRead': false,
    },
    {
      'title': 'Fee Reminder',
      'message': 'Term 2 fees are due by the end of this week.',
      'time': '10 mins ago',
      'icon': LucideIcons.creditCard,
      'color': const Color(0xFFF59E0B),
      'bgColor': const Color(0xFFFFFBEB),
      'isRead': false,
    },
    {
      'title': 'Exam Results',
      'message': 'Mid-term results for Class 10 have been published.',
      'time': '1 day ago',
      'icon': LucideIcons.fileText,
      'color': const Color(0xFF16A34A),
      'bgColor': const Color(0xFFF0FDF4),
      'isRead': true,
    },
    {
      'title': 'PTA Meeting',
      'message': 'Parent-Teacher meeting scheduled for this Saturday at 10 AM.',
      'time': '2 days ago',
      'icon': LucideIcons.users,
      'color': const Color(0xFF6C4CF1),
      'bgColor': const Color(0xFFF3EEFF),
      'isRead': true,
    },
  ];

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

        return Container(
          color: const Color(0xFFF8F9FA),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildNotificationsList(filtered),
                const SizedBox(height: 120),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return Center(
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'You are all caught up! No notifications to display right now.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7A7A9D),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              notification['isRead'] = true;
            });
          },
          child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
                blurRadius: 10,
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(notification['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 8),
                          Text(notification['time'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF9090A7))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification['message'],
                        style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF6C6C80), fontWeight: FontWeight.w500),
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

  // ignore: unused_element
  void _showRealTimeNotification() {
    setState(() {
      _notifications.insert(0, {
        'title': 'New Announcement',
        'message': 'The school bus timings have been updated for tomorrow.',
        'time': 'Just now',
        'icon': LucideIcons.bus,
        'color': const Color(0xFFE11D48),
        'bgColor': const Color(0xFFFFF1F2),
        'isRead': false,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF1F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.bus, color: Color(0xFFE11D48), size: 20),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Announcement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  SizedBox(height: 4),
                  Text('The school bus timings have been updated for tomorrow.', style: TextStyle(fontSize: 14, color: Color(0xFF4A4A68))),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
