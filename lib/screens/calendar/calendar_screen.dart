import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CalendarScreen extends StatefulWidget {
  final VoidCallback onBack;

  const CalendarScreen({super.key, required this.onBack});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  // Mock data mapping date strings to list of events.
  final Map<String, List<Map<String, dynamic>>> _mockEvents = {
    // Today's events
    _formatDateKey(DateTime.now()): [
      {
        'title': 'Science Fair Exhibition',
        'time': '10:00 AM - 02:00 PM',
        'type': 'Event',
        'description': 'Annual science fair showcasing student projects in the main auditorium.',
      },
    ],
    // Tomorrow's events
    _formatDateKey(DateTime.now().add(const Duration(days: 1))): [
      {
        'title': 'Mathematics Mid-Term',
        'time': '09:00 AM - 12:00 PM',
        'type': 'Exam',
        'description': 'Mid-term examination for Grade 10 Mathematics.',
      }
    ],
    // A Festival
    _formatDateKey(DateTime.now().add(const Duration(days: 5))): [
      {
        'title': 'Diwali Celebration',
        'time': 'All Day',
        'type': 'Festival',
        'description': 'School cultural program and early dismissal for Diwali festival.',
      }
    ],
    // Next week's event
    _formatDateKey(DateTime.now().add(const Duration(days: 7))): [
      {
        'title': 'National Holiday',
        'time': 'All Day',
        'type': 'Holiday',
        'description': 'School remains closed on account of Independence Day.',
      }
    ]
  };

  static String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  List<Map<String, dynamic>> _getEventsToDisplay() {
    if (_selectedDate != null) {
      return _mockEvents[_formatDateKey(_selectedDate!)] ?? [];
    } else {
      List<Map<String, dynamic>> allEvents = [];
      String prefix = "${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}";
      _mockEvents.forEach((dateStr, events) {
        if (dateStr.startsWith(prefix)) {
          for (var event in events) {
            var eventCopy = Map<String, dynamic>.from(event);
            eventCopy['dateStr'] = dateStr;
            allEvents.add(eventCopy);
          }
        }
      });
      allEvents.sort((a, b) => (a['dateStr'] as String).compareTo(b['dateStr'] as String));
      return allEvents;
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentEvents = _getEventsToDisplay();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
                    const Text('School Calendar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Dynamic Content Area
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom Embedded Calendar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF64748B).withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Month Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: _previousMonth,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(LucideIcons.chevronLeft, size: 20, color: Color(0xFF1E1E2D)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _selectedDate == null ? const Color(0xFF6C4CF1).withValues(alpha: 0.1) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${_getFullMonthName(_currentMonth.month)} ${_currentMonth.year}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _selectedDate == null ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D)),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _nextMonth,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(LucideIcons.chevronRight, size: 20, color: Color(0xFF1E1E2D)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Weekdays Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) => 
                              SizedBox(
                                width: 32,
                                child: Text(
                                  day,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF9E9E9E)),
                                ),
                              )
                            ).toList(),
                          ),
                          const SizedBox(height: 12),
                          
                          // Grid of Days
                          _buildCalendarGrid(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bottom Section
                    _buildBottomSection(currentEvents),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    int daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    int firstWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday; // 1 (Mon) to 7 (Sun)
    
    // Adjust to make Sunday the first day of the week (0 to 6)
    int offset = firstWeekday % 7;
    
    List<Widget> dayWidgets = [];
    
    // Previous month days
    int prevMonthDays = DateTime(_currentMonth.year, _currentMonth.month, 0).day;
    for (int i = offset - 1; i >= 0; i--) {
      int day = prevMonthDays - i;
      dayWidgets.add(
        Container(
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.transparent, // No background or border for prev month
          ),
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8),
          child: Text(
            day.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFFD1D5DB), // Light grey
            ),
          ),
        ),
      );
    }
    
    // Day cells
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime currentDate = DateTime(_currentMonth.year, _currentMonth.month, day);
      bool isSelected = _selectedDate != null && _formatDateKey(currentDate) == _formatDateKey(_selectedDate!);
      bool isSunday = currentDate.weekday == DateTime.sunday;
      List<Map<String, dynamic>> eventsOnDay = _mockEvents[_formatDateKey(currentDate)] ?? [];
      
      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = currentDate;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF1F5F9), 
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to top left
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? const Color(0xFF6C4CF1) : (isSunday ? const Color(0xFFE11D48) : const Color(0xFF1E1E2D)),
                  ),
                ),
                if (eventsOnDay.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getEventColor(eventsOnDay.first['type']), // Solid color
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getEventShortName(eventsOnDay.first['title']),
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    
    // Next month empty cells to fill the grid
    int totalCells = dayWidgets.length;
    int remainingCells = (7 - (totalCells % 7)) % 7;
    for (int i = 1; i <= remainingCells; i++) {
      dayWidgets.add(
        Container(
          margin: const EdgeInsets.all(4),
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8),
          child: Text(
            i.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFFD1D5DB),
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.75, // Taller cells to match image proportions
      children: dayWidgets,
    );
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'Exam': return const Color(0xFFE11D48);
      case 'Holiday': return const Color(0xFF16A34A);
      case 'Festival': return const Color(0xFFD946EF); // Fuchsia for festivals
      case 'Meeting': return const Color(0xFF0284C7);
      case 'Event':
      default: return const Color(0xFF6C4CF1);
    }
  }

  String _getEventShortName(String title) {
    if (title.contains('Science')) return 'Science';
    if (title.contains('Math')) return 'Exam';
    if (title.contains('Diwali')) return 'Diwali';
    if (title.contains('Holiday')) return 'Holiday';
    if (title.contains('PTA')) return 'Meeting';
    return 'Event';
  }

  String _formatDisplayDate(String dateStr) {
    try {
      DateTime dt = DateTime.parse(dateStr);
      return '${dt.day} ${_getShortMonthName(dt.month)}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.calendarX2, color: Color(0xFF9E9E9E), size: 32),
          ),
          const SizedBox(height: 16),
          const Text('No events scheduled', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          const Text('You have a free day! Enjoy your time.', style: TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
        ],
      ),
    );
  }

  Widget _buildResponsiveEventList(List<dynamic> events, Widget Function(dynamic) buildItem) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Wrap(
            spacing: 16,
            runSpacing: 0,
            children: events.map((event) {
              return SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: buildItem(event),
              );
            }).toList(),
          );
        } else {
          return Column(
            children: events.map((event) => buildItem(event)).toList(),
          );
        }
      }
    );
  }

  Widget _buildBottomSection(List<Map<String, dynamic>> currentEvents) {
    if (_selectedDate == null) {
      // Month view
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('All Month Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
              Text(_getFullMonthName(_currentMonth.month), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
            ],
          ),
          const SizedBox(height: 16),
          if (currentEvents.isEmpty)
            _buildEmptyState()
          else
            _buildResponsiveEventList(currentEvents, (e) => _buildNewEventCard(e)),
        ],
      );
    } else {
      // Day view
      final upcomingEvents = _getUpcomingEvents();
      const weekdays = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];
      String weekdayStr = weekdays[_selectedDate!.weekday - 1];
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(weekdayStr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80))),
          const SizedBox(height: 4),
          Text(
            '${_selectedDate!.day} ${_getFullMonthName(_selectedDate!.month)} ${_selectedDate!.year}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: 4),
          Text(
            '${currentEvents.length} items',
            style: const TextStyle(fontSize: 14, color: Color(0xFF6C6C80)),
          ),
          const SizedBox(height: 24),
          
          if (currentEvents.isEmpty)
            _buildEmptyState()
          else
            _buildResponsiveEventList(currentEvents, (e) => _buildNewEventCard(e)),
            
          if (upcomingEvents.isNotEmpty) ...[
            const SizedBox(height: 32),
            const Text('UPCOMING', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80), letterSpacing: 1.2)),
            const SizedBox(height: 16),
            _buildResponsiveEventList(upcomingEvents, (e) => _buildUpcomingRow(e)),
          ]
        ],
      );
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'Exam': return LucideIcons.clock;
      case 'Holiday': return LucideIcons.palmtree;
      case 'Festival': return LucideIcons.partyPopper;
      case 'Meeting': return LucideIcons.users;
      case 'Event':
      default: return LucideIcons.calendar;
    }
  }

  List<Map<String, dynamic>> _getUpcomingEvents() {
    List<Map<String, dynamic>> upcoming = [];
    if (_selectedDate == null) return upcoming;
    
    _mockEvents.forEach((dateStr, events) {
      try {
        DateTime dt = DateTime.parse(dateStr);
        DateTime dtDate = DateTime(dt.year, dt.month, dt.day);
        DateTime selDate = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
        
        if (dtDate.isAfter(selDate)) {
          for (var event in events) {
            var eventCopy = Map<String, dynamic>.from(event);
            eventCopy['dateStr'] = dateStr;
            upcoming.add(eventCopy);
          }
        }
      } catch (e) {
        // ignore
      }
    });
    
    upcoming.sort((a, b) => (a['dateStr'] as String).compareTo(b['dateStr'] as String));
    return upcoming.take(5).toList();
  }

  Widget _buildUpcomingRow(Map<String, dynamic> event) {
    Color typeColor = _getEventColor(event['type']);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: typeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 60,
            child: Text(
              _formatDisplayDate(event['dateStr']),
              style: const TextStyle(fontSize: 14, color: Color(0xFF6C6C80)),
            ),
          ),
          Expanded(
            child: Text(
              event['title'],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewEventCard(Map<String, dynamic> event) {
    Color typeColor = _getEventColor(event['type']);
    Color lightColor = typeColor.withValues(alpha: 0.1);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getEventIcon(event['type']), color: typeColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Text(
                      event['title'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: lightColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (event['type'] as String).toUpperCase(),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: typeColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    if (event.containsKey('dateStr') && _selectedDate == null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF6C6C80)),
                          const SizedBox(width: 4),
                          Text(_formatDisplayDate(event['dateStr']), style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
                        ],
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.clock, size: 14, color: Color(0xFF6C6C80)),
                        const SizedBox(width: 4),
                        Text(event['time'], style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.mapPin, size: 14, color: Color(0xFF6C6C80)),
                        const SizedBox(width: 4),
                        Text(event['location'] ?? 'Campus', style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getShortMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _getFullMonthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }
}
