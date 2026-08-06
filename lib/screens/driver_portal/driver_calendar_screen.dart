import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DriverCalendarScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const DriverCalendarScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<DriverCalendarScreen> createState() => _DriverCalendarScreenState();
}

class _DriverCalendarScreenState extends State<DriverCalendarScreen> {
  int _selectedCategory = 0; // 0: All, 1: Shift Duties, 2: Holidays, 3: Route Schedule

  final List<Map<String, dynamic>> _events = [
    {
      "title": "Morning & Evening Pickup Shift",
      "date": "Today, 31 July 2026",
      "time": "07:00 AM - 08:30 AM & 03:00 PM - 04:30 PM",
      "category": "Shift Duties",
      "route": "Route 1 - Green Glen",
      "bus": "BUS-01",
      "type": "Shift",
    },
    {
      "title": "Independence Day Holiday",
      "date": "15 August 2026",
      "time": "Full Day",
      "category": "Holidays",
      "route": "-",
      "bus": "-",
      "type": "Holiday",
    },
    {
      "title": "Special Field Trip Assignment",
      "date": "08 August 2026",
      "time": "09:00 AM - 02:00 PM",
      "category": "Shift Duties",
      "route": "Science Museum Special Route",
      "bus": "BUS-01",
      "type": "Shift",
    },
    {
      "title": "Quarterly Vehicle Maintenance Inspection",
      "date": "12 August 2026",
      "time": "10:00 AM - 12:00 PM",
      "category": "Route Schedule",
      "route": "Depot Workshop",
      "bus": "BUS-01",
      "type": "Maintenance",
    },
    {
      "title": "Raksha Bandhan Holiday",
      "date": "28 August 2026",
      "time": "Full Day",
      "category": "Holidays",
      "route": "-",
      "bus": "-",
      "type": "Holiday",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _events.where((e) {
      if (_selectedCategory == 1) return e['category'] == 'Shift Duties';
      if (_selectedCategory == 2) return e['category'] == 'Holidays';
      if (_selectedCategory == 3) return e['category'] == 'Route Schedule';
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        bottom: 90,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.onBack != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  AppBackButton(onPressed: widget.onBack!),
                  const SizedBox(width: 8),
                  const Text('Calendar & Shift Duties', style: AppTypography.cardTitle),
                ],
              ),
            ),

          // Mini Month Calendar Strip Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'July - August 2026 Schedule',
                      style: AppTypography.cardTitle,
                    ),
                    Icon(Icons.calendar_month_rounded, color: Color(0xFF6C4CF1)),
                  ],
                ),
                const SizedBox(height: 14),
                // Days Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDayCell('Mon', '27', false),
                    _buildDayCell('Tue', '28', false),
                    _buildDayCell('Wed', '29', false),
                    _buildDayCell('Thu', '30', false),
                    _buildDayCell('Fri', '31', true), // Today
                    _buildDayCell('Sat', '01', false),
                    _buildDayCell('Sun', '02', false),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All Events', 0),
                _buildFilterChip('Assigned Duties', 1),
                _buildFilterChip('Holidays', 2),
                _buildFilterChip('Route Schedule', 3),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Event Cards List
          ...List.generate(filtered.length, (index) {
            final event = filtered[index];
            final isHoliday = event['type'] == 'Holiday';

            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.cardSpacing),
              padding: const EdgeInsets.all(AppSpacing.internalCardPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: AppShadows.card,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isHoliday
                          ? const Color(0xFFFFF3E0)
                          : const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isHoliday ? Icons.beach_access_rounded : Icons.directions_bus_rounded,
                      color: isHoliday ? const Color(0xFFFF9800) : const Color(0xFF6C4CF1),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title'],
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${event['date']} • ${event['time']}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF7A7A9D),
                          ),
                        ),
                        if (event['route'] != '-') ...[
                          const SizedBox(height: 4),
                          Text(
                            'Route: ${event['route']} (${event['bus']})',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6C4CF1),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDayCell(String dayName, String dayNum, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF9F8FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            dayName,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF7A7A9D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dayNum,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedCategory == index;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color(0xFF6C4CF1),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
          fontWeight: FontWeight.bold,
          fontSize: 11.5,
        ),
        onSelected: (val) {
          if (val) setState(() => _selectedCategory = index);
        },
      ),
    );
  }
}
