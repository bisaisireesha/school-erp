import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: rootBundle.loadString('assets/mock/fees_overview.json'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final data = json.decode(snapshot.data!);
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
                            _buildOutstandingBalanceCard(data['outstandingBalance']),
                            const SizedBox(height: 20),
                            _buildSummaryCards(data['summary']),
                            const SizedBox(height: 20),
                            _buildPaymentProgress(data['progress']),
                            const SizedBox(height: 20),
                            _buildUpcomingPayments(data['upcomingPayments']),
                            const SizedBox(height: 20),
                            _buildPaymentHistory(data['paymentHistory']),
                            const SizedBox(height: 20),
                            _buildFeeBreakdown(data['feeBreakdown'], data['progress']['paid'], data['outstandingBalance']['amount']),
                            const SizedBox(height: 20),
                            _buildRecentReceipts(data['recentReceipts']),
                            const SizedBox(height: 20),
                            if (data['scholarships'] != null)
                              ...data['scholarships'].map<Widget>((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: _buildScholarshipCard(s),
                              )),
                            _buildFineDetails(data['fineDetails']),
              const SizedBox(height: 120), // Bottom padding for navbar
            ],
          ),
        );
      }
    );
  }

  Widget _buildOutstandingBalanceCard(Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F8FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Outstanding Balance', style: TextStyle(color: Color(0xFF2C2849), fontSize: 15, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text('₹${data['amount']}', style: const TextStyle(color: Color(0xFF6C4CF1), fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, color: Color(0xFF6C4CF1), size: 18),
                    const SizedBox(width: 6),
                    const Text('Due Date : ', style: TextStyle(color: Color(0xFF4A4A68), fontSize: 14, fontWeight: FontWeight.w600)),
                    Text(data['dueDate'], style: const TextStyle(color: Color(0xFF6C4CF1), fontSize: 14, fontWeight: FontWeight.w900)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF6C4CF1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: const Color(0xFF6C4CF1).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Pay Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List summary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: summary.map<Widget>((item) {
        Color bgColor;
        Color iconColor;
        IconData icon;
        Color textColor;
        
        if (item['color'] == 'purple') {
          bgColor = const Color(0xFFF8F5FF);
          iconColor = const Color(0xFF6C4CF1);
          textColor = const Color(0xFF1E1E2D);
          icon = Icons.account_balance_wallet_outlined;
        } else if (item['color'] == 'green') {
          bgColor = const Color(0xFFF3FDF7);
          iconColor = const Color(0xFF22C55E);
          textColor = const Color(0xFF1E1E2D);
          icon = Icons.check_circle_outline;
        } else {
          bgColor = const Color(0xFFFFF7F0);
          iconColor = const Color(0xFFF97316);
          textColor = const Color(0xFFF97316); 
          icon = Icons.account_balance_wallet_outlined;
        }
        
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: iconColor.withValues(alpha: 0.1), width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: iconColor.withValues(alpha: 0.15)),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['type'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      const SizedBox(height: 2),
                      Text('₹${item['amount']}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentProgress(Map<String, dynamic> progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Payment Progress ',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
              children: [
                TextSpan(
                  text: '(${progress['year']})',
                  style: const TextStyle(color: Color(0xFF7A7A9D), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEFF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress['percentage'] / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4CF1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${progress['percentage']}%', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF6C4CF1))),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: '₹${progress['paid']}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF6C4CF1)),
              children: [
                TextSpan(
                  text: ' / ₹${progress['total']}',
                  style: const TextStyle(color: Color(0xFF7A7A9D)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildUpcomingPayments(List payments) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Upcoming Payments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF2C2849))),
              Text('View all', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
            ],
          ),
          const SizedBox(height: 16),
          ...payments.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            
            Color iconBgColor;
            Color iconColor;
            IconData icon;
            
            switch (item['iconType']) {
              case 'book':
                iconBgColor = const Color(0xFFF4F0FF);
                iconColor = const Color(0xFF6C4CF1);
                icon = Icons.menu_book_rounded;
                break;
              case 'bus':
                iconBgColor = const Color(0xFFFFF7E6);
                iconColor = const Color(0xFFF59E0B);
                icon = Icons.directions_bus_rounded;
                break;
              case 'activity':
                iconBgColor = const Color(0xFFFEF0F5);
                iconColor = const Color(0xFFEC4899);
                icon = Icons.accessibility_new_rounded;
                break;
              default:
                iconBgColor = const Color(0xFFF4F0FF);
                iconColor = const Color(0xFF6C4CF1);
                icon = Icons.circle;
            }
            
            return Column(
              children: [
                if (index != 0)
                  const Divider(color: Color(0xFFF3EEFF), height: 32, thickness: 1.5),
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF2C2849))),
                          const SizedBox(height: 4),
                          Text(item['dueDate'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D))),
                        ],
                      ),
                    ),
                    Text('₹${item['amount']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFFFF5630))),
                    const SizedBox(width: 12),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF2C2849), size: 14),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory(List history) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Payment History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF2C2849))),
              Text('View all', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
            ],
          ),
          const SizedBox(height: 16),
          ...history.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            
            return Column(
              children: [
                if (index != 0)
                  const Divider(color: Color(0xFFF3EEFF), height: 32, thickness: 1.5),
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3FDF7),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4DBB7E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['date'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D))),
                          const SizedBox(height: 4),
                          Text(item['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF2C2849))),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('₹${item['amount']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF2C2849))),
                        const SizedBox(height: 4),
                        Text(item['status'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF4DBB7E))),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }),
          const SizedBox(height: 4),
          const Divider(color: Color(0xFFF3EEFF), height: 32, thickness: 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.file_download_outlined, color: Color(0xFF6C4CF1), size: 22),
              SizedBox(width: 12),
              Text('Download Payment History', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeeBreakdown(Map<String, dynamic> breakdown, String totalPaidSummary, String outstandingSummary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fee Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1B39))),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Chart
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(140, 140),
                      painter: DonutChartPainter(
                        strokeWidth: 22,
                        segments: (breakdown['items'] as List).map((item) {
                          Color color;
                          switch (item['iconType']) {
                            case 'tuition': color = const Color(0xFF8B5CF6); break;
                            case 'transport': color = const Color(0xFFA1A5B7); break;
                            case 'books': color = const Color(0xFF4ADE80); break;
                            case 'activities': color = const Color(0xFFFB923C); break;
                            case 'uniform': color = const Color(0xFF60A5FA); break;
                            default: color = const Color(0xFF8B5CF6);
                          }
                          double value = double.tryParse(item['amount'].toString().replaceAll(',', '')) ?? 0.0;
                          return {'value': value, 'color': color};
                        }).toList(),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('₹${breakdown['total']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1B39))),
                        const SizedBox(height: 2),
                        const Text('Total Fees', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              // Legend
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: (breakdown['items'] as List).map((item) {
                    Color color;
                    switch (item['iconType']) {
                      case 'tuition': color = const Color(0xFF8B5CF6); break;
                      case 'transport': color = const Color(0xFFA1A5B7); break;
                      case 'books': color = const Color(0xFF4ADE80); break;
                      case 'activities': color = const Color(0xFFFB923C); break;
                      case 'uniform': color = const Color(0xFF60A5FA); break;
                      default: color = const Color(0xFF8B5CF6);
                    }
                    String title = item['title'].toString().replaceAll(' Fee', '').replaceAll(' & Material', '');
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E1B39)))),
                          Text('₹${item['amount']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E1B39))),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          

          
          // Total fees bottom row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(color: const Color(0xFFF9F8FF), borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Fees', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF6C4CF1))),
                Text('₹${breakdown['total']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF6C4CF1))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReceipts(List receipts) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Recent Receipts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF2C2849))),
              Text('View all', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
            ],
          ),
          const SizedBox(height: 16),
          ...receipts.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            
            return Column(
              children: [
                if (index != 0)
                  const Divider(color: Color(0xFFF3EEFF), height: 32, thickness: 1.5),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F0FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF6C4CF1), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['receiptNo'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF2C2849))),
                          const SizedBox(height: 4),
                          Text(item['date'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D))),
                        ],
                      ),
                    ),
                    Text('₹${item['amount']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF2C2849))),
                    const SizedBox(width: 16),
                    const Icon(Icons.file_download_outlined, color: Color(0xFF6C4CF1), size: 22),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }


  Widget _buildFineDetails(Map<String, dynamic> fine) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF5630), size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fine['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF2C2849))),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(fine['type'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF4A4A68))),
                    Text('₹${fine['amount']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFFFF5630))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(fine['condition'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScholarshipCard(Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF8F1), // Light green background
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFF22C55E), size: 36), // Green badge icon
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data['status'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4A4A68))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF8F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        data['pillText'],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF22C55E)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(data['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF2C2849)))),
                    Text('₹${data['amount']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF22C55E))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(data['description'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> segments;
  final double strokeWidth;

  DonutChartPainter({required this.segments, this.strokeWidth = 24});

  @override
  void paint(Canvas canvas, Size size) {
    double total = segments.fold(0.0, (sum, item) => sum + (item['value'] as double));
    double startAngle = -pi / 2;
    
    final rect = Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth);

    for (var segment in segments) {
      if (segment['value'] == 0) continue;
      
      final sweepAngle = (segment['value'] as double) / total * 2 * pi;
      final paint = Paint()
        ..color = segment['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
        
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
