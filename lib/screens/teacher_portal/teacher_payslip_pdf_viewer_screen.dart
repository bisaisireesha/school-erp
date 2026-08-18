import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TeacherPayslipPdfViewerScreen extends StatefulWidget {
  final Map<String, dynamic> payslip;
  final VoidCallback? onBack;

  const TeacherPayslipPdfViewerScreen({
    super.key,
    required this.payslip,
    this.onBack,
  });

  @override
  State<TeacherPayslipPdfViewerScreen> createState() =>
      _TeacherPayslipPdfViewerScreenState();
}

class _TeacherPayslipPdfViewerScreenState
    extends State<TeacherPayslipPdfViewerScreen> {
  final TransformationController _transformationController =
      TransformationController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _totalPages = 2;

  String get _fileName {
    final month = (widget.payslip['month'] ?? 'July 2026').toString().replaceAll(' ', '_');
    return 'Payslip_$month.pdf';
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (maxScroll > 0) {
      final page = (currentScroll / (maxScroll / _totalPages)).floor() + 1;
      final clamped = page.clamp(1, _totalPages);
      if (clamped != _currentPage) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _currentPage != clamped) {
            setState(() {
              _currentPage = clamped;
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDownload() {
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
                'Saved $_fileName to Downloads',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleShare() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.fileText, color: Color(0xFFEF4444), size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fileName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1E1E2D)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'PDF Document • 148 KB',
                        style: TextStyle(fontSize: 12.0, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Share via',
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _shareOption(LucideIcons.mail, 'Email', () {
                  Navigator.pop(ctx);
                  _showToast('Opening Email composer...');
                }),
                _shareOption(LucideIcons.messageSquare, 'Messages', () {
                  Navigator.pop(ctx);
                  _showToast('Preparing PDF link for Messages...');
                }),
                _shareOption(LucideIcons.printer, 'Print', () {
                  Navigator.pop(ctx);
                  _showToast('Connecting to AirPrint printer...');
                }),
                _shareOption(LucideIcons.folderClosed, 'Files', () {
                  Navigator.pop(ctx);
                  _showToast('Saved to Device Files');
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shareOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF6C4CF1), size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
          ),
        ],
      ),
    );
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E1E2D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(msg, style: const TextStyle(fontSize: 13.0, color: Colors.white)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4D50), // Authentic PDF Viewer Slate Canvas Background
      body: SafeArea(
        child: Column(
          children: [
            // ── PDF Header Bar ──────────────────────────────────────────────
            _buildPdfHeader(),

            // ── Interactive Document Body (Scroll & Pinch-to-Zoom) ───────────
            Expanded(
              child: Stack(
                children: [
                  InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.85,
                    maxScale: 3.5,
                    clipBehavior: Clip.none,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
                      child: Column(
                        children: [
                          // Page 1: Official Monthly Payslip
                          _buildPageContainer(pageNumber: 1, child: _buildPayslipPage1()),

                          const SizedBox(height: 18),

                          // Page 2: Tax Calculation & Cumulative Summary
                          _buildPageContainer(pageNumber: 2, child: _buildPayslipPage2()),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  // Floating Page Indicator Pill
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Text(
                          '$_currentPage / $_totalPages',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── PDF TOOLBAR ───────────────────────────────────────────────────────────
  Widget _buildPdfHeader() {
    return Container(
      color: const Color(0xFF2C2F33),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
            onPressed: widget.onBack ?? () => Navigator.pop(context),
            tooltip: 'Back',
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _fileName,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                const Text(
                  'PDF Document • 148 KB',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.share2, size: 18, color: Colors.white),
            onPressed: _handleShare,
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(LucideIcons.download, size: 18, color: Colors.white),
            onPressed: _handleDownload,
            tooltip: 'Download PDF',
          ),
        ],
      ),
    );
  }

  // ─── PAGE CONTAINER WITH A4 LOOK & SHADOW ──────────────────────────────────
  Widget _buildPageContainer({required int pageNumber, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: child,
    );
  }

  // ─── PAGE 1: SALARY SLIP ───────────────────────────────────────────────────
  Widget _buildPayslipPage1() {
    final month = widget.payslip['month'] ?? 'July 2026';
    final paymentDate = widget.payslip['paymentDate'] ?? '28 July 2026';
    final double basic = (widget.payslip['basicSalary'] as num?)?.toDouble() ?? 45000.0;
    final double allowance = (widget.payslip['allowance'] as num?)?.toDouble() ?? 14500.0;
    final double teachingSpecial = (widget.payslip['teachingSpecial'] as num?)?.toDouble() ?? 5500.0;
    const double conveyance = 4000.0;
    const double medical = 2500.0;
    final double grossEarnings = basic + allowance + teachingSpecial + conveyance + medical;

    const double epf = 3600.0;
    const double pt = 200.0;
    const double tds = 1200.0;
    const double healthIns = 300.0;
    const double totalDeductions = epf + pt + tds + healthIns;
    final double netSalaryVal = grossEarnings - totalDeductions;
    final String netSalaryFormatted = '₹${netSalaryVal.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. School Letterhead
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF6C4CF1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(LucideIcons.graduationCap, color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SUNRISE ACADEMY',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    'Affiliated to CBSE • Affiliation No: 1930284',
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                  ),
                  Text(
                    'Plot 124, Education Enclave, Tech District, City - 560100',
                    style: TextStyle(fontSize: 10.0, color: Color(0xFF64748B)),
                  ),
                  Text(
                    'payroll@sunrise.edu • www.sunrise.edu',
                    style: TextStyle(fontSize: 10.0, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Container(height: 1.5, color: const Color(0xFF1E1E2D)),
        const SizedBox(height: 8),

        // 2. Document Title Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          color: const Color(0xFFF1F5F9),
          child: Column(
            children: [
              Text(
                'SALARY SLIP FOR THE MONTH OF ${month.toString().toUpperCase()}',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Pay Date: $paymentDate  •  Pay Period: 01 ${month.toString().split(' ').first} – 31 ${month.toString().split(' ').first}',
                style: const TextStyle(fontSize: 10.0, color: Color(0xFF475569), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 3. Employee Particulars Grid Table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
          ),
          child: Column(
            children: [
              _buildTableRow('Employee Name', 'Sarah Williams', 'Employee ID', 'TCH-2048'),
              _buildTableRow('Designation', 'Senior Faculty', 'Department', 'STEM Education'),
              _buildTableRow('Joining Date', '10 Jul 2020', 'Bank Name', 'HDFC Bank Ltd'),
              _buildTableRow('Bank A/c No.', '•••• •••• 4892', 'PAN Number', 'ABCDE1234F'),
              _buildTableRow('Days in Month', '31 Days', 'Paid Days / LOP', '31 Days / 0 LOP', isLast: true),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 4. Earnings & Deductions Two-Column Table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
          ),
          child: Column(
            children: [
              // Header Row
              Container(
                color: const Color(0xFFF8FAFC),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    const Expanded(child: Text('EARNINGS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: Color(0xFF1E293B)))),
                    const SizedBox(width: 50, child: Text('AMOUNT', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: Color(0xFF1E293B)))),
                    Container(width: 1, height: 16, color: const Color(0xFFCBD5E1), margin: const EdgeInsets.symmetric(horizontal: 6)),
                    const Expanded(child: Text('DEDUCTIONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: Color(0xFF1E293B)))),
                    const SizedBox(width: 50, child: Text('AMOUNT', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: Color(0xFF1E293B)))),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFCBD5E1)),

              // Rows
              _buildSalaryRow('Basic Salary', '₹${basic.toInt()}', 'Provident Fund (EPF)', '₹${epf.toInt()}'),
              _buildSalaryRow('House Rent Allowance (HRA)', '₹${allowance.toInt()}', 'Professional Tax (PT)', '₹${pt.toInt()}'),
              _buildSalaryRow('STEM Faculty Allowance', '₹${teachingSpecial.toInt()}', 'Income Tax (TDS)', '₹${tds.toInt()}'),
              _buildSalaryRow('Conveyance Allowance', '₹${conveyance.toInt()}', 'Medical Insurance', '₹${healthIns.toInt()}'),
              _buildSalaryRow('Medical Allowance', '₹${medical.toInt()}', 'Other Deductions', '₹0'),

              const Divider(height: 1, thickness: 1, color: Color(0xFFCBD5E1)),

              // Total Gross vs Total Deductions
              Container(
                color: const Color(0xFFF8FAFC),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Row(
                  children: [
                    const Expanded(child: Text('Gross Earnings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: Color(0xFF0F172A)))),
                    SizedBox(width: 50, child: Text('₹${grossEarnings.toInt()}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: Color(0xFF0F172A)))),
                    Container(width: 1, height: 16, color: const Color(0xFFCBD5E1), margin: const EdgeInsets.symmetric(horizontal: 6)),
                    const Expanded(child: Text('Total Deductions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: Color(0xFFDC2626)))),
                    SizedBox(width: 50, child: Text('₹${totalDeductions.toInt()}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: Color(0xFFDC2626)))),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 5. Net Salary Highlighted Box
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF86EFAC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'NET SALARY PAYABLE:',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF14532D)),
                  ),
                  Text(
                    netSalaryFormatted,
                    style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w900, color: Color(0xFF15803D)),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Amount in Words: Sixty-Six Thousand Two Hundred Rupees Only',
                style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600, color: Color(0xFF166534)),
              ),
              const Text(
                'Payment Mode: Direct Bank Transfer (NEFT Ref: TXN948291038)',
                style: TextStyle(fontSize: 9.5, color: Color(0xFF15803D)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 6. Signature & Verification Stamps
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 1,
                  color: const Color(0xFF94A3B8),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Employee Signature',
                  style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF6C4CF1), width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ACCOUNTS VERIFIED\nSUNRISE ACADEMY',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Authorized Finance Officer',
                  style: TextStyle(fontSize: 9.5, color: Color(0xFF475569), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        const SizedBox(height: 6),

        // Footer Note
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'System-generated document • IT Act 2000 compliant',
              style: TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8)),
            ),
            Text(
              'Page 1 of 2',
              style: TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  // ─── PAGE 2: TAX COMPUTATION & YTD STATEMENT ───────────────────────────────
  Widget _buildPayslipPage2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SUNRISE ACADEMY • YEAR-TO-DATE (YTD) STATEMENT',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text(
              'FY 2026–27',
              style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, color: Color(0xFFCBD5E1)),
        const SizedBox(height: 12),

        const Text(
          '1. Cumulative Earnings Summary (April 2026 - July 2026)',
          style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 6),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            children: [
              _buildYtdRow('Cumulative Basic Salary YTD', '₹1,80,000'),
              _buildYtdRow('Cumulative HRA YTD', '₹58,000'),
              _buildYtdRow('Cumulative Special Allowances YTD', '₹48,000'),
              _buildYtdRow('Total Gross Earnings YTD', '₹2,86,000', isBold: true),
            ],
          ),
        ),

        const SizedBox(height: 14),

        const Text(
          '2. Statutory Deductions & Tax Deposit Summary',
          style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 6),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            children: [
              _buildYtdRow('Employee PF Deposited (EPFO)', '₹14,400'),
              _buildYtdRow('Employer PF Contribution', '₹14,400'),
              _buildYtdRow('Professional Tax Deposited', '₹800'),
              _buildYtdRow('TDS / Income Tax Deducted YTD', '₹4,800'),
              _buildYtdRow('Tax Regime Selected', 'New Tax Regime (Sec 115BAC)', isBold: true),
            ],
          ),
        ),

        const SizedBox(height: 14),

        const Text(
          '3. Faculty Annual Leave Balance',
          style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 6),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            children: [
              _buildYtdRow('Casual Leave (CL)', '8 Available / 4 Availed'),
              _buildYtdRow('Medical / Sick Leave (ML)', '10 Available / 1 Availed'),
              _buildYtdRow('Earned Leave (EL)', '15 Available / 0 Availed'),
            ],
          ),
        ),

        const SizedBox(height: 30),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        const SizedBox(height: 6),

        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Confidential Faculty Record • Generated for Sarah Williams',
              style: TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8)),
            ),
            Text(
              'Page 2 of 2',
              style: TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableRow(String label1, String val1, String label2, String val2, {bool isLast = false}) {
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFCBD5E1))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label1, style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)))),
          Expanded(child: Text(val1, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
          SizedBox(width: 80, child: Text(label2, style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)))),
          Expanded(child: Text(val2, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
        ],
      ),
    );
  }

  Widget _buildSalaryRow(String earnLabel, String earnVal, String dedLabel, String dedVal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      child: Row(
        children: [
          Expanded(child: Text(earnLabel, style: const TextStyle(fontSize: 9.5, color: Color(0xFF334155)))),
          SizedBox(width: 50, child: Text(earnVal, textAlign: TextAlign.right, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)))),
          Container(width: 1, height: 14, color: const Color(0xFFCBD5E1), margin: const EdgeInsets.symmetric(horizontal: 6)),
          Expanded(child: Text(dedLabel, style: const TextStyle(fontSize: 9.5, color: Color(0xFF334155)))),
          SizedBox(width: 50, child: Text(dedVal, textAlign: TextAlign.right, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Color(0xFFDC2626)))),
        ],
      ),
    );
  }

  Widget _buildYtdRow(String label, String value, {bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? const Color(0xFF0F172A) : const Color(0xFF475569),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? const Color(0xFF6C4CF1) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
