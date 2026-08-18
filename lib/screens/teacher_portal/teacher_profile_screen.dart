import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class TeacherProfileScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const TeacherProfileScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Logout', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
        content: const Text('Are you sure you want to log out of your teacher faculty account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF7A7A9D))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showEditProfileNotice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(LucideIcons.info, size: 16, color: Colors.white),
            SizedBox(width: 8),
            Text('Contact HR Administration to update official faculty records.'),
          ],
        ),
        backgroundColor: const Color(0xFF6C4CF1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = data['teacherProfile'] as Map<String, dynamic>? ?? {};
    final String name = profile['name'] ?? 'Sarah Williams';
    final String id = profile['id'] ?? 'TCH-2048';
    final String designation = profile['designation'] ?? 'Senior Faculty';
    final String specialization = profile['specialization'] ?? 'Mathematics & Physics';
    final String dept = profile['department'] ?? 'Department of STEM Education';
    final String email = profile['email'] ?? 'sarah.williams@sunrise.edu';
    final String phone = profile['phone'] ?? '+1 (555) 345-6789';
    final String office = profile['office'] ?? 'Room 204, Faculty Wing B';
    final String joinDate = profile['joiningDate'] ?? '10 Jul 2020';
    final String experience = profile['experience'] ?? '8+ Years';
    final String qualification = profile['qualification'] ?? 'M.Sc. Applied Mathematics, B.Ed.';
    final String classes = profile['classesAssigned'] ?? 'Class 10-A, Class 10-B, Class 9-C';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (Standard Back Button, Title, and Edit Icon)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  if (onBack != null) ...[
                    AppBackButton(onPressed: onBack!),
                    const SizedBox(width: 4),
                  ],
                  const Expanded(
                    child: Text(
                      'Teacher Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showEditProfileNotice(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F7FC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF0EEF8)),
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.edit2,
                          size: 16,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF0EEF8)),

            // 2. Profile Content Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. Profile Summary Card (Visually prominent but compact)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF0EEF8)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x061E1E2D),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F0FF),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF6C4CF1), width: 1.5),
                            ),
                            child: const Center(
                              child: Text(
                                'SW',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF6C4CF1),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E1E2D),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F0FF),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'ID: $id',
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6C4CF1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        designation,
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF475569),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  specialization,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // B. Professional Information Card
                    _buildSectionHeader('Professional Information'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF0EEF8)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x041E1E2D),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: LucideIcons.building,
                            label: 'Department',
                            value: dept,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: LucideIcons.briefcase,
                            label: 'Designation & Role',
                            value: designation,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: LucideIcons.bookOpen,
                            label: 'Specialization',
                            value: specialization,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: LucideIcons.graduationCap,
                            label: 'Qualification & Degrees',
                            value: qualification,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: LucideIcons.award,
                            label: 'Years of Experience',
                            value: experience,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: LucideIcons.calendar,
                            label: 'Joining Date',
                            value: joinDate,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: LucideIcons.layoutGrid,
                            label: 'Assigned Classes',
                            value: classes,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // C. Contact Information Card
                    _buildSectionHeader('Contact Information'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF0EEF8)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x041E1E2D),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: LucideIcons.mail,
                            label: 'Official Email',
                            value: email,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: LucideIcons.phone,
                            label: 'Phone Number',
                            value: phone,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: LucideIcons.mapPin,
                            label: 'Faculty Office',
                            value: office,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // D. Compact Teaching Information
                    _buildSectionHeader('Teaching Information'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF0EEF8)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x041E1E2D),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: LucideIcons.fileText,
                            label: 'Subjects Taught',
                            value: 'Advanced Mathematics, Physics Lab',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: LucideIcons.calendarDays,
                            label: 'Academic Year',
                            value: '2026 – 2027',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: LucideIcons.shieldCheck,
                            label: 'Reporting Department',
                            value: 'STEM Faculty Board',
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // E. Logout Action
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => _handleLogout(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFEF2F2),
                          foregroundColor: const Color(0xFFEF4444),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFFFEE2E2)),
                          ),
                        ),
                        icon: const Icon(LucideIcons.logOut, size: 17, color: Color(0xFFEF4444)),
                        label: const Text(
                          'Logout of Faculty Account',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E1E2D),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 44,
      endIndent: 14,
      color: Color(0xFFF4F3F8),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, color: const Color(0xFF6C4CF1), size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
