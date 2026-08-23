import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';
import 'visitors_screen.dart';
import 'enquiries_screen.dart';
import 'appointments_screen.dart';
import 'complaints_screen.dart';
import 'postal_records_screen.dart';
import 'call_logs_screen.dart';
import 'certificates_screen.dart';
import 'tasks_screen.dart';
import 'front_desk_reports_screen.dart';

class FrontDeskDashboardScreen extends StatefulWidget {
  const FrontDeskDashboardScreen({super.key});

  @override
  State<FrontDeskDashboardScreen> createState() =>
      _FrontDeskDashboardScreenState();
}

class _FrontDeskDashboardScreenState extends State<FrontDeskDashboardScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    MainLayout.globalSearchQuery.addListener(_onGlobalSearchChanged);
    _searchQuery = MainLayout.globalSearchQuery.value;
  }

  void _onGlobalSearchChanged() {
    if (mounted) {
      setState(() {
        _searchQuery = MainLayout.globalSearchQuery.value;
      });
    }
  }

  @override
  void dispose() {
    MainLayout.globalSearchQuery.removeListener(_onGlobalSearchChanged);
    super.dispose();
  }

  final List<Map<String, dynamic>> _recentVisitors = [
    {
      'name': 'Rajesh Kumar',
      'purpose': 'Admission Enquiry',
      'time': '10:15 AM',
      'status': 'Checked In',
    },
    {
      'name': 'Priya Singh',
      'purpose': 'Meet Principal',
      'time': '11:30 AM',
      'status': 'Waiting',
    },
    {
      'name': 'Amit Sharma',
      'purpose': 'Fee Payment',
      'time': '12:00 PM',
      'status': 'Checked Out',
    },
  ];

  final List<Map<String, dynamic>> _pendingTasks = [
    {
      'title': 'Dispatch Courier to HDFC Bank',
      'priority': 'High',
      'time': 'Today, 2:00 PM',
    },
    {
      'title': 'Update Visitor Log Register',
      'priority': 'Medium',
      'time': 'Today, 4:30 PM',
    },
  ];

  final List<Map<String, dynamic>> _upcomingAppointments = [
    {
      'visitorName': 'Dr. Alok Verma',
      'purpose': 'Guest Lecture',
      'host': 'Principal',
      'time': 'Tomorrow, 10:00 AM',
    },
    {
      'visitorName': 'Mr. Suresh',
      'purpose': 'Vendor Meeting (Stationery)',
      'host': 'Admin Office',
      'time': 'Tomorrow, 11:30 AM',
    },
  ];

  final List<Map<String, dynamic>> _studentHelpDesk = [
    {
      'studentName': 'Rahul Kumar',
      'grade': '10th - A',
      'issue': 'ID Card Replacement',
      'status': 'Pending',
      'time': '10 Mins Ago',
    },
    {
      'studentName': 'Sneha Patil',
      'grade': '8th - B',
      'issue': 'Bus Pass Renewal',
      'status': 'In Progress',
      'time': '1 Hour Ago',
    },
  ];

  final List<Map<String, dynamic>> _todaySchedule = [
    {
      'time': '08:30 AM',
      'title': 'School Bus Arrivals',
      'type': 'Transport',
      'location': 'Main Gate',
    },
    {
      'time': '10:00 AM',
      'title': 'Admissions Open Desk',
      'type': 'Event',
      'location': 'Lobby Area',
    },
    {
      'time': '02:00 PM',
      'title': 'PTA Meeting Setup',
      'type': 'Meeting',
      'location': 'Auditorium',
    },
    {
      'time': '04:00 PM',
      'title': 'Evening Dispatch',
      'type': 'Task',
      'location': 'Mail Room',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildHeaderTitle(),
          const SizedBox(height: 16),
          _buildStatsGrid(),
          const SizedBox(height: 32),
          _buildSectionHeader(
            'Today\'s Schedule',
            onViewAll: () {
              MainLayout.pushSubScreen(
                context,
                AppointmentsScreen(
                  onBack: () => MainLayout.popSubScreen(context),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildTodaySchedule(),
          const SizedBox(height: 32),
          _buildSectionHeader(
            'Recent Visitors',
            onViewAll: () {
              MainLayout.pushSubScreen(
                context,
                VisitorsScreen(onBack: () => MainLayout.popSubScreen(context)),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildRecentVisitors(),
          const SizedBox(height: 32),
          _buildSectionHeader(
            'Pending Tasks',
            onViewAll: () {
              MainLayout.pushSubScreen(
                context,
                TasksScreen(onBack: () => MainLayout.popSubScreen(context)),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildPendingTasks(),
          const SizedBox(height: 32),
          _buildSectionHeader(
            'Upcoming Appointments',
            onViewAll: () {
              MainLayout.pushSubScreen(
                context,
                AppointmentsScreen(
                  onBack: () => MainLayout.popSubScreen(context),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildUpcomingAppointments(),
          const SizedBox(height: 32),
          _buildSectionHeader(
            'Student Help Desk',
            onViewAll: () {
              MainLayout.pushSubScreen(
                context,
                ComplaintsScreen(
                  onBack: () => MainLayout.popSubScreen(context),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildStudentHelpDesk(),
          const SizedBox(height: 32),
          _buildQuickActions(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Front Desk Dashboard',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Color(0xFF1E1E2D),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1E2D),
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  icon: LucideIcons.users,
                  iconColor: const Color(0xFF6C4CF1),
                  iconBg: const Color(0xFFF3F0FF),
                  title: 'Today Visitor',
                  valueRichText: const TextSpan(
                    text: '45',
                    style: TextStyle(color: Color(0xFF1E1E2D)),
                  ),
                  bottomText: '10 New Today',
                  bottomTextColor: const Color(0xFF4A4A68),
                  onTap: () {
                    MainLayout.pushSubScreen(
                      context,
                      VisitorsScreen(
                        onBack: () => MainLayout.popSubScreen(context),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKpiCard(
                  icon: LucideIcons.messageSquare,
                  iconColor: const Color(0xFF0EA5E9),
                  iconBg: const Color(0xFFE0F2FE),
                  title: 'Pending Enquiries',
                  valueRichText: const TextSpan(
                    text: '18',
                    style: TextStyle(color: Color(0xFF1E1E2D)),
                  ),
                  bottomText: '5 Needs Follow-up',
                  bottomTextColor: const Color(0xFF4A4A68),
                  onTap: () {
                    MainLayout.pushSubScreen(
                      context,
                      EnquiriesScreen(
                        onBack: () => MainLayout.popSubScreen(context),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  icon: LucideIcons.userCheck,
                  iconColor: const Color(0xFFF59E0B),
                  iconBg: const Color(0xFFFEF3C7),
                  title: 'Still Inside',
                  valueRichText: const TextSpan(
                    text: '12',
                    style: TextStyle(color: Color(0xFF1E1E2D)),
                  ),
                  bottomText: 'Active Visitors',
                  bottomTextColor: const Color(0xFF4A4A68),
                  onTap: () {
                    MainLayout.pushSubScreen(
                      context,
                      VisitorsScreen(
                        onBack: () => MainLayout.popSubScreen(context),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKpiCard(
                  icon: LucideIcons.alertTriangle,
                  iconColor: const Color(0xFFEF4444),
                  iconBg: const Color(0xFFFEE2E2),
                  title: 'Open Complaints',
                  valueRichText: const TextSpan(
                    text: '4',
                    style: TextStyle(color: Color(0xFF1E1E2D)),
                  ),
                  bottomText: 'Awaiting Resolution',
                  bottomTextColor: const Color(0xFF4A4A68),
                  onTap: () {
                    MainLayout.pushSubScreen(
                      context,
                      ComplaintsScreen(
                        onBack: () => MainLayout.popSubScreen(context),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required TextSpan valueRichText,
    required String bottomText,
    required Color bottomTextColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4A68),
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Inter',
                ),
                children: [valueRichText],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bottomText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: bottomTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySchedule() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
          children: List.generate(_todaySchedule.length, (index) {
            final item = _todaySchedule[index];
            final isLast = index == _todaySchedule.length - 1;

            Color iconColor;
            Color iconBg;

            switch (item['type']) {
              case 'Transport':
                iconColor = const Color(0xFF6C4CF1);
                iconBg = const Color(0xFFF3F0FF);
                break;
              case 'Event':
                iconColor = const Color(0xFFF59E0B);
                iconBg = const Color(0xFFFEF3C7);
                break;
              case 'Meeting':
                iconColor = const Color(0xFF0EA5E9);
                iconBg = const Color(0xFFE0F2FE);
                break;
              default:
                iconColor = const Color(0xFF11B136);
                iconBg = const Color(0xFFE8F5E9);
            }

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                MainLayout.pushSubScreen(
                  context,
                  AppointmentsScreen(
                    onBack: () => MainLayout.popSubScreen(context),
                  ),
                );
              },
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Text(
                        item['time'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: iconColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: iconBg, width: 3),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: const Color(0xFFF3F0FF),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  item['type'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A4A68),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  LucideIcons.mapPin,
                                  size: 12,
                                  color: Color(0xFF4A4A68),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item['location'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4A4A68),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: Color(0xFFC4C4D4),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildRecentVisitors() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: _recentVisitors.map((visitor) {
          final isCheckedIn = visitor['status'] == 'Checked In';
          final isWaiting = visitor['status'] == 'Waiting';

          return GestureDetector(
            onTap: () {
              MainLayout.pushSubScreen(
                context,
                VisitorsScreen(onBack: () => MainLayout.popSubScreen(context)),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F0FF),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        visitor['name'][0],
                        style: const TextStyle(
                          color: Color(0xFF6C4CF1),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visitor['name'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          visitor['purpose'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4A4A68),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        visitor['time'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A4A68),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isCheckedIn
                              ? const Color(0xFFE8F5E9)
                              : isWaiting
                              ? const Color(0xFFFFF3E0)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          visitor['status'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isCheckedIn
                                ? const Color(0xFF11B136)
                                : isWaiting
                                ? const Color(0xFFF57C00)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: Color(0xFFC4C4D4),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPendingTasks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: _pendingTasks.map((task) {
          final isHigh = task['priority'] == 'High';
          return GestureDetector(
            onTap: () {
              MainLayout.pushSubScreen(
                context,
                TasksScreen(onBack: () => MainLayout.popSubScreen(context)),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isHigh
                          ? const Color(0xFFFEE2E2)
                          : const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isHigh ? LucideIcons.alertCircle : LucideIcons.clock,
                      color: isHigh
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFF59E0B),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task['time'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4A4A68),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronRight,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUpcomingAppointments() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: _upcomingAppointments.map((appt) {
          return GestureDetector(
            onTap: () {
              MainLayout.pushSubScreen(
                context,
                AppointmentsScreen(
                  onBack: () => MainLayout.popSubScreen(context),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.calendar,
                      color: Color(0xFF0EA5E9),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appt['visitorName'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${appt['purpose']} • ${appt['host']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4A4A68),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    appt['time'].split(',')[0],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: Color(0xFFC4C4D4),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStudentHelpDesk() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: _studentHelpDesk.map((ticket) {
          final isPending = ticket['status'] == 'Pending';
          return GestureDetector(
            onTap: () {
              MainLayout.pushSubScreen(
                context,
                ComplaintsScreen(
                  onBack: () => MainLayout.popSubScreen(context),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.graduationCap,
                      color: Color(0xFF6C4CF1),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket['studentName'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${ticket['issue']} • ${ticket['grade']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4A4A68),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        ticket['time'],
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A4A68),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isPending
                              ? const Color(0xFFFFF3E0)
                              : const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ticket['status'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isPending
                                ? const Color(0xFFF57C00)
                                : const Color(0xFF0EA5E9),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: Color(0xFFC4C4D4),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickActions() {
    final List<Map<String, dynamic>> actions = [
      {
        'label': 'New\nVisitor',
        'icon': LucideIcons.userPlus,
        'onTap': () {
          MainLayout.pushSubScreen(
            context,
            VisitorsScreen(onBack: () => MainLayout.popSubScreen(context)),
          );
        },
      },
      {
        'label': 'Gate\nPass',
        'icon': LucideIcons.ticket,
        'onTap': () {
          MainLayout.pushSubScreen(
            context,
            VisitorsScreen(onBack: () => MainLayout.popSubScreen(context)),
          );
        },
      },
      {
        'label': 'Add\nEnquiry',
        'icon': LucideIcons.messageSquarePlus,
        'onTap': () {
          MainLayout.pushSubScreen(
            context,
            EnquiriesScreen(onBack: () => MainLayout.popSubScreen(context)),
          );
        },
      },
      {
        'label': 'Call\nLog',
        'icon': LucideIcons.phoneCall,
        'onTap': () {
          MainLayout.pushSubScreen(
            context,
            CallLogsScreen(onBack: () => MainLayout.popSubScreen(context)),
          );
        },
      },
      {
        'label': 'Postal &\nCourier',
        'icon': LucideIcons.send,
        'onTap': () {
          MainLayout.pushSubScreen(
            context,
            PostalRecordsScreen(onBack: () => MainLayout.popSubScreen(context)),
          );
        },
      },
      {
        'label': 'Certificates',
        'icon': LucideIcons.award,
        'onTap': () {
          MainLayout.pushSubScreen(
            context,
            CertificatesScreen(onBack: () => MainLayout.popSubScreen(context)),
          );
        },
      },
      {
        'label': 'Tasks',
        'icon': LucideIcons.checkSquare,
        'onTap': () {
          MainLayout.pushSubScreen(
            context,
            TasksScreen(onBack: () => MainLayout.popSubScreen(context)),
          );
        },
      },
      {
        'label': 'Reports',
        'icon': LucideIcons.barChart2,
        'onTap': () {
          MainLayout.pushSubScreen(
            context,
            FrontDeskReportsScreen(
              onBack: () => MainLayout.popSubScreen(context),
            ),
          );
        },
      },
    ];

    final filteredActions = actions.where((action) {
      if (_searchQuery.isEmpty) return true;
      return (action['label'] as String)
          .toLowerCase()
          .replaceAll('\n', ' ')
          .contains(_searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1E2D),
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 24,
              crossAxisSpacing: 8,
              childAspectRatio: 0.8,
              children: filteredActions.map((action) {
                return _buildActionItem(
                  action['label'] as String,
                  action['icon'] as IconData,
                  onTap: action['onTap'] as VoidCallback,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    String label,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F0FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF6C4CF1), size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A4A68),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
