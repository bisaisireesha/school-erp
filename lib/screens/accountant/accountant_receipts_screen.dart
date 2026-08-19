import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class AccountantReceiptsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AccountantReceiptsScreen({super.key, required this.onBack});

  @override
  State<AccountantReceiptsScreen> createState() => _AccountantReceiptsScreenState();
}

class _AccountantReceiptsScreenState extends State<AccountantReceiptsScreen> {
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

  final List<Map<String, dynamic>> _receipts = [
    {
      'id': 'REC-2408-01',
      'name': 'Rahul Sharma',
      'className': 'Class 10-A',
      'category': 'Term 1 Fee',
      'amount': '₹45,000',
      'date': 'Today, 10:30 AM',
      'status': 'Generated',
      'paymentMode': 'Online',
    },
    {
      'id': 'REC-2408-02',
      'name': 'Priya Patel',
      'className': 'Class 8-B',
      'category': 'Transport Fee',
      'amount': '₹12,500',
      'date': 'Yesterday',
      'status': 'Generated',
      'paymentMode': 'Cash',
    },
    {
      'id': 'REC-2408-03',
      'name': 'Amit Kumar',
      'className': 'Class 12-C',
      'category': 'Hostel Fee',
      'amount': '₹85,000',
      'date': 'Aug 14, 2025',
      'status': 'Draft',
      'paymentMode': 'Cheque',
    },
    {
      'id': 'REC-2408-04',
      'name': 'Sneha Gupta',
      'className': 'Class 9-A',
      'category': 'Admission Fee',
      'amount': '₹25,000',
      'date': 'Aug 12, 2025',
      'status': 'Generated',
      'paymentMode': 'Online',
    },
    {
      'id': 'REC-2408-05',
      'name': 'Vikram Singh',
      'className': 'Class 10-B',
      'category': 'Term 1 Fee',
      'amount': '₹45,000',
      'date': 'Aug 10, 2025',
      'status': 'Generated',
      'paymentMode': 'Online',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredReceipts = _receipts.where((r) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (r['name'] as String).toLowerCase();
      final id = (r['id'] as String).toLowerCase();
      return name.contains(q) || id.contains(q);
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
                          Text('Receipts', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                          Text('Manage and generate receipts', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showNewReceiptDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C4CF1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(LucideIcons.plus, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text('New', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: filteredReceipts.map((receipt) => _buildReceiptCard(receipt)).toList(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptCard(Map<String, dynamic> receipt) {
    final isDraft = receipt['status'] == 'Draft';
    return GestureDetector(
      onTap: () => _showReceiptDetails(receipt),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                receipt['id'] as String,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF6C4CF1)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDraft ? const Color(0xFFF1F5F9) : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  receipt['status'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDraft ? const Color(0xFF64748B) : const Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(LucideIcons.user, color: Color(0xFF64748B), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          receipt['name'] as String,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            receipt['className'] as String? ?? 'Class 10-A',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${receipt['category']} • ${receipt['paymentMode']}',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    receipt['amount'] as String,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    receipt['date'] as String,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _downloadReceipt(receipt),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: receipt['isDownloading'] == true 
                          ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6C4CF1)))
                          : const Icon(LucideIcons.download, size: 16, color: Color(0xFF64748B)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _shareReceipt(receipt),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: receipt['isSharing'] == true
                          ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6C4CF1)))
                          : Icon(receipt['isShared'] == true ? LucideIcons.check : LucideIcons.share2, size: 16, color: receipt['isShared'] == true ? const Color(0xFF16A34A) : const Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('View details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9))),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 14, color: Color(0xFF0EA5E9)),
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Future<void> _downloadReceipt(Map<String, dynamic> receipt) async {
    setState(() {
      receipt['isDownloading'] = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        receipt['isDownloading'] = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text('Receipt ${receipt['id']} downloaded successfully!', style: const TextStyle(fontWeight: FontWeight.bold))),
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
  }

  Future<void> _shareReceipt(Map<String, dynamic> receipt) async {
    setState(() {
      receipt['isSharing'] = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        receipt['isSharing'] = false;
        receipt['isShared'] = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text('Receipt ${receipt['id']} shared successfully!', style: const TextStyle(fontWeight: FontWeight.bold))),
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
  }

  void _showReceiptDetails(Map<String, dynamic> receipt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Receipt Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(LucideIcons.x, size: 20, color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Receipt ${receipt['id']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: receipt['status'] == 'Draft' ? const Color(0xFFF1F5F9) : const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            receipt['status'] as String,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: receipt['status'] == 'Draft' ? const Color(0xFF64748B) : const Color(0xFF16A34A)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Student Information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Name', receipt['name'] as String),
                          const Divider(height: 24, color: Color(0xFFE2E8F0)),
                          _buildDetailRow('Class', receipt['className'] as String? ?? 'Class 10-A'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Payment Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Category', receipt['category'] as String),
                          const Divider(height: 24, color: Color(0xFFE2E8F0)),
                          _buildDetailRow('Amount', receipt['amount'] as String),
                          const Divider(height: 24, color: Color(0xFFE2E8F0)),
                          _buildDetailRow('Mode', receipt['paymentMode'] as String),
                          const Divider(height: 24, color: Color(0xFFE2E8F0)),
                          _buildDetailRow('Date', receipt['date'] as String),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _downloadReceipt(receipt);
                            },
                            icon: const Icon(LucideIcons.download, size: 16, color: Color(0xFF6C4CF1)),
                            label: const Text('Download PDF', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF3F0FF),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _shareReceipt(receipt);
                            },
                            icon: const Icon(LucideIcons.share2, size: 16, color: Colors.white),
                            label: const Text('Share Receipt', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4CF1),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
      ],
    );
  }

  void _showNewReceiptDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController classController = TextEditingController();
    final TextEditingController sectionController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController modeController = TextEditingController(text: 'Online');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('New Receipt', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Generate a new manual receipt for collected payments.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(flex: 2, child: _buildFormField('STUDENT NAME', nameController)),
                  const SizedBox(width: 12),
                  Expanded(flex: 1, child: _buildFormField('CLASS', classController)),
                  const SizedBox(width: 12),
                  Expanded(flex: 1, child: _buildFormField('SECTION', sectionController)),
                ],
              ),
              const SizedBox(height: 16),
              _buildFormField('FEE CATEGORY (e.g. Tuition, Transport)', categoryController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildFormField('AMOUNT (₹)', amountController, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormField('PAYMENT MODE', modeController)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF1E1E2D),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _receipts.insert(0, {
                          'id': 'REC-2408-${(_receipts.length + 1).toString().padLeft(2, '0')}',
                          'name': nameController.text.isEmpty ? 'Unknown' : nameController.text,
                          'className': 'Class ${classController.text.isEmpty ? '?' : classController.text}-${sectionController.text.isEmpty ? '?' : sectionController.text}',
                          'category': categoryController.text.isEmpty ? 'General Fee' : categoryController.text,
                          'amount': '₹${amountController.text.isEmpty ? '0' : amountController.text}',
                          'date': 'Just now',
                          'status': 'Generated',
                          'paymentMode': modeController.text.isEmpty ? 'Cash' : modeController.text,
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Receipt generated successfully!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Generate', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
          ),
        );
      },
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6C4CF1)),
            ),
          ),
        ),
      ],
    );
  }
}