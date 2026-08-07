import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountantPaySlipsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AccountantPaySlipsScreen({super.key, required this.onBack});

  @override
  State<AccountantPaySlipsScreen> createState() => _AccountantPaySlipsScreenState();
}

class _AccountantPaySlipsScreenState extends State<AccountantPaySlipsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Teachers', 'Drivers', 'Admins'];

  final List<Map<String, dynamic>> _mockStaff = [
    {
      'id': 'EMP-001',
      'name': 'Sarah Jenkins',
      'role': 'Teachers',
      'salary': '₹45,000',
      'status': 'Pending',
    },
    {
      'id': 'EMP-002',
      'name': 'Raj Kumar',
      'role': 'Drivers',
      'salary': '₹18,000',
      'status': 'Generated',
    },
    {
      'id': 'EMP-003',
      'name': 'Anita Sharma',
      'role': 'Admins',
      'salary': '₹35,000',
      'status': 'Pending',
    },
    {
      'id': 'EMP-004',
      'name': 'Vikram Singh',
      'role': 'Teachers',
      'salary': '₹42,000',
      'status': 'Pending',
    },
  ];

  List<Map<String, dynamic>> get _filteredStaff {
    if (_selectedFilter == 'All') return _mockStaff;
    return _mockStaff.where((s) => s['role'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF1E1E2D)),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Pay Slips',
          style: TextStyle(
            color: Color(0xFF1E1E2D),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.download, color: Color(0xFF1E1E2D)),
            onPressed: () => _showDownloadReportSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredStaff.length,
              itemBuilder: (context, index) {
                return _buildStaffCard(_filteredStaff[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
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
                    filter,
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

  Widget _buildStaffCard(Map<String, dynamic> staff) {
    final isGenerated = staff['status'] == 'Generated';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.user, color: Color(0xFF6C4CF1)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${staff['id']} • ${staff['role']}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isGenerated ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    staff['status'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isGenerated ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Base Salary',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      staff['salary'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                  ],
                ),
                if (!isGenerated)
                  ElevatedButton.icon(
                    onPressed: () => _showGenerateSlipSheet(context, staff),
                    icon: const Icon(LucideIcons.filePlus, size: 16, color: Colors.white),
                    label: const Text(
                      'Generate',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () => _showViewSlipSheet(context, staff),
                    icon: const Icon(LucideIcons.download, size: 16, color: Color(0xFF1E1E2D)),
                    label: const Text(
                      'Download Slip',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showGenerateSlipSheet(BuildContext context, Map<String, dynamic> staff) {
    final TextEditingController bonusController = TextEditingController();
    final TextEditingController deductionController = TextEditingController();
    bool isProcessing = false;
    bool isGenerated = false;
    double baseSalary = double.parse(staff['salary'].replaceAll('₹', '').replaceAll(',', ''));
    double bonus = 0;
    double deductions = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          double netPay = baseSalary + bonus - deductions;
          String formatRupees(int amount) {
            String res = amount.toString();
            if (res.length > 3) {
              res = '${res.substring(0, res.length - 3)},${res.substring(res.length - 3)}';
            }
            if (res.length > 6) {
              res = '${res.substring(0, res.length - 6)},${res.substring(res.length - 6)}';
            }
            return '₹$res';
          }
          String netPayStr = formatRupees(netPay.toInt());

          return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
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
                if (isProcessing) ...[
                  _buildProcessingState(staff['name']),
                ] else if (isGenerated) ...[
                  _buildGeneratedState(context),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Generate Pay Slip', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                              SizedBox(height: 4),
                              Text('August 2026', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
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
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.user, color: Color(0xFF64748B)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(staff['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                                      Text('${staff['id']} • ${staff['role']}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ),
                                Text(staff['salary'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: _buildInputField('BONUS / ALLOWANCE', bonusController, onChanged: (v) {
                                setSheetState(() {
                                  bonus = double.tryParse(v) ?? 0;
                                });
                              })),
                              const SizedBox(width: 16),
                              Expanded(child: _buildInputField('DEDUCTIONS', deductionController, onChanged: (v) {
                                setSheetState(() {
                                  deductions = double.tryParse(v) ?? 0;
                                });
                              })),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Net Pay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                              Text(netPayStr, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF6C4CF1))),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        setSheetState(() => isProcessing = true);
                        await Future.delayed(const Duration(seconds: 2));
                        if (!context.mounted) return;
                        setState(() {
                          staff['status'] = 'Generated';
                          staff['salary'] = netPayStr;
                        });
                        setSheetState(() {
                          isProcessing = false;
                          isGenerated = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Generate & Notify', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    ),
  );
}

  Widget _buildProcessingState(String name) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF6C4CF1)),
          const SizedBox(height: 24),
          const Text('Generating Pay Slip...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          Text('Calculating totals for $name', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  void _showViewSlipSheet(BuildContext context, Map<String, dynamic> staff) {
    bool isDownloading = false;
    bool isDownloaded = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
              if (isDownloading)
                _buildDownloadingState(staff['name'])
              else if (isDownloaded)
                _buildDownloadedState(context)
              else ...[
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Pay Slip', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 8),
                            const Text('August 2026', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: const Text('Generated', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
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
                          const Text('Employee', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                          Text(staff['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ID', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                          Text(staff['id'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Role', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                          Text(staff['role'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Base Salary', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                          Text(staff['salary'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Net Pay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          Text(staff['salary'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF6C4CF1))),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(LucideIcons.x, size: 16, color: Color(0xFF1E1E2D)),
                          label: const Text('Close', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            setSheetState(() => isDownloading = true);
                            await Future.delayed(const Duration(seconds: 2));
                            if (!context.mounted) return;
                            setSheetState(() {
                              isDownloading = false;
                              isDownloaded = true;
                            });
                          },
                          icon: const Icon(LucideIcons.download, size: 16, color: Colors.white),
                          label: const Text('Download', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C4CF1),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadingState(String name) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF6C4CF1)),
          const SizedBox(height: 24),
          const Text('Downloading PDF...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          Text('Preparing pay slip for $name', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildGeneratedState(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
            child: const Icon(LucideIcons.checkCircle2, color: Color(0xFF16A34A), size: 48),
          ),
          const SizedBox(height: 24),
          const Text('Slip Generated!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          const Text('Staff member has been notified', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Done', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadedState(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
            child: const Icon(LucideIcons.checkCircle2, color: Color(0xFF16A34A), size: 48),
          ),
          const SizedBox(height: 24),
          const Text('Download Complete!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          const Text('Saved to your device', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Done', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDownloadReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
            Container(
              height: 300,
              alignment: Alignment.center,
              child: FutureBuilder(
                future: Future.delayed(const Duration(seconds: 2)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Color(0xFF6C4CF1)),
                        const SizedBox(height: 24),
                        const Text('Downloading Report...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 8),
                        const Text('Preparing pay slips data', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
                          child: const Icon(LucideIcons.checkCircle2, color: Color(0xFF16A34A), size: 48),
                        ),
                        const SizedBox(height: 24),
                        const Text('Download Complete!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 8),
                        const Text('Report saved to your device', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4CF1),
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Text('Done', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            style: const TextStyle(color: Color(0xFF1E1E2D), fontSize: 14),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              prefixText: '₹ ',
              prefixStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
