import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class FeePaymentsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const FeePaymentsScreen({super.key, required this.onBack});

  @override
  State<FeePaymentsScreen> createState() => _FeePaymentsScreenState();
}

class _FeePaymentsScreenState extends State<FeePaymentsScreen> {
  int _selectedSegment = 0;

  void _simulateDownload(String itemName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading $itemName...'),
        backgroundColor: const Color(0xFF6C4CF1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  // Mock JSON Data as requested
  final List<Map<String, dynamic>> _mockFees = [
    {
      "id": "INV-2026-001",
      "category": "Academics",
      "title": "Term 2 Tuition Fee",
      "description": "Includes sports and lab fees",
      "amount": "₹15,000",
      "dueDate": "15 Jun, 2026",
      "status": "Unpaid",
      "icon": LucideIcons.graduationCap,
    },
    {
      "id": "INV-2026-002",
      "category": "Transport",
      "title": "School Bus Transport",
      "description": "Route 4 - Morning & Afternoon",
      "amount": "₹3,000",
      "dueDate": "15 Jun, 2026",
      "status": "Unpaid",
      "icon": LucideIcons.bus,
    },
    {
      "id": "INV-2026-003",
      "category": "Academics",
      "title": "Term 1 Tuition Fee",
      "description": "Base tuition fee for Term 1",
      "amount": "₹15,000",
      "dueDate": "15 Jan, 2026",
      "status": "Paid",
      "paymentMethod": "UPI",
      "icon": LucideIcons.graduationCap,
    },
    {
      "id": "INV-2026-004",
      "category": "Library",
      "title": "Library Deposit",
      "description": "Annual refundable deposit",
      "amount": "₹500",
      "dueDate": "15 Jan, 2026",
      "status": "Paid",
      "paymentMethod": "Bank Transfer",
      "icon": LucideIcons.book,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Fees & Payments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Overview Cards (4 KPI Grid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          icon: LucideIcons.wallet,
                          iconColor: const Color(0xFF6C4CF1),
                          iconBg: const Color(0xFFF3F0FF),
                          value: '₹33,500',
                          label: 'Total Fee',
                          onTap: () => setState(() => _selectedSegment = 0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          icon: LucideIcons.checkCircle2,
                          iconColor: const Color(0xFF16A34A),
                          iconBg: const Color(0xFFF0FDF4),
                          value: '₹15,500',
                          label: 'Paid',
                          onTap: () => setState(() => _selectedSegment = 2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          icon: LucideIcons.alertCircle,
                          iconColor: const Color(0xFFE11D48),
                          iconBg: const Color(0xFFFFF1F2),
                          value: '₹18,000',
                          label: 'Pending',
                          onTap: () => setState(() => _selectedSegment = 1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          icon: LucideIcons.calendarClock,
                          iconColor: const Color(0xFFF59E0B),
                          iconBg: const Color(0xFFFFFBEB),
                          value: '15 Jun',
                          label: 'Due Date',
                          onTap: () => setState(() => _selectedSegment = 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildSegmentButton('All', 0)),
                    Expanded(child: _buildSegmentButton('Pending', 1)),
                    Expanded(child: _buildSegmentButton('Paid', 2)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Invoices List
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: MainLayout.globalSearchQuery,
                builder: (context, searchQuery, child) {
                  final query = searchQuery.toLowerCase();
                  final filteredFees = _mockFees.where((fee) {
                    return query.isEmpty || 
                           fee['title'].toString().toLowerCase().contains(query) ||
                           fee['category'].toString().toLowerCase().contains(query);
                  }).toList();

                  return ListView(
                    padding: const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 120),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      if (_selectedSegment == 0) ...[
                        _buildSectionHeader('Pending Dues'),
                        const SizedBox(height: 16),
                        if (filteredFees.where((fee) => fee['status'] != 'Paid').isEmpty)
                          const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("No pending dues!", style: TextStyle(color: Color(0xFF6C6C80))))),
                        _buildResponsiveList(filteredFees.where((fee) => fee['status'] != 'Paid').toList(), (fee) => _buildPendingCard(fee)),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Recent Payment History'),
                        const SizedBox(height: 16),
                        if (filteredFees.where((fee) => fee['status'] == 'Paid').isEmpty)
                          const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("No payment history.", style: TextStyle(color: Color(0xFF6C6C80))))),
                        _buildResponsiveList(filteredFees.where((fee) => fee['status'] == 'Paid').toList(), (fee) => _buildHistoryCard(fee)),
                      ] else if (_selectedSegment == 1) ...[
                        if (filteredFees.where((fee) => fee['status'] != 'Paid').isEmpty)
                          const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text("No pending dues!", style: TextStyle(color: Color(0xFF6C6C80))))),
                        _buildResponsiveList(filteredFees.where((fee) => fee['status'] != 'Paid').toList(), (fee) => _buildPendingCard(fee)),
                      ] else ...[
                        if (filteredFees.where((fee) => fee['status'] == 'Paid').isEmpty)
                          const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text("No payment history.", style: TextStyle(color: Color(0xFF6C6C80))))),
                        _buildResponsiveList(filteredFees.where((fee) => fee['status'] == 'Paid').toList(), (fee) => _buildHistoryCard(fee)),
                      ],
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveList(List<dynamic> items, Widget Function(dynamic) builder) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Wrap(
            spacing: 16,
            runSpacing: 0,
            children: items.map((item) {
              return SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: builder(item),
              );
            }).toList(),
          );
        } else {
          return Column(
            children: items.map((item) => builder(item)).toList(),
          );
        }
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildPendingCard(Map<String, dynamic> fee) {
    final bool isPaid = fee['status'] == 'Paid';
    final Color statusColor = isPaid ? const Color(0xFF16A34A) : const Color(0xFFE11D48);
    final Color statusBg = isPaid ? const Color(0xFFF0FDF4) : const Color(0xFFFFF1F2);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F4FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(fee['icon'] as IconData, color: const Color(0xFF6C4CF1), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fee['title']?.toString() ?? 'Title',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fee['id']?.toString() ?? 'ID',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(4)),
                      child: Text(fee['category']?.toString() ?? 'Fee', style: const TextStyle(fontSize: 10, color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Text(
                fee['amount']?.toString() ?? '₹0',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3EEFF)),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${fee['id']}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fee['description']?.toString() ?? 'No description',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Due Date',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF1E1E2D)),
                      const SizedBox(width: 6),
                      Text(
                        fee['dueDate']?.toString() ?? 'Unknown',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  fee['status']?.toString() ?? 'Unknown',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: statusColor),
                ),
              ),
            ],
          ),
          if (!isPaid) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showPaymentModal(fee),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Pay Now', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showPaymentModal(Map<String, dynamic> fee) {
    showDialog(
      context: context,
      builder: (context) {
        String paymentAmountType = 'full';
        String customAmount = '';
        bool isProcessing = false;
        bool isSuccess = false;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    if (isSuccess) ...[
                      // Success View
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0FDF4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.check, color: Color(0xFF16A34A), size: 48),
                      ),
                      const SizedBox(height: 24),
                      const Text('Payment Successful!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                      const SizedBox(height: 8),
                      Text('You have successfully paid ${paymentAmountType == 'full' ? fee['amount'] : '₹$customAmount'} for ${fee['title']}.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF6C6C80), height: 1.5)),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              fee['status'] = 'Paid';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ] else if (isProcessing) ...[
                      // Processing View
                      const SizedBox(height: 32),
                      const CircularProgressIndicator(color: Color(0xFF6C4CF1)),
                      const SizedBox(height: 24),
                      const Text('Processing Payment...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      const SizedBox(height: 32),
                    ] else ...[
                      // Payment Selection View
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(fee['title']?.toString() ?? 'Payment', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(4)),
                                  child: Text(fee['category']?.toString() ?? 'Fee', style: const TextStyle(fontSize: 10, color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(LucideIcons.x, color: Color(0xFF1E1E2D), size: 24),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('Payment Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setModalState(() => paymentAmountType = 'full'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: paymentAmountType == 'full' ? const Color(0xFF6C4CF1) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text('Full', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: paymentAmountType == 'full' ? Colors.white : const Color(0xFF6C6C80))),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setModalState(() => paymentAmountType = 'custom'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: paymentAmountType == 'custom' ? const Color(0xFF6C4CF1) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text('Custom', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: paymentAmountType == 'custom' ? Colors.white : const Color(0xFF6C6C80))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (paymentAmountType == 'custom') ...[
                        const SizedBox(height: 16),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter amount',
                            prefixText: '₹ ',
                            prefixStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            filled: true,
                            fillColor: const Color(0xFFF8F9FA),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 2),
                            ),
                          ),
                          onChanged: (val) {
                            setModalState(() {
                              customAmount = val;
                            });
                          },
                        ),
                      ],

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total to Pay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80))),
                          Text(paymentAmountType == 'full' ? fee['amount']?.toString() ?? '' : (customAmount.isEmpty ? '₹0' : '₹$customAmount'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setModalState(() => isProcessing = true);
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                setModalState(() {
                                  isProcessing = false;
                                  isSuccess = true;
                                });
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C4CF1),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text('Pay ${paymentAmountType == 'full' ? fee['amount']?.toString() ?? '' : (customAmount.isEmpty ? '₹0' : '₹$customAmount')}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> fee) {
    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(fee['icon'] as IconData, color: const Color(0xFF16A34A), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fee['title']?.toString() ?? 'Title',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${fee['id']}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(4)),
                    child: Text(fee['category']?.toString() ?? 'Fee', style: const TextStyle(fontSize: 10, color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Paid on ${fee['dueDate']} • ${fee['paymentMethod'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80)),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  fee['amount']?.toString() ?? '₹0',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF16A34A)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _showInvoiceModal(fee),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(LucideIcons.eye, size: 14, color: Color(0xFF6C4CF1)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _simulateDownload('Invoice #${fee['id']}'),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(LucideIcons.download, size: 14, color: Color(0xFF6C4CF1)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
  }

  void _showInvoiceModal(Map<String, dynamic> fee) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0FDF4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.receipt, color: Color(0xFF16A34A), size: 32),
                ),
                const SizedBox(height: 16),
                const Text('Invoice Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 24),
                _buildInvoiceRow('Invoice No.', '#${fee['id']}'),
                const SizedBox(height: 12),
                _buildInvoiceRow('Category', fee['category']?.toString() ?? 'Fee'),
                const SizedBox(height: 12),
                _buildInvoiceRow('Description', fee['title']?.toString() ?? 'Payment'),
                const SizedBox(height: 12),
                _buildInvoiceRow('Date Paid', fee['dueDate']?.toString() ?? 'Unknown'),
                const SizedBox(height: 12),
                _buildInvoiceRow('Payment Method', fee['paymentMethod']?.toString() ?? 'Unknown'),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF3EEFF), thickness: 1.5),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Paid', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    Text(fee['amount']?.toString() ?? '₹0', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF16A34A))),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F0FF),
                      foregroundColor: const Color(0xFF6C4CF1),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Close', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInvoiceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80))),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
      ],
    );
  }

  Widget _buildSegmentButton(String title, int index) {
    final isSelected = _selectedSegment == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedSegment = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
