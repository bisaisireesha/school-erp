import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class DriverProfileScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const DriverProfileScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out of your driver account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
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

  void _showPersonalInfoBottomSheet(BuildContext context) {
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
                  const Text(
                    'Personal & Vehicle Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFF0EDF8)),
                  const SizedBox(height: 14),
                  _buildModalDetailRow('Full Name', 'Rajesh Kumar'),
                  const SizedBox(height: 10),
                  _buildModalDetailRow('Employee ID', 'EMP-DRV-102'),
                  const SizedBox(height: 10),
                  _buildModalDetailRow('Phone Number', '+91 98765 43210'),
                  const SizedBox(height: 10),
                  _buildModalDetailRow('License Number', 'DL-14201100982 (Valid till Oct 2029)'),
                  const SizedBox(height: 10),
                  _buildModalDetailRow('License Class', 'Heavy Passenger Vehicle (HPV)'),
                  const SizedBox(height: 10),
                  _buildModalDetailRow('Assigned Vehicle', 'BUS-01 (KA-05-EX-4029)'),
                  const SizedBox(height: 10),
                  _buildModalDetailRow('Vehicle Model', 'Tata Starbus 40-Seater'),

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

  void _showHelpSupportBottomSheet(BuildContext context) {
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
                  const Row(
                    children: [
                      Icon(LucideIcons.headset, color: Color(0xFF6C4CF1), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Help & Support',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFF0EDF8)),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF0EDF8)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Emergency Transport Desk', style: TextStyle(fontSize: 12.5, color: Color(0xFF7A7A9D))),
                        SizedBox(height: 2),
                        Text('+91 98765 00000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        SizedBox(height: 8),
                        Text('School Safety Dispatch', style: TextStyle(fontSize: 12.5, color: Color(0xFF7A7A9D))),
                        SizedBox(height: 2),
                        Text('+91 98765 99999', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Text(
                    'Need assistance with your route, bus maintenance, or GPS tracking? Contact your transport supervisor directly via the hotline above.',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.4),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: AppSpacing.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Got it'),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 90.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Back Arrow & Page Title (NO Edit button)
              Row(
                children: [
                  if (onBack != null) ...[
                    AppBackButton(onPressed: onBack!),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'Profile & Account Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Driver Profile Header Card
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: AppShadows.soft,
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                ),
                child: Row(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEFF),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF6C4CF1), width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          'RK',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C4CF1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Driver Profile Details
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rajesh Kumar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Bus Driver • BUS-01',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF7A7A9D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'ID: EMP-DRV-102 • +91 98765 43210',
                            style: TextStyle(
                              fontSize: 11.5,
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

              const SizedBox(height: 20),

              // Account Settings Options Title
              const Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),

              // Account Settings List (Personal Information, Help & Support, Log Out)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: AppShadows.soft,
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                ),
                child: Column(
                  children: [
                    // Option 1: Personal Information
                    InkWell(
                      onTap: () => _showPersonalInfoBottomSheet(context),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3EEFF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.user, size: 18, color: Color(0xFF6C4CF1)),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Personal Information',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                  ),
                                  Text(
                                    'View personal, vehicle & license details',
                                    style: TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFF0EDF8)),

                    // Option 2: Help & Support
                    InkWell(
                      onTap: () => _showHelpSupportBottomSheet(context),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEBF5FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.helpCircle, size: 18, color: Color(0xFF3B82F6)),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Help & Support',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                  ),
                                  Text(
                                    'Get help or contact transport supervisor',
                                    style: TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFF0EDF8)),

                    // Option 3: Log Out
                    InkWell(
                      onTap: () => _handleLogout(context),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFEF2F2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.logOut, size: 18, color: Color(0xFFEF4444)),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                  Text(
                                    'Sign out of your driver account',
                                    style: TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
