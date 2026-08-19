import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../hostel/hostel_screen.dart';
import '../hostel/hostel_students_screen.dart';
import '../hostel/hostel_blocks_screen.dart';
import '../hostel/hostel_wardens_screen.dart';
import '../hostel/hostel_attendance_screen.dart';
import '../hostel/hostel_visitors_screen.dart';
import '../hostel/outing_pass_screen.dart';
import '../attendance/attendance_screen.dart';
import '../profile/profile_screen.dart';
import '../main_layout.dart';

import '../hostel/hostel_health_screen.dart';
import '../hostel/hostel_maintenance_screen.dart';
import '../hostel_warden/mess_dashboard_screen.dart';
import '../hostel_warden/mess_menu_screen.dart';
import '../hostel_warden/inventory_screen.dart';
import '../hostel_warden/vendors_screen.dart';
import '../hostel_warden/reports_screen.dart';

class WardenMoreScreen extends StatefulWidget {
  const WardenMoreScreen({super.key});

  @override
  State<WardenMoreScreen> createState() => _WardenMoreScreenState();
}

class _WardenMoreScreenState extends State<WardenMoreScreen> {
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

  static const List<Map<String, dynamic>> _hostelActions = [
    {'title': 'Hostel Students', 'icon': LucideIcons.users, 'key': 'Hostel Students'},
    {'title': 'Blocks', 'icon': LucideIcons.building, 'key': 'Blocks'},
    {'title': 'Wardens', 'icon': LucideIcons.shield, 'key': 'Wardens'},
    {'title': 'Hostel Attendance', 'icon': LucideIcons.calendarCheck, 'key': 'Hostel Attendance'},
    {'title': 'Visitors', 'icon': LucideIcons.userCheck, 'key': 'Visitors'},
    {'title': 'Health & Medical', 'icon': LucideIcons.heartPulse, 'key': 'Health & Medical'},
    {'title': 'Maintenance', 'icon': LucideIcons.wrench, 'key': 'Maintenance'},
  ];

  static const List<Map<String, dynamic>> _messActions = [
    {'title': 'Mess Dashboard', 'icon': LucideIcons.layoutDashboard, 'key': 'Mess Dashboard'},
    {'title': 'Mess Menu', 'icon': LucideIcons.utensils, 'key': 'Mess Menu'},
    {'title': 'Inventory', 'icon': LucideIcons.boxes, 'key': 'Inventory'},
    {'title': 'Vendors', 'icon': LucideIcons.truck, 'key': 'Vendors'},
  ];

  static const List<Map<String, dynamic>> _reportActions = [
    {'title': 'Reports', 'icon': LucideIcons.barChart3, 'key': 'Reports'},
  ];

  List<Map<String, dynamic>> _filterActions(List<Map<String, dynamic>> actions) {
    if (_searchQuery.isEmpty) return actions;
    return actions.where((action) => (action['title'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredHostelActions = _filterActions(_hostelActions);
    final filteredMessActions = _filterActions(_messActions);
    final filteredReportActions = _filterActions(_reportActions);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildProfileHeader(context),
          ),
          if (filteredHostelActions.isNotEmpty) ...[
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildActionSection(context, 'Hostel Management', filteredHostelActions),
            ),
          ],
          if (filteredMessActions.isNotEmpty) ...[
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildActionSection(context, 'Mess Management', filteredMessActions),
            ),
          ],
          if (filteredReportActions.isNotEmpty) ...[
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildActionSection(context, 'Reports & Analytics', filteredReportActions),
            ),
          ],
          if (filteredHostelActions.isEmpty && filteredMessActions.isEmpty && filteredReportActions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text('No matching items found', style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
              ),
            ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
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
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F0FF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'RV',
                  style: TextStyle(
                    color: Color(0xFF6C4CF1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ramesh Verma',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hostel Warden - Block B',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Warden',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(BuildContext context, String sectionTitle, List<Map<String, dynamic>> actions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.90,
          ),
          itemBuilder: (context, index) {
            final item = actions[index];
            return GestureDetector(
              onTap: () => _handleTap(context, item['key'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE8E3F8).withValues(alpha: 0.45),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F0FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'] as IconData, color: const Color(0xFF6C4CF1), size: 22),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _handleTap(BuildContext context, String key) {
    if (key == 'Outings') {
      MainLayout.pushSubScreen(context, OutingPassScreen(onBack: () => MainLayout.popSubScreen(context)));
      return;
    }
    if (key == 'Visitors') {
      MainLayout.pushSubScreen(context, HostelVisitorsScreen(onBack: () => MainLayout.popSubScreen(context)));
      return;
    }
    if (key == 'Hostel Students') {
      MainLayout.pushSubScreen(context, HostelStudentsScreen(onBack: () => MainLayout.popSubScreen(context)));
      return;
    }
    if (key == 'Blocks') {
      MainLayout.pushSubScreen(context, HostelBlocksScreen(onBack: () => MainLayout.popSubScreen(context)));
      return;
    }
    if (key == 'Wardens') {
      MainLayout.pushSubScreen(context, HostelWardensScreen(onBack: () => MainLayout.popSubScreen(context)));
      return;
    }
    if (key == 'Hostel Attendance') {
      MainLayout.pushSubScreen(context, HostelAttendanceScreen(onBack: () => MainLayout.popSubScreen(context)));
      return;
    }
    if (key == 'Health & Medical') {
      MainLayout.pushSubScreen(context, HostelHealthScreen(onBack: () => MainLayout.popSubScreen(context)));
      return;
    }
    if (key == 'Maintenance') {
      MainLayout.pushSubScreen(context, HostelMaintenanceScreen(onBack: () => MainLayout.popSubScreen(context)));
      return;
    }
    if (key == 'Mess Dashboard') {
      MainLayout.pushSubScreen(context, MessDashboardScreen(onBack: () => MainLayout.popSubScreen(context)));
      return;
    }

    switch (key) {
      case 'Hostel Students':
      case 'Blocks':
      case 'Wardens':
      case 'Visitors':
        MainLayout.pushSubScreen(context, HostelScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
      case 'Vendors':
        MainLayout.pushSubScreen(context, VendorsScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
      case 'Inventory':
        MainLayout.pushSubScreen(context, InventoryScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
      case 'Mess Menu':
        MainLayout.pushSubScreen(context, MessMenuScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
      case 'Hostel Attendance':
        MainLayout.pushSubScreen(context, AttendanceScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
      case 'Reports':
        MainLayout.pushSubScreen(context, ReportsScreen(onBack: () => MainLayout.popSubScreen(context)));
        break;
    }
  }
}
