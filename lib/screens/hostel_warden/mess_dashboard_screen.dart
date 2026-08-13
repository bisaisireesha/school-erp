import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';
import 'mess_menu_screen.dart';
import 'inventory_screen.dart';
import 'vendors_screen.dart';
import '../attendance/attendance_screen.dart';
import 'reports_screen.dart';
import '../hostel/hostel_maintenance_screen.dart';
import '../messages/messages_screen.dart';
import '../hostel/hostel_wardens_screen.dart';

class MessDashboardScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const MessDashboardScreen({super.key, this.onBack});

  @override
  State<MessDashboardScreen> createState() => _MessDashboardScreenState();
}

class _MessDashboardScreenState extends State<MessDashboardScreen> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _weeklyMenu = [];
  List<Map<String, dynamic>> _inventory = [];
  List<Map<String, dynamic>> _vendors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    MainLayout.globalSearchQuery.addListener(_onGlobalSearchChanged);
    _searchQuery = MainLayout.globalSearchQuery.value;
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/mess_dashboard.json');
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _weeklyMenu = List<Map<String, dynamic>>.from(data['weeklyMenu']);
          _inventory = List<Map<String, dynamic>>.from(data['inventory']);
          _vendors = List<Map<String, dynamic>>.from(data['vendors']);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getColor(String colorStr) {
    return Color(int.parse(colorStr));
  }
  
  IconData _getIcon(String iconStr) {
    switch (iconStr) {
      case 'leaf': return LucideIcons.leaf;
      case 'wheat': return LucideIcons.wheat;
      case 'droplets': return LucideIcons.droplets;
      case 'flame': return LucideIcons.flame;
      default: return LucideIcons.box;
    }
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
      );
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildKPIs(),
              const SizedBox(height: 24),
              _buildServiceStatus(),
              const SizedBox(height: 24),
              _buildWeeklyMenu(),
              const SizedBox(height: 24),
              _buildInventoryWatch(),
              const SizedBox(height: 24),
              _buildVendorsPayments(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          if (widget.onBack != null) ...[
            GestureDetector(
              onTap: widget.onBack,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5)),
                child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
              ),
            ),
            const SizedBox(width: 16),
          ],
          const Expanded(child: Text('Mess Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))),
        ],
      ),
    );
  }

  Widget _buildKPIs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildKpiCard('603', 'Today\'s Diners', 'of 642 planned', LucideIcons.users, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF), '+4%', true)),
              const SizedBox(width: 12),
              Expanded(child: _buildKpiCard('1,206', 'Meals Served Today', 'Breakfast + Lunch', LucideIcons.utensilsCrossed, const Color(0xFF10B981), const Color(0xFFD1FAE5), '+2.1%', true)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildKpiCard('₹42', 'Plate Cost (avg)', 'Target ≤ ₹45', LucideIcons.indianRupee, const Color(0xFF3B82F6), const Color(0xFFDBEAFE), '-3%', false)),
              const SizedBox(width: 12),
              Expanded(child: _buildKpiCard('6.2%', 'Wastage', 'Goal under 5%', LucideIcons.trendingDown, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), '+0.8%', true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String value, String title, String subtitle, IconData icon, Color iconColor, Color bgColor, String trend, bool isPositiveTrend) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9)), boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 20)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: isPositiveTrend ? const Color(0xFFDCFCE7) : const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isPositiveTrend ? LucideIcons.trendingUp : LucideIcons.trendingDown, size: 12, color: isPositiveTrend ? const Color(0xFF16A34A) : const Color(0xFF3B82F6)),
                    const SizedBox(width: 4),
                    Text(trend, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isPositiveTrend ? const Color(0xFF16A34A) : const Color(0xFF3B82F6))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildServiceStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text('TODAY\'S MEALS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Service status by meal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              GestureDetector(
                onTap: () => MainLayout.pushSubScreen(context, AttendanceScreen(onBack: () => MainLayout.popSubScreen(context))),
                child: const Text('Meal attendance >', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              _buildServiceCard('Breakfast', '07:00 - 09:00', 'DONE', const Color(0xFF16A34A), const Color(0xFFDCFCE7), ['Poha', 'Boiled Eggs', 'Bread & Jam', 'Tea / Milk'], '305/318', '96%', 0.96, const Color(0xFFF59E0B), LucideIcons.coffee, const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
              const SizedBox(height: 16),
              _buildServiceCard('Lunch', '12:30 - 02:00', 'LIVE', const Color(0xFFD97706), const Color(0xFFFEF3C7), ['Rajma', 'Jeera Rice', 'Roti', 'Salad', 'Curd'], '298/322', '93%', 0.93, const Color(0xFF16A34A), LucideIcons.soup, const Color(0xFF10B981), const Color(0xFFD1FAE5)),
              const SizedBox(height: 16),
              _buildServiceCard('Evening Snacks', '04:30 - 05:30', 'UPCOMING', const Color(0xFF64748B), const Color(0xFFF1F5F9), ['Veg Sandwich', 'Banana', 'Masala Chai'], '0/320', '0%', 0.0, const Color(0xFFE2E8F0), LucideIcons.cookie, const Color(0xFF3B82F6), const Color(0xFFDBEAFE)),
              const SizedBox(height: 16),
              _buildServiceCard('Dinner', '08:00 - 09:30', 'UPCOMING', const Color(0xFF64748B), const Color(0xFFF1F5F9), ['Paneer Butter Masala', 'Roti', 'Dal Tadka', 'Rice', 'Gulab Jamun'], '0/320', '0%', 0.0, const Color(0xFFE2E8F0), LucideIcons.utensils, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(String title, String time, String badgeText, Color badgeColor, Color badgeBg, List<String> items, String served, String percent, double progress, Color progressColor, IconData icon, Color iconColor, Color iconBg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9)), boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 20)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(LucideIcons.clock, size: 12, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(12)), child: Text(badgeText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor))),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: items.map((item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
              child: Text(item, style: const TextStyle(fontSize: 11, color: Color(0xFF334155), fontWeight: FontWeight.w600)),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Served', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              RichText(text: TextSpan(children: [
                TextSpan(text: served, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const TextSpan(text: ' · ', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                TextSpan(text: percent, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              ])),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: const Color(0xFFF1F5F9), valueColor: AlwaysStoppedAnimation<Color>(progressColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('This Week\'s Menu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
              GestureDetector(
                onTap: () => MainLayout.pushSubScreen(context, MessMenuScreen(onBack: () => MainLayout.popSubScreen(context))),
                child: const Text('Edit menu', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: _weeklyMenu.map((dayData) {
              final isToday = dayData['day'] == 'Wednesday'; // Just mocking today
              return _buildExpandableDayCard(
                dayData['day'],
                dayData['breakfast'],
                dayData['lunch'],
                dayData['dinner'],
                isToday,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableDayCard(String day, String breakfast, String lunch, String dinner, bool isToday) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isToday ? const Color(0xFF6C4CF1).withValues(alpha: 0.3) : const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: isToday ? const Color(0xFFF8F5FF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
          initiallyExpanded: isToday,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          title: Row(
            children: [
              Text(day, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: isToday ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D))),
              if (isToday)
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF6C4CF1), borderRadius: BorderRadius.circular(12)),
                  child: const Text('TODAY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
            ],
          ),
          children: [
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 16),
            _buildMealRow(LucideIcons.coffee, 'Breakfast', breakfast, const Color(0xFFF59E0B), const Color(0xFFFFFBEB)),
            const SizedBox(height: 16),
            _buildMealRow(LucideIcons.utensils, 'Lunch', lunch, const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
            const SizedBox(height: 16),
            _buildMealRow(LucideIcons.utensilsCrossed, 'Dinner', dinner, const Color(0xFF3B82F6), const Color(0xFFEFF6FF)),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildMealRow(IconData icon, String title, String items, Color color, Color bgColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              const SizedBox(height: 2),
              Text(items, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D), height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryWatch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Inventory Watch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  SizedBox(height: 2),
                  Text('Critical & low stock', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
              GestureDetector(
                onTap: () => MainLayout.pushSubScreen(context, InventoryScreen(onBack: () => MainLayout.popSubScreen(context))),
                child: const Text('All stock', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9)), boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Column(
              children: _inventory.asMap().entries.map((entry) {
                int idx = entry.key;
                var item = entry.value;
                return _buildInventoryItem(
                  _getIcon(item['iconStr']),
                  _getColor(item['iconBg']),
                  _getColor(item['iconColor']),
                  item['title'],
                  item['onHand'],
                  item['min'],
                  item['status'],
                  _getColor(item['statusColor']),
                  _getColor(item['statusBg']),
                  item['progress'].toDouble(),
                  _getColor(item['progressColor']),
                  isLast: idx == _inventory.length - 1,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryItem(IconData icon, Color iconBg, Color iconColor, String title, String onHand, String min, String status, Color statusColor, Color statusBg, double progress, Color progressColor, {bool isLast = false}) {
    return Container(
      decoration: BoxDecoration(border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 20)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(onHand, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                    Text(min, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: progress, minHeight: 4, backgroundColor: const Color(0xFFF1F5F9), valueColor: AlwaysStoppedAnimation<Color>(progressColor)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorsPayments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Vendors & Payments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
              GestureDetector(
                onTap: () => MainLayout.pushSubScreen(context, VendorsScreen(onBack: () => MainLayout.popSubScreen(context))),
                child: const Text('All vendors', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: _vendors.map((vendor) {
              return _buildVendorItem(
                vendor['iconText'],
                vendor['name'],
                vendor['tags'],
                vendor['amount'],
                vendor['rating'],
                vendor['status'],
                _getColor(vendor['statusColor']),
                _getColor(vendor['statusBg']),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildVendorItem(String iconText, String name, String tags, String amount, String rating, String status, Color statusColor, Color statusBg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: 44, height: 44, decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle), child: Center(child: Text(iconText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))))),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 2),
                Text(tags, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star_border_rounded, size: 14, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 4),
                  Text(rating, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                      ],
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

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
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
            const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 24,
              crossAxisSpacing: 8,
              childAspectRatio: 0.8,
              children: [
                _buildActionCard('Mess\nMenu', LucideIcons.fileEdit, onTap: () {
                  MainLayout.pushSubScreen(context, MessMenuScreen(onBack: () => MainLayout.popSubScreen(context)));
                }),
                _buildActionCard('Meal\nAttd.', LucideIcons.clipboardCheck, onTap: () {
                  MainLayout.pushSubScreen(context, AttendanceScreen(onBack: () => MainLayout.popSubScreen(context)));
                }),
                _buildActionCard('Inventory', LucideIcons.package, onTap: () {
                  MainLayout.pushSubScreen(context, InventoryScreen(onBack: () => MainLayout.popSubScreen(context)));
                }),
                _buildActionCard('Vendors', LucideIcons.briefcase, onTap: () {
                  MainLayout.pushSubScreen(context, VendorsScreen(onBack: () => MainLayout.popSubScreen(context)));
                }),
                _buildActionCard('Maintenance', LucideIcons.wrench, onTap: () {
                  MainLayout.pushSubScreen(context, HostelMaintenanceScreen(onBack: () => MainLayout.popSubScreen(context)));
                }),
                _buildActionCard('Broadcast\nMsg', LucideIcons.megaphone, onTap: () {
                  MainLayout.pushSubScreen(context, MessagesScreen(onBack: () => MainLayout.popSubScreen(context)));
                }),
                _buildActionCard('Staff', LucideIcons.users, onTap: () {
                  MainLayout.pushSubScreen(context, HostelWardensScreen(onBack: () => MainLayout.popSubScreen(context)));
                }),
                _buildActionCard('Reports', LucideIcons.fileText, onTap: () {
                  MainLayout.pushSubScreen(context, ReportsScreen(onBack: () => MainLayout.popSubScreen(context)));
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String label, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF6C4CF1).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF6C4CF1), size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
