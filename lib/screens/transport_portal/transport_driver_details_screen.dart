import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TransportDriverDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> driverData;

  const TransportDriverDetailsScreen({
    super.key,
    required this.driverData,
  });

  @override
  Widget build(BuildContext context) {
    final String name = driverData['name'] as String? ?? 'Ramesh Kumar';
    final String role = driverData['role'] as String? ?? 'Driver';
    final String phone = driverData['phone'] as String? ?? '+91 98765 43210';
    final String assignedBus = driverData['assignedVehicle'] as String? ?? driverData['assignedBus'] as String? ?? 'BUS-01';
    final String route = driverData['route'] as String? ?? 'Route 1 - Green Glen';
    final String status = driverData['status'] as String? ?? 'Active';

    // Professional fields
    final String experience = driverData['experience'] as String? ?? '8 Years';
    final String previousEmployer = driverData['previousEmployer'] as String? ?? 'BMTC Transit Metro Division';
    final String employmentType = driverData['employmentType'] as String? ?? 'Full-Time';
    final String department = driverData['department'] as String? ?? 'Transport & Fleet Logistics';
    final String designation = driverData['designation'] as String? ?? (role == 'Driver' ? 'Senior Bus Driver' : 'Transport Escort');
    final String joiningDate = driverData['joiningDate'] as String? ?? '01 Jun 2021';
    final String emergencyContact = driverData['emergencyContact'] as String? ?? 'Sunita Kumar (+91 98112 33445)';

    // Driver licensing fields
    final String licenseNo = driverData['licenseNo'] as String? ?? 'DL-142020008891';
    final String licenseExpiry = driverData['licenseExpiry'] as String? ?? '12 Nov 2029';
    final String vehicleCategory = driverData['vehicleCategory'] as String? ?? 'Heavy Passenger Vehicle (Bus)';

    // Certifications & Qualifications
    final String certifications = driverData['certifications'] as String? ?? 'Defensive Driving, First Aid Certified';
    final String skills = driverData['skills'] as String? ?? 'Heavy Passenger Driving, CPR First Responder';

    final bool isDriver = role == 'Driver';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: () => Navigator.pop(context)),
        title: const Text(
          'Staff Profile Details',
          style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 18.5, letterSpacing: -0.3),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver Profile Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C4CF1), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(LucideIcons.userCheck, color: Colors.white, size: 28),
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
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$designation • $role',
                          style: const TextStyle(color: Colors.white70, fontSize: 12.0, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Experience: $experience • $employmentType',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11.5, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 1. Professional & Employment Details
            const Text(
              'Professional & Employment Information',
              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                children: [
                  _buildDetailRow('Designation', designation, icon: LucideIcons.briefcase, iconColor: const Color(0xFF6C4CF1)),
                  const Divider(height: 16, color: Color(0xFFF0EDF8)),
                  _buildDetailRow('Department', department, icon: LucideIcons.building2, iconColor: const Color(0xFF3B82F6)),
                  const Divider(height: 16, color: Color(0xFFF0EDF8)),
                  _buildDetailRow('Employment Type', employmentType, icon: LucideIcons.userCheck, iconColor: const Color(0xFF10B981)),
                  const Divider(height: 16, color: Color(0xFFF0EDF8)),
                  _buildDetailRow('Total Working Experience', experience, icon: LucideIcons.award, iconColor: const Color(0xFFF59E0B)),
                  const Divider(height: 16, color: Color(0xFFF0EDF8)),
                  _buildDetailRow('Previous Employer', previousEmployer, icon: LucideIcons.history, iconColor: const Color(0xFF8B5CF6)),
                  const Divider(height: 16, color: Color(0xFFF0EDF8)),
                  _buildDetailRow('Joining Date', joiningDate, icon: LucideIcons.calendar, iconColor: const Color(0xFF7A7A9D)),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 2. Licensing & Vehicle Authorization (If Driver)
            if (isDriver) ...[
              const Text(
                'Licensing & Vehicle Authorization',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  children: [
                    _buildDetailRow('License Number', licenseNo, icon: LucideIcons.fileText, iconColor: const Color(0xFF6C4CF1)),
                    const Divider(height: 16, color: Color(0xFFF0EDF8)),
                    _buildDetailRow('License Expiry', licenseExpiry, icon: LucideIcons.calendarCheck, iconColor: const Color(0xFF10B981)),
                    const Divider(height: 16, color: Color(0xFFF0EDF8)),
                    _buildDetailRow('Vehicle Category Authorized', vehicleCategory, icon: LucideIcons.shield, iconColor: const Color(0xFF3B82F6)),
                    const Divider(height: 16, color: Color(0xFFF0EDF8)),
                    _buildDetailRow('Assigned Bus No.', assignedBus, icon: LucideIcons.bus, iconColor: const Color(0xFFF59E0B)),
                    const Divider(height: 16, color: Color(0xFFF0EDF8)),
                    _buildDetailRow('Primary Route', route, icon: LucideIcons.mapPin, iconColor: const Color(0xFF06B6D4)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],

            // 3. Certifications & Qualifications
            const Text(
              'Certifications & Qualifications',
              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                children: [
                  _buildDetailRow('Certifications', certifications, icon: LucideIcons.badgeCheck, iconColor: const Color(0xFF10B981)),
                  const Divider(height: 16, color: Color(0xFFF0EDF8)),
                  _buildDetailRow('Skills & Expertise', skills, icon: LucideIcons.wrench, iconColor: const Color(0xFF6C4CF1)),
                  const Divider(height: 16, color: Color(0xFFF0EDF8)),
                  _buildDetailRow('Medical Fitness', 'Valid • Annual Safety Inspection Clear', icon: LucideIcons.heartPulse, iconColor: const Color(0xFF10B981)),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 4. Contact & Emergency Information
            const Text(
              'Contact & Emergency Details',
              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                children: [
                  _buildDetailRow('Phone Number', phone, icon: LucideIcons.phone, iconColor: const Color(0xFF10B981)),
                  const Divider(height: 16, color: Color(0xFFF0EDF8)),
                  _buildDetailRow('Emergency Contact', emergencyContact, icon: LucideIcons.phoneCall, iconColor: const Color(0xFFEF4444)),
                  const Divider(height: 16, color: Color(0xFFF0EDF8)),
                  _buildDetailRow('Staff Email', '${name.toLowerCase().replaceAll(' ', '.')}@sunriseschool.edu', icon: LucideIcons.mail, iconColor: const Color(0xFF6C4CF1)),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {required IconData icon, required Color iconColor}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 14),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500)),
              const SizedBox(height: 1),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
