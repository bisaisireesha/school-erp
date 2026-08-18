import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class DriverAttendanceScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const DriverAttendanceScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<DriverAttendanceScreen> createState() => _DriverAttendanceScreenState();
}

class _DriverAttendanceScreenState extends State<DriverAttendanceScreen> {
  int _selectedMonthIndex = 6; // July 2026
  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  int? _selectedCalendarDay;

  // Mock Driver Personal Attendance Logs
  final List<Map<String, dynamic>> _dailyLogs = [
    {
      'day': 31,
      'date': '31 Jul 2026',
      'dayName': 'Friday',
      'status': 'Present',
      'checkIn': '06:30 AM',
      'checkOut': '05:45 PM',
      'hours': '11h 15m',
      'location': 'Bus Depot Gate 1',
      'shift': 'Morning & Evening Pick-Up/Drop',
    },
    {
      'day': 30,
      'date': '30 Jul 2026',
      'dayName': 'Thursday',
      'status': 'Present',
      'checkIn': '06:32 AM',
      'checkOut': '05:40 PM',
      'hours': '11h 08m',
      'location': 'Bus Depot Gate 1',
      'shift': 'Morning & Evening Pick-Up/Drop',
    },
    {
      'day': 29,
      'date': '29 Jul 2026',
      'dayName': 'Wednesday',
      'status': 'Late',
      'checkIn': '07:15 AM',
      'checkOut': '06:00 PM',
      'hours': '10h 45m',
      'location': 'Bus Depot Gate 1',
      'shift': 'Morning & Evening Pick-Up/Drop (Traffic delay)',
    },
    {
      'day': 28,
      'date': '28 Jul 2026',
      'dayName': 'Tuesday',
      'status': 'Leave',
      'checkIn': '—',
      'checkOut': '—',
      'hours': '0h 00m',
      'location': 'Approved Casual Leave',
      'shift': 'Substitute Driver: Anil Verma',
    },
    {
      'day': 27,
      'date': '27 Jul 2026',
      'dayName': 'Monday',
      'status': 'Present',
      'checkIn': '06:28 AM',
      'checkOut': '05:50 PM',
      'hours': '11h 22m',
      'location': 'Bus Depot Gate 1',
      'shift': 'Morning & Evening Pick-Up/Drop',
    },
    {
      'day': 25,
      'date': '25 Jul 2026',
      'dayName': 'Saturday',
      'status': 'Present',
      'checkIn': '07:00 AM',
      'checkOut': '02:30 PM',
      'hours': '7h 30m',
      'location': 'School Campus',
      'shift': 'Special Sports Event Duty',
    },
    {
      'day': 24,
      'date': '24 Jul 2026',
      'dayName': 'Friday',
      'status': 'Absent',
      'checkIn': '—',
      'checkOut': '—',
      'hours': '0h 00m',
      'location': 'Unplanned Absence',
      'shift': 'Emergency Leave',
    },
  ];

  // Calendar Day Map for July 2026
  final Map<int, String> _julyAttendanceMap = {
    1: 'Present', 2: 'Present', 3: 'Present', 4: 'Weekend', 5: 'Weekend',
    6: 'Present', 7: 'Present', 8: 'Present', 9: 'Present', 10: 'Present',
    11: 'Weekend', 12: 'Weekend', 13: 'Present', 14: 'Late', 15: 'Present',
    16: 'Present', 17: 'Present', 18: 'Weekend', 19: 'Weekend', 20: 'Present',
    21: 'Present', 22: 'Present', 23: 'Present', 24: 'Absent', 25: 'Present',
    26: 'Weekend', 27: 'Present', 28: 'Leave', 29: 'Late', 30: 'Present', 31: 'Present',
  };

