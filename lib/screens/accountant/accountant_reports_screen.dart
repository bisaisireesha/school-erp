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
      final title = (r['title'] as String?) ?? '';
      final description = (r['description'] as String?) ?? '';
      return title.toLowerCase().contains(q) ||
          description.toLowerCase().contains(q);
    }).toList();

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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4CF1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Text('This Month', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // KPI Cards
              _buildKPICards(),
              const SizedBox(height: 24),
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
    return GestureDetector(
      onTap: () => _downloadReport(report['title'] as String),
      child: Container(
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.download, color: Color(0xFF6C4CF1), size: 18),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadReport(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$title downloaded successfully!',
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

  Widget _buildKPICards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildKPI('Total Reports', '24 Generated', 'This period', LucideIcons.fileText, const Color(0xFF6C4CF1))),
              const SizedBox(width: 16),
              Expanded(child: _buildKPI('Pending Reviews', '5 Reports', 'Needs action', LucideIcons.alertCircle, const Color(0xFFF59E0B))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildKPI('Shared Docs', '18 Shared', 'With Mgmt.', LucideIcons.share2, const Color(0xFF10B981))),
              const SizedBox(width: 16),
              Expanded(child: _buildKPI('Scheduled', '12 Reports', 'Auto-generation', LucideIcons.calendarClock, const Color(0xFF3B82F6))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPI(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
