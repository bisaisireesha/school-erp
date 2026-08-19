import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:math' as math;
import '../main_layout.dart';
import 'accountant_quick_collection_screen.dart';
import 'accountant_expenses_screen.dart';
import 'accountant_invoices_screen.dart';
import 'accountant_reports_screen.dart';
import 'accountant_pay_slips_screen.dart';
import 'accountant_bank_accounts_screen.dart';
import 'accountant_deposits_screen.dart';
import 'accountant_overdue_screen.dart';
import 'accountant_receipts_screen.dart';
import 'accountant_payment_history_screen.dart';

class AccountantDashboardScreen extends StatefulWidget {
  const AccountantDashboardScreen({super.key});

  @override
  State<AccountantDashboardScreen> createState() => _AccountantDashboardScreenState();
}

class _AccountantDashboardScreenState extends State<AccountantDashboardScreen> {
  String _searchQuery = '';
  int? _selectedChartIndex;

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            _buildKPICards(),
            const SizedBox(height: 24),
            _buildSectionTitle('Recent Transactions', onTap: () => MainLayout.pushSubScreen(context, AccountantPaymentHistoryScreen(onBack: () => MainLayout.popSubScreen(context)))),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => MainLayout.pushSubScreen(context, AccountantPaymentHistoryScreen(onBack: () => MainLayout.popSubScreen(context))),
              child: _buildRecentTransactions(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Collection Trend', onTap: () => MainLayout.pushSubScreen(context, AccountantDepositsScreen(onBack: () => MainLayout.popSubScreen(context)))),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => MainLayout.pushSubScreen(context, AccountantDepositsScreen(onBack: () => MainLayout.popSubScreen(context))),
              child: _buildCollectionTrendChart(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Payment Mode', onTap: () => MainLayout.pushSubScreen(context, AccountantReceiptsScreen(onBack: () => MainLayout.popSubScreen(context)))),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => MainLayout.pushSubScreen(context, AccountantReceiptsScreen(onBack: () => MainLayout.popSubScreen(context))),
              child: _buildPaymentModeSection(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Overdue Accounts', onTap: () => MainLayout.pushSubScreen(context, AccountantOverdueScreen(onBack: () => MainLayout.popSubScreen(context)))),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => MainLayout.pushSubScreen(context, AccountantOverdueScreen(onBack: () => MainLayout.popSubScreen(context))),
              child: _buildOverdueAccounts(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Quick Actions'),
            const SizedBox(height: 14),
            _buildQuickActions(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C4CF1), Color(0xFF8B6CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C4CF1).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning! 👋',
                  style: TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Finance Overview',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Academic Year 2024-25',
                    style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(LucideIcons.landmark, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildKpiCard('Total Revenue', '₹24.5L', LucideIcons.indianRupee, const Color(0xFF16A34A), const Color(0xFFF0FDF4), '+12.3%', onTap: () => MainLayout.pushSubScreen(context, AccountantDepositsScreen(onBack: () => MainLayout.popSubScreen(context))))),
            const SizedBox(width: 12),
            Expanded(child: _buildKpiCard('Pending Fees', '₹8.2L', LucideIcons.clock, const Color(0xFFEF4444), const Color(0xFFFEF2F2), '142 students', onTap: () => MainLayout.pushSubScreen(context, AccountantOverdueScreen(onBack: () => MainLayout.popSubScreen(context))))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildKpiCard('Today\'s Collection', '₹1.8L', LucideIcons.wallet, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF), '23 receipts', onTap: () => MainLayout.pushSubScreen(context, AccountantReceiptsScreen(onBack: () => MainLayout.popSubScreen(context))))),
            const SizedBox(width: 12),
            Expanded(child: _buildKpiCard('Expenses', '₹6.4L', LucideIcons.trendingDown, const Color(0xFFF59E0B), const Color(0xFFFFFBEB), 'This month', onTap: () => MainLayout.pushSubScreen(context, AccountantExpensesScreen(onBack: () => MainLayout.popSubScreen(context))))),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color, Color bgColor, String subtitle, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(subtitle, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        ],
      ),
      ),
    );
  }
    Widget _buildSectionTitle(String title, {VoidCallback? onTap}) {
      Widget titleWidget = Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)));
      if (onTap != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleWidget,
            GestureDetector(
              onTap: onTap,
              child: const Row(
                children: [
                  Text('View All', style: TextStyle(color: Color(0xFF6C4CF1), fontSize: 12, fontWeight: FontWeight.bold)),
                  Icon(Icons.chevron_right, color: Color(0xFF6C4CF1), size: 16),
                ],
              ),
            ),
          ],
        );
      }
      return titleWidget;
    }

  Widget _buildRecentTransactions() {
    final transactions = [
      {'name': 'Aarav Sharma', 'type': 'Fee Payment', 'amount': '₹25,000', 'time': '10:15 AM', 'status': 'Completed', 'statusColor': const Color(0xFF16A34A), 'statusBg': const Color(0xFFF0FDF4), 'icon': LucideIcons.arrowDownLeft, 'iconColor': const Color(0xFF16A34A), 'iconBg': const Color(0xFFF0FDF4)},
      {'name': 'Lab Equipment', 'type': 'Expense', 'amount': '-₹45,600', 'time': '09:30 AM', 'status': 'Processed', 'statusColor': const Color(0xFF3B82F6), 'statusBg': const Color(0xFFEFF6FF), 'icon': LucideIcons.arrowUpRight, 'iconColor': const Color(0xFFEF4444), 'iconBg': const Color(0xFFFEF2F2)},
      {'name': 'Priya Patel', 'type': 'Fee Payment', 'amount': '₹18,500', 'time': 'Yesterday', 'status': 'Completed', 'statusColor': const Color(0xFF16A34A), 'statusBg': const Color(0xFFF0FDF4), 'icon': LucideIcons.arrowDownLeft, 'iconColor': const Color(0xFF16A34A), 'iconBg': const Color(0xFFF0FDF4)},
      {'name': 'Staff Salary - July', 'type': 'Payroll', 'amount': '-₹3,25,000', 'time': 'Yesterday', 'status': 'Completed', 'statusColor': const Color(0xFF16A34A), 'statusBg': const Color(0xFFF0FDF4), 'icon': LucideIcons.arrowUpRight, 'iconColor': const Color(0xFFEF4444), 'iconBg': const Color(0xFFFEF2F2)},
      {'name': 'Rohit Kumar', 'type': 'Fee Payment', 'amount': '₹32,000', 'time': '2 days ago', 'status': 'Completed', 'statusColor': const Color(0xFF16A34A), 'statusBg': const Color(0xFFF0FDF4), 'icon': LucideIcons.arrowDownLeft, 'iconColor': const Color(0xFF16A34A), 'iconBg': const Color(0xFFF0FDF4)},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: transactions.asMap().entries.map((entry) {
          final txn = entry.value;
          final isLast = entry.key == transactions.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: txn['iconBg'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(txn['icon'] as IconData, color: txn['iconColor'] as Color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(txn['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(txn['type'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              const SizedBox(width: 8),
                              Text('• ${txn['time']}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          txn['amount'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: (txn['amount'] as String).startsWith('-') ? const Color(0xFFEF4444) : const Color(0xFF16A34A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: txn['statusBg'] as Color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(txn['status'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: txn['statusColor'] as Color)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isLast) Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Collection Trend Bar Chart ──
  Widget _buildCollectionTrendChart() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
    final collections = [3.2, 4.8, 3.6, 5.1, 4.4, 6.2, 5.5];
    final expenses   = [2.1, 2.8, 3.0, 2.6, 3.5, 3.8, 4.1];
    final maxValue = 7.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Legend row
          Row(
            children: [
              _buildLegendDot(const Color(0xFF6C4CF1), 'Collection'),
              const SizedBox(width: 14),
              _buildLegendDot(const Color(0xFF64748B), 'Expenses'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Last 7 Months', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6C4CF1))),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Chart area using CustomPaint
          LayoutBuilder(
            builder: (context, constraints) {
              final chartWidth = constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTapUp: (details) {
                      const leftPadding = 30.0;
                      final chartAreaWidth = chartWidth - leftPadding;
                      final barGroupWidth = chartAreaWidth / months.length;
                      final dx = details.localPosition.dx;
                      if (dx > leftPadding) {
                        final index = ((dx - leftPadding) / barGroupWidth).floor();
                        if (index >= 0 && index < months.length) {
                          setState(() {
                            if (_selectedChartIndex == index) {
                              _selectedChartIndex = null;
                            } else {
                              _selectedChartIndex = index;
                            }
                          });
                        }
                      }
                    },
                    child: SizedBox(
                      height: 180,
                      width: chartWidth,
                      child: CustomPaint(
                        painter: _BarChartPainter(
                          months: months,
                          collections: collections,
                          expenses: expenses,
                          maxValue: maxValue,
                          chartWidth: chartWidth,
                          selectedIndex: _selectedChartIndex,
                        ),
                      ),
                    ),
                  ),
                  if (_selectedChartIndex != null)
                    Positioned(
                      top: 10,
                      left: math.max(
                        0.0,
                        math.min(
                          chartWidth - 100, // Tooltip roughly 100px wide, prevent clipping on right
                          30.0 + ((chartWidth - 30.0) / months.length) * _selectedChartIndex! + ((chartWidth - 30.0) / months.length) / 2 - 50,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.8), blurRadius: 8, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              months[_selectedChartIndex!],
                              style: const TextStyle(color: Color(0xFF1E1E2D), fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Coll: ₹${collections[_selectedChartIndex!]}L',
                              style: const TextStyle(color: Color(0xFF6C4CF1), fontSize: 11, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              'Exp: ₹${expenses[_selectedChartIndex!]}L',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          // Summary row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(LucideIcons.trendingUp, color: Color(0xFF6C4CF1), size: 14),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹32.8L', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                          Text('Collected', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(LucideIcons.trendingDown, color: Color(0xFF64748B), size: 14),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹21.9L', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                          Text('Expenses', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
      ],
    );
  }

  // ── Payment Mode Section ──
  Widget _buildPaymentModeSection() {
    final paymentModes = [
      {'mode': 'Online/UPI', 'amount': '₹12.4L', 'count': '234', 'percent': 0.45, 'color': const Color(0xFF6C4CF1), 'icon': LucideIcons.smartphone},
      {'mode': 'Bank Transfer', 'amount': '₹8.6L', 'count': '86', 'percent': 0.31, 'color': const Color(0xFF3B82F6), 'icon': LucideIcons.building},
      {'mode': 'Cash', 'amount': '₹3.8L', 'count': '112', 'percent': 0.14, 'color': const Color(0xFF16A34A), 'icon': LucideIcons.banknote},
      {'mode': 'Cheque', 'amount': '₹2.2L', 'count': '28', 'percent': 0.08, 'color': const Color(0xFFF59E0B), 'icon': LucideIcons.fileText},
      {'mode': 'Card', 'amount': '₹0.5L', 'count': '15', 'percent': 0.02, 'color': const Color(0xFFEF4444), 'icon': LucideIcons.creditCard},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Donut chart + total
          Row(
            children: [
              // Custom painted donut chart
              SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(
                  painter: _DonutChartPainter(
                    segments: paymentModes.map((m) => _DonutSegment(
                      value: m['percent'] as double,
                      color: m['color'] as Color,
                    )).toList(),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('₹27.5L', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                        Text('Total', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Legends
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: paymentModes.map((mode) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: mode['color'] as Color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            mode['mode'] as String,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          Text(
                            '${((mode['percent'] as double) * 100).toInt()}%',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mode['color'] as Color),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Divider
          Container(height: 1, color: const Color(0xFFF1F5F9)),
          const SizedBox(height: 16),
          // Payment mode detail cards
          ...paymentModes.map((mode) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (mode['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(mode['icon'] as IconData, color: mode['color'] as Color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mode['mode'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 2),
                        Text('${mode['count']} transactions', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(mode['amount'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (mode['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${((mode['percent'] as double) * 100).toInt()}%',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: mode['color'] as Color),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Overdue Accounts ──
  Widget _buildOverdueAccounts() {
    final overdueAccounts = [
      {'name': 'Vikram Reddy', 'class': 'Class 10-A', 'amount': '₹42,000', 'daysOverdue': 45, 'feeType': 'Tuition Fee'},
      {'name': 'Sneha Joshi', 'class': 'Class 8-B', 'amount': '₹28,500', 'daysOverdue': 32, 'feeType': 'Tuition + Transport'},
      {'name': 'Arjun Nair', 'class': 'Class 12-A', 'amount': '₹55,000', 'daysOverdue': 60, 'feeType': 'Hostel + Tuition'},
      {'name': 'Meera Gupta', 'class': 'Class 6-C', 'amount': '₹18,000', 'daysOverdue': 21, 'feeType': 'Transport Fee'},
      {'name': 'Rahul Verma', 'class': 'Class 9-A', 'amount': '₹35,200', 'daysOverdue': 38, 'feeType': 'Tuition Fee'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(LucideIcons.alertTriangle, color: Color(0xFFEF4444), size: 14),
                    ),
                    const SizedBox(width: 8),
                    const Text('5 accounts overdue', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('₹1,78,700', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFEF4444))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...overdueAccounts.asMap().entries.map((entry) {
            final account = entry.value;
            final isLast = entry.key == overdueAccounts.length - 1;
            final daysOverdue = account['daysOverdue'] as int;
            Color urgencyColor;
            if (daysOverdue >= 60) {
              urgencyColor = const Color(0xFFEF4444);
            } else if (daysOverdue >= 30) {
              urgencyColor = const Color(0xFFF59E0B);
            } else {
              urgencyColor = const Color(0xFF3B82F6);
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: urgencyColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            (account['name'] as String).split(' ').map((w) => w[0]).take(2).join(),
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: urgencyColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(account['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(account['class'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                const SizedBox(width: 6),
                                Text('• ${account['feeType']}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(account['amount'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: urgencyColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('$daysOverdue days', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: urgencyColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isLast) Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),
              ],
            );
          }),
          // Send Reminder Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reminders sent to all overdue accounts!')),
                  );
                },
                icon: const Icon(LucideIcons.send, size: 16),
                label: const Text('Send Reminder to All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6C4CF1),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Actions ──
  Widget _buildQuickActions() {
    final actions = [
      {'icon': LucideIcons.receipt, 'label': 'Fee\nCollection', 'key': 'fee'},
      {'icon': LucideIcons.fileSpreadsheet, 'label': 'Expense\nEntry', 'key': 'expense'},
      {'icon': LucideIcons.fileText, 'label': 'Generate\nInvoice', 'key': 'invoice'},
      {'icon': LucideIcons.pieChart, 'label': 'View\nReports', 'key': 'reports'},
      {'icon': LucideIcons.creditCard, 'label': 'Process\nPayroll', 'key': 'payroll'},
      {'icon': LucideIcons.building, 'label': 'Bank\nRecon', 'key': 'bank'},
      {'icon': LucideIcons.shieldCheck, 'label': 'Tax\nFiling', 'key': 'tax'},
      {'icon': LucideIcons.history, 'label': 'Audit\nLogs', 'key': 'audit'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 4;
          if (constraints.maxWidth > 900) {
            crossAxisCount = 8;
          } else if (constraints.maxWidth > 500) {
            crossAxisCount = 6;
          }
          return GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 20,
            crossAxisSpacing: 4,
            childAspectRatio: 0.75,
            children: actions.map((action) {
          return GestureDetector(
            onTap: () {
              final key = action['key'] as String;
              Widget? screen;
              if (key == 'fee') {
                screen = AccountantQuickCollectionScreen(onBack: () => MainLayout.popSubScreen(context));
              } else if (key == 'expense') {
                screen = AccountantExpensesScreen(onBack: () => MainLayout.popSubScreen(context));
              } else if (key == 'invoice') {
                screen = AccountantInvoicesScreen(onBack: () => MainLayout.popSubScreen(context));
              } else if (key == 'reports') {
                screen = AccountantReportsScreen(onBack: () => MainLayout.popSubScreen(context));
              } else if (key == 'payroll') {
                screen = AccountantPaySlipsScreen(onBack: () => MainLayout.popSubScreen(context));
              } else if (key == 'bank') {
                screen = AccountantBankAccountsScreen(onBack: () => MainLayout.popSubScreen(context));
              }

              if (screen != null) {
                MainLayout.pushSubScreen(context, screen);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${(action['label'] as String).replaceAll('\n', ' ')} - Coming soon!')),
                );
              }
            },
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F0FF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(action['icon'] as IconData, color: const Color(0xFF6C4CF1), size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF4A4A68), height: 1.1),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
          );
        },
      ),
    );
  }
}

// ── Donut Chart Painter ──
class _DonutSegment {
  final double value;
  final Color color;
  _DonutSegment({required this.value, required this.color});
}

class _DonutChartPainter extends CustomPainter {
  final List<_DonutSegment> segments;
  _DonutChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 16.0;
    const gapAngle = 0.04;

    double startAngle = -math.pi / 2;

    for (final segment in segments) {
      final sweepAngle = segment.value * 2 * math.pi - gapAngle;
      if (sweepAngle <= 0) {
        startAngle += segment.value * 2 * math.pi;
        continue;
      }
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += segment.value * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Bar Chart Painter ──
class _BarChartPainter extends CustomPainter {
  final List<String> months;
  final List<double> collections;
  final List<double> expenses;
  final double maxValue;
  final double chartWidth;
  final int? selectedIndex;

  _BarChartPainter({
    required this.months,
    required this.collections,
    required this.expenses,
    required this.maxValue,
    required this.chartWidth,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 30.0;
    const bottomPadding = 24.0;
    const topPadding = 4.0;
    final chartAreaWidth = size.width - leftPadding;
    final chartAreaHeight = size.height - bottomPadding - topPadding;

    // Draw horizontal grid lines & y-axis labels
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1;
    const gridCount = 4;
    for (int i = 0; i <= gridCount; i++) {
      final y = topPadding + (chartAreaHeight / gridCount) * i;
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), gridPaint);

      // Y-axis label
      final label = '${((gridCount - i) / gridCount * maxValue).toStringAsFixed(0)}L';
      final tp = TextPainter(
        text: TextSpan(text: label, style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPadding - tp.width - 4, y - tp.height / 2));
    }

    // Draw bars
    final barGroupWidth = chartAreaWidth / months.length;
    const barWidth = 10.0;
    const barGap = 3.0;

    for (int i = 0; i < months.length; i++) {
      final groupCenterX = leftPadding + barGroupWidth * i + barGroupWidth / 2;

      // Draw highlight if selected
      if (selectedIndex == i) {
        final highlightPaint = Paint()..color = const Color(0xFFF8F9FA);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(leftPadding + barGroupWidth * i, topPadding, barGroupWidth, chartAreaHeight),
            const Radius.circular(8),
          ),
          highlightPaint,
        );
      }

      // Collection bar (left)
      final collHeight = (collections[i] / maxValue) * chartAreaHeight;
      final collRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          groupCenterX - barWidth - barGap / 2,
          topPadding + chartAreaHeight - collHeight,
          barWidth,
          collHeight,
        ),
        const Radius.circular(4),
      );
      final collPaint = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF8B6CFF), Color(0xFF6C4CF1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(collRect.outerRect);
      canvas.drawRRect(collRect, collPaint);

      // Expense bar (right)
      final expHeight = (expenses[i] / maxValue) * chartAreaHeight;
      final expRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          groupCenterX + barGap / 2,
          topPadding + chartAreaHeight - expHeight,
          barWidth,
          expHeight,
        ),
        const Radius.circular(4),
      );
      final expPaint = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF94A3B8), Color(0xFF64748B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(expRect.outerRect);
      canvas.drawRRect(expRect, expPaint);

      // Month label
      final monthTp = TextPainter(
        text: TextSpan(
          text: months[i],
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      monthTp.paint(canvas, Offset(groupCenterX - monthTp.width / 2, topPadding + chartAreaHeight + 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
