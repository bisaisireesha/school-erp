import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../auth/login_screen.dart';

class TransportProfileScreen extends StatelessWidget {
  const TransportProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Color(0xFF1E1E2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1E1E2D),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(LucideIcons.edit2, color: Color(0xFF6C4CF1), size: 18),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildSectionTitle('Professional Information'),
            const SizedBox(height: 16),
            _buildInfoCard([
              _buildInfoRow(LucideIcons.building, 'Department', 'Transport & Fleet Logistics'),
              _buildInfoRow(LucideIcons.briefcase, 'Designation & Role', 'Senior Transport Manager'),
              _buildInfoRow(LucideIcons.bookOpen, 'Specialization', 'Fleet Management & Routing'),
              _buildInfoRow(LucideIcons.graduationCap, 'Qualification & Degrees', 'B.Tech (Automobile), Logistics Cert.'),
              _buildInfoRow(LucideIcons.award, 'Years of Experience', '12 Years'),
              _buildInfoRow(LucideIcons.calendar, 'Joining Date', '15 Aug 2018'),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Contact Information'),
            const SizedBox(height: 16),
            _buildInfoCard([
              _buildInfoRow(LucideIcons.mail, 'Official Email', 'suresh.kumar@sunrise.edu'),
              _buildInfoRow(LucideIcons.phone, 'Phone Number', '+91 98765 12345'),
              _buildInfoRow(LucideIcons.mapPin, 'Office Location', 'Transport Office, Block C'),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Operational Information'),
            const SizedBox(height: 16),
            _buildInfoCard([
              _buildInfoRow(LucideIcons.bus, 'Total Fleet Managed', '35 Vehicles'),
              _buildInfoRow(LucideIcons.map, 'Assigned Routes', 'All Main City Routes'),
              _buildInfoRow(LucideIcons.shieldCheck, 'Reporting Department', 'Administration Board'),
            ]),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(LucideIcons.logOut, color: Color(0xFFEF4444)),
                label: const Text(
                  'Logout of Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEF2F2),
                  foregroundColor: const Color(0xFFEF4444),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: const Color(0xFFEF4444).withValues(alpha: 0.2)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF6C4CF1), width: 1.5),
            ),
            child: Center(
              child: Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F0FF),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'SK',
                    style: TextStyle(
                      color: Color(0xFF6C4CF1),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Suresh Kumar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'ID: TRN-9012',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Transport Manager',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4A68),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Transport & Fleet Logistics',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1E1E2D),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF6C4CF1), size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1E2D),
                    height: 1.4,
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
