import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_payslip_pdf_viewer_screen.dart';

class TeacherPayrollScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const TeacherPayrollScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<TeacherPayrollScreen> createState() => _TeacherPayrollScreenState();
}

class _TeacherPayrollScreenState extends State<TeacherPayrollScreen> {
  late Map<String, dynamic> _currentPayslip;
  late List<Map<String, dynamic>> _previousPayslips;

  @override
  void initState() {
    super.initState();
    _loadPayrollData();
  }

  void _loadPayrollData() {
    final payroll = widget.data['payroll'] as Map<String, dynamic>? ?? {};

    _currentPayslip = {
      "month": payroll['currentMonth'] ?? "July 2026",
      "status": payroll['status'] ?? "Paid",
      "paymentDate": payroll['paymentDate'] ?? "28 July 2026",
      "basicSalary": (payroll['basicSalary'] as num?)?.toDouble() ?? 45000.0,
      "allowance": 14500.0,
      "teachingSpecial": 5500.0,
      "deductions": 5300.0,
      "netSalary": payroll['netSalary'] ?? "₹59,700",
    };

    final rawPrevious = payroll['previousPayslips'] as List? ?? [];
    if (rawPrevious.isNotEmpty) {
      _previousPayslips = rawPrevious.map((item) {
        final map = Map<String, dynamic>.from(item);
        map['basicSalary'] = (map['basicSalary'] as num?)?.toDouble() ?? 45000.0;
        map['allowance'] = (map['allowance'] as num?)?.toDouble() ?? 14500.0;
        map['teachingSpecial'] = 5500.0;
        map['deductions'] = (map['deductions'] as num?)?.toDouble() ?? 5300.0;
        return map;
      }).toList();
    } else {
      _previousPayslips = [
        {
          "month": "June 2026",
          "netSalary": "₹59,700",
          "status": "Paid",
          "paymentDate": "28 June 2026",
          "basicSalary": 45000.0,
          "allowance": 14500.0,
          "teachingSpecial": 5500.0,
          "deductions": 5300.0,
        },
        {
          "month": "May 2026",
          "netSalary": "₹59,700",
          "status": "Paid",
          "paymentDate": "28 May 2026",
          "basicSalary": 45000.0,
          "allowance": 14500.0,
          "teachingSpecial": 5500.0,
          "deductions": 5300.0,
        },
        {
          "month": "April 2026",
          "netSalary": "₹58,500",
          "status": "Paid",
          "paymentDate": "28 April 2026",
          "basicSalary": 45000.0,
          "allowance": 13300.0,
          "teachingSpecial": 5500.0,
          "deductions": 5300.0,
        },
        {
          "month": "March 2026",
          "netSalary": "₹58,500",
          "status": "Paid",
          "paymentDate": "28 March 2026",
          "basicSalary": 45000.0,
          "allowance": 13300.0,
          "teachingSpecial": 5500.0,
          "deductions": 5300.0,
        },
      ];
    }
  }

  void _openPayslipPdf(Map<String, dynamic> payslip) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TeacherPayslipPdfViewerScreen(
          payslip: payslip,
        ),
      ),
    );
  }

  void _downloadPdfDirectly(String month) {
    final fileName = 'Payslip_${month.replaceAll(' ', '_')}.pdf';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E1E2D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle2, color: Color(0xFF10B981), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Saved $fileName to Downloads',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 4),
                  ],
                  const Expanded(
                    child: Text(
                      'Payslips & Salary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF0EEF8)),

            // Content Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Latest Payslip Banner Card ───────────────────────────
                    GestureDetector(
                      onTap: () => _openPayslipPdf(_currentPayslip),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(color: const Color(0xFFF0EEF8)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x061E1E2D),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Month, Status & PDF icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F0FF),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        LucideIcons.fileText,
                                        color: Color(0xFF6C4CF1),
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _currentPayslip['month'],
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E1E2D),
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const Text(
                                          'Latest Disbursed Payslip',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _currentPayslip['status'],
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Salary Amount & Disbursal Date
                            Text(
                              _currentPayslip['netSalary'],
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1E2D),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Disbursed on ${_currentPayslip['paymentDate']}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 14),
                            const Divider(height: 1, color: Color(0xFFF0EEF8)),
                            const SizedBox(height: 12),

                            // View PDF Action Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(LucideIcons.fileText, size: 14, color: Color(0xFF6C4CF1)),
                                    SizedBox(width: 6),
                                    Text(
                                      'View Full PDF Document',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF6C4CF1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => _downloadPdfDirectly(_currentPayslip['month']),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F0FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(LucideIcons.download, size: 13, color: Color(0xFF6C4CF1)),
                                        SizedBox(width: 4),
                                        Text(
                                          'Download',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF6C4CF1),
                                          ),
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

                    // ── Previous Payslips Header ─────────────────────────────
                    const Text(
                      'Previous Payslips',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Previous Payslips List ───────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.0),
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
                        children: _previousPayslips.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          final String month = item['month'];
                          final String amount = item['netSalary'];
                          final String paymentDate = item['paymentDate'];
                          final bool isLast = index == _previousPayslips.length - 1;

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () => _openPayslipPdf(item),
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F0FF),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: Icon(LucideIcons.fileText, color: Color(0xFF6C4CF1), size: 18),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Center: Month & Date
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              month,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E1E2D),
                                              ),
                                            ),
                                            const SizedBox(height: 1),
                                            Text(
                                              'Paid on $paymentDate',
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Right: Salary Amount & Download Icon
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            amount,
                                            style: const TextStyle(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF1E1E2D),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () => _downloadPdfDirectly(month),
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8F7FC),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Icon(
                                                LucideIcons.download,
                                                size: 15,
                                                color: Color(0xFF6C4CF1),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isLast)
                                const Divider(
                                  height: 1,
                                  indent: 62,
                                  endIndent: 14,
                                  color: Color(0xFFF4F3F8),
                                ),
                            ],
                          );
                        }).toList(),
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
}
