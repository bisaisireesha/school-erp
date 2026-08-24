import 'package:flutter/material.dart';
import '../../widgets/date_range_picker_bottom_sheet.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

class AttendanceScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AttendanceScreen({super.key, required this.onBack});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Mock Data
  final Map<String, dynamic> studentInfo = {
    'name': 'Akshara',
    'class': 'Class 10 - A',
    'rollNo': '1042',
    'imageUrl': 'https://i.pravatar.cc/150?img=5',
    'status': 'Present Today',
    'teacher': 'Sarah Connor',
  };

  final Map<String, dynamic> kpiStats = {
    'present': 132,
    'absent': 8,
    'late': 5,
    'holiday': 12,
  };

  List<Map<String, dynamic>> _getRecordsForRange() {
    DateTime start = _selectedListRange?.start ?? DateTime(DateTime.now().year, DateTime.now().month, 1);
    DateTime end = _selectedListRange?.end ?? DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    
    List<Map<String, dynamic>> records = [];
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    // Generate records from start to end
    DateTime current = start;
    while (!current.isAfter(end)) {
      int statusInt = _attendanceStatus[current.day] ?? (current.day % 7 == 0 ? 4 : (current.day % 6 == 0 ? 2 : 1));
      
      String statusStr = 'Present';
      String inTime = '08:15 AM';
      String outTime = '03:30 PM';
      
      if (statusInt == 2) {
        statusStr = 'Absent';
        inTime = '--:--';
        outTime = '--:--';
      } else if (statusInt == 3) {
        statusStr = 'Late';
        inTime = '08:45 AM';
      } else if (statusInt == 4) {
        statusStr = 'Holiday';
        inTime = '--:--';
        outTime = '--:--';
      }
      
      String dayStr = weekdays[current.weekday - 1];
      
      records.add({
        "date": "${current.day.toString().padLeft(2, '0')} ${months[current.month - 1]} ${current.year}",
        "day": dayStr,
        "status": statusStr,
        "in": inTime,
        "out": outTime,
      });
      
      current = current.add(const Duration(days: 1));
    }
    
    return records.reversed.toList(); // Newest first
  }

  DateTimeRange? _selectedListRange;
  String _selectedQuickOption = 'This Month';
  DateTime _currentDate = DateTime.now();
  DateTime? _selectedDate;
  bool _isCalendarView = true;
  
  final GlobalKey _dropdownKey = GlobalKey();
  String _selectedAcademicYear = '2025 - 2026';
  final List<String> _academicYears = List.generate(5, (index) {
    int startYear = 2025 - index;
    return '$startYear - ${startYear + 1}';
  });

  // Mock attendance status for calendar
  // 1: present, 2: absent, 3: late, 4: holiday
  final Map<int, int> _attendanceStatus = {
    28: 1,
    27: 3,
    25: 4,
    24: 1,
    23: 2,
    22: 1,
    21: 1,
    20: 1,
    17: 1,
    16: 1,
    15: 1,
    14: 1,
    12: 4,
    10: 1,
    9: 1,
    8: 2,
    7: 1,
    6: 1,
    3: 1,
    2: 1,
    1: 3,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildStudentCard(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildKPICards(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Attendance Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EEFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
   if (!mounted) return;
   setState(() => _isCalendarView = true);
 },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _isCalendarView
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: _isCalendarView
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              LucideIcons.calendarDays,
                              size: 16,
                              color: _isCalendarView
                                  ? const Color(0xFF6C4CF1)
                                  : const Color(0xFF6C6C80),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
   if (!mounted) return;
   setState(() => _isCalendarView = false);
 },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: !_isCalendarView
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: !_isCalendarView
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              LucideIcons.list,
                              size: 16,
                              color: !_isCalendarView
                                  ? const Color(0xFF6C4CF1)
                                  : const Color(0xFF6C6C80),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_isCalendarView) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildCalendar(),
              ),
              if (_selectedDate != null &&
                  _selectedDate!.month == _currentDate.month &&
                  _selectedDate!.year == _currentDate.year) ...[
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _buildSelectedDateCard(),
                ),
              ],
            ] else
              _buildRecentRecords(),
            const SizedBox(height: 120), // Bottom padding for navbar
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Back button and title
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
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
                'Attendance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ],
          ),
          GestureDetector(
            key: _dropdownKey,
            onTap: _showCustomYearDropdown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.calendar,
                    size: 14,
                    color: Color(0xFF6C4CF1),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedAcademicYear,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: Color(0xFF6C4CF1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard() {
    int todayStatus = _attendanceStatus[DateTime.now().day] ?? 1;
    String todayStatusText = 'Present Today';
    Color todayStatusBgColor = const Color(0xFFE8F8ED);
    Color todayStatusTextColor = const Color(0xFF16A34A);

    if (todayStatus == 2) {
      todayStatusText = 'Absent Today';
      todayStatusBgColor = const Color(0xFFFFF0F0);
      todayStatusTextColor = const Color(0xFFE11D48);
    } else if (todayStatus == 3) {
      todayStatusText = 'Late Today';
      todayStatusBgColor = const Color(0xFFFFF4E3);
      todayStatusTextColor = const Color(0xFFF59E0B);
    } else if (todayStatus == 4) {
      todayStatusText = 'Holiday Today';
      todayStatusBgColor = const Color(0xFFEDF8FC);
      todayStatusTextColor = const Color(0xFF0284C7);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(studentInfo['imageUrl']),
            backgroundColor: const Color(0xFFF3EEFF),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentInfo['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${studentInfo['class']} | Roll No: ${studentInfo['rollNo']}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Teacher: ${studentInfo['teacher'] ?? 'Sarah Connor'}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6C6C80),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: todayStatusBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              todayStatusText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: todayStatusTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getOrdinal(int number) {
    if (number >= 11 && number <= 13) return '${number}th';
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  Widget _buildKPICards() {
    final months = [
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
    
    DateTime dateToShow = _currentDate;
    if (!_isCalendarView && _selectedListRange != null) {
      dateToShow = _selectedListRange!.start;
    }
    
    final monthName = months[dateToShow.month - 1];
    final year = dateToShow.year;
    final lastDay = DateTime(year, dateToShow.month + 1, 0).day;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$monthName $year',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              Text(
                '1st - ${_getOrdinal(lastDay)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              double aspectRatio = 2.2;

              if (constraints.maxWidth > 900) {
                crossAxisCount = 4;
                aspectRatio = 2.5;
              } else if (constraints.maxWidth > 500) {
                crossAxisCount = 2;
                aspectRatio = 3.0;
              }

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: aspectRatio,
                padding: EdgeInsets.zero,
                children: [
                  _buildKPIItem(
                    'Total Days',
                    lastDay.toString(),
                    LucideIcons.calendarDays,
                    const Color(0xFF0284C7),
                    const Color(0xFFEDF8FC),
                  ),
                  _buildKPIItem(
                    'Present',
                    '20',
                    LucideIcons.checkCircle2,
                    const Color(0xFF16A34A),
                    const Color(0xFFE8F8ED),
                  ),
                  _buildKPIItem(
                    'Absent',
                    '10',
                    LucideIcons.xCircle,
                    const Color(0xFFE11D48),
                    const Color(0xFFFFF0F0),
                  ),
                  _buildKPIItem(
                    'Late Days',
                    '4',
                    LucideIcons.logOut,
                    const Color(0xFFF59E0B),
                    const Color(0xFFFFF4E3),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKPIItem(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, Color bgColor, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    int daysInMonth = DateUtils.getDaysInMonth(
      _currentDate.year,
      _currentDate.month,
    );
    DateTime firstDay = DateTime(_currentDate.year, _currentDate.month, 1);
    int startingWeekday = firstDay.weekday; // 1 = Monday, 7 = Sunday
    int emptySlots = startingWeekday - 1; // 0 for Monday

    final List<String> weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final List<String> monthNames = [
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Calendar Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _showMonthPicker,
                    child: Text(
                      '${monthNames[_currentDate.month - 1]} ${_currentDate.year}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (!mounted) return;

                      setState(() {
                        _currentDate = DateTime.now();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!mounted) return;

                      setState(() {
                        _currentDate = DateTime(
                          _currentDate.year,
                          _currentDate.month - 1,
                          1,
                        );
                      });
                    },
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      if (!mounted) return;

                      setState(() {
                        _currentDate = DateTime(
                          _currentDate.year,
                          _currentDate.month + 1,
                          1,
                        );
                      });
                    },
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildLegendItem(
                const Color(0xFF16A34A),
                const Color(0xFFE8F8ED),
                'Present',
              ),
              _buildLegendItem(
                const Color(0xFFE11D48),
                const Color(0xFFFFF0F0),
                'Absent',
              ),
              _buildLegendItem(
                const Color(0xFFF59E0B),
                const Color(0xFFFFF4E3),
                'Late',
              ),
              _buildLegendItem(
                const Color(0xFF0EA5E9),
                const Color(0xFFEDF8FC),
                'Holiday',
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Weekdays
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekdays
                .map(
                  (day) => SizedBox(
                    width: 32,
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C6C80),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: emptySlots + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              if (index < emptySlots) return const SizedBox.shrink();

              int day = index - emptySlots + 1;
              int status = 0;
              bool isPastOrCurrentMonth =
                  (_currentDate.year < DateTime.now().year) ||
                  (_currentDate.year == DateTime.now().year &&
                      _currentDate.month <= DateTime.now().month);

              if (isPastOrCurrentMonth) {
                status = _attendanceStatus[day] ?? (day % 7 == 0 ? 4 : (day % 6 == 0 ? 2 : (day % 5 == 0 ? 3 : 1)));
              } else {
                if ((_attendanceStatus[day] ?? 0) == 4) {
                  status = 4;
                }
              }

              Color bgColor = Colors.transparent;
              Color textColor = const Color(0xFF1E1E2D);

              if (status == 1) {
                // Present
                bgColor = const Color(0xFFE8F8ED);
                textColor = const Color(0xFF16A34A);
              } else if (status == 2) {
                // Absent
                bgColor = const Color(0xFFFFF0F0);
                textColor = const Color(0xFFE11D48);
              } else if (status == 3) {
                // Late
                bgColor = const Color(0xFFFFF4E3);
                textColor = const Color(0xFFF59E0B);
              } else if (status == 4) {
                // Holiday
                bgColor = const Color(0xFFEDF8FC); // Tailwind Sky 200
                textColor = const Color(0xFF0284C7); // Tailwind Sky 600
              }

              // Highlight today
              bool isToday =
                  (day == DateTime.now().day &&
                  _currentDate.month == DateTime.now().month &&
                  _currentDate.year == DateTime.now().year);

              bool isSelected =
                  _selectedDate != null &&
                  _selectedDate!.day == day &&
                  _selectedDate!.month == _currentDate.month &&
                  _selectedDate!.year == _currentDate.year;

              return GestureDetector(
                onTap: () {
                  if (!mounted) return;

                  setState(() {
                    _selectedDate = DateTime(
                      _currentDate.year,
                      _currentDate.month,
                      day,
                    );
                  });

                  if (status != 0) {
                    String statusStr;
                    if (status == 1) {
                      statusStr = 'Present';
                    } else if (status == 2) {
                      statusStr = 'Absent';
                    } else if (status == 3) {
                      statusStr = 'Late';
                    } else {
                      statusStr = 'Holiday';
                    }

                    final date = DateTime(_currentDate.year, _currentDate.month, day);
                    final List<String> weekdaysFull = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
                    final List<String> shortMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                    
                    final record = {
                      'date': '${day.toString().padLeft(2, '0')} ${shortMonths[date.month - 1]} ${date.year}',
                      'day': weekdaysFull[date.weekday - 1],
                      'status': statusStr,
                      'in': '08:30 AM',
                      'out': '02:30 PM',
                    };

                    _showListRecordDetails(record);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: const Color(0xFF1E1E2D), width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: (status != 0 || isToday)
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDateCard() {
    final months = [
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
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    String dateStr =
        '${days[_selectedDate!.weekday - 1]}, ${_selectedDate!.day} ${months[_selectedDate!.month - 1]} ${_selectedDate!.year}';

    int status = 0;
    bool isPastOrCurrentMonth =
        (_selectedDate!.year < DateTime.now().year) ||
        (_selectedDate!.year == DateTime.now().year &&
            _selectedDate!.month <= DateTime.now().month);

    if (isPastOrCurrentMonth) {
      status = _attendanceStatus[_selectedDate!.day] ?? 0;
    } else {
      if ((_attendanceStatus[_selectedDate!.day] ?? 0) == 4) {
        status = 4;
      }
    }

    String statusStr = 'Present';
    Color statusColor = const Color(0xFF16A34A);
    Color statusBg = const Color(0xFFE8F8ED);
    String timeStr = 'Checked in at 08:25 AM';

    if (status == 2) {
      statusStr = 'Absent';
      statusColor = const Color(0xFFE11D48);
      statusBg = const Color(0xFFFFF0F0);
      timeStr = 'Did not attend';
    } else if (status == 3) {
      statusStr = 'Late';
      statusColor = const Color(0xFFF59E0B);
      statusBg = const Color(0xFFFFF4E3);
      timeStr = 'Checked in at 09:15 AM';
    } else if (status == 4) {
      statusStr = 'Holiday';
      statusColor = const Color(0xFF0284C7);
      statusBg = const Color(0xFFEDF8FC);
      timeStr = 'School Closed';
    } else if (status == 0) {
      statusStr = 'No Record';
      statusColor = const Color(0xFF6C6C80);
      statusBg = const Color(0xFFF3EEFF);
      timeStr = 'N/A';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusStr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF3EEFF), height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(LucideIcons.clock, size: 16, color: Color(0xFF6C6C80)),
              const SizedBox(width: 8),
              Text(
                timeStr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4A68),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRecords() {
    final currentRecords = _getRecordsForRange();
    final DateTime start = _selectedListRange?.start ?? DateTime(DateTime.now().year, DateTime.now().month, 1);
    final DateTime end = _selectedListRange?.end ?? DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    String rangeText = "${months[start.month - 1]} ${start.day} - ${months[end.month - 1]} ${end.day}, ${start.year}";

    if (currentRecords.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'No records found',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => DateRangePickerBottomSheet(
                  initialRange: _selectedListRange,
                  onRangeSelected: (range, option) {
                    if (!mounted) return;

                    setState(() {
                      _selectedListRange = range;
                      _selectedQuickOption = option;
                    });
                  },
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF1E1E2D)),
                      const SizedBox(width: 8),
                      Text(
                        rangeText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                    ],
                  ),
                  const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF1E1E2D)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _selectedQuickOption,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 16),
          // List Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: currentRecords.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Color(0xFFF3EEFF), height: 1),
              itemBuilder: (context, index) {
                return _buildRecordItemRow(currentRecords[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItemRow(Map<String, dynamic> record) {
    final String status = record['status'];
    Color statusColor;
    Color statusBgColor;
    IconData iconData;

    if (status == 'Present') {
      statusColor = const Color(0xFF16A34A);
      statusBgColor = const Color(0xFFE8F8ED);
      iconData = LucideIcons.userCheck;
    } else if (status == 'Absent') {
      statusColor = const Color(0xFFE11D48);
      statusBgColor = const Color(0xFFFFF0F0);
      iconData = LucideIcons.userX;
    } else if (status == 'Late') {
      statusColor = const Color(0xFFF59E0B);
      statusBgColor = const Color(0xFFFFF4E3);
      iconData = LucideIcons.userMinus;
    } else {
      statusColor = const Color(0xFF0284C7);
      statusBgColor = const Color(0xFFEDF8FC);
      iconData = LucideIcons.users;
    }

    final dateParts = record['date'].split(' ');
    final dateDisplay = '${dateParts[0]} ${dateParts[1]}';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showListRecordDetails(record),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Date
            SizedBox(
              width: 55, // Fixed width to ensure Date doesn't shift the day
              child: Text(
                dateDisplay,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ),
            const Spacer(),
            // Day
            Text(
              record['day'].substring(0, 3),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7A7A9D),
              ),
            ),
            const Spacer(),
            // Status Pill + Chevron
            Row(
              children: [
                Container(
                    width: 105,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(iconData, size: 14, color: statusColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 18,
                    color: Color(0xFF1E1E2D),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showListRecordDetails(Map<String, dynamic> record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final String status = record['status'];
        Color statusColor;
        Color statusBgColor;
        String timeStr = 'Checked in at ${record['in']}';

        if (status == 'Present') {
          statusColor = const Color(0xFF16A34A);
          statusBgColor = const Color(0xFFE8F8ED);
        } else if (status == 'Absent') {
          statusColor = const Color(0xFFE11D48);
          statusBgColor = const Color(0xFFFFF0F0);
          timeStr = 'Did not attend';
        } else if (status == 'Late') {
          statusColor = const Color(0xFFF59E0B);
          statusBgColor = const Color(0xFFFFF4E3);
        } else {
          statusColor = const Color(0xFF0284C7);
          statusBgColor = const Color(0xFFEDF8FC);
          timeStr = 'School Closed';
        }

        final dateParts = record['date'].split(' ');
        final dateStr =
            '${record['day'].substring(0, 3)}, ${dateParts[0]} ${dateParts[1]} ${dateParts[2]}';

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E3F8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF3EEFF), height: 1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      LucideIcons.clock,
                      size: 16,
                      color: Color(0xFF6C6C80),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4A68),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCustomYearDropdown() {
    final RenderBox renderBox = _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.pop(context),
                    child: Container(),
                  ),
                ),
                Positioned(
                  top: offset.dy + size.height + 8,
                  right: MediaQuery.of(context).size.width - offset.dx - size.width,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C4CF1).withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          ..._academicYears.map((year) {
                            final isSelected = year == _selectedAcademicYear;
                            return InkWell(
                              onTap: () {
                                if (!mounted) return;

                                setState(() {
                                  _selectedAcademicYear = year;
                                  // Update the calendar's year when the academic year changes
                                  int startYear = int.tryParse(year.substring(0, 4)) ?? _currentDate.year;
                                  _currentDate = DateTime(startYear, _currentDate.month, 1);
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: isSelected ? const Color(0xFFF3F0FF) : Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: Row(
                                  children: [
                                    if (isSelected)
                                      const Icon(Icons.check, color: Color(0xFF6C4CF1), size: 16)
                                    else
                                      const SizedBox(width: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      year,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                        color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }


  void _showMonthPicker() {
    final List<String> shortMonths = [
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
    int selectedYear = _currentDate.year;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => setDialogState(() => selectedYear--),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: Color(0xFF6C4CF1),
                          ),
                        ),
                        Text(
                          selectedYear.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setDialogState(() => selectedYear++),
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF6C4CF1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 12,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        bool isSelected =
                            (_currentDate.month == index + 1) &&
                            (_currentDate.year == selectedYear);
                        return GestureDetector(
                          onTap: () {
                            if (!mounted) return;

                            setState(() {
                              _currentDate = DateTime(
                                selectedYear,
                                index + 1,
                                1,
                              );
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF6C4CF1)
                                  : const Color(0xFFF3EEFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                shortMonths[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF1E1E2D),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
