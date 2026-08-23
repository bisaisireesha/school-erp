import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:math' as math;
import '../main_layout.dart';
import 'mess_menu_screen.dart';
import '../hostel/hostel_attendance_screen.dart';
import '../hostel/hostel_maintenance_screen.dart';
import 'reports_screen.dart';
import '../hostel/outing_pass_screen.dart';
import '../hostel/hostel_rooms_screen.dart';
import '../messages/messages_screen.dart';
import 'mess_dashboard_screen.dart';
import 'inventory_screen.dart';
import '../hostel/hostel_wardens_screen.dart';
import '../hostel/hostel_health_screen.dart';
import '../hostel/hostel_students_screen.dart';
import '../hostel/hostel_blocks_screen.dart';

class HostelWardenDashboardScreen extends StatefulWidget {
  const HostelWardenDashboardScreen({super.key});

  @override
  State<HostelWardenDashboardScreen> createState() =>
      _HostelWardenDashboardScreenState();
}

class _HostelWardenDashboardScreenState
    extends State<HostelWardenDashboardScreen> {
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

  List<Map<String, dynamic>> _pendingOutings = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (!_isLoading && _pendingOutings.isNotEmpty) return;
    try {
      final String response = await rootBundle.loadString(
        'assets/mock/hostel_warden_dashboard.json',
      );
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _pendingOutings = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF6C4CF1)),
      );
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildSectionTitle('Hostel Dashboard'),
          const SizedBox(height: 16),
          _buildStatsGrid(),
          const SizedBox(height: 32),
          _buildSectionTitle('Today\'s Schedule'),
          const SizedBox(height: 16),
          _buildTodaySchedule(),
          const SizedBox(height: 32),

          _buildMessAndDiningStatus(),
          const SizedBox(height: 32),
          _buildRoomOccupancySection(),
          const SizedBox(height: 32),
          _buildSectionTitle('Pending Tasks'),
          const SizedBox(height: 16),
          _buildPendingTasks(),
          _buildSectionTitle('Outpass & Leave Requests'),
          const SizedBox(height: 16),
          _buildPendingOutings(),
          const SizedBox(height: 32),
          _buildSectionTitle('Student Welfare'),
          const SizedBox(height: 16),
          _buildStudentWelfare(),
          const SizedBox(height: 32),
          _buildSectionTitle('Maintenance'),
          const SizedBox(height: 16),
          _buildMaintenance(),
          const SizedBox(height: 32),
          _buildSectionTitle('Warden On Duty'),
          const SizedBox(height: 16),
          _buildWardensOnDuty(),
          const SizedBox(height: 32),
          _buildQuickActions(),
          const SizedBox(height: 32),
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
                  title: 'Total Students',
                  valueRichText: const TextSpan(
                    text: '250',
                    style: TextStyle(color: Color(0xFF1E1E2D)),
                  ),
                  bottomText: '10 New admissions',
                  bottomTextColor: const Color(0xFF4A4A68),
                  onTap: () => MainLayout.pushSubScreen(
                    context,
                    HostelStudentsScreen(
                      onBack: () => MainLayout.popSubScreen(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKpiCard(
                  icon: LucideIcons.building,
                  iconColor: const Color(0xFF0EA5E9),
                  iconBg: const Color(0xFFE0F2FE),
                  title: 'Total Blocks',
                  valueRichText: const TextSpan(
                    text: '4',
                    style: TextStyle(color: Color(0xFF1E1E2D)),
                  ),
                  bottomText: 'A, B, C, D Blocks',
                  bottomTextColor: const Color(0xFF4A4A68),
                  onTap: () => MainLayout.pushSubScreen(
                    context,
                    HostelBlocksScreen(
                      onBack: () => MainLayout.popSubScreen(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  icon: LucideIcons.bedDouble,
                  iconColor: const Color(0xFFF59E0B),
                  iconBg: const Color(0xFFFEF3C7),
                  title: 'Room Allocation',
                  valueRichText: const TextSpan(
                    text: '85%',
                    style: TextStyle(color: Color(0xFF1E1E2D)),
                  ),
                  bottomText: '42 Rooms Available',
                  bottomTextColor: const Color(0xFF4A4A68),
                  onTap: () => MainLayout.pushSubScreen(
                    context,
                    HostelRoomsScreen(
                      onBack: () => MainLayout.popSubScreen(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKpiCard(
                  icon: LucideIcons.clipboardCheck,
                  iconColor: const Color(0xFF11B136),
                  iconBg: const Color(0xFFE8F5E9),
                  title: 'Hostel Attendance',
                  valueRichText: const TextSpan(
                    text: '95%',
                    style: TextStyle(color: Color(0xFF1E1E2D)),
                  ),
                  bottomText: '12 Students on Leave',
                  bottomTextColor: const Color(0xFF4A4A68),
                  onTap: () => MainLayout.pushSubScreen(
                    context,
                    HostelAttendanceScreen(
                      onBack: () => MainLayout.popSubScreen(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule() {
    final List<HostelScheduleModel> schedule = [
      HostelScheduleModel(
        time: '06:30 AM',
        title: 'Wake-up & roll call',
        subtitle: 'All blocks',
        icon: LucideIcons.clipboardCheck,
        color: const Color(0xFF0EA5E9),
        bgColor: const Color(0xFFE0F2FE),
        status: 'DONE',
        statusColor: const Color(0xFF16A34A),
        statusBg: const Color(0xFFDCFCE7),
      ),
      HostelScheduleModel(
        time: '08:00 AM',
        title: 'Warden round · Boys A',
        subtitle: 'Mr. Verma',
        icon: LucideIcons.shieldCheck,
        color: const Color(0xFF16A34A),
        bgColor: const Color(0xFFDCFCE7),
        status: 'DONE',
        statusColor: const Color(0xFF16A34A),
        statusBg: const Color(0xFFDCFCE7),
      ),
      HostelScheduleModel(
        time: '11:00 AM',
        title: 'Room inspection · Girls B',
        subtitle: 'Ms. Iyer',
        icon: LucideIcons.clipboardList,
        color: const Color(0xFFF59E0B),
        bgColor: const Color(0xFFFEF3C7),
        status: 'NOW',
        statusColor: const Color(0xFFF59E0B),
        statusBg: const Color(0xFFFFFBEB),
      ),
      HostelScheduleModel(
        time: '04:30 PM',
        title: 'Outpass return cutoff',
        subtitle: '12 students',
        icon: LucideIcons.logIn,
        color: const Color(0xFF6C4CF1),
        bgColor: const Color(0xFFF3F0FF),
        status: 'UPCOMING',
        statusColor: const Color(0xFF6C6C80),
        statusBg: const Color(0xFFFFFFFF),
      ),
      HostelScheduleModel(
        time: '09:30 PM',
        title: 'Night attendance lock',
        subtitle: 'All blocks',
        icon: LucideIcons.calendar,
        color: const Color(0xFF0EA5E9),
        bgColor: const Color(0xFFE0F2FE),
        status: 'UPCOMING',
        statusColor: const Color(0xFF6C6C80),
        statusBg: const Color(0xFFFFFFFF),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => MainLayout.pushSubScreen(
          context,
          HostelAttendanceScreen(
            onBack: () => MainLayout.popSubScreen(context),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: schedule.asMap().entries.map((entry) {
              final int index = entry.key;
              final item = entry.value;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time at top
                        Text(
                          item.time,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: item.color,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Icon + Title + Status + Chevron
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: item.bgColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                item.icon,
                                color: item.color,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.subtitle,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6C6C80),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: item.statusBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: item.statusColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              LucideIcons.chevronRight,
                              size: 16,
                              color: Color(0xFF6C6C80),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (index != schedule.length - 1)
                    const Divider(height: 1, color: Color(0xFFF3EEFF)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMessAndDiningStatus() {
    return GestureDetector(
      onTap: () => MainLayout.pushSubScreen(
        context,
        MessDashboardScreen(onBack: () => MainLayout.popSubScreen(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LucideIcons.utensils,
                    color: Color(0xFFF59E0B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Mess & Dining Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildMessStatusCard(
                        icon: LucideIcons.utensils,
                        iconColor: const Color(0xFF22C55E),
                        iconBgColor: const Color(0xFFDCFCE7),
                        title: '312 Students',
                        subtitle: 'Breakfast Served',
                        footer: 'Completed 08:30 AM',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMessStatusCard(
                        icon: LucideIcons.clock,
                        iconColor: const Color(0xFF0EA5E9),
                        iconBgColor: const Color(0xFFE0F2FE),
                        title: '1:00 PM',
                        subtitle: 'Lunch Scheduled',
                        footer: 'Menu: Veg thali · Curd rice',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildMessStatusCard(
                        icon: LucideIcons.heartPulse,
                        iconColor: const Color(0xFF6C4CF1),
                        iconBgColor: const Color(0xFFF3F0FF),
                        title: '5 Students',
                        subtitle: 'Special Diet Requests',
                        footer: 'Lactose · Jain · Diabetic',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMessStatusCard(
                        icon: LucideIcons.alertCircle,
                        iconColor: const Color(0xFFEF4444),
                        iconBgColor: const Color(0xFFFFE4E6),
                        title: '1 Open Issue',
                        subtitle: 'Food Complaint',
                        footer: 'Dinner spice level · Block B',
                      ),
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

  Widget _buildMessStatusCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String footer,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            footer,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6C6C80)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFFFFF),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF9CA3AF),
                    size: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B7280),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Inter',
                  color: Color(0xFF111827),
                ),
                children: [valueRichText],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: bottomTextColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                bottomText,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: bottomTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    bool hasViewAll =
        title == 'Outpass & Leave Requests' ||
        title == 'Pending Tasks' ||
        title == 'Warden On Duty' ||
        title == 'Today\'s Schedule' ||
        title == 'Student Welfare' ||
        title == 'Maintenance';
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
          if (hasViewAll)
            GestureDetector(
              onTap: () {
                if (title == 'Today\'s Schedule') {
                  MainLayout.pushSubScreen(
                    context,
                    HostelAttendanceScreen(
                      onBack: () => MainLayout.popSubScreen(context),
                    ),
                  );
                } else if (title == 'Outpass & Leave Requests' ||
                    title == 'Pending Tasks') {
                  MainLayout.pushSubScreen(
                    context,
                    OutingPassScreen(
                      onBack: () => MainLayout.popSubScreen(context),
                    ),
                  );
                } else if (title == 'Warden On Duty') {
                  MainLayout.pushSubScreen(
                    context,
                    HostelWardensScreen(
                      onBack: () => MainLayout.popSubScreen(context),
                    ),
                  );
                } else if (title == 'Student Welfare') {
                  MainLayout.pushSubScreen(
                    context,
                    HostelHealthScreen(
                      onBack: () => MainLayout.popSubScreen(context),
                    ),
                  );
                } else if (title == 'Maintenance') {
                  MainLayout.pushSubScreen(
                    context,
                    HostelMaintenanceScreen(
                      onBack: () => MainLayout.popSubScreen(context),
                    ),
                  );
                }
              },
              child: const Text(
                'View all',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPendingTasks() {
    final List<HostelTaskModel> tasks = [
      HostelTaskModel(
        title: 'Approve 5 Leave Requests',
        time: 'Due Today',
        icon: LucideIcons.fileSignature,
        color: const Color(0xFFF59E0B),
        bgColor: const Color(0xFFFFFBEB),
      ),
      HostelTaskModel(
        title: 'Check Room 102 Maintenance',
        time: 'Overdue',
        icon: LucideIcons.wrench,
        color: const Color(0xFFE11D48),
        bgColor: const Color(0xFFFFE4E6),
      ),
      HostelTaskModel(
        title: 'Verify Kitchen Inventory',
        time: 'Tomorrow',
        icon: LucideIcons.clipboardList,
        color: const Color(0xFF16A34A),
        bgColor: const Color(0xFFF0FDF4),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => MainLayout.pushSubScreen(
          context,
          OutingPassScreen(onBack: () => MainLayout.popSubScreen(context)),
        ),
        child: Column(
          children: tasks.map((task) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: task.bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(task.icon, color: task.color, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.time,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: task.time == 'Overdue'
                                ? const Color(0xFFE11D48)
                                : const Color(0xFF6C6C80),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFF3EEFF),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      LucideIcons.check,
                      size: 16,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildWardensOnDuty() {
    final List<WardenOnDutyModel> wardens = [
      WardenOnDutyModel(
        name: 'Mr. Verma',
        role: 'Boys A · Day shift',
        phone: '+91 98xxxx 1023',
        status: 'ON DUTY',
      ),
      WardenOnDutyModel(
        name: 'Ms. Rao',
        role: 'Girls A · Day shift',
        phone: '+91 98xxxx 4471',
        status: 'ON DUTY',
      ),
      WardenOnDutyModel(
        name: 'Mr. Khanna',
        role: 'Boys B · Night shift',
        phone: '+91 98xxxx 9920',
        status: 'OFF',
      ),
      WardenOnDutyModel(
        name: 'Ms. Iyer',
        role: 'Girls B · Day shift',
        phone: '+91 98xxxx 3346',
        status: 'ON DUTY',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => MainLayout.pushSubScreen(
          context,
          HostelWardensScreen(onBack: () => MainLayout.popSubScreen(context)),
        ),
        child: Container(
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
          child: Column(
            children: [
              ...wardens.map((warden) {
                final isOnDuty = warden.status == 'ON DUTY';
                final initials = warden.name
                    .split(' ')
                    .map((e) => e.isNotEmpty ? e[0] : '')
                    .join('')
                    .substring(0, 2)
                    .toUpperCase();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F0FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C4CF1),
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
                                  warden.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E2D),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  warden.role,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6C6C80),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                warden.phone,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isOnDuty
                                      ? const Color(0xFFDCFCE7)
                                      : const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  warden.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isOnDuty
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (warden != wardens.last)
                      const Divider(height: 1, color: Color(0xFFF3EEFF)),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingOutings() {
    final List<HostelOutpassModel> passes = [
      HostelOutpassModel(
        name: 'Rahul Sharma',
        details: 'Boys A · 203 · Family visit',
        time: 'Today 06:00 PM',
        status: 'DUE TODAY',
      ),
      HostelOutpassModel(
        name: 'Priya Singh',
        details: 'Girls A · 305 · Medical',
        time: 'Tomorrow 11:00 AM',
        status: 'APPROVED',
      ),
      HostelOutpassModel(
        name: 'Kabir Mehra',
        details: 'Boys B · 412 · Weekend leave',
        time: 'Mon 08:00 AM',
        status: 'APPROVED',
      ),
      HostelOutpassModel(
        name: 'Sneha Iyer',
        details: 'Girls B · 218 · Family event',
        time: 'Pending approval',
        status: 'PENDING',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => MainLayout.pushSubScreen(
          context,
          OutingPassScreen(onBack: () => MainLayout.popSubScreen(context)),
        ),
        child: Container(
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
          child: Column(
            children: [
              ...passes.map((pass) {
                Color statusColor;
                Color statusBgColor;
                if (pass.status == 'APPROVED') {
                  statusColor = const Color(0xFF16A34A);
                  statusBgColor = const Color(0xFFDCFCE7);
                } else if (pass.status == 'DUE TODAY') {
                  statusColor = const Color(0xFFF59E0B);
                  statusBgColor = const Color(0xFFFEF3C7);
                } else {
                  statusColor = const Color(0xFFE11D48);
                  statusBgColor = const Color(0xFFFFE4E6);
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFE0F2FE,
                              ).withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                LucideIcons.logOut,
                                color: Color(0xFF0EA5E9),
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pass.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E2D),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  pass.details,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6C6C80),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                pass.time,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBgColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  pass.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (pass != passes.last)
                      const Divider(height: 1, color: Color(0xFFF3EEFF)),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentWelfare() {
    final List<HostelWelfareModel> records = [
      HostelWelfareModel(
        title: 'Medical Assistance',
        student: 'Amit Kumar',
        location: 'Boys A · 104',
        status: 'URGENT',
      ),
      HostelWelfareModel(
        title: 'Counseling Session',
        student: 'Priya Singh',
        location: 'Girls B · 201',
        status: 'SCHEDULED',
      ),
      HostelWelfareModel(
        title: 'Fever check',
        student: 'Rahul Sharma',
        location: 'Boys A · 203',
        status: 'RESOLVED',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => MainLayout.pushSubScreen(
          context,
          HostelHealthScreen(onBack: () => MainLayout.popSubScreen(context)),
        ),
        child: Container(
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
          child: Column(
            children: [
              ...records.map((record) {
                Color statusColor;
                Color statusBgColor;
                if (record.status == 'RESOLVED') {
                  statusColor = const Color(0xFF16A34A);
                  statusBgColor = const Color(0xFFDCFCE7);
                } else if (record.status == 'SCHEDULED') {
                  statusColor = const Color(0xFFF59E0B);
                  statusBgColor = const Color(0xFFFEF3C7);
                } else {
                  statusColor = const Color(0xFFE11D48);
                  statusBgColor = const Color(0xFFFFE4E6);
                }

                IconData icon = record.title.contains('Counsel')
                    ? LucideIcons.userPlus
                    : LucideIcons.activity;
                Color iconColor = record.title.contains('Counsel')
                    ? const Color(0xFF6C4CF1)
                    : const Color(0xFFEF4444);
                Color iconBgColor = record.title.contains('Counsel')
                    ? const Color(0xFFF3F0FF)
                    : const Color(0xFFFFE4E6);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: iconBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(icon, color: iconColor, size: 20),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E2D),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${record.student} · ${record.location}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6C6C80),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBgColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  record.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (record != records.last)
                      const Divider(height: 1, color: Color(0xFFF3EEFF)),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaintenance() {
    final List<HostelMaintenanceModel> issues = [
      HostelMaintenanceModel(
        issue: 'AC not cooling',
        location: 'Boys B · 402',
        reportedBy: 'Kabir Mehra',
        status: 'IN PROGRESS',
      ),
      HostelMaintenanceModel(
        issue: 'Tap leaking',
        location: 'Girls A · Washroom 3',
        reportedBy: 'Housekeeping',
        status: 'REPORTED',
      ),
      HostelMaintenanceModel(
        issue: 'Broken light',
        location: 'Boys A · Corridor 1',
        reportedBy: 'Warden',
        status: 'RESOLVED',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => MainLayout.pushSubScreen(
          context,
          HostelMaintenanceScreen(
            onBack: () => MainLayout.popSubScreen(context),
          ),
        ),
        child: Container(
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
          child: Column(
            children: [
              ...issues.map((issue) {
                Color statusColor;
                Color statusBgColor;
                if (issue.status == 'RESOLVED') {
                  statusColor = const Color(0xFF16A34A);
                  statusBgColor = const Color(0xFFDCFCE7);
                } else if (issue.status == 'IN PROGRESS') {
                  statusColor = const Color(0xFFF59E0B);
                  statusBgColor = const Color(0xFFFEF3C7);
                } else {
                  statusColor = const Color(0xFFE11D48);
                  statusBgColor = const Color(0xFFFFE4E6);
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                LucideIcons.wrench,
                                color: Color(0xFFF59E0B),
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  issue.issue,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E2D),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${issue.location} · By: ${issue.reportedBy}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6C6C80),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBgColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  issue.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (issue != issues.last)
                      const Divider(height: 1, color: Color(0xFFF3EEFF)),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomOccupancySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => MainLayout.pushSubScreen(
          context,
          HostelRoomsScreen(onBack: () => MainLayout.popSubScreen(context)),
        ),
        child: Container(
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
                  const Text(
                    'Room Occupancy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => MainLayout.pushSubScreen(
                      context,
                      HostelRoomsScreen(
                        onBack: () => MainLayout.popSubScreen(context),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          'See all',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C4CF1),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: Color(0xFF6C4CF1),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Donut Chart
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: 140,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: CustomPaint(
                              painter: DonutChartPainter(
                                percentage1: 70, // Green (Occupied)
                                percentage2: 15, // Red (Full)
                                percentage3: 15, // Orange (Near Full)
                                strokeWidth: 24,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '90%',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E1E2D),
                                  height: 1.1,
                                ),
                              ),
                              Text(
                                'Occupied',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6C6C80),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Stats List
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        _buildBlockOccupancyRow(
                          color: const Color(0xFFF59E0B),
                          bgColor: const Color(0xFFFFFBEB),
                          title: 'Boys Hostel A',
                          occupancy: '102/104',
                          percentage: '98%',
                        ),
                        _buildDottedDivider(),
                        _buildBlockOccupancyRow(
                          color: const Color(0xFF22C55E),
                          bgColor: const Color(0xFFDCFCE7),
                          title: 'Boys Hostel B',
                          occupancy: '72/95',
                          percentage: '76%',
                        ),
                        _buildDottedDivider(),
                        _buildBlockOccupancyRow(
                          color: const Color(0xFFEF4444),
                          bgColor: const Color(0xFFFFE4E6),
                          title: 'Girls Hostel A',
                          occupancy: '96/96',
                          percentage: '100%',
                        ),
                        _buildDottedDivider(),
                        _buildBlockOccupancyRow(
                          color: const Color(0xFF22C55E),
                          bgColor: const Color(0xFFDCFCE7),
                          title: 'Girls Hostel B',
                          occupancy: '60/72',
                          percentage: '83%',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0xFFF3EEFF)),
              const SizedBox(height: 16),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          LucideIcons.building,
                          color: Color(0xFF6C4CF1),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Total Capacity',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6C6C80),
                            ),
                          ),
                          Text(
                            '367 Rooms',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: const Color(0xFFF3EEFF),
                  ),
                  Row(
                    children: [
                      _buildLegendItem(
                        color: const Color(0xFF22C55E),
                        label: 'Occupied',
                      ),
                      const SizedBox(width: 12),
                      _buildLegendItem(
                        color: const Color(0xFFF59E0B),
                        label: 'Near Full',
                      ),
                      const SizedBox(width: 12),
                      _buildLegendItem(
                        color: const Color(0xFFEF4444),
                        label: 'Full',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlockOccupancyRow({
    required Color color,
    required Color bgColor,
    required String title,
    required String occupancy,
    required String percentage,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  occupancy,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A4A68),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            percentage,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDottedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 4.0;
          const dashHeight = 1.0;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFE5E7EB)),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF4A4A68),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
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
              children:
                  [
                        {
                          'label': 'Room\nAllocation',
                          'icon': LucideIcons.bedDouble,
                          'screen': HostelRoomsScreen(
                            onBack: () => MainLayout.popSubScreen(context),
                          ),
                        },
                        {
                          'label': 'Mess\nMenu',
                          'icon': LucideIcons.utensils,
                          'screen': MessMenuScreen(
                            onBack: () => MainLayout.popSubScreen(context),
                          ),
                        },
                        {
                          'label': 'Attendance',
                          'icon': LucideIcons.clipboardCheck,
                          'screen': HostelAttendanceScreen(
                            onBack: () => MainLayout.popSubScreen(context),
                          ),
                        },
                        {
                          'label': 'Broadcast\nMsg',
                          'icon': LucideIcons.megaphone,
                          'screen': MessagesScreen(
                            onBack: () => MainLayout.popSubScreen(context),
                          ),
                        },
                        {
                          'label': 'Inventory',
                          'icon': LucideIcons.package,
                          'screen': InventoryScreen(
                            onBack: () => MainLayout.popSubScreen(context),
                          ),
                        },
                        {
                          'label': 'Maintenance',
                          'icon': LucideIcons.wrench,
                          'screen': HostelMaintenanceScreen(
                            onBack: () => MainLayout.popSubScreen(context),
                          ),
                        },
                        {
                          'label': 'Staff',
                          'icon': LucideIcons.users,
                          'screen': HostelWardensScreen(
                            onBack: () => MainLayout.popSubScreen(context),
                          ),
                        },
                        {
                          'label': 'Reports',
                          'icon': LucideIcons.fileText,
                          'screen': ReportsScreen(
                            onBack: () => MainLayout.popSubScreen(context),
                          ),
                        },
                      ]
                      .where((action) {
                        if (_searchQuery.isEmpty) return true;
                        return (action['label'] as String)
                            .toLowerCase()
                            .replaceAll('\n', ' ')
                            .contains(_searchQuery.toLowerCase());
                      })
                      .map((action) {
                        return _buildActionItem(
                          action['label'] as String,
                          action['icon'] as IconData,
                          onTap: () {
                            MainLayout.pushSubScreen(
                              context,
                              action['screen'] as Widget,
                            );
                          },
                        );
                      })
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(String label, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF6C4CF1).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF6C4CF1), size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class WardenOnDutyModel {
  final String name;
  final String role;
  final String phone;
  final String status;

  WardenOnDutyModel({
    required this.name,
    required this.role,
    required this.phone,
    required this.status,
  });
}

class HostelOutpassModel {
  final String name;
  final String details;
  final String time;
  final String status;

  HostelOutpassModel({
    required this.name,
    required this.details,
    required this.time,
    required this.status,
  });
}

class DonutChartPainter extends CustomPainter {
  final double percentage1;
  final double percentage2;
  final double percentage3;
  final double strokeWidth;

  DonutChartPainter({
    required this.percentage1,
    required this.percentage2,
    required this.percentage3,
    this.strokeWidth = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - strokeWidth / 2;

    final paint1 = Paint()
      ..color =
          const Color(0xFF22C55E) // Green
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final paint2 = Paint()
      ..color =
          const Color(0xFFEF4444) // Red
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final paint3 = Paint()
      ..color =
          const Color(0xFFF59E0B) // Orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final double total = percentage1 + percentage2 + percentage3;
    final double sweepGreen = (percentage1 / total) * 2 * math.pi;
    final double sweepRed = (percentage2 / total) * 2 * math.pi;
    final double sweepOrange = (percentage3 / total) * 2 * math.pi;

    double startAngle = -math.pi / 2;
    final double gap = 0.08;

    // Orange
    if (sweepOrange > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + gap / 2,
        math.max(0, sweepOrange - gap),
        false,
        paint3,
      );
    }
    startAngle += sweepOrange;
    // Green
    if (sweepGreen > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + gap / 2,
        math.max(0, sweepGreen - gap),
        false,
        paint1,
      );
    }
    startAngle += sweepGreen;
    // Red
    if (sweepRed > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + gap / 2,
        math.max(0, sweepRed - gap),
        false,
        paint2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HostelScheduleModel {
  final String time;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String status;
  final Color statusColor;
  final Color statusBg;

  HostelScheduleModel({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.status,
    required this.statusColor,
    required this.statusBg,
  });
}

class HostelWelfareModel {
  final String title;
  final String student;
  final String location;
  final String status;

  HostelWelfareModel({
    required this.title,
    required this.student,
    required this.location,
    required this.status,
  });
}

class HostelMaintenanceModel {
  final String issue;
  final String location;
  final String reportedBy;
  final String status;

  HostelMaintenanceModel({
    required this.issue,
    required this.location,
    required this.reportedBy,
    required this.status,
  });
}

class HostelTaskModel {
  final String title;
  final String time;
  final IconData icon;
  final Color color;
  final Color bgColor;

  HostelTaskModel({
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}
