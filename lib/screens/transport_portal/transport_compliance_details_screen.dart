import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TransportComplianceDetailsScreen extends StatelessWidget {
  const TransportComplianceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 16),
                    _buildInfoCard(),
                    const SizedBox(height: 24),
                    const Text(
                      'Compliance Documents',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildComplianceDocumentsCard(),
                    const SizedBox(height: 24),
                    const Text(
                      'Compliance Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryCard(),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981), // Green for marking as closed/resolved
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Mark to Close',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFE0E7FF), // Light blue avatar
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(LucideIcons.user, color: Color(0xFF4F46E5), size: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Suresh Kumar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'ACTIVE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'ATTENDANT',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'd9fcd0c3-3817-4695-a3af-a04453730d53',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Unassigned',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(LucideIcons.phone, 'Phone', '—'),
                const SizedBox(height: 20),
                _buildInfoRow(LucideIcons.mail, 'Email', 'driver2@aprogra.com'),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 90,
            color: const Color(0xFFF3EEFF),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(LucideIcons.bus, 'Vehicle', '—'),
                const SizedBox(height: 20),
                _buildInfoRow(LucideIcons.calendar, 'Joined', '21/08/2026'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6C6C80)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6C6C80),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComplianceDocumentsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _buildDocumentItem(
            icon: LucideIcons.fileBadge,
            iconColor: const Color(0xFF10B981),
            iconBg: const Color(0xFFDCFCE7),
            title: 'Driving License',
            subtitle: 'N/A (Attendant)',
            statusLabel: 'Valid',
            statusColor: const Color(0xFF10B981),
            statusBg: const Color(0xFFDCFCE7),
          ),
          const Divider(height: 1, color: Color(0xFFF3EEFF), thickness: 1.5),
          _buildDocumentItem(
            icon: LucideIcons.activity,
            iconColor: const Color(0xFFF59E0B),
            iconBg: const Color(0xFFFEF3C7),
            title: 'Medical Certificate',
            subtitle: 'Not recorded',
            statusLabel: 'Action Needed',
            statusColor: const Color(0xFFF59E0B),
            statusBg: const Color(0xFFFEF3C7),
          ),
          const Divider(height: 1, color: Color(0xFFF3EEFF), thickness: 1.5),
          _buildDocumentItem(
            icon: LucideIcons.shieldAlert,
            iconColor: const Color(0xFFF59E0B),
            iconBg: const Color(0xFFFEF3C7),
            title: 'Training Certificate',
            subtitle: 'Not recorded',
            statusLabel: 'Action Needed',
            statusColor: const Color(0xFFF59E0B),
            statusBg: const Color(0xFFFEF3C7),
          ),
          const Divider(height: 1, color: Color(0xFFF3EEFF), thickness: 1.5),
          _buildDocumentItem(
            icon: LucideIcons.checkCircle,
            iconColor: const Color(0xFF10B981),
            iconBg: const Color(0xFFDCFCE7),
            title: 'Background Verification',
            subtitle: 'VERIFIED',
            statusLabel: 'Valid',
            statusColor: const Color(0xFF10B981),
            statusBg: const Color(0xFFDCFCE7),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String statusLabel,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
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
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (statusLabel == 'Valid') ...[
                  const Icon(LucideIcons.checkCircle2, size: 12, color: Color(0xFF10B981)),
                  const SizedBox(width: 4),
                ] else if (statusLabel == 'Action Needed') ...[
                  const Icon(LucideIcons.alertTriangle, size: 12, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 4),
                ],
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(LucideIcons.chevronRight, size: 18, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(LucideIcons.shieldAlert, 'Overall Status', 'Action Required', const Color(0xFFF97316)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF3EEFF), thickness: 1.5),
          ),
          _buildSummaryRow(LucideIcons.checkCircle, 'Documents Verified', 'Yes', const Color(0xFF10B981)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF3EEFF), thickness: 1.5),
          ),
          _buildSummaryRow(LucideIcons.activity, 'Last Medical', '—', const Color(0xFF1E1E2D)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF3EEFF), thickness: 1.5),
          ),
          _buildSummaryRow(LucideIcons.clock, 'Next Training', '—', const Color(0xFF1E1E2D)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, Color valueColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6C6C80)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6C6C80),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
