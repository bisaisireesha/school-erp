import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';
import 'transport_drivers_screen.dart';
import 'transport_compliance_screen.dart';
import 'transport_student_assignment_screen.dart';
import 'transport_fee_collection_screen.dart';
import 'transport_calendar_screen.dart';
import 'transport_profile_screen.dart';

class TransportMoreScreen extends StatefulWidget {
  const TransportMoreScreen({super.key});

  @override
  State<TransportMoreScreen> createState() => _TransportMoreScreenState();
}

class _TransportMoreScreenState extends State<TransportMoreScreen> {
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

  static const List<Map<String, dynamic>> _transportActions = [
    {'title': 'Drivers & Staff', 'icon': LucideIcons.users, 'key': 'Drivers & Staff'},
    {'title': 'Compliance', 'icon': LucideIcons.shieldCheck, 'key': 'Compliance'},
    {'title': 'Fee Collection', 'icon': LucideIcons.wallet, 'key': 'Fee Collection'},
    {'title': 'Student Assignments', 'icon': LucideIcons.userCheck, 'key': 'Student Assignments'},
    {'title': 'Calendar & Events', 'icon': LucideIcons.calendar, 'key': 'Calendar & Events'},
  ];

  List<Map<String, dynamic>> _filterActions(List<Map<String, dynamic>> actions) {
    if (_searchQuery.isEmpty) return actions;
    return actions
        .where((action) => (action['title'] as String)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredActions = _filterActions(_transportActions);

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
          if (filteredActions.isNotEmpty) ...[
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildActionSection(context, 'Transport Management', filteredActions),
            ),
          ],
          if (filteredActions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(
                  'No matching items found',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                ),
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
          MaterialPageRoute(builder: (context) => const TransportProfileScreen()),
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
                  'SK',
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
                    'Suresh Kumar',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Transport Manager',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
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
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16A34A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(
    BuildContext context,
    String sectionTitle,
    List<Map<String, dynamic>> actions,
  ) {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFF3EEFF),
                    width: 1.5,
                  ),
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
                      child: Icon(
                        item['icon'] as IconData,
                        color: const Color(0xFF6C4CF1),
                        size: 22,
                      ),
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
    if (key == 'Drivers & Staff') {
      MainLayout.pushSubScreen(context, const TransportDriversScreen());
    } else if (key == 'Compliance') {
      MainLayout.pushSubScreen(context, const TransportComplianceScreen());
    } else if (key == 'Student Assignments') {
      MainLayout.pushSubScreen(context, const TransportStudentAssignmentScreen());
    } else if (key == 'Fee Collection') {
      MainLayout.pushSubScreen(context, const TransportFeeCollectionScreen());
    } else if (key == 'Calendar & Events') {
      MainLayout.pushSubScreen(context, TransportCalendarScreen(onBack: () => MainLayout.popSubScreen(context)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigating to $key...')),
      );
    }
  }
}
