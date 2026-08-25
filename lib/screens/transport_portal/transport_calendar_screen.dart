import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../calendar/year_view_screen.dart';
import '../calendar/event_details_screen.dart';

class TransportCalendarScreen extends StatefulWidget {
  final VoidCallback onBack;

  const TransportCalendarScreen({super.key, required this.onBack});

  @override
  State<TransportCalendarScreen> createState() => _TransportCalendarScreenState();
}

class _TransportCalendarScreenState extends State<TransportCalendarScreen> {
  late ScrollController _scrollController;
  int _visibleMonth = DateTime.now().month;
  int _visibleYear = DateTime.now().year;
  bool _isFirstLoad = true;

  // Mock Events
  final Map<String, List<Map<String, dynamic>>> _mockEvents = {};

  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> _monthShortNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _initializeEvents();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      _jumpToMonth(_visibleMonth);
    }
  }

  void _jumpToMonth(int month) {
    // A rough calculation to jump to the month.
    // Since months have different heights, we jump roughly and users can scroll the rest.
    // We can use a combination of screen width to estimate.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        double screenWidth = MediaQuery.of(context).size.width;
        double cellWidth = screenWidth / 7;
        double rowHeight = cellWidth / 0.6;
        // A month has roughly 5 rows + heading space
        double monthHeight = (rowHeight * 5) + 60;
        _scrollController.jumpTo((month - 1) * monthHeight);
      }
    });
  }

  void _onMonthSelected(DateTime date) {
    setState(() {
      _visibleYear = date.year;
      _visibleMonth = date.month;
    });
    _jumpToMonth(_visibleMonth);
  }

  void _initializeEvents() {
    final now = DateTime.now();
    for (int month = 1; month <= 12; month++) {
      String m = month.toString().padLeft(2, '0');
      _mockEvents['${now.year}-$m-04'] = [
        {
          'title': 'Fleet Maintenance',
          'type': 'Maintenance',
          'time': '9:00 AM',
          'location': 'Depot',
        },
      ];
      _mockEvents['${now.year}-$m-07'] = [
        {
          'title': 'Driver Training',
          'type': 'Training',
          'time': '8:00 AM',
          'location': 'Training Room',
        },
      ];
      _mockEvents['${now.year}-$m-10'] = [
        {
          'title': 'Road Tax Deadline',
          'type': 'Deadline',
          'time': '10:00 AM',
          'location': 'RTO Office',
        },
      ];
      _mockEvents['${now.year}-$m-12'] = [
        {
          'title': 'Transport Audit',
          'type': 'Audit',
          'time': '4:00 PM',
          'location': 'Main Office',
        },
      ];
      _mockEvents['${now.year}-$m-15'] = [
        {
          'title': 'Vehicle Inspection',
          'type': 'Maintenance',
          'time': '9:00 AM',
          'location': 'Depot',
        },
      ];
      _mockEvents['${now.year}-$m-18'] = [
        {
          'title': 'Staff Meeting',
          'type': 'Meeting',
          'time': '8:00 AM',
          'location': 'Conference Room',
        },
      ];
      _mockEvents['${now.year}-$m-21'] = [
        {
          'title': 'Insurance Renewal',
          'type': 'Deadline',
          'time': '9:00 AM',
          'location': 'Online',
        },
      ];
      _mockEvents['${now.year}-$m-24'] = [
        {
          'title': 'Route Planning Session',
          'type': 'Meeting',
          'time': '3:00 PM',
          'location': 'Main Office',
        },
      ];
      _mockEvents['${now.year}-$m-27'] = [
        {
          'title': 'Public Holiday',
          'type': 'Holiday',
          'time': 'All Day',
          'location': 'N/A',
        },
      ];
      _mockEvents['${now.year}-$m-30'] = [
        {
          'title': 'Monthly Report Submission',
          'type': 'Deadline',
          'time': '11:00 AM',
          'location': 'Admin Block',
        },
      ];
    }
  }

  Map<String, dynamic> _getEventStyle(String type) {
    switch (type) {
      case 'Maintenance':
        return {
          'bg': const Color(0xFFFCE7F3),
          'text': const Color(0xFF9D174D),
          'icon': Icons.build,
        };
      case 'Deadline':
        return {
          'bg': const Color(0xFFFEE2E2),
          'text': const Color(0xFF991B1B),
          'icon': Icons.warning_amber,
        };
      case 'Holiday':
        return {
          'bg': const Color(0xFFDBEAFE),
          'text': const Color(0xFF1E40AF),
          'icon': Icons.beach_access,
        };
      case 'Meeting':
        return {
          'bg': const Color(0xFFE0E7FF),
          'text': const Color(0xFF3730A3),
          'icon': Icons.groups,
        };
      case 'Training':
        return {
          'bg': const Color(0xFFD1FAE5),
          'text': const Color(0xFF065F46),
          'icon': Icons.model_training,
        };
      default:
        return {
          'bg': const Color(0xFFE0E7FF),
          'text': const Color(0xFF3730A3),
          'icon': Icons.circle,
        };
    }
  }

  bool _onScroll(ScrollNotification notification) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cellWidth = screenWidth / 7;
    double rowHeight = cellWidth / 0.6;
    double avgMonthHeight = rowHeight * 5;

    int scrolledIndex = (notification.metrics.pixels / avgMonthHeight).floor();
    if (scrolledIndex < 0) scrolledIndex = 0;
    if (scrolledIndex > 11) scrolledIndex = 11;

    int newMonth = scrolledIndex + 1;
    if (_visibleMonth != newMonth) {
      setState(() {
        _visibleMonth = newMonth;
      });
    }
    return false;
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Back button
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF3EEFF),
                      width: 1.5,
                    ),
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
                'Calendar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            
            // Dynamic Sticky Month & Year Heading
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _monthNames[_visibleMonth - 1],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YearViewScreen(
                            initialYear: _visibleYear,
                            onMonthSelected: _onMonthSelected,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      '$_visibleYear',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Fixed Weekday Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                    .map(
                      (day) => SizedBox(
                        width: 40,
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            // Scrollable 12 Months of the selected year
            Expanded(
              child: Container(
                color: Colors.white,
                child: NotificationListener<ScrollNotification>(
                  onNotification: _onScroll,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return _buildMonthGrid(_visibleYear, index + 1);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthGrid(int year, int month) {
    final fullTitle = _monthNames[month - 1];
    final shortTitle = _monthShortNames[month - 1];

    int daysInMonth = DateTime(year, month + 1, 0).day;
    int firstWeekday = DateTime(year, month, 1).weekday % 7;

    List<Widget> dayWidgets = [];

    // Empty cells for days before the 1st
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
            ),
          ),
        ),
      );
    }

    // Cells for the days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime currentDate = DateTime(year, month, day);
      String dateKey =
          '${currentDate.year}-${currentDate.month.toString().padLeft(2, "0")}-${currentDate.day.toString().padLeft(2, "0")}';
      List<dynamic> events = _mockEvents[dateKey] ?? [];

      bool isToday =
          currentDate.year == DateTime.now().year &&
          currentDate.month == DateTime.now().month &&
          currentDate.day == DateTime.now().day;

      bool isWeekend =
          currentDate.weekday == DateTime.saturday ||
          currentDate.weekday == DateTime.sunday;
      bool isFirstDayOfMonth = day == 1;
      dayWidgets.add(
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isFirstDayOfMonth)
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFF6B7280), width: 2.0),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 2.0),
                      child: Text(
                        shortTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

              if (!isFirstDayOfMonth) const SizedBox(height: 14),

              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isToday
                        ? const Color(0xFF5B5FEF)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                      color: isToday
                          ? Colors.white
                          : (isWeekend
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF1F2937)),
                    ),
                  ),
                ),
              ),
              if (events.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    itemCount: events.length,
                    itemBuilder: (context, eventIndex) {
                      final event = events[eventIndex];
                      final style = _getEventStyle(event['type']);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailsScreen(
                                event: event,
                                dateString:
                                    '$fullTitle ${currentDate.day}, ${currentDate.year}',
                                eventColor: style['bg'] as Color,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: style['bg'],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                style['icon'] as IconData,
                                size: 8,
                                color: style['text'],
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  event['title'],
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: style['text'],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    }

    int totalCells = dayWidgets.length;
    int remainingCells = (7 - (totalCells % 7)) % 7;
    for (int i = 1; i <= remainingCells; i++) {
      dayWidgets.add(
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.6,
        children: dayWidgets,
      ),
    );
  }
}
