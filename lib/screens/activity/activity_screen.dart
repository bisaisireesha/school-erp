import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class ActivityScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ActivityScreen({super.key, required this.onBack});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Academic', 'Events', 'Homework', 'Transport', 'Others'];

  final List<Map<String, dynamic>> _activityGroups = [
    {
      'date': 'Today, 20 May 2026',
      'items': [
        {
          'title': 'Homework Assigned',
          'type': 'Academic',
          'subtitle': 'Mathematics – Worksheet on Decimals\nAssigned by: Mr. Rohit Kumar',
          'time': '10:30 AM',
        },
        {
          'title': 'Parent Teacher Meeting',
          'type': 'Event',
          'subtitle': 'PTM scheduled for Aarav Sharma\nVenue: School Conference Room',
          'time': '02:00 PM',
        },
        {
          'title': 'Bus Delay',
          'type': 'Transport',
          'subtitle': 'Bus DS-07 is delayed by 15 mins\nRoute: Green Park → Dino Stars School',
          'time': '04:15 PM',
        },
        {
          'title': 'School Announcement',
          'type': 'Others',
          'subtitle': 'Annual Sports Day on 30 May 2026\nAll parents are requested to attend.',
          'time': '05:00 PM',
        },
      ]
    },
    {
      'date': 'Yesterday, 19 May 2026',
      'items': [
        {
          'title': 'Quiz Completed',
          'type': 'Academic',
          'subtitle': 'Science Quiz on Plant Life Cycle\nScore: 8/10',
          'time': '11:20 AM',
        },
        {
          'title': 'Field Trip',
          'type': 'Event',
          'subtitle': 'Trip to Nehru Science Centre\nAttended by Aarav Sharma',
          'time': '09:00 AM',
        },
      ]
    },
    {
      'date': '18 May 2026',
      'items': [
        {
          'title': 'Homework Submitted',
          'type': 'Academic',
          'subtitle': 'English – Essay on \'My Favourite Book\'\nSubmitted by Aarav Sharma',
          'time': '06:10 PM',
        },
        {
          'title': 'Bus Pickup',
          'type': 'Transport',
          'subtitle': 'Aarav was picked up from Green Park\nTime: 07:35 AM',
          'time': '07:35 AM',
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: MainLayout.globalSearchQuery,
      builder: (context, searchQuery, child) {
        final query = searchQuery.toLowerCase();
        return Container(
          color: Colors.transparent,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              _buildAppBar(),
              _buildFilterPills(),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._buildTimeline(query),
                    const SizedBox(height: 24),
                    _buildOverviewCard(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
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
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Activities & Updates', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
        ],
      ),
    );
  }

  Widget _buildFilterPills() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      width: double.infinity,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _filters.map((filter) {
          final isSelected = filter == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF3F0FF) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE8E3F8),
                  width: 1.5,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFF4A4A68),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildTimeline(String query) {
    List<Widget> children = [];
    
    // Simple filter logic
    var filteredGroups = _activityGroups.map((group) {
      return {
        'date': group['date'],
        'items': group['items'].where((item) {
          final matchesQuery = query.isEmpty || 
                               item['title'].toString().toLowerCase().contains(query) || 
                               item['subtitle'].toString().toLowerCase().contains(query);
          final matchesFilter = _selectedFilter == 'All' || 
                                item['type'] == _selectedFilter || 
                                (_selectedFilter == 'Homework' && item['title'].toString().contains('Homework'));
          return matchesQuery && matchesFilter;
        }).toList()
      };
    }).where((group) => (group['items'] as List).isNotEmpty).toList();

    for (var group in filteredGroups) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 8),
          child: Text(
            group['date'] as String,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
          ),
        ),
      );

      var items = group['items'] as List<dynamic>;
      children.add(
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return Wrap(
                spacing: 16,
                runSpacing: 0,
                children: items.map((item) {
                  return SizedBox(
                    width: (constraints.maxWidth - 16) / 2,
                    child: _buildTimelineCard(item),
                  );
                }).toList(),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.map((item) {
                  return _buildTimelineCard(item);
                }).toList(),
              );
            }
          },
        ),
      );
    }

    if (children.isEmpty) {
      children.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: Text('No activities found for this filter.', style: TextStyle(color: Colors.grey, fontSize: 16))),
        ),
      );
    }

    return children;
  }

  Widget _buildTimelineCard(Map<String, dynamic> item) {
    Color themeColor;
    Color bgColor;
    IconData icon;

    switch (item['type']) {
      case 'Academic':
      case 'Homework':
        themeColor = const Color(0xFF6C4CF1);
        bgColor = const Color(0xFFF3F0FF);
        icon = item['title'].contains('Quiz') ? Icons.assignment_turned_in_outlined : (item['title'].contains('Submitted') ? Icons.edit_outlined : Icons.description_outlined);
        break;
      case 'Event':
        themeColor = const Color(0xFF4CAF50);
        bgColor = const Color(0xFFE8F5E9);
        icon = Icons.event_note_rounded;
        break;
      case 'Transport':
        themeColor = const Color(0xFFFF9800);
        bgColor = const Color(0xFFFFF3E0);
        icon = Icons.directions_bus_rounded;
        break;
      default:
        themeColor = const Color(0xFF2196F3);
        bgColor = const Color(0xFFE3F2FD);
        icon = Icons.campaign_outlined;
    }

    return GestureDetector(
      onTap: () {
        // Do nothing, as requested by user
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dot Indicator
            Container(
              margin: const EdgeInsets.only(top: 18),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            
            // Circular Icon Background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: themeColor, size: 24),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    item['title'],
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item['type'],
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: themeColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item['time'],
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['subtitle'],
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Icon(LucideIcons.chevronRight, color: Color(0xFFD1D1D6), size: 20),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E3F8), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.calendarDays, color: Color(0xFF6C4CF1), size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('This Week Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 4),
                Text('8 Activities', style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('4 Academic • 2 Events • 1 Transport • 1 Others', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Do nothing, as requested by user
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8E3F8), width: 1.5),
              ),
              child: Row(
                children: const [
                  Text('View Calendar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                  SizedBox(width: 6),
                  Icon(LucideIcons.calendar, color: Color(0xFF6C4CF1), size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
