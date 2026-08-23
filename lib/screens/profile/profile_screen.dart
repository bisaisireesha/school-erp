import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'personal_information_screen.dart';
import 'notifications_settings_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final role = authProvider.currentUser?.role ?? 'parent';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Gradient Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 0.84, 1.0],
                  colors: [
                    const Color(0xFF995EFF).withValues(alpha: 0.40),
                    const Color(0xFFCCAEFF).withValues(alpha: 0.30),
                    const Color(0xFFFFFFFF).withValues(alpha: 0.20),
                    const Color(0xFFFFFFFF).withValues(alpha: 0.10),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildProfileSection(role),
                  const SizedBox(height: 24),
                  _buildRoleDetailsSection(role),
                  const SizedBox(height: 32),
                  _buildSettingsList(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
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
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalInformationScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Color(0xFF6C4CF1),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String role) {
    String name = 'Suresh Patel';
    String subtitle = 'Parent · 2 Children Enrolled';
    String initials = 'SP';
    String email = 'suresh.patel@email.com';
    String contact2 = '+91 98765 43210';
    IconData contact2Icon = LucideIcons.phone;
    String badge = 'Parent';
    Color badgeColor = const Color(0xFF6C4CF1);
    Color badgeBg = const Color(0xFFF3F0FF);
    String? extraPill;

    if (role == 'student') {
      name = 'Akshara';
      subtitle = 'Class 10-A | Roll No: 1042';
      initials = 'AK';
      email = 'akshara.s@school.edu';
      contact2 = 'ADM-2024-1042';
      contact2Icon = LucideIcons.badgeCheck;
      badge = 'Student';
      badgeColor = const Color(0xFF3B82F6);
      badgeBg = const Color(0xFFEFF6FF);
    } else if (role == 'warden') {
      name = 'Ramesh Verma';
      subtitle = 'Hostel Warden · Block A & B';
      initials = 'RV';
      email = 'warden.verma@school.edu';
      contact2 = '+91 98765 55443';
      contact2Icon = LucideIcons.phone;
      badge = 'Staff · Warden';
      badgeColor = const Color(0xFFF59E0B);
      badgeBg = const Color(0xFFFEF3C7);
      extraPill = 'Ext 104';
    } else if (role == 'front_desk') {
      name = 'Aditi Tiwari';
      subtitle = 'Front Desk Executive · Main Reception';
      initials = 'AT';
      email = 'frontdesk@school.edu';
      contact2 = '+91 98765 99887';
      contact2Icon = LucideIcons.phone;
      badge = 'Staff · Front Desk';
      badgeColor = const Color(0xFF10B981);
      badgeBg = const Color(0xFFD1FAE5);
      extraPill = 'Ext 205';
    } else if (role == 'accountant') {
      name = 'Arun Kumar';
      subtitle = 'Finance Department · Accountant';
      initials = 'AK';
      email = 'accountant@school.edu';
      contact2 = '+91 98765 12345';
      contact2Icon = LucideIcons.phone;
      badge = 'Staff · Accountant';
      badgeColor = const Color(0xFF6C4CF1);
      badgeBg = const Color(0xFFF3F0FF);
      extraPill = 'EMP-FIN-001';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Banner & Avatar
            SizedBox(
              height: 146,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      gradient: LinearGradient(
                        colors: [Color(0xFF6C4CF1), Color(0xFF9B7BFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    child: Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6C4CF1,
                            ).withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Color(0xFF6C4CF1),
                              fontWeight: FontWeight.w800,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1E2D),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6C4CF1),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Contact info pills
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildContactPill(LucideIcons.mail, email),
                _buildContactPill(contact2Icon, contact2),
                if (extraPill != null)
                  _buildContactPill(LucideIcons.phoneCall, extraPill),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleDetailsSection(String role) {
    if (role == 'front_desk') {
      return _buildFrontDeskDetailsSection();
    } else if (role == 'warden') {
      return _buildWardenDetailsSection();
    } else if (role == 'student') {
      return _buildStudentAcademicSection();
    } else if (role == 'accountant') {
      return const SizedBox.shrink();
    } else {
      return _buildMyChildrenSection();
    }
  }

  Widget _buildFrontDeskDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Front Desk Duty & Desk Info',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDutyInfoRow(
                  LucideIcons.badgeCheck,
                  'Staff ID',
                  'FD-108 (Permanent Staff)',
                ),
                const Divider(color: Color(0xFFF1F1F5), height: 20),
                _buildDutyInfoRow(
                  LucideIcons.clock,
                  'Shift Timings',
                  'Morning: 08:00 AM – 04:30 PM',
                ),
                const Divider(color: Color(0xFFF1F1F5), height: 20),
                _buildDutyInfoRow(
                  LucideIcons.mapPin,
                  'Desk Location',
                  'Main Reception Counter 1 (Ground Fl.)',
                ),
                const Divider(color: Color(0xFFF1F1F5), height: 20),
                _buildDutyInfoRow(
                  LucideIcons.phoneCall,
                  'Desk Intercom',
                  'Ext 205 / Line 2',
                ),
                const Divider(color: Color(0xFFF1F1F5), height: 20),
                _buildDutyInfoRow(
                  LucideIcons.userCheck,
                  'Reporting Authority',
                  'Administrative Officer (Main Office)',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWardenDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hostel Administration & Duty Info',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDutyInfoRow(
                  LucideIcons.shield,
                  'Warden ID',
                  'WDN-402 (Hostel Chief)',
                ),
                const Divider(color: Color(0xFFF1F1F5), height: 20),
                _buildDutyInfoRow(
                  LucideIcons.building2,
                  'Assigned Blocks',
                  'Boys Hostel Block A & Block B',
                ),
                const Divider(color: Color(0xFFF1F1F5), height: 20),
                _buildDutyInfoRow(
                  LucideIcons.users,
                  'Total Boarders',
                  '450 Resident Students',
                ),
                const Divider(color: Color(0xFFF1F1F5), height: 20),
                _buildDutyInfoRow(
                  LucideIcons.phoneCall,
                  'Hostel Helpline',
                  'Ext 104 (Control Room)',
                ),
                const Divider(color: Color(0xFFF1F1F5), height: 20),
                _buildDutyInfoRow(
                  LucideIcons.clock,
                  'Duty Hours',
                  '06:00 AM – 10:00 PM (Resident)',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentAcademicSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Academic & Class Info',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDutyInfoRow(
                  LucideIcons.graduationCap,
                  'Class & Section',
                  'Class 10-A (Secondary)',
                ),
                const Divider(color: Color(0xFFF1F1F5), height: 20),
                _buildDutyInfoRow(
                  LucideIcons.hash,
                  'Roll Number & ID',
                  'Roll No: 1042 · ADM-2024-1042',
                ),
                const Divider(color: Color(0xFFF1F1F5), height: 20),
                _buildDutyInfoRow(
                  LucideIcons.user,
                  'Class Teacher',
                  'Mrs. Sunita Rao (Mathematics)',
                ),
                const Divider(color: Color(0xFFF1F1F5), height: 20),
                _buildDutyInfoRow(
                  LucideIcons.flag,
                  'House Group',
                  'Ruby House (Red Tigers)',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDutyInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF6C4CF1)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8F90A6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3EEFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF9090A7)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A4A68),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyChildrenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'My Children',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              _buildChildCard(
                'Akshara',
                'Class 10-A · Roll No: 1042',
                'AK',
                const Color(0xFF6C4CF1),
                const Color(0xFFF3F0FF),
              ),
              const SizedBox(height: 12),
              _buildChildCard(
                'Aryan',
                'Class 7-B · Roll No: 708',
                'AR',
                const Color(0xFF0EA5E9),
                const Color(0xFFE0F2FE),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChildCard(
    String name,
    String grade,
    String initials,
    Color color,
    Color bgColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  grade,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            LucideIcons.chevronRight,
            color: Color(0xFFD1D5DB),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalInformationScreen(),
                ),
              );
            },
            child: _buildSettingsItem(
              LucideIcons.user,
              'Personal Information',
              const Color(0xFF6C4CF1),
              const Color(0xFFF3EEFF),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsSettingsScreen(),
                ),
              );
            },
            child: _buildSettingsItem(
              LucideIcons.bell,
              'Notifications',
              const Color(0xFF0EA5E9),
              const Color(0xFFE0F2FE),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
            child: _buildSettingsItem(
              LucideIcons.headphones,
              'Help & Support',
              const Color(0xFF16A34A),
              const Color(0xFFF0FDF4),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: _buildSettingsItem(
              LucideIcons.logOut,
              'Log Out',
              const Color(0xFFE11D48),
              const Color(0xFFFFF1F2),
              hideChevron: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    Color color,
    Color bgColor, {
    bool hideChevron = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E1E2D),
              ),
            ),
          ),
          if (!hideChevron)
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9090A7),
              size: 20,
            ),
        ],
      ),
    );
  }
}
