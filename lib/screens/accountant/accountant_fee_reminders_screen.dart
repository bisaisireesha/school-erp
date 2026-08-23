import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountantFeeRemindersScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AccountantFeeRemindersScreen({super.key, required this.onBack});

  @override
  State<AccountantFeeRemindersScreen> createState() =>
      _AccountantFeeRemindersScreenState();
}

class _AccountantFeeRemindersScreenState
    extends State<AccountantFeeRemindersScreen> {
  String _searchQuery = '';
  int _selectedFilter = 0; // 0: All, 1: Overdue, 2: Upcoming, 3: Sent

  final List<Map<String, dynamic>> _mockReminders = [
    {
      'id': 'ADM-260592',
      'student': 'Saanvi Khan',
      'class': 'Class 5A',
      'amount': '₹3,750',
      'dueDate': 'Oct 15, 2026',
      'status': 'Overdue',
      'days': '10 days ago',
      'feeHead': 'Tuition Fee',
      'phone': '+91 98765 43210',
    },
    {
      'id': 'ADM-260629',
      'student': 'Vihaan Shah',
      'class': 'Class 7C',
      'amount': '₹2,700',
      'dueDate': 'Oct 20, 2026',
      'status': 'Overdue',
      'days': '5 days ago',
      'feeHead': 'Hostel Fee',
      'phone': '+91 87654 32109',
    },
    {
      'id': 'ADM-260500',
      'student': 'Rohan Das',
      'class': 'Class 7C',
      'amount': '₹1,500',
      'dueDate': 'Oct 28, 2026',
      'status': 'Upcoming',
      'days': 'In 3 days',
      'feeHead': 'Transport Fee',
      'phone': '+91 76543 21098',
    },
    {
      'id': 'ADM-260711',
      'student': 'Aarav Patel',
      'class': 'Class 5A',
      'amount': '₹8,500',
      'dueDate': 'Oct 30, 2026',
      'status': 'Upcoming',
      'days': 'In 5 days',
      'feeHead': 'Annual Fee',
      'phone': '+91 65432 10987',
    },
    {
      'id': 'ADM-260502',
      'student': 'Zoya Varma',
      'class': 'Class 8D',
      'amount': '₹3,600',
      'dueDate': 'Oct 20, 2026',
      'status': 'Sent',
      'days': 'Sent yesterday',
      'feeHead': 'Tuition Fee',
      'phone': '+91 54321 09876',
    },
    {
      'id': 'ADM-260703',
      'student': 'Kabir Sharma',
      'class': 'Class 5A',
      'amount': '₹2,812',
      'dueDate': 'Oct 10, 2026',
      'status': 'Sent',
      'days': 'Sent 3 days ago',
      'feeHead': 'Hostel Fee',
      'phone': '+91 43210 98765',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredReminders = _mockReminders.where((r) {
      if (_selectedFilter == 1 && r['status'] != 'Overdue') return false;
      if (_selectedFilter == 2 && r['status'] != 'Upcoming') return false;
      if (_selectedFilter == 3 && r['status'] != 'Sent') return false;

      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final student = (r['student'] as String?) ?? '';
      final id = (r['id'] as String?) ?? '';
      final feeHead = (r['feeHead'] as String?) ?? '';
      return student.toLowerCase().contains(q) ||
          id.toLowerCase().contains(q) ||
          feeHead.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
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
                    if (filteredReminders.isEmpty)
                      _buildEmptyState()
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 900) {
                              return Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: filteredReminders
                                    .map(
                                      (r) => SizedBox(
                                        width: (constraints.maxWidth - 16) / 2,
                                        child: _buildReminderCard(r),
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredReminders.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildReminderCard(
                                    filteredReminders[index],
                                  ),
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
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Fee Reminders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        LucideIcons.checkCircle,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Reminders sent to all overdue accounts!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFF16A34A),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(24),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            icon: const Icon(LucideIcons.send, size: 16, color: Colors.white),
            label: const Text(
              'Send All',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
              Expanded(
                child: _buildKPICard(
                  'Overdue',
                  '24',
                  LucideIcons.alertTriangle,
                  const Color(0xFFEF4444),
                  const Color(0xFFFEF2F2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKPICard(
                  'Upcoming',
                  '56',
                  LucideIcons.calendarClock,
                  const Color(0xFFF59E0B),
                  const Color(0xFFFFFBEB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  'Sent Today',
                  '12',
                  LucideIcons.mailCheck,
                  const Color(0xFF16A34A),
                  const Color(0xFFF0FDF4),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKPICard(
                  'Response Rate',
                  '42%',
                  LucideIcons.barChart2,
                  const Color(0xFF0EA5E9),
                  const Color(0xFFE0F2FE),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
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
          _buildFilterButton(1, 'Overdue'),
          _buildFilterButton(2, 'Upcoming'),
          _buildFilterButton(3, 'Sent'),
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
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C4CF1)
                : const Color(0xFFE2E8F0),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6C4CF1).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
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
            hintText: 'Search students, classes...',
            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            prefixIcon: Icon(
              LucideIcons.search,
              color: Color(0xFF94A3B8),
              size: 18,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> r) {
    Color statusColor;
    Color statusBgColor;

    switch (r['status']) {
      case 'Overdue':
        statusColor = const Color(0xFFEF4444);
        statusBgColor = const Color(0xFFFEF2F2);
        break;
      case 'Upcoming':
        statusColor = const Color(0xFFF59E0B);
        statusBgColor = const Color(0xFFFFFBEB);
        break;
      case 'Sent':
        statusColor = const Color(0xFF16A34A);
        statusBgColor = const Color(0xFFF0FDF4);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r['student'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${r['id']} • ${r['class']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  r['status'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
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
                  const Text(
                    'Pending Amount',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    r['amount'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Fee Head',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    r['feeHead'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.calendar, size: 14, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    'Due: ${r['dueDate']} (${r['days']})',
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          LucideIcons.checkCircle,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Reminder sent to ${r['student']}!',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFF16A34A),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(24),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              icon: const Icon(LucideIcons.send, size: 16, color: Colors.white),
              label: const Text(
                'Send Reminder',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
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
            child: const Icon(
              LucideIcons.checkCircle,
              size: 48,
              color: Color(0xFF16A34A),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'All clear!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No reminders match your criteria.',
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
