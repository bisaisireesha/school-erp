import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';
import '../profile/profile_screen.dart';
import 'accountant_invoices_screen.dart';
import 'accountant_academics_screen.dart';
import 'accountant_transport_screen.dart';

class AccountantMoreScreen extends StatefulWidget {
  const AccountantMoreScreen({super.key});

  @override
  State<AccountantMoreScreen> createState() => _AccountantMoreScreenState();
}

class _AccountantMoreScreenState extends State<AccountantMoreScreen> {
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

  static const List<Map<String, dynamic>> _quickActions = [
    // Fee Collection
    {'title': 'Academics', 'icon': LucideIcons.building, 'key': 'Academics'},
    {'title': 'Transport', 'icon': LucideIcons.bus, 'key': 'Transport'},
    {'title': 'Hostel', 'icon': LucideIcons.building2, 'key': 'Hostel'},
    // Records
    {'title': 'Payment History', 'icon': LucideIcons.creditCard, 'key': 'Payment History'},
    {'title': 'Fee Reminders', 'icon': LucideIcons.bell, 'key': 'Fee Reminders'},
    {'title': 'Overdue Accounts', 'icon': LucideIcons.layers, 'key': 'Overdue Accounts'},
    // Payables
    {'title': 'Bills & Expenses', 'icon': LucideIcons.fileText, 'key': 'Bills & Expenses'},
    {'title': 'Invoice Mgmt', 'icon': LucideIcons.fileCheck, 'key': 'Invoice Mgmt'},
    // Payroll
    {'title': 'Payslips', 'icon': LucideIcons.banknote, 'key': 'Payslips'},
    {'title': 'Salary Structures', 'icon': LucideIcons.wallet, 'key': 'Salary Structures'},
    // Reports
    {'title': 'Financial Summary', 'icon': LucideIcons.barChart3, 'key': 'Financial Summary'},
    {'title': 'Reports Hub', 'icon': LucideIcons.barChart2, 'key': 'Reports Hub'},
    {'title': 'Workbooks', 'icon': LucideIcons.fileSpreadsheet, 'key': 'Workbooks'},
    // Banking
    {'title': 'Bank Accounts', 'icon': LucideIcons.landmark, 'key': 'Bank Accounts'},
    {'title': 'Receipts', 'icon': LucideIcons.receipt, 'key': 'Receipts'},
    {'title': 'Cheque Tracker', 'icon': LucideIcons.mail, 'key': 'Cheque Tracker'},
    {'title': 'Deposits', 'icon': LucideIcons.indianRupee, 'key': 'Deposits'},
    // Online Payments
    {'title': 'Gateway Setup', 'icon': LucideIcons.smartphone, 'key': 'Gateway Setup'},
    {'title': 'Payment Links', 'icon': LucideIcons.qrCode, 'key': 'Payment Links'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredActions = _quickActions.where((a) {
      if (_searchQuery.isEmpty) return true;
      return (a['title'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildProfileHeader(context),
          ),
          const SizedBox(height: 28),
          if (filteredActions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Finance Tools',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 3;
                      if (constraints.maxWidth > 900) {
                        crossAxisCount = 6;
                      } else if (constraints.maxWidth > 500) {
                        crossAxisCount = 4;
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredActions.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.88,
                        ),
                    itemBuilder: (context, index) {
                      final item = filteredActions[index];
                      return GestureDetector(
                        onTap: () {
                          if (item['key'] == 'Invoice Mgmt') {
                            MainLayout.pushSubScreen(
                              context,
                              AccountantInvoicesScreen(onBack: () => MainLayout.popSubScreen(context)),
                            );
                          } else if (item['key'] == 'Academics') {
                            MainLayout.pushSubScreen(
                              context,
                              AccountantAcademicsScreen(onBack: () => MainLayout.popSubScreen(context)),
                            );
                          } else if (item['key'] == 'Transport') {
                            MainLayout.pushSubScreen(
                              context,
                              AccountantTransportScreen(onBack: () => MainLayout.popSubScreen(context)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${item['title']} - Coming soon!')),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                            boxShadow: [
                              BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF3F0FF),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: const Color(0xFF6C4CF1),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  item['title'] as String,
                                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
              ),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text('No matching items found', style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
              ),
            ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6C4CF1), Color(0xFF8B6CFF)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('AC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Accountant', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  SizedBox(height: 2),
                  Text('Finance Department', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Color(0xFF6C4CF1), size: 16),
            ),
          ],
        ),
      ),
    );
  }


}
