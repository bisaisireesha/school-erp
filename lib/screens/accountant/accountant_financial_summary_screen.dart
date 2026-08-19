import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountantFinancialSummaryScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AccountantFinancialSummaryScreen({super.key, required this.onBack});

  @override
  State<AccountantFinancialSummaryScreen> createState() => _AccountantFinancialSummaryScreenState();
}

class _AccountantFinancialSummaryScreenState extends State<AccountantFinancialSummaryScreen> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['This Month', 'Last Month', 'This Quarter', 'This Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
          ),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Financial Summary',
          style: TextStyle(
            color: Color(0xFF1E1E2D),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.download, color: Color(0xFF1E1E2D)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Financial report downloaded successfully!',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNetProfitCard(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Revenue',
                          '₹12,45,000',
                          '+12.5%',
                          LucideIcons.arrowUpRight,
                          const Color(0xFF16A34A),
                          const Color(0xFFF0FDF4),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMetricCard(
                          'Expenses',
                          '₹4,20,000',
                          '-2.4%',
                          LucideIcons.arrowDownRight,
                          const Color(0xFFEF4444),
                          const Color(0xFFFEF2F2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Revenue Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBreakdownSection([
                    _buildBreakdownRow('Tuition Fees', '₹8,50,000', 0.68, const Color(0xFF6C4CF1)),
                    _buildBreakdownRow('Transport Fees', '₹2,10,000', 0.17, const Color(0xFF3B82F6)),
                    _buildBreakdownRow('Hostel Fees', '₹1,50,000', 0.12, const Color(0xFFF59E0B)),
                    _buildBreakdownRow('Other Income', '₹35,000', 0.03, const Color(0xFF10B981)),
                  ]),
                  const SizedBox(height: 24),
                  const Text(
                    'Expense Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBreakdownSection([
                    _buildBreakdownRow('Staff Salaries', '₹2,80,000', 0.66, const Color(0xFFEF4444)),
                    _buildBreakdownRow('Maintenance', '₹65,000', 0.15, const Color(0xFFF97316)),
                    _buildBreakdownRow('Utilities', '₹45,000', 0.11, const Color(0xFF8B5CF6)),
                    _buildBreakdownRow('Miscellaneous', '₹30,000', 0.08, const Color(0xFF64748B)),
                  ]),
                  const SizedBox(height: 24),
                  const Text(
                    'Payment Mode Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBreakdownSection([
                    _buildBreakdownRow('Online (UPI/Bank)', '₹8,10,000', 0.65, const Color(0xFF3B82F6)),
                    _buildBreakdownRow('Cash', '₹3,75,000', 0.30, const Color(0xFF10B981)),
                    _buildBreakdownRow('Cheque', '₹60,000', 0.05, const Color(0xFFF59E0B)),
                  ]),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _periods.map((period) {
            final isSelected = _selectedPeriod == period;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedPeriod = period;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6C4CF1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    period,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNetProfitCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C4CF1), Color(0xFF8B74F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C4CF1).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Net Profit',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              const Text(
                '₹8,25,000',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(LucideIcons.trendingUp, color: Colors.greenAccent.shade100, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '+18.2% vs last period',
                    style: TextStyle(color: Colors.greenAccent.shade100, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.wallet, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String amount, String trend, IconData icon, Color color, Color bgColor) {
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
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: 8),
          Text(
            trend,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownSection(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String amount, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E1E2D)),
              ),
              Text(
                amount,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: const Color(0xFFF1F5F9),
                    color: color,
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 40,
                child: Text(
                  '${(percentage * 100).toInt()}%',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
