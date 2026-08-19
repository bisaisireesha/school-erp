import 'package:flutter/material.dart';
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

  final List<Map<String, dynamic>> recentRecords = [
    {"date": "28 Jul 2026", "day": "Tuesday", "status": "Present", "in": "08:15 AM", "out": "03:30 PM"},
    {"date": "27 Jul 2026", "day": "Monday", "status": "Late", "in": "08:45 AM", "out": "03:30 PM"},
    {"date": "24 Jul 2026", "day": "Friday", "status": "Present", "in": "08:20 AM", "out": "03:30 PM"},
    {"date": "23 Jul 2026", "day": "Thursday", "status": "Absent", "in": "--:--", "out": "--:--"},
  ];

  // Calendar state
  DateTime _currentDate = DateTime.now();
  
  // Mock attendance status for calendar
  // 1: present, 2: absent, 3: late, 4: holiday
  final Map<int, int> _attendanceStatus = {
    28: 1, 27: 3, 25: 4, 24: 1, 23: 2, 22: 1, 21: 1, 20: 1, 17: 1, 16: 1, 15: 1, 14: 1,
    12: 4, 10: 1, 9: 1, 8: 2, 7: 1, 6: 1, 3: 1, 2: 1, 1: 3
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            child: _buildCalendar(),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: const Text('Recent Attendance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          ),
          const SizedBox(height: 16),
          _buildRecentRecords(),
          const SizedBox(height: 120), // Bottom padding for navbar
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
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
              child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
        ],
      ),
    );
  }

  Widget _buildStudentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.5), blurRadius: 15, offset: const Offset(0, 5)),
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
                Text(studentInfo['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 2),
                Text('${studentInfo['class']} | Roll No: ${studentInfo['rollNo']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80))),
                const SizedBox(height: 2),
                Text('Teacher: ${studentInfo['teacher'] ?? 'Sarah Connor'}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6C6C80))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(studentInfo['status'] ?? 'Present Today', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICards() {
    return LayoutBuilder(
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
            _buildKPIItem('Present', (kpiStats['present'] ?? 132).toString(), LucideIcons.checkCircle2, const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
            _buildKPIItem('Absent', (kpiStats['absent'] ?? 8).toString(), LucideIcons.xCircle, const Color(0xFFE11D48), const Color(0xFFFFF1F2)),
            _buildKPIItem('Late', (kpiStats['late'] ?? 5).toString(), LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFFFBEB)),
            _buildKPIItem('Holiday', (kpiStats['holiday'] ?? 12).toString(), LucideIcons.sun, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE)),
          ],
        );
      },
    );
  }

  Widget _buildKPIItem(String title, String value, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, 4)),
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
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80))),
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
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    int daysInMonth = DateUtils.getDaysInMonth(_currentDate.year, _currentDate.month);
    DateTime firstDay = DateTime(_currentDate.year, _currentDate.month, 1);
    int startingWeekday = firstDay.weekday; // 1 = Monday, 7 = Sunday
    int emptySlots = startingWeekday - 1; // 0 for Monday

    final List<String> weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final List<String> monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.5), blurRadius: 15, offset: const Offset(0, 5)),
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
                    child: Text('${monthNames[_currentDate.month - 1]} ${_currentDate.year}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentDate = DateTime.now();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Today', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
                      });
                    },
                    child: const Icon(Icons.chevron_left_rounded, color: Color(0xFF6C4CF1)),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
                      });
                    },
                    child: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6C4CF1)),
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
              _buildLegendItem(const Color(0xFF16A34A), const Color(0xFFF0FDF4), 'Present'),
              _buildLegendItem(const Color(0xFFE11D48), const Color(0xFFFFF1F2), 'Absent'),
              _buildLegendItem(const Color(0xFFF59E0B), const Color(0xFFFFFBEB), 'Late'),
              _buildLegendItem(const Color(0xFF0EA5E9), const Color(0xFFF0F9FF), 'Holiday'),
            ],
          ),
          const SizedBox(height: 24),
          // Weekdays
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekdays.map((day) => SizedBox(
              width: 32,
              child: Center(child: Text(day, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80)))),
            )).toList(),
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
              bool isPastOrCurrentMonth = (_currentDate.year < DateTime.now().year) || (_currentDate.year == DateTime.now().year && _currentDate.month <= DateTime.now().month);
              
              if (isPastOrCurrentMonth) {
                status = _attendanceStatus[day] ?? 0;
              } else {
                if ((_attendanceStatus[day] ?? 0) == 4) {
                  status = 4;
                }
              }

              Color bgColor = Colors.transparent;
              Color textColor = const Color(0xFF1E1E2D);
              
              if (status == 1) { // Present
                bgColor = const Color(0xFFF0FDF4);
                textColor = const Color(0xFF16A34A);
              } else if (status == 2) { // Absent
                bgColor = const Color(0xFFFFF1F2);
                textColor = const Color(0xFFE11D48);
              } else if (status == 3) { // Late
                bgColor = const Color(0xFFFFFBEB);
                textColor = const Color(0xFFF59E0B);
              } else if (status == 4) { // Holiday
                bgColor = const Color(0xFFBAE6FD); // Tailwind Sky 200
                textColor = const Color(0xFF0284C7); // Tailwind Sky 600
              }

              // Highlight today
              bool isToday = (day == DateTime.now().day && _currentDate.month == DateTime.now().month && _currentDate.year == DateTime.now().year);

              return Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: isToday ? Border.all(color: const Color(0xFF6C4CF1), width: 2) : null,
                ),
                child: Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: (status != 0 || isToday) ? FontWeight.bold : FontWeight.w500,
                      color: textColor,
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

  Widget _buildRecentRecords() {
    if (recentRecords.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text('No records found', style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: recentRecords.map((record) {
                return SizedBox(
                  width: (constraints.maxWidth - 48 - 32) / 3,
                  child: _buildRecordItem(record),
                );
              }).toList(),
            ),
          );
        } else if (constraints.maxWidth > 500) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: recentRecords.map((record) {
                return SizedBox(
                  width: (constraints.maxWidth - 48 - 16) / 2,
                  child: _buildRecordItem(record),
                );
              }).toList(),
            ),
          );
        } else {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: recentRecords.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildRecordItem(recentRecords[index]);
            },
          );
        }
      },
    );
  }

  Widget _buildRecordItem(Map<String, dynamic> record) {
    final String status = record['status'];
    Color statusColor;
    Color statusBgColor;

    if (status == 'Present') {
      statusColor = const Color(0xFF16A34A);
      statusBgColor = const Color(0xFFF0FDF4);
    } else if (status == 'Absent') {
      statusColor = const Color(0xFFE11D48);
      statusBgColor = const Color(0xFFFFF1F2);
    } else {
      statusColor = const Color(0xFFF59E0B);
      statusBgColor = const Color(0xFFFFFBEB);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(record['date'].split(' ')[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: statusColor)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${record['day']}, ${record['date'].split(' ')[1]}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(LucideIcons.logIn, size: 12, color: Color(0xFF6C6C80)),
                    const SizedBox(width: 4),
                    Text('In: ${record['in']}', style: const TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
                    const SizedBox(width: 12),
                    const Icon(LucideIcons.logOut, size: 12, color: Color(0xFF6C6C80)),
                    const SizedBox(width: 4),
                    Text('Out: ${record['out']}', style: const TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
          ),
        ],
      ),
    );
  }

  void _showMonthPicker() {
    final List<String> shortMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    int selectedYear = _currentDate.year;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                          child: const Icon(Icons.chevron_left_rounded, color: Color(0xFF6C4CF1)),
                        ),
                        Text(selectedYear.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        GestureDetector(
                          onTap: () => setDialogState(() => selectedYear++),
                          child: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6C4CF1)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 12,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        bool isSelected = (_currentDate.month == index + 1) && (_currentDate.year == selectedYear);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentDate = DateTime(selectedYear, index + 1, 1);
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF3EEFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                shortMonths[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
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
