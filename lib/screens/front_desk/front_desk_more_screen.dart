import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';
import '../profile/profile_screen.dart';
import '../profile/personal_information_screen.dart';
import 'appointments_screen.dart';
import 'postal_records_screen.dart';
import 'complaints_screen.dart';
import 'certificates_screen.dart';
import 'call_logs_screen.dart';
import 'lost_and_found_screen.dart';
import 'tasks_screen.dart';
import 'front_desk_reports_screen.dart';

class FrontDeskMoreScreen extends StatefulWidget {
  const FrontDeskMoreScreen({super.key});

  @override
  State<FrontDeskMoreScreen> createState() => _FrontDeskMoreScreenState();
}

class _FrontDeskMoreScreenState extends State<FrontDeskMoreScreen> {
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

  static const List<Map<String, dynamic>> _operationsActions = [
    {'title': 'Appointments', 'icon': LucideIcons.calendarCheck, 'key': 'Appointments'},
    {'title': 'Postal Records', 'icon': LucideIcons.mailbox, 'key': 'Postal Records'},
    {'title': 'Complaints', 'icon': LucideIcons.messageCircleWarning, 'key': 'Complaints'},
    {'title': 'Call Log', 'icon': LucideIcons.phoneIncoming, 'key': 'Call Log'},
  ];

  static const List<Map<String, dynamic>> _otherActions = [
    {'title': 'Certificates', 'icon': LucideIcons.award, 'key': 'Certificates'},
    {'title': 'Lost & Found', 'icon': LucideIcons.searchCheck, 'key': 'Lost & Found'},
    {'title': 'Tasks', 'icon': LucideIcons.listChecks, 'key': 'Tasks'},
    {'title': 'Reports', 'icon': LucideIcons.chartNoAxesCombined, 'key': 'Reports'},
  ];

  List<Map<String, dynamic>> _filterActions(List<Map<String, dynamic>> actions) {
    if (_searchQuery.isEmpty) return actions;
    return actions.where((action) => (action['title'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredOps = _filterActions(_operationsActions);
    final filteredOther = _filterActions(_otherActions);

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
          if (filteredOps.isNotEmpty) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildActionSection(context, 'Front Desk Operations', filteredOps),
            ),
          ],
          if (filteredOther.isNotEmpty) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildActionSection(context, 'Other Tools', filteredOther),
            ),
          ],
          if (filteredOps.isEmpty && filteredOther.isEmpty)
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
              color: const Color(0xFFE8E3F8).withOpacity(0.5),
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
                  'AT',
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
                    'Aditi Tiwari',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Front Desk Executive',
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
                'Staff',
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
        Text(sectionTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            final item = actions[index];
            return GestureDetector(
              onTap: () {
                if (item['key'] == 'Appointments') {
                  MainLayout.pushSubScreen(context, AppointmentsScreen(onBack: () => MainLayout.popSubScreen(context)));
                } else if (item['key'] == 'Postal Records') {
                  MainLayout.pushSubScreen(context, PostalRecordsScreen(onBack: () => MainLayout.popSubScreen(context)));
                } else if (item['key'] == 'Complaints') {
                  MainLayout.pushSubScreen(context, ComplaintsScreen(onBack: () => MainLayout.popSubScreen(context)));
                } else if (item['key'] == 'Certificates') {
                  MainLayout.pushSubScreen(context, CertificatesScreen(onBack: () => MainLayout.popSubScreen(context)));
                } else if (item['key'] == 'Call Log') {
                  MainLayout.pushSubScreen(context, CallLogsScreen(onBack: () => MainLayout.popSubScreen(context)));
                } else if (item['key'] == 'Lost & Found') {
                  MainLayout.pushSubScreen(context, LostAndFoundScreen(onBack: () => MainLayout.popSubScreen(context)));
                } else if (item['key'] == 'Tasks') {
                  MainLayout.pushSubScreen(context, TasksScreen(onBack: () => MainLayout.popSubScreen(context)));
                } else if (item['key'] == 'Reports') {
                  MainLayout.pushSubScreen(context, FrontDeskReportsScreen(onBack: () => MainLayout.popSubScreen(context)));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item['title']} clicked!')),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE8E3F8).withOpacity(0.5),
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
                      child: Icon(item['icon'] as IconData, color: const Color(0xFF6C4CF1), size: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A4A68),
                        height: 1.2,
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
}
