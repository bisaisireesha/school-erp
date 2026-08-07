import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class AccountantInvoicesScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AccountantInvoicesScreen({super.key, required this.onBack});

  @override
  State<AccountantInvoicesScreen> createState() => _AccountantInvoicesScreenState();
}

class _AccountantInvoicesScreenState extends State<AccountantInvoicesScreen> {
  String _searchQuery = '';
  int _selectedFilter = 0; // 0: All, 1: Paid, 2: Unpaid, 3: Overdue

  @override
  void initState() {
    super.initState();
    MainLayout.globalSearchQuery.addListener(_onGlobalSearchChanged);
    _searchQuery = MainLayout.globalSearchQuery.value;
  }

  void _onGlobalSearchChanged() {
    if (mounted) {
      setState(() {
        _searchQuery = MainLayout.globalSearchQuery.value;
      });
    }
  }

  @override
  void dispose() {
    MainLayout.globalSearchQuery.removeListener(_onGlobalSearchChanged);
    super.dispose();
  }

  final List<Map<String, dynamic>> _invoices = [
    {
      'id': 'INV-1041',
      'student': 'Aarav Gupta',
      'rollNo': '10A-014',
      'grade': 'Grade 10-A',
      'feeHead': 'Tuition + Lab',
      'amount': '₹24,500',
      'balance': '₹0',
      'date': '10 Jun 2026',
      'status': 'Paid',
    },
    {
      'id': 'INV-1042',
      'student': 'Rahul Verma',
      'rollNo': '09B-021',
      'grade': 'Grade 9-B',
      'feeHead': 'Transport',
      'amount': '₹12,500',
      'balance': '₹12,500',
      'date': '12 Jun 2026',
      'status': 'Unpaid',
    },
    {
      'id': 'INV-1038',
      'student': 'Neha Gupta',
      'rollNo': '12S-005',
      'grade': 'Grade 12-Sci',
      'feeHead': 'Tuition + Hostel',
      'amount': '₹55,000',
      'balance': '₹20,000',
      'date': '05 Jun 2026',
      'status': 'Overdue',
    },
    {
      'id': 'INV-1044',
      'student': 'Vikram Singh',
      'rollNo': '08C-032',
      'grade': 'Grade 8-C',
      'feeHead': 'Tuition',
      'amount': '₹28,000',
      'balance': '₹28,000',
      'date': '15 Jun 2026',
      'status': 'Unpaid',
    },
    {
      'id': 'INV-1035',
      'student': 'Priya Desai',
      'rollNo': '11C-018',
      'grade': 'Grade 11-Com',
      'feeHead': 'Tuition + Lab',
      'amount': '₹42,000',
      'balance': '₹0',
      'date': '01 Jun 2026',
      'status': 'Paid',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredInvoices = _invoices.where((inv) {
      // Apply search
      final q = _searchQuery.toLowerCase();
      final id = (inv['id'] as String?) ?? '';
      final student = (inv['student'] as String?) ?? '';
      final rollNo = (inv['rollNo'] as String?) ?? '';
      final matchesSearch = id.toLowerCase().contains(q) ||
          student.toLowerCase().contains(q) ||
          rollNo.toLowerCase().contains(q);
      
      if (!matchesSearch) return false;

      // Apply filter
      if (_selectedFilter == 1 && inv['status'] != 'Paid') return false;
      if (_selectedFilter == 2 && inv['status'] != 'Unpaid') return false;
      if (_selectedFilter == 3 && inv['status'] != 'Overdue') return false;

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildKPIs(),
                    _buildFilters(),
                    if (filteredInvoices.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: _buildEmptyState(),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 900) {
                              return Wrap(
                                spacing: 16,
                                children: filteredInvoices.map((inv) => SizedBox(
                                  width: (constraints.maxWidth - 16) / 2,
                                  child: _buildInvoiceCard(inv),
                                )).toList(),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: filteredInvoices.length,
                              itemBuilder: (context, index) {
                                return _buildInvoiceCard(filteredInvoices[index]);
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPIs() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildKPICard('Total Invoices', '1,245', LucideIcons.fileText, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
              const SizedBox(width: 16),
              Expanded(child: _buildKPICard('Paid Amount', '₹ 8.5L', LucideIcons.checkCircle, const Color(0xFF16A34A), const Color(0xFFF0FDF4))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildKPICard('Pending', '₹ 2.1L', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
              const SizedBox(width: 16),
              Expanded(child: _buildKPICard('Overdue', '₹ 45K', LucideIcons.alertCircle, const Color(0xFFEF4444), const Color(0xFFFEF2F2))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: const Icon(LucideIcons.arrowLeft, size: 24, color: Color(0xFF1E1E2D)),
              ),
              const SizedBox(width: 16),
              const Text(
                'Invoice Management',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _showCreateInvoiceBottomSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            icon: const Icon(LucideIcons.plus, size: 16),
            label: const Text('New Invoice', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }


  Widget _buildFilters() {
    final filters = ['All Invoices', 'Paid', 'Unpaid', 'Overdue'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(filters.length, (index) {
            final isSelected = _selectedFilter == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> inv) {
    final status = inv['status'] as String;
    Color statusColor;
    Color statusBg;
    
    if (status == 'Paid') {
      statusColor = const Color(0xFF16A34A);
      statusBg = const Color(0xFFF0FDF4);
    } else if (status == 'Unpaid') {
      statusColor = const Color(0xFFF59E0B);
      statusBg = const Color(0xFFFFFBEB);
    } else {
      statusColor = const Color(0xFFEF4444);
      statusBg = const Color(0xFFFEF2F2);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                inv['id'] as String,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(LucideIcons.user, color: Color(0xFF94A3B8), size: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inv['student'] as String,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${inv['feeHead']} • ${inv['grade']}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Due: ${inv['date']}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Amount', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    inv['amount'] as String,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showDownloadBottomSheet(inv);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(LucideIcons.download, size: 18, color: Color(0xFF64748B)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      _showInvoiceDetails(inv);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(color: Color(0xFF6C4CF1), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
            ),
            child: const Icon(LucideIcons.fileSearch, size: 48, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Invoices Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filters or search query.',
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  void _showDownloadBottomSheet(Map<String, dynamic> inv) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F0FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.download, size: 32, color: Color(0xFF6C4CF1)),
              ),
              const SizedBox(height: 24),
              Text(
                'Downloading ${inv['id']}...',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your invoice is being downloaded. This will take just a moment.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download complete!')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Got it', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInvoiceDetails(Map<String, dynamic> inv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${inv['id']} Details', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(LucideIcons.x, size: 24, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildDetailRow('Student', '${inv['student']} (${inv['rollNo']})'),
              const SizedBox(height: 16),
              _buildDetailRow('Fee Head', inv['feeHead'] as String),
              const SizedBox(height: 16),
              _buildDetailRow('Amount', inv['amount'] as String),
              const SizedBox(height: 16),
              _buildDetailRow('Balance', inv['balance'] as String),
              const SizedBox(height: 16),
              _buildDetailRow('Due Date', inv['date'] as String),
              const SizedBox(height: 16),
              _buildDetailRow('Status', inv['status'] as String),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8F9FA),
                    foregroundColor: const Color(0xFF1E1E2D),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Close', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  void _showCreateInvoiceBottomSheet() {
    final studentCtrl = TextEditingController();
    final rollNoCtrl = TextEditingController();
    final classCtrl = TextEditingController();
    final feeHeadCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Create Receivable Invoice', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 4),
                        const Text(
                          'Use this when the school is billing a student or parent and expects money to come in.',
                          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(LucideIcons.x, size: 24, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildFormField('Student / Parent Name', 'e.g. Aarav Patel', controller: studentCtrl)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormField('Roll No', 'e.g. 08A-000', controller: rollNoCtrl)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildFormField('Class', 'e.g. Grade 8-A', controller: classCtrl)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormField('Fee Head', 'e.g. Tuition Fee', controller: feeHeadCtrl)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF6C4CF1), // header background color
                                  onPrimary: Colors.white, // header text color
                                  onSurface: Color(0xFF1E1E2D), // body text color
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (date != null) {
                          setModalState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: _buildFormField(
                          'Due Date', 
                          selectedDate != null ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}' : 'e.g. 07/30/2026', 
                          icon: LucideIcons.calendar
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormField('Invoice Amount', 'e.g. 12500', controller: amountCtrl)),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.fileText, color: Color(0xFF6C4CF1), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('This creates an incoming receivable.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 4),
                          const Text(
                            'The invoice starts as Pending with zero paid amount. Collection will later create a receipt and reduce the balance.',
                            style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFF1F5F9)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (studentCtrl.text.isEmpty || amountCtrl.text.isEmpty || selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields.')));
                        return;
                      }
                      Navigator.pop(context);
                      setState(() {
                        _invoices.insert(0, {
                          'id': 'INV-${1050 + _invoices.length}',
                          'student': studentCtrl.text,
                          'rollNo': rollNoCtrl.text.isEmpty ? 'N/A' : rollNoCtrl.text,
                          'grade': classCtrl.text.isEmpty ? 'N/A' : classCtrl.text,
                          'feeHead': feeHeadCtrl.text.isEmpty ? 'General' : feeHeadCtrl.text,
                          'amount': '₹${amountCtrl.text}',
                          'balance': '₹${amountCtrl.text}',
                          'date': '${selectedDate!.day.toString().padLeft(2, '0')} ${_getMonthName(selectedDate!.month)} ${selectedDate!.year}',
                          'status': 'Unpaid',
                        });
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice created successfully!')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Create Invoice', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildFormField(String label, String hint, {IconData? icon, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            const Text(' *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8E3F8)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D)),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (icon != null) Icon(icon, color: const Color(0xFF94A3B8), size: 18),
            ],
          ),
        ),
      ],
    );
  }
}
