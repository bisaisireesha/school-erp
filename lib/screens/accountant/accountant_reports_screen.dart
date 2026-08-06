import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class AccountantReportsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AccountantReportsScreen({super.key, required this.onBack});

  @override
  State<AccountantReportsScreen> createState() => _AccountantReportsScreenState();
}

class _AccountantReportsScreenState extends State<AccountantReportsScreen> {
  String _searchQuery = '';
  int _selectedPeriod = 0;

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

  final List<Map<String, dynamic>> _reports = [
    {
      'title': 'Fee Collection Report',
      'description': 'Detailed fee collection by class & category',
      'icon': LucideIcons.receipt,
      'color': const Color(0xFF6C4CF1),
      'bg': const Color(0xFFF3F0FF),
      'lastGenerated': 'Aug 4, 2025',
    },
    {
      'title': 'Expense Report',
      'description': 'Monthly expense breakdown & analysis',
      'icon': LucideIcons.fileSpreadsheet,
      'color': const Color(0xFFEF4444),
      'bg': const Color(0xFFFEF2F2),
      'lastGenerated': 'Aug 3, 2025',
    },
    {
      'title': 'Outstanding Dues Report',
      'description': 'Students with pending fee payments',
      'icon': LucideIcons.alertCircle,
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFFFBEB),
      'lastGenerated': 'Aug 5, 2025',
    },
    {
      'title': 'Payroll Summary',
      'description': 'Staff salary disbursement details',
      'icon': LucideIcons.creditCard,
      'color': const Color(0xFF3B82F6),
      'bg': const Color(0xFFEFF6FF),
      'lastGenerated': 'Jul 31, 2025',
    },
    {
      'title': 'Revenue vs Expenses',
      'description': 'Comparative financial performance',
      'icon': LucideIcons.barChart3,
      'color': const Color(0xFF16A34A),
      'bg': const Color(0xFFF0FDF4),
      'lastGenerated': 'Aug 1, 2025',
    },
    {
      'title': 'Tax & Compliance',
      'description': 'TDS, GST & statutory compliance status',
      'icon': LucideIcons.shieldCheck,
      'color': const Color(0xFF8B5CF6),
      'bg': const Color(0xFFF5F3FF),
      'lastGenerated': 'Jul 28, 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredReports = _reports.where((r) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return (r['title'] as String).toLowerCase().contains(q) ||
          (r['description'] as String).toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Financial Reports', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                          Text('Generate & download reports', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Period Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: ['This Month', 'Last Month', 'Quarterly', 'Yearly'].asMap().entries.map((entry) {
                      final isSelected = _selectedPeriod == entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(entry.value),
                          selected: isSelected,
                          onSelected: (selected) => setState(() => _selectedPeriod = entry.key),
                          selectedColor: const Color(0xFF6C4CF1),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF64748B),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                          ),
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Report Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 900) {
                      return Wrap(
                        spacing: 16,
                        children: filteredReports.map((report) => SizedBox(
                          width: (constraints.maxWidth - 16) / 2,
                          child: _buildReportCard(report),
                        )).toList(),
                      );
                    }
                    return Column(
                      children: filteredReports.map((report) => _buildReportCard(report)).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: report['bg'] as Color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(report['icon'] as IconData, color: report['color'] as Color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report['title'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 3),
                Text(report['description'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                Text('Last: ${report['lastGenerated']}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Generating ${report['title']}...')),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.download, color: Color(0xFF6C4CF1), size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
