import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class TransportFeeCollectionScreen extends StatefulWidget {
  const TransportFeeCollectionScreen({super.key});

  @override
  State<TransportFeeCollectionScreen> createState() =>
      _TransportFeeCollectionScreenState();
}

class _TransportFeeCollectionScreenState
    extends State<TransportFeeCollectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedTabIndex = 0;

  // State for Quick Payment Form
  String? _selectedStudent;
  String? _selectedPaymentMethod = 'UPI';
  bool _isFullSettlement = false;
  final TextEditingController _dateController = TextEditingController(
    text: '24/08/2026',
  );
  final List<Map<String, dynamic>> _tabs = [
    {'title': 'Fee Accounts', 'icon': LucideIcons.users},
    {'title': 'Record Payment', 'icon': LucideIcons.receipt},
    {'title': 'Fare Structure', 'icon': LucideIcons.wallet},
    {'title': 'Collection Summary', 'icon': LucideIcons.trendingUp},
  ];

  final List<Map<String, dynamic>> _students = [
    {
      'name': 'Yuvaan Kumar',
      'email': 'student29@aprogram.com',
      'class': 'Nursery-B',
      'isAssigned': true,
      'isPaid': false,
      'route': 'Route 1 - North Bangalore',
      'stop': 'MG Road',
      'time': '07:00',
      'busReg': 'KA-01-CD-5...',
      'feePlan': 'Monthly',
      'totalFee': '₹1,500',
      'amountPaid': '₹0',
      'balance': '₹1,500',
    },
    {
      'name': 'Trisha Singh',
      'email': 'student28@aprogram.com',
      'class': 'Nursery-B',
      'isAssigned': true,
      'isPaid': false,
      'route': 'Route 3 - East Bangalore',
      'stop': 'Whitefield',
      'time': '06:45',
      'busReg': 'KA-01-AB-12...',
      'feePlan': 'Monthly',
      'totalFee': '₹1,500',
      'amountPaid': '₹500',
      'balance': '₹1,000',
    },
    {
      'name': 'Aarav Mehta',
      'email': 'student31@aprogram.com',
      'class': 'LKG-A',
      'isAssigned': true,
      'isPaid': true,
      'route': 'Route 2 - South Bangalore',
      'stop': 'Jayanagar',
      'time': '07:15',
      'busReg': 'KA-02-EF-3344',
      'feePlan': 'Quarterly',
      'totalFee': '₹4,000',
      'amountPaid': '₹4,000',
      'balance': '₹0',
    },
  ];

  final List<Map<String, dynamic>> _recentPayments = [
    {
      'studentName': 'Aarav Mehta',
      'date': '24 Aug 2026',
      'amount': '₹4,000',
      'method': 'UPI',
      'receiptNo': 'RCP-180274',
      'status': 'Success',
    },
    {
      'studentName': 'Diya Sharma',
      'date': '23 Aug 2026',
      'amount': '₹3,000',
      'method': 'Cash',
      'receiptNo': 'RCP-180273',
      'status': 'Success',
    },
  ];

  final List<Map<String, dynamic>> _routes = [
    {
      'name': 'Route 1 - North Bangalore',
      'busReg': 'KA-01-AB-1234',
      'stops': '2 stops',
      'yearlyAmount': '₹0',
      'annualAmount': '₹0',
      'students': '14',
      'costPerYear': '₹0/yr',
    },
    {
      'name': 'Route 2 - South Bangalore',
      'busReg': 'KA-01-CD-5678',
      'stops': '1 stops',
      'yearlyAmount': '₹0',
      'annualAmount': '₹0',
      'students': '7',
      'costPerYear': '₹0/yr',
    },
    {
      'name': 'Route 3 - East Bangalore',
      'busReg': 'KA-01-EF-9012',
      'stops': '1 stops',
      'yearlyAmount': '₹0',
      'annualAmount': '₹0',
      'students': '7',
      'costPerYear': '₹0/yr',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = _students;
    if (_selectedTabIndex == 1) {
      filteredList = _students.where((s) => s['isPaid'] == false).toList();
    } else if (_selectedTabIndex == 2) {
      filteredList = _students.where((s) => s['isPaid'] == true).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildKPICards(),
              _buildTabs(),
              if (_selectedTabIndex == 0) ...[
                _buildSearchBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fee Records',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...filteredList.map((student) => _buildFeeCard(student)),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ] else if (_selectedTabIndex == 1) ...[
                _buildQuickPaymentForm(),
                _buildRecentPayments(),
                const SizedBox(height: 40),
              ] else if (_selectedTabIndex == 2) ...[
                _buildFareStructure(),
                const SizedBox(height: 40),
              ] else if (_selectedTabIndex == 3) ...[
                _buildCollectionSummary(),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => MainLayout.popSubScreen(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF1E1E2D),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Fee Collection',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1E2D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  title: 'Total Collected',
                  value: '₹0',
                  subtitle: '0 accounts paid',
                  icon: LucideIcons.trendingUp,
                  color: const Color(0xFF10B981),
                  bgColor: const Color(0xFFDCFCE7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKPICard(
                  title: 'Pending Balance',
                  value: '₹0',
                  subtitle: '0 accounts',
                  icon: LucideIcons.clock,
                  color: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFEF3C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  title: 'Total Discount',
                  value: '₹0',
                  subtitle: 'discounts tracked',
                  icon: LucideIcons.percent,
                  color: const Color(0xFF6C4CF1),
                  bgColor: const Color(0xFFF3F0FF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKPICard(
                  title: 'Overdue',
                  value: '0',
                  subtitle: 'needs follow-up',
                  icon: LucideIcons.alertTriangle,
                  color: const Color(0xFFEF4444),
                  bgColor: const Color(0xFFFEE2E2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1E2D),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF3EEFF), width: 1.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? const Color(0xFF6C4CF1)
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tabs[index]['icon'],
                      size: 18,
                      color: isSelected
                          ? const Color(0xFF6C4CF1)
                          : const Color(0xFF6C6C80),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _tabs[index]['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w900
                            : FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF6C4CF1)
                            : const Color(0xFF6C6C80),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        ),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search student or route...',
            hintStyle: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              LucideIcons.search,
              color: Color(0xFF9CA3AF),
              size: 18,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
          onChanged: (val) {
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _buildFeeCard(Map<String, dynamic> student) {
    return GestureDetector(
      onTap: () => _showViewDetailsBottomSheet(context, student),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F0FF),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        student['name'][0],
                        style: const TextStyle(
                          color: Color(0xFF6C4CF1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          student['email'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6C6C80),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F0FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            student['class'],
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C4CF1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (student['isAssigned'])
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
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
                                'Assigned',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: student['isPaid']
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              student['isPaid']
                                  ? LucideIcons.checkCircle2
                                  : LucideIcons.xCircle,
                              size: 12,
                              color: student['isPaid']
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              student['isPaid'] ? 'Paid' : 'Not Paid',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: student['isPaid']
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF3EEFF), thickness: 1.5),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.mapPin,
                          size: 16,
                          color: Color(0xFF6C4CF1),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student['route'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${student['stop']} • ${student['time']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 32,
                    color: const Color(0xFFF3EEFF),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.bus,
                          size: 16,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bus Reg No',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6C6C80),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                student['busReg'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 20,
                    color: Color(0xFF6C4CF1),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(color: Color(0xFFF8F9FA)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFeeColumn('FEE PLAN', student['feePlan']),
                  _buildFeeColumn('TOTAL FEE', student['totalFee']),
                  _buildFeeColumn('AMOUNT PAID', student['amountPaid']),
                  _buildFeeColumn(
                    'BALANCE',
                    student['balance'],
                    valueColor: student['balance'] == '₹0'
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showViewDetailsBottomSheet(
    BuildContext context,
    Map<String, dynamic> student,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Fee Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Color(0xFF6C6C80)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFF3F0FF),
                    child: Text(
                      student['name'][0],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${student['class']} • ${student['email'] ?? 'student@email.com'}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Fee Summary',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C6C80),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    _buildBottomSheetRow('Fee Plan', student['feePlan']),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFE5E7EB)),
                    const SizedBox(height: 12),
                    _buildBottomSheetRow('Total Fee', student['totalFee']),
                    const SizedBox(height: 12),
                    _buildBottomSheetRow('Amount Paid', student['amountPaid']),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFE5E7EB)),
                    const SizedBox(height: 12),
                    _buildBottomSheetRow(
                      'Balance',
                      student['balance'],
                      isTotal: true,
                      valueColor: student['balance'] == '₹0'
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedTabIndex = 1; // Switch to Record Payment tab
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Record Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
            color: isTotal ? const Color(0xFF1E1E2D) : const Color(0xFF6C6C80),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.w900,
            color: valueColor ?? const Color(0xFF1E1E2D),
          ),
        ),
      ],
    );
  }

  Widget _buildFeeColumn(String label, String value, {Color? valueColor}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C6C80),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: valueColor ?? const Color(0xFF1E1E2D),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickPaymentForm() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
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
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    LucideIcons.zap,
                    color: Color(0xFF6C4CF1),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Quick Payment Entry',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Student',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
              ),
            ),
            const SizedBox(height: 8),
            _buildDropdownField(
              hint: 'Choose student...',
              icon: LucideIcons.user,
              value: _selectedStudent,
              items: _students.map((s) => s['name'] as String).toList(),
              onChanged: (val) => setState(() => _selectedStudent = val),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Amount (₹)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFormField(
                        hint: 'Enter amount',
                        icon: Icons.currency_rupee,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdownField(
                        hint: 'UPI',
                        icon: LucideIcons.creditCard,
                        value: _selectedPaymentMethod,
                        items: const ['UPI', 'Cash', 'Bank Transfer', 'Card'],
                        onChanged: (val) =>
                            setState(() => _selectedPaymentMethod = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Receipt No.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFormField(
                        hint: 'RCP-180274',
                        icon: LucideIcons.fileText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Date',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFormField(
                        hint: 'Payment Date',
                        icon: LucideIcons.calendar,
                        controller: _dateController,
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFF6C4CF1),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              _dateController.text =
                                  "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Notes (Optional)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
              ),
            ),
            const SizedBox(height: 8),
            _buildFormField(hint: 'Optional notes', icon: LucideIcons.copy),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () =>
                  setState(() => _isFullSettlement = !_isFullSettlement),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _isFullSettlement
                          ? const Color(0xFF6C4CF1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _isFullSettlement
                            ? const Color(0xFF6C4CF1)
                            : const Color(0xFFD1D5DB),
                        width: 1.5,
                      ),
                    ),
                    child: _isFullSettlement
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Mark as full settlement',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                if (_selectedStudent == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a student')),
                  );
                  return;
                }

                setState(() {
                  _recentPayments.insert(0, {
                    'studentName': _selectedStudent,
                    'date': 'Just now',
                    'amount': '₹1,500', // Mock amount
                    'method': _selectedPaymentMethod ?? 'UPI',
                    'receiptNo': 'RCP-180275',
                    'status': 'Success',
                  });
                  _selectedStudent = null;
                  _isFullSettlement = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment recorded successfully!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D5FEF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(LucideIcons.receipt, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Record Payment',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget _buildDropdownField({
    required String hint,
    required IconData icon,
    required List<String> items,
    String? value,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6C6C80)),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                icon: const Icon(
                  LucideIcons.chevronDown,
                  size: 18,
                  color: Color(0xFF1E1E2D),
                ),
                isExpanded: true,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E2D),
                ),
                onChanged: onChanged,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String hint,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6C6C80)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E1E2D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPayments() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Payments',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 16),
          ..._recentPayments.map((payment) => _buildRecentPaymentCard(payment)),
        ],
      ),
    );
  }

  Widget _buildRecentPaymentCard(Map<String, dynamic> payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
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
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.checkCircle2,
              color: Color(0xFF10B981),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment['studentName'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${payment['date']} • ${payment['receiptNo']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                payment['amount'],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF6C4CF1),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                payment['method'],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6C6C80),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFareStructure() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFareStructureKPICards(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Routes Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6C4CF1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._routes.map((route) => _buildRouteCard(route)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFareStructureKPICards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFareKPICard(
                  'YEARLY REVENUE',
                  '₹0',
                  const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFareKPICard(
                  'ANNUAL REVENUE',
                  '₹0',
                  const Color(0xFF1E1E2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFareKPICard(
                  'TOTAL ROUTES',
                  '3',
                  const Color(0xFF1E1E2D),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFareKPICard(
                  'TOTAL STUDENTS',
                  '28',
                  const Color(0xFF1E1E2D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFareKPICard(String title, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C6C80),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(
                      LucideIcons.calendar,
                      size: 14,
                      color: Color(0xFF6C4CF1),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Aug 2026',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      LucideIcons.chevronDown,
                      size: 14,
                      color: Color(0xFF6C4CF1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildSummaryGridCard(
                  'TOTAL COLLECTED',
                  '₹12,400',
                  LucideIcons.wallet,
                  const Color(0xFF10B981),
                  '+12% this month',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryGridCard(
                  'PENDING DUES',
                  '₹3,200',
                  LucideIcons.alertCircle,
                  const Color(0xFFF59E0B),
                  '14 students',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryGridCard(
                  'TARGET ACHIEVED',
                  '80%',
                  LucideIcons.target,
                  const Color(0xFF6C4CF1),
                  '₹15,500 total',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryGridCard(
                  'TRANSACTIONS',
                  '42',
                  LucideIcons.receipt,
                  const Color(0xFF3B82F6),
                  'Avg. ₹295/txn',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Payment Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 16),
          Container(
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
                ),
              ],
            ),
            child: Column(
              children: [
                _buildBreakdownBar('UPI Payments', 65, const Color(0xFF10B981)),
                const SizedBox(height: 16),
                _buildBreakdownBar(
                  'Cash Payments',
                  25,
                  const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 16),
                _buildBreakdownBar(
                  'Bank Transfer',
                  10,
                  const Color(0xFF3B82F6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Route-wise Collections',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 16),
          _buildRouteCollectionCard('Route 1 - North Bangalore', '₹6,000', 60),
          _buildRouteCollectionCard('Route 2 - South Bangalore', '₹4,400', 35),
          _buildRouteCollectionCard('Route 3 - East Bangalore', '₹2,000', 15),
        ],
      ),
    );
  }

  Widget _buildRouteCollectionCard(
    String routeName,
    String amount,
    int percentage,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              LucideIcons.mapPin,
              color: Color(0xFF6C4CF1),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  routeName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      height: 4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percentage / 100,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C4CF1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1E2D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryGridCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C6C80),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color, // Matching value to the icon color
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownBar(String title, int percentage, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage / 100,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> route) {
    return GestureDetector(
      onTap: () => _showRouteDetailsBottomSheet(context, route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LucideIcons.mapPin,
                    color: Color(0xFF6C4CF1),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route['name'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.directions_bus_outlined,
                            size: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${route['busReg']} • ${route['stops']}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: Color(0xFF6C6C80), size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'YEARLY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C6C80),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          route['yearlyAmount'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(
                              0xFF10B981,
                            ), // Green color as per design
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: const Color(0xFFE5E7EB),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ANNUAL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C6C80),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          route['annualAmount'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF3EEFF), height: 1, thickness: 1.5),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.users,
                      size: 16,
                      color: Color(0xFF6C6C80),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      route['students'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'students',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C6C80),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 16,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      route['costPerYear'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF10B981),
                      ),
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

  void _showRouteDetailsBottomSheet(
    BuildContext context,
    Map<String, dynamic> route,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Route Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Color(0xFF6C6C80)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      LucideIcons.mapPin,
                      color: Color(0xFF6C4CF1),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${route['busReg']} • ${route['stops']} stops',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Financial Overview',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C6C80),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    _buildBottomSheetRow(
                      'Yearly Revenue Target',
                      route['yearlyAmount'],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFE5E7EB)),
                    const SizedBox(height: 12),
                    _buildBottomSheetRow(
                      'Annual Revenue Target',
                      route['annualAmount'],
                    ),
                    const SizedBox(height: 12),
                    _buildBottomSheetRow(
                      'Cost per Student',
                      route['costPerYear'],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFE5E7EB)),
                    const SizedBox(height: 12),
                    _buildBottomSheetRow(
                      'Total Students Assigned',
                      route['students'],
                      isTotal: true,
                      valueColor: const Color(0xFF10B981),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to full route map or list of students if needed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'View Assigned Students',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
