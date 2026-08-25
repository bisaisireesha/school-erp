import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DriverDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> staff;

  const DriverDetailsScreen({super.key, required this.staff});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final String firstName = widget.staff['firstName'] ?? '';
    final String lastName = widget.staff['lastName'] ?? '';
    final String fullName = '$firstName $lastName';
    final String id = widget.staff['id'] ?? 'd9fcd0c3-3817-4695-a3af-a04453730d53';
    final String vehicle = widget.staff['assignedVehicle'] ?? 'Unassigned';

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Staff Profile Details',
                  style: TextStyle(
                    color: Color(0xFF1E1E2D),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Color(0xFF9CA3AF)),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C4CF1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha:0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_outline, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(fullName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('${widget.staff['designation'] ?? 'Senior Bus Driver'} • ${widget.staff['role']}', style: TextStyle(color: Colors.white.withValues(alpha:0.8), fontSize: 12)),
                              const SizedBox(height: 2),
                              Text('Experience: ${widget.staff['experience'] ?? '8 Years'} • Full-Time', style: TextStyle(color: Colors.white.withValues(alpha:0.8), fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5)),
                        ),
                      ],
                    ),
                  ),

                  _buildDetailSection(
                    title: 'Professional & Employment Information',
                    children: [
                      _buildDetailListItem(icon: LucideIcons.contact, iconColor: const Color(0xFF3B82F6), label: 'Staff ID', value: id.length > 8 ? id.substring(id.length - 8) : id),
                      _buildDetailListItem(icon: LucideIcons.briefcase, iconColor: const Color(0xFF8B5CF6), label: 'Designation', value: widget.staff['designation'] ?? 'Senior Bus Driver'),
                      _buildDetailListItem(icon: LucideIcons.building, iconColor: const Color(0xFF3B82F6), label: 'Department', value: widget.staff['department'] ?? 'Transport & Fleet Logistics'),
                      _buildDetailListItem(icon: LucideIcons.userCheck, iconColor: const Color(0xFF10B981), label: 'Employment Type', value: 'Full-Time'),
                      _buildDetailListItem(icon: LucideIcons.award, iconColor: const Color(0xFFF59E0B), label: 'Total Working Experience', value: widget.staff['experience'] ?? '8 Years'),
                      _buildDetailListItem(icon: LucideIcons.history, iconColor: const Color(0xFF8B5CF6), label: 'Previous Employer', value: 'BMTC Transit Metro Division'),
                      _buildDetailListItem(icon: LucideIcons.calendar, iconColor: const Color(0xFF6C6C80), label: 'Joining Date', value: widget.staff['joiningDate'] ?? '01 Jun 2021', showDivider: false),
                    ],
                  ),
                  
                  _buildDetailSection(
                    title: 'Licensing & Vehicle Authorization',
                    children: [
                      _buildDetailListItem(icon: LucideIcons.fileText, iconColor: const Color(0xFF8B5CF6), label: 'License Number', value: widget.staff['licenseNumber'] ?? 'DL-09201500341'),
                      _buildDetailListItem(icon: LucideIcons.calendarClock, iconColor: const Color(0xFF10B981), label: 'License Expiry', value: widget.staff['licenseExpiry'] ?? '12 Nov 2029'),
                      _buildDetailListItem(icon: LucideIcons.shieldCheck, iconColor: const Color(0xFF3B82F6), label: 'Vehicle Category Authorized', value: 'Heavy Passenger Vehicle (Bus)'),
                      _buildDetailListItem(icon: LucideIcons.truck, iconColor: const Color(0xFFF59E0B), label: 'Assigned Bus No.', value: vehicle),
                      _buildDetailListItem(icon: LucideIcons.mapPin, iconColor: const Color(0xFF06B6D4), label: 'Primary Route', value: widget.staff['assignedRoute'] ?? 'Route 2 - Sunrise Hills', showDivider: false),
                    ],
                  ),
                  
                  _buildDetailSection(
                    title: 'Certifications & Qualifications',
                    children: [
                      _buildDetailListItem(icon: LucideIcons.checkCircle, iconColor: const Color(0xFF10B981), label: 'Certifications', value: 'Defensive Driving, First Aid Certified'),
                      _buildDetailListItem(icon: LucideIcons.wrench, iconColor: const Color(0xFF8B5CF6), label: 'Skills & Expertise', value: 'Heavy Passenger Driving, CPR First Responder'),
                      _buildDetailListItem(icon: LucideIcons.activity, iconColor: const Color(0xFF10B981), label: 'Medical Fitness', value: 'Valid • Annual Safety Inspection Clear', showDivider: false),
                    ],
                  ),
                  
                  _buildDetailSection(
                    title: 'Attendance & Performance Summary',
                    children: [
                      _buildDetailListItem(icon: LucideIcons.calendarCheck, iconColor: const Color(0xFF10B981), label: 'Monthly Attendance', value: '96% (Present: 24, Absent: 1)'),
                      _buildDetailListItem(icon: LucideIcons.star, iconColor: const Color(0xFFF59E0B), label: 'Performance Rating', value: '4.8 / 5.0 (Based on Parent Feedback)'),
                      _buildDetailListItem(icon: LucideIcons.alertTriangle, iconColor: const Color(0xFFEF4444), label: 'Incidents & Violations', value: '0 reported in the last 6 months', showDivider: false),
                    ],
                  ),
                  
                  _buildDetailSection(
                    title: 'Contact & Emergency Details',
                    children: [
                      _buildDetailListItem(icon: LucideIcons.phone, iconColor: const Color(0xFF10B981), label: 'Phone Number', value: widget.staff['phone'] ?? '+91 98765 43211'),
                      _buildDetailListItem(icon: LucideIcons.phoneCall, iconColor: const Color(0xFFEF4444), label: 'Emergency Contact', value: widget.staff['emergencyContact'] ?? 'Sunita Kumar (+91 98112 33445)'),
                      _buildDetailListItem(icon: LucideIcons.mail, iconColor: const Color(0xFF8B5CF6), label: 'Staff Email', value: widget.staff['email'] ?? 'suresh.patel@sunriseschool.edu', showDivider: false),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1E2D),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailListItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha:0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
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
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E2D),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF3EEFF),
            indent: 56,
            endIndent: 16,
          ),
      ],
    );
  }
}