  void _showDailyLogDetailsBottomSheet(Map<String, dynamic> log) {
    final String date = log['date'];
    final String dayName = log['dayName'] ?? '';
    final String status = log['status'];
    final String checkIn = log['checkIn'];
    final String checkOut = log['checkOut'];
    final String hours = log['hours'];
    final String location = log['location'] ?? 'Bus Depot';
    final String shift = log['shift'] ?? 'Standard Shift';

    Color statusBg;
    Color statusColor;
    if (status == 'Present') {
      statusBg = const Color(0xFFECFDF5);
      statusColor = const Color(0xFF10B981);
    } else if (status == 'Late') {
      statusBg = const Color(0xFFFFFBEB);
      statusColor = const Color(0xFFD97706);
    } else if (status == 'Leave') {
      statusBg = const Color(0xFFEBF5FF);
      statusColor = const Color(0xFF3B82F6);
    } else {
      statusBg = const Color(0xFFFEF2F2);
      statusColor = const Color(0xFFEF4444);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Drag Handle
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              date,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (dayName.isNotEmpty)
                              Text(
                                dayName,
                                style: const TextStyle(fontSize: 12.5, color: Color(0xFF7A7A9D)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFF0EDF8)),
                  const SizedBox(height: 16),

                  // Check-In & Check-Out Detail Row
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(LucideIcons.logIn, size: 18, color: Color(0xFF10B981)),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Check-In', style: TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D))),
                                Text(checkIn, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(LucideIcons.logOut, size: 18, color: Color(0xFFEF4444)),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Check-Out', style: TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D))),
                                Text(checkOut, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Total Working Duration & Shift Details
                  _buildModalDetailRow('Total Hours', hours),
                  const SizedBox(height: 10),
                  _buildModalDetailRow('Location', location),
                  const SizedBox(height: 10),
                  _buildModalDetailRow('Shift Info', shift),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: AppSpacing.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        foregroundColor: const Color(0xFF1E1E2D),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Close'),
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

  Widget _buildModalDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _selectedCalendarDay == null
        ? _dailyLogs
        : _dailyLogs.where((log) => log['day'] == _selectedCalendarDay).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 90.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Back Button & Page Title
              Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'My Attendance',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Small Monthly Attendance Summary (Attendance %, Present, Absent, Leave)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCompactStat('Attendance', '95.2%', const Color(0xFF6C4CF1)),
                    _buildCompactDivider(),
                    _buildCompactStat('Present', '20', const Color(0xFF10B981)),
                    _buildCompactDivider(),
                    _buildCompactStat('Absent', '1', const Color(0xFFEF4444)),
                    _buildCompactDivider(),
                    _buildCompactStat('Leave', '1', const Color(0xFF3B82F6)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Clean, Modern Calendar with Soft Rounded Square Date Cells (10px radius)
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                ),
                child: Column(
                  children: [
                    // Month Switcher Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_months[_selectedMonthIndex]} 2026',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(LucideIcons.chevronLeft, size: 16, color: Color(0xFF64748B)),
                              onPressed: () {
                                setState(() {
                                  if (_selectedMonthIndex > 0) _selectedMonthIndex--;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF64748B)),
                              onPressed: () {
                                setState(() {
                                  if (_selectedMonthIndex < 11) _selectedMonthIndex++;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Weekday Titles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                        return SizedBox(
                          width: 32,
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),

                    // Days Grid for July (31 days starting Wednesday) using Soft Rounded Square Cells
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 31 + 2, // 2 offset slots for Wednesday start
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                      ),
                      itemBuilder: (context, index) {
                        if (index < 2) return const SizedBox(); // offset for Wednesday
                        final day = index - 1;
                        final status = _julyAttendanceMap[day] ?? 'Weekend';
                        final isSelected = _selectedCalendarDay == day;

                        Color bgColor;
                        Color textColor;
                        Border? border;

                        if (isSelected) {
                          bgColor = const Color(0xFF6C4CF1);
                          textColor = Colors.white;
                          border = Border.all(color: const Color(0xFF6C4CF1), width: 1.5);
                        } else if (status == 'Present') {
                          bgColor = const Color(0xFFECFDF5);
                          textColor = const Color(0xFF10B981);
                          border = Border.all(color: const Color(0xFFA7F3D0), width: 1);
                        } else if (status == 'Late') {
                          bgColor = const Color(0xFFFFFBEB);
                          textColor = const Color(0xFFD97706);
                          border = Border.all(color: const Color(0xFFFDE68A), width: 1);
                        } else if (status == 'Absent') {
                          bgColor = const Color(0xFFFEF2F2);
                          textColor = const Color(0xFFEF4444);
                          border = Border.all(color: const Color(0xFFFCA5A5), width: 1);
                        } else if (status == 'Leave') {
                          bgColor = const Color(0xFFEBF5FF);
                          textColor = const Color(0xFF3B82F6);
                          border = Border.all(color: const Color(0xFFBFDBFE), width: 1);
                        } else {
                          bgColor = const Color(0xFFF8F9FD);
                          textColor = const Color(0xFF94A3B8);
                          border = Border.all(color: const Color(0xFFF0EDF8), width: 1);
                        }

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedCalendarDay == day) {
                                _selectedCalendarDay = null; // clear filter
                              } else {
                                _selectedCalendarDay = day;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(10.0),
                              border: border,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF6C4CF1).withValues(alpha: 0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
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
              ),

              const SizedBox(height: 16),

              // Daily Attendance History Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Daily Attendance History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_selectedCalendarDay != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _selectedCalendarDay = null),
                      child: const Text(
                        'Show All',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),

              // Minimal Attendance History List (Date, Status Badge, Working Hours)
              filteredLogs.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'No attendance record for selected date',
                          style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredLogs.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0EDF8)),
                      itemBuilder: (context, index) {
                        final log = filteredLogs[index];
                        final String date = log['date'];
                        final String status = log['status'];
                        final String hours = log['hours'];

                        Color statusBg;
                        Color statusColor;
                        if (status == 'Present') {
                          statusBg = const Color(0xFFECFDF5);
                          statusColor = const Color(0xFF10B981);
                        } else if (status == 'Late') {
                          statusBg = const Color(0xFFFFFBEB);
                          statusColor = const Color(0xFFD97706);
                        } else if (status == 'Leave') {
                          statusBg = const Color(0xFFEBF5FF);
                          statusColor = const Color(0xFF3B82F6);
                        } else {
                          statusBg = const Color(0xFFFEF2F2);
                          statusColor = const Color(0xFFEF4444);
                        }

                        return InkWell(
                          onTap: () => _showDailyLogDetailsBottomSheet(log),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Date & Status Badge
                                Row(
                                  children: [
                                    Text(
                                      date,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E1E2D),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                      decoration: BoxDecoration(
                                        color: statusBg,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Working Hours & Chevron
                                Row(
                                  children: [
                                    Text(
                                      hours,
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      LucideIcons.chevronRight,
                                      size: 16,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ],
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

  Widget _buildCompactStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildCompactDivider() {
    return Container(
      width: 1,
      height: 22,
      color: const Color(0xFFE2E8F0),
    );
  }
}
