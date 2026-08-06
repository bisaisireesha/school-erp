import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class DriverExpenseScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const DriverExpenseScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<DriverExpenseScreen> createState() => _DriverExpenseScreenState();
}

class _DriverExpenseScreenState extends State<DriverExpenseScreen> {
  String _searchQuery = '';
  String _historyFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Mock Expense History Data
  final List<Map<String, dynamic>> _expenseHistory = [
    {
      'id': 'EXP-2026-891',
      'title': 'Diesel Refill (60 Liters)',
      'category': 'Fuel',
      'amount': '2,450',
      'date': '31 Jul 2026',
      'route': 'Route 1 - Green Glen Morning Pickup',
      'paymentMethod': 'Fuel Card',
      'status': 'Pending',
      'receiptName': 'fuel_receipt_31jul.jpg',
      'receiptSize': '1.4 MB',
      'notes': 'Filled 60L diesel at HP Petrol Pump, Outer Ring Rd. Meter reading 45,820 km.',
      'submittedTime': '31 Jul 2026, 08:30 AM',
      'reviewTime': '31 Jul 2026, 10:15 AM',
      'approvalTime': 'Awaiting Finance Officer Approval',
    },
    {
      'id': 'EXP-2026-872',
      'title': 'Fastag Toll Recharge',
      'category': 'Toll',
      'amount': '800',
      'date': '28 Jul 2026',
      'route': 'Route 3 - Metro Expressway',
      'paymentMethod': 'Fastag',
      'status': 'Approved',
      'receiptName': 'fastag_statement_jul.pdf',
      'receiptSize': '850 KB',
      'notes': 'Weekly toll auto-debit top up for express highway trips.',
      'submittedTime': '28 Jul 2026, 07:45 AM',
      'reviewTime': '28 Jul 2026, 09:20 AM',
      'approvalTime': '28 Jul 2026, 11:00 AM (Approved by Accounts)',
    },
    {
      'id': 'EXP-2026-845',
      'title': 'Emergency Tire Puncture Repair',
      'category': 'Maintenance',
      'amount': '450',
      'date': '24 Jul 2026',
      'route': 'Route 2 - Sunrise Hills',
      'paymentMethod': 'Cash',
      'status': 'Approved',
      'receiptName': 'tire_repair_bill.png',
      'receiptSize': '2.1 MB',
      'notes': 'Rear left tire puncture repaired during afternoon trip.',
      'submittedTime': '24 Jul 2026, 02:15 PM',
      'reviewTime': '24 Jul 2026, 03:00 PM',
      'approvalTime': '24 Jul 2026, 04:30 PM (Approved by Fleet Mgr)',
    },
    {
      'id': 'EXP-2026-810',
      'title': 'Overnight Commercial Parking',
      'category': 'Parking',
      'amount': '350',
      'date': '20 Jul 2026',
      'route': 'Special Sports Trip',
      'paymentMethod': 'Personal UPI',
      'status': 'Rejected',
      'rejectionReason': 'Unauthorized parking location. Pre-approval from transport manager is required for overnight parking claims.',
      'receiptName': 'parking_ticket.jpg',
      'receiptSize': '1.1 MB',
      'notes': 'Parked at Stadium Complex during inter-school athletic event.',
      'submittedTime': '20 Jul 2026, 09:10 PM',
      'reviewTime': '21 Jul 2026, 09:00 AM',
      'approvalTime': '21 Jul 2026, 10:30 AM (Rejected by Fleet Mgr)',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Open Full-Screen Slide-Up Add Expense Form
  void _openAddExpenseBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return _AddExpenseBottomSheet(
          onAddExpense: (newExpense) {
            setState(() {
              _expenseHistory.insert(0, newExpense);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Expense claim submitted successfully!'),
                backgroundColor: Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }

  // Open Expense Details Page / Bottom Sheet Modal
  void _showExpenseDetailsBottomSheet(Map<String, dynamic> item) {
    final String title = item['title'];
    final String category = item['category'];
    final String amount = item['amount'];
    final String date = item['date'];
    final String route = item['route'];
    final String paymentMethod = item['paymentMethod'] ?? 'Fuel Card';
    final String status = item['status'];
    final String notes = item['notes'] ?? 'No additional notes provided.';
    final String? rejectionReason = item['rejectionReason'];
    final String? receiptName = item['receiptName'];
    final String receiptSize = item['receiptSize'] ?? '1.4 MB';
    final String submittedTime = item['submittedTime'] ?? '$date, 08:30 AM';
    final String reviewTime = item['reviewTime'] ?? '$date, 10:00 AM';
    final String approvalTime = item['approvalTime'] ?? (status == 'Approved' ? '$date, 02:00 PM' : 'Pending Review');

    Color statusBg;
    Color statusColor;
    if (status == 'Approved') {
      statusBg = const Color(0xFFECFDF5);
      statusColor = const Color(0xFF10B981);
    } else if (status == 'Rejected') {
      statusBg = const Color(0xFFFEF2F2);
      statusColor = const Color(0xFFEF4444);
    } else {
      statusBg = const Color(0xFFFFFBEB);
      statusColor = const Color(0xFFD97706);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.90,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: SafeArea(
            child: Column(
              children: [
                // Top Drag Handle
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Compact Header Bar with Back, Title, and More Menu (⋮)
                Row(
                  children: [
                    AppBackButton(onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Expense Details',
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(LucideIcons.moreVertical, size: 20, color: Color(0xFF64748B)),
                      onSelected: (val) {
                        if (val == 'share') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sharing expense claim summary...'), behavior: SnackBarBehavior.floating),
                          );
                        } else if (val == 'report') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Dispute / report issue initiated'), behavior: SnackBarBehavior.floating),
                          );
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'share', child: Row(children: [Icon(LucideIcons.share2, size: 16), SizedBox(width: 8), Text('Share Claim')])),
                        PopupMenuItem(value: 'report', child: Row(children: [Icon(LucideIcons.helpCircle, size: 16), SizedBox(width: 8), Text('Report Issue')])),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFFF0EDF8)),
                const SizedBox(height: 12),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Summary Hero Area
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3EEFF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(_getCategoryIcon(category), color: const Color(0xFF6C4CF1), size: 24),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E2D),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$category • $date',
                                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹ $amount',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E2D),
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                  decoration: BoxDecoration(
                                    color: statusBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Rejection Reason Info Card (If Rejected)
                        if (status == 'Rejected' && rejectionReason != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFCA5A5)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(LucideIcons.alertCircle, size: 18, color: Color(0xFFEF4444)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Rejection Reason',
                                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF991B1B)),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        rejectionReason,
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF7F1D1D), height: 1.3),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // SECTION 1: Expense Information
                        const Text(
                          'Expense Information',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FD),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF0EDF8)),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow('Category', category),
                              const Divider(height: 20, color: Color(0xFFF0EDF8)),
                              _buildDetailRow('Date Claimed', date),
                              const Divider(height: 20, color: Color(0xFFF0EDF8)),
                              _buildDetailRow('Route / Trip', route),
                              const Divider(height: 20, color: Color(0xFFF0EDF8)),
                              _buildDetailRow('Payment Method', paymentMethod),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // SECTION 2: Description / Notes
                        const Text(
                          'Description / Notes',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FD),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF0EDF8)),
                          ),
                          child: Text(
                            notes,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // SECTION 3: Receipt / Invoice with Thumbnail Preview & Action Buttons
                        const Text(
                          'Receipt / Invoice Document',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FD),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF0EDF8)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3EEFF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Icon(LucideIcons.fileCheck, color: Color(0xFF6C4CF1), size: 22),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          receiptName ?? 'receipt_attached.jpg',
                                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Tax Invoice • $receiptSize',
                                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Opening full view of ${receiptName ?? 'receipt_attached.jpg'}'),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: const Color(0xFF6C4CF1),
                                          ),
                                        );
                                      },
                                      icon: const Icon(LucideIcons.eye, size: 15),
                                      label: const Text('View Full'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF6C4CF1),
                                        side: const BorderSide(color: Color(0xFF6C4CF1)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Downloading ${receiptName ?? 'receipt_attached.jpg'}...'),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: const Color(0xFF10B981),
                                          ),
                                        );
                                      },
                                      icon: const Icon(LucideIcons.download, size: 15),
                                      label: const Text('Download'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF1E1E2D),
                                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // SECTION 4: Approval Timeline Stepper
                        const Text(
                          'Approval Timeline',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FD),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF0EDF8)),
                          ),
                          child: Column(
                            children: [
                              _buildTimelineStep(
                                icon: LucideIcons.checkCircle2,
                                color: const Color(0xFF10B981),
                                title: 'Claim Submitted',
                                subtitle: submittedTime,
                                isLast: false,
                              ),
                              _buildTimelineStep(
                                icon: LucideIcons.clock,
                                color: const Color(0xFF3B82F6),
                                title: 'Under Fleet Review',
                                subtitle: reviewTime,
                                isLast: false,
                              ),
                              _buildTimelineStep(
                                icon: status == 'Approved'
                                    ? LucideIcons.checkCircle2
                                    : (status == 'Rejected' ? LucideIcons.xCircle : LucideIcons.hourglass),
                                color: status == 'Approved'
                                    ? const Color(0xFF10B981)
                                    : (status == 'Rejected' ? const Color(0xFFEF4444) : const Color(0xFFF59E0B)),
                                title: status == 'Approved'
                                    ? 'Approved & Disbursed'
                                    : (status == 'Rejected' ? 'Claim Rejected' : 'Awaiting Final Approval'),
                                subtitle: approvalTime,
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(icon, size: 18, color: color),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: const Color(0xFFCBD5E1),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    if (category == 'Fuel') return LucideIcons.fuel;
    if (category == 'Toll') return LucideIcons.navigation;
    if (category == 'Parking') return LucideIcons.circleParking;
    if (category == 'Maintenance') return LucideIcons.wrench;
    return LucideIcons.receipt;
  }

  @override
  Widget build(BuildContext context) {
    // Filter History by search query and category chip
    final filteredList = _expenseHistory.where((item) {
      final matchesFilter = _historyFilter == 'All' || item['status'] == _historyFilter;
      final q = _searchQuery.toLowerCase();
      final title = (item['title'] as String).toLowerCase();
      final category = (item['category'] as String).toLowerCase();
      final route = (item['route'] as String).toLowerCase();
      final date = (item['date'] as String).toLowerCase();

      final matchesSearch = q.isEmpty ||
          title.contains(q) ||
          category.contains(q) ||
          route.contains(q) ||
          date.contains(q);

      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row: Back Arrow, Title, and Floating Circular Add (+) Button
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  AppBackButton(
                    onPressed: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Expense Reimbursement',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  // Floating Circular Add (+) Button Aligned to Right
                  GestureDetector(
                    onTap: _openAddExpenseBottomSheet,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6C4CF1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.plus, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Full-width Rounded Search Bar (#F8F9FD Fill, 12px Radius)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search expenses...',
                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(LucideIcons.search, size: 17, color: Color(0xFF64748B)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16, color: Color(0xFF64748B)),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
            ),

            // Left-Aligned Filter Chips (All, Pending, Approved, Rejected)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: ['All', 'Pending', 'Approved', 'Rejected'].map((filter) {
                    final isSel = _historyFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: GestureDetector(
                        onTap: () => setState(() => _historyFilter = filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFF6C4CF1) : const Color(0xFFF8F9FD),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSel ? const Color(0xFF6C4CF1) : const Color(0xFFF0EDF8),
                            ),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSel ? Colors.white : const Color(0xFF475569),
                              fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Thin Divider Below Filters
            const Divider(height: 1, color: Color(0xFFF0EDF8)),

            // Scrollable Expense List (Subtle Dividers, 16px Layout Grid Alignment)
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.receipt, size: 40, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          const Text(
                            'No matching expenses found',
                            style: TextStyle(fontSize: 13.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredList.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0EDF8)),
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        final String title = item['title'];
                        final String category = item['category'];
                        final String amount = item['amount'];
                        final String date = item['date'];
                        final String route = item['route'] ?? '';
                        final String status = item['status'];

                        Color statusBg;
                        Color statusColor;
                        if (status == 'Approved') {
                          statusBg = const Color(0xFFECFDF5);
                          statusColor = const Color(0xFF10B981);
                        } else if (status == 'Rejected') {
                          statusBg = const Color(0xFFFEF2F2);
                          statusColor = const Color(0xFFEF4444);
                        } else {
                          statusBg = const Color(0xFFFFFBEB);
                          statusColor = const Color(0xFFD97706);
                        }

                        return InkWell(
                          onTap: () => _showExpenseDetailsBottomSheet(item),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                // Left: Soft Purple Rounded Square Icon
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3EEFF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      _getCategoryIcon(category),
                                      color: const Color(0xFF6C4CF1),
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Center: Expense Title (15px bold emphasis), Category + Date
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E1E2D),
                                          letterSpacing: -0.2,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$category • $date',
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: Color(0xFF7A7A9D),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (route.isNotEmpty && route != 'General Vehicle Expense') ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          route,
                                          style: const TextStyle(
                                            fontSize: 11.0,
                                            color: Color(0xFF94A3B8),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Right: Amount (₹ Primary Visual Focus - 16px bold), Colored Status Badge (Compact 10px), Chevron
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹ $amount',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E1E2D),
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: statusBg,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  LucideIcons.chevronRight,
                                  size: 16,
                                  color: Color(0xFF94A3B8),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// FULL-SCREEN SLIDE-UP BOTTOM SHEET FORM WIDGET
class _AddExpenseBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic> newExpense) onAddExpense;

  const _AddExpenseBottomSheet({
    required this.onAddExpense,
  });

  @override
  State<_AddExpenseBottomSheet> createState() => _AddExpenseBottomSheetState();
}

class _AddExpenseBottomSheetState extends State<_AddExpenseBottomSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _routeController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'Fuel';
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMethod = 'Fuel Card';
  Map<String, dynamic>? _uploadedReceipt;

  final List<String> _categories = ['Fuel', 'Toll', 'Parking', 'Maintenance', 'Other'];
  final List<String> _paymentMethods = ['Fuel Card', 'Fastag', 'Cash', 'Personal UPI'];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _routeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _simulatePickReceipt(String source) {
    setState(() {
      _uploadedReceipt = {
        'name': source == 'camera' ? 'captured_receipt_${DateTime.now().millisecondsSinceEpoch}.jpg' : 'receipt_doc_scan.pdf',
        'size': '1.4 MB',
        'type': source == 'camera' ? 'JPG Image' : 'PDF Document',
      };
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt attached (${_uploadedReceipt!['name']})'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeReceipt() {
    setState(() {
      _uploadedReceipt = null;
    });
  }

  void _submitForm() {
    final title = _titleController.text.trim();
    final amount = _amountController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an Expense Title'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the Expense Amount'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${_selectedDate.day} ${months[(_selectedDate.month - 1).clamp(0, 11)]} ${_selectedDate.year}';

    final newClaim = {
      'id': 'EXP-2026-${DateTime.now().millisecondsSinceEpoch % 1000}',
      'title': title,
      'category': _selectedCategory,
      'amount': amount,
      'date': dateStr,
      'route': _routeController.text.trim().isEmpty ? 'General Vehicle Expense' : _routeController.text.trim(),
      'paymentMethod': _selectedPaymentMethod,
      'status': 'Pending',
      'receiptName': _uploadedReceipt != null ? _uploadedReceipt!['name'] : 'receipt_attached.jpg',
      'receiptSize': _uploadedReceipt != null ? _uploadedReceipt!['size'] : '1.4 MB',
      'notes': _notesController.text.trim().isEmpty ? 'No additional notes.' : _notesController.text.trim(),
      'submittedTime': '$dateStr, Just now',
      'reviewTime': 'Pending Initial Review',
      'approvalTime': 'Pending Approval',
    };

    widget.onAddExpense(newClaim);
    Navigator.pop(context);
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
        children: isRequired
            ? const [
                TextSpan(text: ' *', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
              ]
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + keyboardPadding),
      child: SafeArea(
        child: Column(
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header Bar: Close (X) Icon on the LEFT, Title "Add Expense"
            Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20, color: Color(0xFF64748B)),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFE8ECF5)),
            const SizedBox(height: 14),

            // Form Scrollable Fields (Clean 8pt grid vertical spacing)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Field 1: Expense Category* (Dropdown with icon)
                    _buildFieldLabel('Expense Category', isRequired: true),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FD),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE8ECF5)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)),
                          items: _categories.map((cat) {
                            return DropdownMenuItem<String>(
                              value: cat,
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.tag, size: 16, color: Color(0xFF6C4CF1)),
                                  const SizedBox(width: 10),
                                  Text(
                                    cat,
                                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCategory = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Field 2: Expense Title*
                    _buildFieldLabel('Expense Title', isRequired: true),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 48,
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'e.g. Diesel Refill, Toll Fee, Parking Charge',
                          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FD),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8ECF5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8ECF5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Fields 3 & 4: 2-Column Row (Amount* & Expense Date*)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Amount (₹)', isRequired: true),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 48,
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(LucideIcons.indianRupee, size: 16, color: Color(0xFF64748B)),
                                    hintText: '0.00',
                                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                    filled: true,
                                    fillColor: const Color(0xFFF8F9FD),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFFE8ECF5)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFFE8ECF5)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Expense Date', isRequired: true),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDate,
                                    firstDate: DateTime(2025),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setState(() => _selectedDate = picked);
                                  }
                                },
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FD),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE8ECF5)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF64748B)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Field 5: Route / Trip Name (with location icon)
                    _buildFieldLabel('Route / Trip Name'),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 48,
                      child: TextField(
                        controller: _routeController,
                        decoration: InputDecoration(
                          hintText: 'e.g. Route 1 - Green Glen Morning Trip',
                          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                          prefixIcon: const Icon(LucideIcons.mapPin, size: 16, color: Color(0xFF64748B)),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FD),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8ECF5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8ECF5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Field 6: Payment Method (dropdown with card icon)
                    _buildFieldLabel('Payment Method'),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FD),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE8ECF5)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPaymentMethod,
                          isExpanded: true,
                          icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)),
                          items: _paymentMethods.map((pm) {
                            return DropdownMenuItem<String>(
                              value: pm,
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.creditCard, size: 16, color: Color(0xFF6C4CF1)),
                                  const SizedBox(width: 10),
                                  Text(
                                    pm,
                                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedPaymentMethod = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Field 7: Description / Notes (Optional)
                    _buildFieldLabel('Description / Notes (Optional)'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Add additional details or fuel meter reading info...',
                        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FD),
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE8ECF5)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE8ECF5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Field 8: Upload Receipt / Invoice* (Dashed Drag & Drop Dropzone)
                    _buildFieldLabel('Upload Receipt / Invoice', isRequired: true),
                    const SizedBox(height: 8),

                    _uploadedReceipt == null
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FD),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFC7D2FE), width: 1.5),
                            ),
                            child: Column(
                              children: [
                                const Icon(LucideIcons.uploadCloud, color: Color(0xFF6C4CF1), size: 30),
                                const SizedBox(height: 8),
                                const Text(
                                  'Drag & drop files here or tap to browse',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Supported formats: JPG, PNG, PDF (Max 5MB)',
                                  style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _simulatePickReceipt('camera'),
                                      icon: const Icon(LucideIcons.camera, size: 15),
                                      label: const Text('Camera'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF6C4CF1),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    OutlinedButton.icon(
                                      onPressed: () => _simulatePickReceipt('gallery'),
                                      icon: const Icon(LucideIcons.image, size: 15),
                                      label: const Text('Browse Files'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF1E1E2D),
                                        side: const BorderSide(color: Color(0xFFE8ECF5)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFBBF7D0)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Icon(LucideIcons.fileCheck, color: Color(0xFF10B981), size: 20),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _uploadedReceipt!['name'],
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${_uploadedReceipt!['type']} • ${_uploadedReceipt!['size']}',
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.refreshCw, size: 16, color: Color(0xFF6C4CF1)),
                                  onPressed: () => _simulatePickReceipt('gallery'),
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
                                  onPressed: _removeReceipt,
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Full-width Sticky Primary Purple Submit Expense Button
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                child: const Text('Submit Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
