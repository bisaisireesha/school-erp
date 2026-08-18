import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class DriverPayslipScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const DriverPayslipScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<DriverPayslipScreen> createState() => _DriverPayslipScreenState();
}

class _DriverPayslipScreenState extends State<DriverPayslipScreen> {
  final Map<String, dynamic> _currentPayslip = {
    "month": "July 2026",
    "status": "Paid",
    "paymentDate": "28 July 2026",
    "basicSalary": 24500.0,
    "allowance": 4500.0,
    "overtime": 2800.0,
    "deductions": 1800.0,
    "netSalary": "₹30,000",
  };

  final List<Map<String, dynamic>> _previousPayslips = [
    {
      "month": "June 2026",
      "netSalary": "₹30,000",
      "status": "Paid",
      "paymentDate": "28 June 2026",
      "basicSalary": 24500.0,
      "allowance": 4500.0,
      "overtime": 2800.0,
      "deductions": 1800.0,
    },
    {
      "month": "May 2026",
      "netSalary": "₹29,200",
      "status": "Paid",
      "paymentDate": "28 May 2026",
      "basicSalary": 24500.0,
      "allowance": 4500.0,
      "overtime": 2000.0,
      "deductions": 1800.0,
    },
    {
      "month": "April 2026",
      "netSalary": "₹30,000",
      "status": "Paid",
      "paymentDate": "28 April 2026",
      "basicSalary": 24500.0,
      "allowance": 4500.0,
      "overtime": 2800.0,
      "deductions": 1800.0,
    },
    {
      "month": "March 2026",
      "netSalary": "₹28,500",
      "status": "Paid",
      "paymentDate": "28 March 2026",
      "basicSalary": 24500.0,
      "allowance": 4500.0,
      "overtime": 1300.0,
      "deductions": 1800.0,
    },
  ];

  void _downloadPdf(String month) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF6C4CF1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(LucideIcons.fileCheck, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Downloaded Payslip_$month.pdf successfully!',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPayslipDetailsBottomSheet(Map<String, dynamic> payslip) {
    final String month = payslip['month'];
    final String status = payslip['status'];
    final String paymentDate = payslip['paymentDate'];
    final String netSalary = payslip['netSalary'];
    final double basic = (payslip['basicSalary'] as num?)?.toDouble() ?? 24500.0;
    final double allowance = (payslip['allowance'] as num?)?.toDouble() ?? 4500.0;
    final double overtime = (payslip['overtime'] as num?)?.toDouble() ?? 2800.0;
    final double deductions = (payslip['deductions'] as num?)?.toDouble() ?? 1800.0;

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
                  // Drag Handle
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

                  // Month Title & Paid Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$month Payslip',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Paid on $paymentDate',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A9D)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFF0EDF8)),
                  const SizedBox(height: 16),

                  // Detailed Breakdown Section
                  const Text(
                    'Earnings & Deductions Breakdown',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                  ),
                  const SizedBox(height: 12),
                  _buildBreakdownRow('Basic Salary', '₹${basic.toStringAsFixed(2)}', const Color(0xFF1E1E2D)),
                  const SizedBox(height: 8),
                  _buildBreakdownRow('Transport & Driving Allowance', '₹${allowance.toStringAsFixed(2)}', const Color(0xFF1E1E2D)),
                  const SizedBox(height: 8),
                  _buildBreakdownRow('Overtime Shift Pay', '₹${overtime.toStringAsFixed(2)}', const Color(0xFF10B981)),
                  const SizedBox(height: 8),
                  _buildBreakdownRow('PF & Tax Deductions', '- ₹${deductions.toStringAsFixed(2)}', const Color(0xFFEF4444)),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFF0EDF8)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Net Salary Payable',
                          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        netSalary,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Download Button inside Modal
                  SizedBox(
                    width: double.infinity,
                    height: AppSpacing.buttonHeight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _downloadPdf(month);
                      },
                      icon: const Icon(LucideIcons.download, size: 16, color: Colors.white),
                      label: Text('Download $month Payslip PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                      ),
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

  Widget _buildBreakdownRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: valueColor),
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
              // Header Row: Back Arrow & Page Title
              Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'Payslips & Earnings',
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

              // Clean White Current Month Summary Card
              GestureDetector(
                onTap: () => _showPayslipDetailsBottomSheet(_currentPayslip),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: AppShadows.soft,
                    border: Border.all(color: const Color(0xFFF0EDF8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month & Status Badge Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _currentPayslip['month'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                              letterSpacing: -0.2,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _currentPayslip['status'],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Salary Amount
                      Text(
                        _currentPayslip['netSalary'],
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Paid on ${_currentPayslip['paymentDate']}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A9D)),
                      ),

                      const SizedBox(height: 14),
                      const Divider(height: 1, color: Color(0xFFF0EDF8)),
                      const SizedBox(height: 12),

                      // Subtle "Download Payslip" Action Button Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(LucideIcons.fileText, size: 14, color: Color(0xFF6C4CF1)),
                              SizedBox(width: 6),
                              Text(
                                'Tap for full breakdown',
                                style: TextStyle(fontSize: 12, color: Color(0xFF6C4CF1), fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _downloadPdf(_currentPayslip['month']),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3EEFF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(LucideIcons.download, size: 13, color: Color(0xFF6C4CF1)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Download',
                                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Previous Payslips Section Header
              const Text(
                'Previous Payslips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),

              // Previous Payslips - Separate White Rounded Cards with 16px Padding & Soft Shadow
              ...List.generate(_previousPayslips.length, (index) {
                final item = _previousPayslips[index];
                final String month = item['month'];
                final String amount = item['netSalary'];
                final String paymentDate = item['paymentDate'];

                return GestureDetector(
                  onTap: () => _showPayslipDetailsBottomSheet(item),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: AppShadows.soft,
                      border: Border.all(color: const Color(0xFFF0EDF8)),
                    ),
                    child: Row(
                      children: [
                        // Soft Purple Rounded Square Document Icon Container
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3EEFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(LucideIcons.fileText, color: Color(0xFF6C4CF1), size: 18),
                        ),
                        const SizedBox(width: 12),

                        // Center: Month & Year (Primary) + Payment Date (Secondary)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                month,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Paid on $paymentDate',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFF7A7A9D),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right: Salary Amount & Download Icon
                        Row(
                          children: [
                            Text(
                              amount,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(LucideIcons.download, size: 18, color: Color(0xFF6C4CF1)),
                              onPressed: () => _downloadPdf(month),
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(4),
                              tooltip: 'Download Payslip',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
