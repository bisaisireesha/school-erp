import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TransportFeeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> studentRecord;

  const TransportFeeDetailsScreen({
    super.key,
    required this.studentRecord,
  });

  @override
  Widget build(BuildContext context) {
    final String name = studentRecord['student'] ?? studentRecord['name'] ?? 'Student';
    final String rollNo = studentRecord['rollNo'] ?? '12';
    final String route = studentRecord['route'] ?? 'Route 1';
    final String amount = studentRecord['amount'] ?? '₹ 12,500';
    final String status = studentRecord['status'] ?? 'Paid';
    final String date = studentRecord['date'] ?? '10 Jul 2026';
    final bool isPaid = status.toLowerCase() == 'paid';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: () => Navigator.pop(context)),
        title: const Text(
          'Fee Details',
          style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Header Card
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
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(LucideIcons.user, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$route • Roll No: $rollNo',
                          style: const TextStyle(color: Colors.white70, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
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
            const SizedBox(height: 16),

            // Fee Structure Card
            const Text(
              'Fee Breakdown Structure',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.0),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                children: [
                  _buildFeeRow('Base Route Charge', '₹ 9,500'),
                  const Divider(height: 16, color: Color(0xFFF0ECF9)),
                  _buildFeeRow('Distance Slab Fee (Zone 2)', '₹ 2,000'),
                  const Divider(height: 16, color: Color(0xFFF0ECF9)),
                  _buildFeeRow('Maintenance & GPS Security', '₹ 1,000'),
                  const Divider(height: 16, color: Color(0xFFF0ECF9)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Transport Fee',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                      Text(
                        amount,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment History & Due Dates
            const Text(
              'Payment History & Due Dates',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.0),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                children: [
                  _buildDetailRow('Term Period', 'Term 2 (2026-2027)'),
                  const SizedBox(height: 8),
                  _buildDetailRow('Due Date', isPaid ? 'Paid on $date' : date),
                  const SizedBox(height: 8),
                  _buildDetailRow('Payment Mode', isPaid ? 'UPI / Online Portal' : 'Pending Payment'),
                  const SizedBox(height: 8),
                  _buildDetailRow('Transaction Reference', isPaid ? 'TXN-998240182' : 'N/A'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Download Receipt Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fee Receipt for $name downloaded successfully!'),
                      backgroundColor: const Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                icon: const Icon(LucideIcons.download, size: 18, color: Colors.white),
                label: const Text(
                  'Download Official Fee Receipt',
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

  Widget _buildFeeRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A9D))),
        Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A9D))),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
      ],
    );
  }
}
