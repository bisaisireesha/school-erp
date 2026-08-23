import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';
import '../homework/homework_screen.dart';
import '../transport/transport_screen.dart';
import '../calendar/calendar_screen.dart';
import '../fees/fees_screen.dart';

class AllHighlightsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const AllHighlightsScreen({super.key, required this.onBack});

  static final List<Map<String, dynamic>> _highlights = [
    {
      'icon': Icons.menu_book_rounded,
      'iconBg': const Color(0xFFF3EEFF),
      'iconColor': const Color(0xFF6C4CF1),
      'title': '2 Assignments Due',
      'subtitle': 'Math worksheet and Science project due today',
      'tagText': 'Pending',
      'tagColor': const Color(0xFFF59E0B),
      'tagBgColor': const Color(0xFFFFFBEB),
      'time': 'Today',
      'route': 'homework',
    },
    {
      'icon': Icons.directions_bus_rounded,
      'iconBg': const Color(0xFFF0FDF4),
      'iconColor': const Color(0xFF16A34A),
      'title': 'Transport Update',
      'subtitle': 'Bus Green 12 is near your pickup point',
      'tagText': 'Live',
      'tagColor': const Color(0xFF16A34A),
      'tagBgColor': const Color(0xFFF0FDF4),
      'time': '2 mins ago',
      'route': 'transport',
    },
    {
      'icon': Icons.account_balance_wallet_rounded,
      'iconBg': const Color(0xFFFFFBEB),
      'iconColor': const Color(0xFFF59E0B),
      'title': 'Fee Reminder',
      'subtitle': 'Term 2 Tuition Fee of ₹12,500 is due this Friday',
      'tagText': 'Unpaid',
      'tagColor': const Color(0xFFF59E0B),
      'tagBgColor': const Color(0xFFFFFBEB),
      'time': 'Due in 3 days',
      'route': 'fees',
    },
    {
      'icon': Icons.event_available_rounded,
      'iconBg': const Color(0xFFF3EEFF),
      'iconColor': const Color(0xFF6C4CF1),
      'title': 'Annual Sports Day',
      'subtitle': 'Report to school ground by 8:00 AM',
      'tagText': 'Upcoming',
      'tagColor': const Color(0xFF6C4CF1),
      'tagBgColor': const Color(0xFFF3EEFF),
      'time': 'In 3 days',
      'route': 'calendar',
    },
    {
      'icon': Icons.school_rounded,
      'iconBg': const Color(0xFFF0FDF4),
      'iconColor': const Color(0xFF16A34A),
      'title': 'PTA Meeting',
      'subtitle': 'Parent-Teacher meeting at 10 AM in Auditorium',
      'tagText': 'Confirmed',
      'tagColor': const Color(0xFF16A34A),
      'tagBgColor': const Color(0xFFF0FDF4),
      'time': 'This Saturday',
      'route': 'calendar',
    },
    {
      'icon': Icons.emoji_events_rounded,
      'iconBg': const Color(0xFFFFFBEB),
      'iconColor': const Color(0xFFF59E0B),
      'title': 'Science Fair Winner',
      'subtitle': 'Your child won 2nd prize in the Science Exhibition',
      'tagText': 'Achievement',
      'tagColor': const Color(0xFFF59E0B),
      'tagBgColor': const Color(0xFFFFFBEB),
      'time': '2 days ago',
      'route': 'calendar',
    },
    {
      'icon': Icons.local_library_rounded,
      'iconBg': const Color(0xFFF3EEFF),
      'iconColor': const Color(0xFF6C4CF1),
      'title': 'Library Book Overdue',
      'subtitle': '"The Great Gatsby" was due yesterday. Fine: ₹10/day',
      'tagText': 'Overdue',
      'tagColor': const Color(0xFFF59E0B),
      'tagBgColor': const Color(0xFFFFFBEB),
      'time': '1 day ago',
      'route': 'homework',
    },
    {
      'icon': Icons.campaign_rounded,
      'iconBg': const Color(0xFFF0FDF4),
      'iconColor': const Color(0xFF16A34A),
      'title': 'Holiday Announced',
      'subtitle': 'School closed on Aug 25 for Independence Day celebration',
      'tagText': 'Notice',
      'tagColor': const Color(0xFF6C4CF1),
      'tagBgColor': const Color(0xFFF3EEFF),
      'time': 'Aug 25',
      'route': 'calendar',
    },
  ];

  void _navigateToScreen(BuildContext context, String route) {
    switch (route) {
      case 'homework':
        MainLayout.pushSubScreen(
          context,
          HomeworkScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'transport':
        MainLayout.pushSubScreen(
          context,
          TransportScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'fees':
        MainLayout.pushSubScreen(
          context,
          FeesScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
      case 'calendar':
        MainLayout.pushSubScreen(
          context,
          CalendarScreen(onBack: () => MainLayout.popSubScreen(context)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onBack,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF3EEFF),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFE8E3F8,
                              ).withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF1E1E2D),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'All Highlights',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.sparkles,
                        size: 20,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ],
                ),
              ),

              // Highlights list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                itemCount: _highlights.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = _highlights[index];
                  return GestureDetector(
                    onTap: () => _navigateToScreen(context, item['route']),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFF3EEFF),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFE8E3F8,
                            ).withValues(alpha: 0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: item['iconBg'],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              item['icon'],
                              color: item['iconColor'],
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['title'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E1E2D),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['time'],
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF9090A7),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['subtitle'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6C6C80),
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: item['tagBgColor'],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: item['tagColor'],
                                            size: 8,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['tagText'],
                                            style: TextStyle(
                                              color: item['tagColor'],
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      LucideIcons.chevronRight,
                                      size: 16,
                                      color: Color(0xFFBDBDD0),
                                    ),
                                  ],
                                ),
                              ],
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
