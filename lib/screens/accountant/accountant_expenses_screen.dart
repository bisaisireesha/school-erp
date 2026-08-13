import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountantExpensesScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AccountantExpensesScreen({super.key, required this.onBack});

  @override
  State<AccountantExpensesScreen> createState() => _AccountantExpensesScreenState();
}

class _AccountantExpensesScreenState extends State<AccountantExpensesScreen> {
  String _searchQuery = '';
  int _selectedFilter = 0; // 0: All, 1: Pending, 2: Paid, 3: Rejected

  final TextEditingController _vendorController = TextEditingController(text: 'New Vendor');
  final TextEditingController _amountController = TextEditingController(text: '18500');
  final TextEditingController _dateController = TextEditingController(text: '20/07/2026');
  final TextEditingController _dueDateController = TextEditingController(text: '30/07/2026');
  final TextEditingController _ownerController = TextEditingController(text: 'Accounts Desk');
  final TextEditingController _descController = TextEditingController(text: 'Attach scanned bill during backend phase.');

  String _selectedCategory = 'Supplies';
  final List<String> _categories = ['Supplies', 'Utilities', 'Maintenance', 'Vendor Payment'];

  final List<Map<String, dynamic>> _mockExpenses = [
    {
      'id': 'EXP-23901',
      'vendor': 'City Power Board',
      'category': 'Utilities',
      'amount': '₹45,000',
      'date': 'Oct 24, 2026',
      'status': 'Pending',
      'description': 'Electricity bill for October',
    },
    {
      'id': 'EXP-23902',
      'vendor': 'Sharma Stationery Mart',
      'category': 'Supplies',
      'amount': '₹12,450',
      'date': 'Oct 20, 2026',
      'status': 'Paid',
      'description': 'Exam papers and printer ink',
    },
    {
      'id': 'EXP-23903',
      'vendor': 'Rapid Tech Repairs',
      'category': 'Maintenance',
      'amount': '₹8,000',
      'date': 'Oct 18, 2026',
      'status': 'Pending',
      'description': 'Computer lab AC repair',
    },
    {
      'id': 'EXP-23904',
      'vendor': 'Fresh Catering Services',
      'category': 'Vendor Payment',
      'amount': '₹1,20,000',
      'date': 'Oct 15, 2026',
      'status': 'Paid',
      'description': 'Hostel mess contract payment',
    },
    {
      'id': 'EXP-23905',
      'vendor': 'ABC Internet Provider',
      'category': 'Utilities',
      'amount': '₹6,500',
      'date': 'Oct 12, 2026',
      'status': 'Rejected',
      'description': 'Duplicate bill submitted',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _mockExpenses.where((e) {
      if (_selectedFilter == 1 && e['status'] != 'Pending') return false;
      if (_selectedFilter == 2 && e['status'] != 'Paid') return false;
      if (_selectedFilter == 3 && e['status'] != 'Rejected') return false;

      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final vendor = (e['vendor'] as String?) ?? '';
      final category = (e['category'] as String?) ?? '';
      final id = (e['id'] as String?) ?? '';
      return vendor.toLowerCase().contains(q) ||
             category.toLowerCase().contains(q) ||
             id.toLowerCase().contains(q);
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
                    _buildSearchBar(),
                    if (filteredExpenses.isEmpty)
                      _buildEmptyState()
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 900) {
                              return Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: filteredExpenses.map((e) => SizedBox(
                                  width: (constraints.maxWidth - 16) / 2,
                                  child: _buildExpenseCard(e),
                                )).toList(),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredExpenses.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildExpenseCard(filteredExpenses[index]),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onBack,
                  child: const Icon(LucideIcons.arrowLeft, size: 24, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Bills & Expenses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => _showCreateBillSheet(context),
            icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
            label: const Text('Create Bill', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildKPICard('Expenses (MTD)', '₹1.8L', LucideIcons.wallet, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
              const SizedBox(width: 16),
              Expanded(child: _buildKPICard('Pending Bills', '12', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildKPICard('Paid Bills', '45', LucideIcons.checkCircle, const Color(0xFF16A34A), const Color(0xFFF0FDF4))),
              const SizedBox(width: 16),
              Expanded(child: _buildKPICard('High Value', '₹1.2L', LucideIcons.trendingUp, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE))),
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
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE2E8F0).withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterButton(0, 'All'),
          _buildFilterButton(1, 'Pending'),
          _buildFilterButton(2, 'Paid'),
          _buildFilterButton(3, 'Rejected'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(int index, String title) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
          boxShadow: isSelected ? [
            BoxShadow(color: const Color(0xFF6C4CF1).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
          ] : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
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
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: 'Search vendors, categories, ID...',
            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            prefixIcon: Icon(LucideIcons.search, color: Color(0xFF94A3B8), size: 18),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseCard(Map<String, dynamic> e) {
    Color statusColor;
    Color statusBgColor;

    switch (e['status']) {
      case 'Pending':
        statusColor = const Color(0xFFF59E0B); // Orange
        statusBgColor = const Color(0xFFFFFBEB);
        break;
      case 'Paid':
        statusColor = const Color(0xFF16A34A); // Green
        statusBgColor = const Color(0xFFF0FDF4);
        break;
      case 'Rejected':
        statusColor = const Color(0xFFEF4444); // Red
        statusBgColor = const Color(0xFFFEF2F2);
        break;
      default:
        statusColor = const Color(0xFF64748B);
        statusBgColor = const Color(0xFFF1F5F9);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  e['vendor'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  e['status'],
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
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
                  const Text('Bill Number', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(e['id'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Category', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(e['category'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                ],
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
                    const Text('Total Amount', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(e['amount'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Balance', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(e['status'] == 'Paid' ? '₹0' : e['amount'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: e['status'] == 'Paid' ? const Color(0xFF16A34A) : const Color(0xFFEF4444))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Date', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(e['date'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(LucideIcons.fileText, size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  e['description'],
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: e['status'] == 'Pending'
                ? ElevatedButton.icon(
                    onPressed: () => _showProcessPaymentSheet(context, e),
                    icon: const Icon(LucideIcons.checkCircle, size: 16, color: Colors.white),
                    label: const Text('Process Payment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  )
                : OutlinedButton.icon(
                    onPressed: () => _showViewDetailsSheet(context, e),
                    icon: const Icon(LucideIcons.eye, size: 16, color: Color(0xFF1E1E2D)),
                    label: const Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
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
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
            ),
            child: const Icon(LucideIcons.checkCircle, size: 48, color: Color(0xFF16A34A)),
          ),
          const SizedBox(height: 24),
          const Text(
            'All caught up!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: 8),
          const Text(
            'No expenses match your criteria.',
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  void _showCreateBillSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create Vendor Bill',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(LucideIcons.x, color: Color(0xFF1E1E2D)),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildInputField('VENDOR / SUPPLIER', _vendorController)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Category *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F9FA),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedCategory,
                                        isExpanded: true,
                                        icon: const Icon(LucideIcons.chevronDown, color: Color(0xFF94A3B8), size: 18),
                                        items: _categories.map((String cat) {
                                          return DropdownMenuItem<String>(
                                            value: cat,
                                            child: Text(cat, style: const TextStyle(color: Color(0xFF1E1E2D), fontSize: 14)),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setSheetState(() {
                                              _selectedCategory = newValue;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildInputField('BILL DATE', _dateController, icon: LucideIcons.calendar, readOnly: true, onTap: () => _selectDate(context, _dateController))),
                            const SizedBox(width: 16),
                            Expanded(child: _buildInputField('DUE DATE', _dueDateController, icon: LucideIcons.calendar, readOnly: true, onTap: () => _selectDate(context, _dueDateController))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildInputField('BILL AMOUNT', _amountController)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildInputField('OWNER / DEPARTMENT', _ownerController)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInputField('NOTES', _descController, maxLines: 3),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mockExpenses.insert(0, {
                              'id': 'EXP-${23906 + _mockExpenses.length}',
                              'vendor': _vendorController.text.isNotEmpty ? _vendorController.text : 'Unknown Vendor',
                              'category': _selectedCategory,
                              'amount': '₹${_amountController.text}',
                              'date': _dateController.text,
                              'status': 'Pending',
                              'description': _descController.text.isNotEmpty ? _descController.text : 'No description',
                            });
                          });
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          Navigator.pop(context);
                          scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Vendor Bill created successfully!')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('Create Bill', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
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
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1E2D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      controller.text = '${picked.day.toString().padLeft(2, '0')} ${months[picked.month - 1]} ${picked.year}';
    }
  }

  void _showProcessPaymentSheet(BuildContext context, Map<String, dynamic> e) {
    int step = 0;
    String selectedMethod = 'Net Banking';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              if (step == 0) ...[
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text('Complete Payment', style: TextStyle(fontSize: 16, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(e['amount'], style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                      const SizedBox(height: 4),
                      Text('Paying ${e['vendor']}', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('Select Payment Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                ),
                _buildPaymentMethodTile(LucideIcons.building, 'Net Banking', 'Axis, HDFC, SBI, ICICI', selectedMethod == 'Net Banking', () => setSheetState(() => selectedMethod = 'Net Banking')),
                _buildPaymentMethodTile(LucideIcons.smartphone, 'UPI / QR', 'Google Pay, PhonePe, Paytm', selectedMethod == 'UPI / QR', () => setSheetState(() => selectedMethod = 'UPI / QR')),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    onPressed: () async {
                      setSheetState(() => step = 1);
                      await Future.delayed(const Duration(seconds: 2));
                      if (!context.mounted) return;
                      setSheetState(() => step = 2);
                      setState(() {
                        e['status'] = 'Paid';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Pay Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ] else if (step == 1) ...[
                _buildProcessingState(e['vendor']),
              ] else if (step == 2) ...[
                _buildSuccessState(context, e['amount']),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingState(String vendor) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF6C4CF1)),
          const SizedBox(height: 24),
          const Text('Processing Payment...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          Text('Connecting securely to $vendor', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, String amount) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF0FDF4),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.checkCircle, color: Color(0xFF16A34A), size: 48),
          ),
          const SizedBox(height: 24),
          const Text('Payment Successful!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          Text('Successfully paid $amount', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(IconData icon, String title, String subtitle, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F0FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFF64748B), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                ],
              ),
            ),
            if (isSelected)
              const Icon(LucideIcons.checkCircle2, color: Color(0xFF6C4CF1), size: 20)
            else
              Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFE2E8F0)))),
          ],
        ),
      ),
    );
  }

  void _showViewDetailsSheet(BuildContext context, Map<String, dynamic> e) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bill ${e['id']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 8),
                        Text('Vendor: ${e['vendor']}', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(LucideIcons.x, color: Color(0xFF1E1E2D)),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                      Text(e['amount'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Date', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                      Text(e['date'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: e['status'] == 'Paid' ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(e['status'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: e['status'] == 'Paid' ? const Color(0xFF16A34A) : const Color(0xFFEF4444))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {IconData? icon, int maxLines = 1, bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            if (label == 'VENDOR / SUPPLIER' || label == 'BILL AMOUNT' || label == 'BILL DATE')
              const Text(' *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(color: Color(0xFF1E1E2D), fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: icon != null ? Icon(icon, color: const Color(0xFF94A3B8), size: 18) : null,
            ),
          ),
        ),
      ],
    );
  }
}
