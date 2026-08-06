import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TransportComplianceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> record;

  const TransportComplianceDetailsScreen({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final String busNo = record['busNo'] ?? 'BUS-01';
    final String item = record['item'] ?? 'Fitness Certificate';
    final String expiry = record['expiry'] ?? 'N/A';
    final String status = record['status'] ?? 'Valid';
    final String authority = record['authority'] ?? 'RTO Authority';
    final bool isWarn = status == 'Warning';
    final bool isExpired = status == 'Expired';

    Color statusColor;
    Color statusBg;
    Color statusBorder;
    if (isExpired) {
      statusColor = const Color(0xFFEF4444);
      statusBg = const Color(0xFFFEF2F2);
      statusBorder = const Color(0xFFFCA5A5);
    } else if (isWarn) {
      statusColor = const Color(0xFFD97706);
      statusBg = const Color(0xFFFFFBEB);
      statusBorder = const Color(0xFFFDE68A);
    } else {
      statusColor = const Color(0xFF16A34A);
      statusBg = const Color(0xFFF0FDF4);
      statusBorder = const Color(0xFFBBF7D0);
    }

    // Extended compliance documents for the details view
    final List<Map<String, dynamic>> documents = [
      {
        'name': item,
        'type': 'Primary Document',
        'authority': authority,
        'issueDate': '15 Jan 2026',
        'expiry': expiry,
        'status': status,
        'icon': LucideIcons.fileText,
      },
      {
        'name': 'Vehicle Insurance Policy',
        'type': 'Mandatory Insurance',
        'authority': 'National Insurance Co.',
        'issueDate': '01 Jan 2026',
        'expiry': '31 Dec 2026',
        'status': 'Valid',
        'icon': LucideIcons.shield,
      },
      {
        'name': 'Pollution Under Control (PUC)',
        'type': 'Emission Certificate',
        'authority': 'Eco Check Center',
        'issueDate': '10 May 2026',
        'expiry': '10 Nov 2026',
        'status': 'Valid',
        'icon': LucideIcons.leaf,
      },
      {
        'name': 'Speed Governor Calibration',
        'type': 'Safety Device',
        'authority': 'Govt Inspectorate',
        'issueDate': '15 Mar 2026',
        'expiry': '15 Sep 2026',
        'status': 'Valid',
        'icon': LucideIcons.gauge,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: () => Navigator.pop(context)),
        title: const Text(
          'Compliance Details',
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
            // Vehicle Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isWarn || isExpired
                      ? [const Color(0xFFD97706), const Color(0xFFF59E0B)]
                      : [const Color(0xFF10B981), const Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isWarn || isExpired ? LucideIcons.alertTriangle : LucideIcons.shieldCheck,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          busNo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item,
                          style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Issued by $authority',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Compliance Summary Row
            const Text(
              'Compliance Summary',
              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: statusBorder, width: 1.0),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Overall Status', status, valueColor: statusColor, isBold: true),
                  const Divider(height: 14, color: Color(0xFFE8E8F0)),
                  _buildSummaryRow('Primary Document', item),
                  const Divider(height: 14, color: Color(0xFFE8E8F0)),
                  _buildSummaryRow('Expiry Date', expiry, valueColor: isWarn || isExpired ? statusColor : const Color(0xFF1E1E2D)),
                  const Divider(height: 14, color: Color(0xFFE8E8F0)),
                  _buildSummaryRow('Issuing Authority', authority),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // All Documents & Certificates
            const Text(
              'Documents & Certificates',
              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
            ),
            const SizedBox(height: 8),

            ...documents.map((doc) {
              final String docStatus = doc['status'] as String;
              final bool docWarn = docStatus == 'Warning';
              final bool docExpired = docStatus == 'Expired';

              Color dColor;
              Color dBg;
              if (docExpired) {
                dColor = const Color(0xFFEF4444);
                dBg = const Color(0xFFFEF2F2);
              } else if (docWarn) {
                dColor = const Color(0xFFD97706);
                dBg = const Color(0xFFFFFBEB);
              } else {
                dColor = const Color(0xFF10B981);
                dBg = const Color(0xFF10B981).withValues(alpha: 0.10);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF3EEFF), width: 1.0),
                  boxShadow: AppShadows.soft,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: dBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(doc['icon'] as IconData, color: dColor, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc['name'] as String,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${doc['type']} • ${doc['authority']}',
                            style: const TextStyle(fontSize: 11.5, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Issued: ${doc['issueDate']}  •  Expiry: ${doc['expiry']}',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: docWarn || docExpired ? dColor : const Color(0xFF6E6E8D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: dBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        docStatus,
                        style: TextStyle(color: dColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // Action Button
            if (isWarn || isExpired)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Renewal initiated for $busNo - $item'),
                        backgroundColor: const Color(0xFF6C4CF1),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.refreshCw, size: 17, color: Colors.white),
                  label: const Text(
                    'Initiate Renewal Process',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.0, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? const Color(0xFF1E1E2D),
          ),
        ),
      ],
    );
  }
}
