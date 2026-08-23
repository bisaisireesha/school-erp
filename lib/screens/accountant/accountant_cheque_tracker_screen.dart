import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountantChequeTrackerScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AccountantChequeTrackerScreen({super.key, required this.onBack});

  @override
  State<AccountantChequeTrackerScreen> createState() =>
      _AccountantChequeTrackerScreenState();
}

class _AccountantChequeTrackerScreenState
    extends State<AccountantChequeTrackerScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Cleared', 'Bounced'];

  final List<Map<String, dynamic>> _cheques = [
    {
      'chequeNo': 'CHQ-001842',
      'payer': 'Ramesh Sharma',
      'bank': 'HDFC Bank',
      'amount': '₹45,000',
      'date': 'Aug 15, 2025',
      'dueDate': 'Aug 20, 2025',
      'purpose': 'Term 1 Fee',
      'status': 'Pending',
      'statusColor': const Color(0xFFF59E0B),
      'statusBg': const Color(0xFFFFFBEB),
    },
    {
      'chequeNo': 'CHQ-001843',
      'payer': 'Sonia Mehta',
      'bank': 'SBI',
      'amount': '₹85,000',
      'date': 'Aug 14, 2025',
      'dueDate': 'Aug 18, 2025',
      'purpose': 'Hostel Fee',
      'status': 'Cleared',
      'statusColor': const Color(0xFF16A34A),
      'statusBg': const Color(0xFFF0FDF4),
    },
    {
      'chequeNo': 'CHQ-001844',
      'payer': 'Arvind Patel',
      'bank': 'ICICI Bank',
      'amount': '₹12,500',
      'date': 'Aug 12, 2025',
      'dueDate': 'Aug 16, 2025',
      'purpose': 'Transport Fee',
      'status': 'Bounced',
      'statusColor': const Color(0xFFDC2626),
      'statusBg': const Color(0xFFFEF2F2),
    },
    {
      'chequeNo': 'CHQ-001845',
      'payer': 'Kavita Singh',
      'bank': 'Axis Bank',
      'amount': '₹25,000',
      'date': 'Aug 10, 2025',
      'dueDate': 'Aug 17, 2025',
      'purpose': 'Admission Fee',
      'status': 'Pending',
      'statusColor': const Color(0xFFF59E0B),
      'statusBg': const Color(0xFFFFFBEB),
    },
    {
      'chequeNo': 'CHQ-001846',
      'payer': 'Deepak Nair',
      'bank': 'Kotak Bank',
      'amount': '₹60,000',
      'date': 'Aug 8, 2025',
      'dueDate': 'Aug 12, 2025',
      'purpose': 'Term 2 Fee',
      'status': 'Cleared',
      'statusColor': const Color(0xFF16A34A),
      'statusBg': const Color(0xFFF0FDF4),
    },
  ];

  List<Map<String, dynamic>> get _filteredCheques {
    if (_selectedFilter == 'All') return _cheques;
    return _cheques.where((c) => c['status'] == _selectedFilter).toList();
  }

  int get _pendingCount =>
      _cheques.where((c) => c['status'] == 'Pending').length;
  int get _clearedCount =>
      _cheques.where((c) => c['status'] == 'Cleared').length;
  int get _bouncedCount =>
      _cheques.where((c) => c['status'] == 'Bounced').length;
  int get _totalCount => _cheques.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF3EEFF),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF1E1E2D),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cheque Tracker',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          Text(
                            'Track & manage cheque payments',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showAddChequeDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C4CF1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              LucideIcons.plus,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // KPI grid — 2 rows × 2 columns
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.1,
                  children: [
                    _buildKpiCard(
                      'Total Cheques',
                      _totalCount,
                      const Color(0xFF6C4CF1),
                      const Color(0xFFF3F0FF),
                      LucideIcons.fileText,
                    ),
                    _buildKpiCard(
                      'Pending',
                      _pendingCount,
                      const Color(0xFFF59E0B),
                      const Color(0xFFFFFBEB),
                      LucideIcons.clock,
                    ),
                    _buildKpiCard(
                      'Cleared',
                      _clearedCount,
                      const Color(0xFF16A34A),
                      const Color(0xFFF0FDF4),
                      LucideIcons.checkCircle2,
                    ),
                    _buildKpiCard(
                      'Bounced',
                      _bouncedCount,
                      const Color(0xFFDC2626),
                      const Color(0xFFFEF2F2),
                      LucideIcons.xCircle,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Filter tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((f) {
                      final isSelected = _selectedFilter == f;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedFilter = f),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF6C4CF1)
                                : const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF6C4CF1)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Cheque list (non-scrolling inside parent scroll)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: _filteredCheques
                      .map((c) => _buildChequeCard(c))
                      .toList(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(
    String label,
    int count,
    Color color,
    Color bgColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChequeCard(Map<String, dynamic> cheque) {
    final Color statusColor = cheque['statusColor'] as Color;
    final Color statusBg = cheque['statusBg'] as Color;

    return GestureDetector(
      onTap: () => _showChequeDetails(cheque),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cheque['chequeNo'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6C4CF1),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    cheque['status'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Payer + amount
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Icon(
                    LucideIcons.user,
                    color: Color(0xFF64748B),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cheque['payer'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${cheque['bank']} • ${cheque['purpose']}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      cheque['amount'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Due: ${cheque['dueDate']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 14),

            // Footer actions
            Row(
              children: [
                Icon(
                  LucideIcons.calendar,
                  size: 13,
                  color: const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 4),
                Text(
                  'Issued: ${cheque['date']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Text(
                      'View details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0EA5E9),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: Color(0xFF0EA5E9),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(Map<String, dynamic> cheque, String newStatus) {
    setState(() {
      cheque['status'] = newStatus;
      if (newStatus == 'Cleared') {
        cheque['statusColor'] = const Color(0xFF16A34A);
        cheque['statusBg'] = const Color(0xFFF0FDF4);
      } else {
        cheque['statusColor'] = const Color(0xFFDC2626);
        cheque['statusBg'] = const Color(0xFFFEF2F2);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Cheque status updated successfully!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(24),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showChequeDetails(Map<String, dynamic> cheque) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cheque Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        LucideIcons.x,
                        size: 20,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cheque['chequeNo'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C4CF1),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: cheque['statusBg'] as Color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            cheque['status'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: cheque['statusColor'] as Color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Payer Information',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Payer', cheque['payer'] as String),
                          const Divider(height: 24, color: Color(0xFFE2E8F0)),
                          _buildDetailRow('Bank', cheque['bank'] as String),
                          const Divider(height: 24, color: Color(0xFFE2E8F0)),
                          _buildDetailRow(
                            'Purpose',
                            cheque['purpose'] as String,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Amount', cheque['amount'] as String),
                          const Divider(height: 24, color: Color(0xFFE2E8F0)),
                          _buildDetailRow(
                            'Issued Date',
                            cheque['date'] as String,
                          ),
                          const Divider(height: 24, color: Color(0xFFE2E8F0)),
                          _buildDetailRow(
                            'Due Date',
                            cheque['dueDate'] as String,
                          ),
                        ],
                      ),
                    ),
                    if (cheque['status'] == 'Pending') ...[
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _updateStatus(cheque, 'Cleared');
                              },
                              icon: const Icon(
                                LucideIcons.checkCircle,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Mark Cleared',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF16A34A),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _updateStatus(cheque, 'Bounced');
                              },
                              icon: const Icon(
                                LucideIcons.xCircle,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Mark Bounced',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDC2626),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
          ),
        ),
      ],
    );
  }

  void _showAddChequeDialog(BuildContext context) {
    final payerController = TextEditingController();
    final bankController = TextEditingController();
    final chequeNoController = TextEditingController();
    final amountController = TextEditingController();
    final purposeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Cheque',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.close, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enter cheque details to start tracking.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildField('PAYER NAME', payerController),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: _buildField('CHEQUE NO', chequeNoController),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildField('BANK NAME', bankController)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        'AMOUNT (₹)',
                        amountController,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildField(
                  'PURPOSE (e.g. Term Fee, Transport)',
                  purposeController,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1E1E2D),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _cheques.insert(0, {
                            'chequeNo': chequeNoController.text.isEmpty
                                ? 'CHQ-NEW'
                                : 'CHQ-${chequeNoController.text}',
                            'payer': payerController.text.isEmpty
                                ? 'Unknown'
                                : payerController.text,
                            'bank': bankController.text.isEmpty
                                ? 'Unknown Bank'
                                : bankController.text,
                            'amount':
                                '₹${amountController.text.isEmpty ? '0' : amountController.text}',
                            'date': 'Today',
                            'dueDate': 'TBD',
                            'purpose': purposeController.text.isEmpty
                                ? 'General'
                                : purposeController.text,
                            'status': 'Pending',
                            'statusColor': const Color(0xFFF59E0B),
                            'statusBg': const Color(0xFFFFFBEB),
                          });
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cheque added successfully!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Add Cheque',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6C4CF1)),
            ),
          ),
        ),
      ],
    );
  }
}
