import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountantQuickCollectionScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AccountantQuickCollectionScreen({super.key, required this.onBack});

  @override
  State<AccountantQuickCollectionScreen> createState() => _AccountantQuickCollectionScreenState();
}

class _AccountantQuickCollectionScreenState extends State<AccountantQuickCollectionScreen> {
  String _selectedPaymentMode = 'Cash';
  final TextEditingController _receivedAmountController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _mockInvoices = [
    {'id': 'INV-2025-1549', 'name': 'Aditi Verma', 'due': 4500},
    {'id': 'INV-2025-1550', 'name': 'Rahul Singh', 'due': 1200},
    {'id': 'INV-2025-1551', 'name': 'Neha Sharma', 'due': 3000},
  ];
  Map<String, dynamic>? _selectedInvoice;

  final List<Map<String, dynamic>> _recentCollections = [
    {'name': 'Aarav Sharma', 'initial': 'A', 'subtitle': 'INV-2025-1548 • 13 May 2025, 10:45 AM', 'amount': '2,500', 'mode': 'UPI', 'modeBg': const Color(0xFFF3F0FF), 'modeColor': const Color(0xFF6C4CF1), 'avatarBg': const Color(0xFFF3F0FF), 'avatarColor': const Color(0xFF6C4CF1)},
    {'name': 'Myra Patel', 'initial': 'M', 'subtitle': 'INV-2025-1547 • 13 May 2025, 10:20 AM', 'amount': '3,000', 'mode': 'Cash', 'modeBg': const Color(0xFFF0FDF4), 'modeColor': const Color(0xFF16A34A), 'avatarBg': const Color(0xFFF0FDF4), 'avatarColor': const Color(0xFF16A34A)},
    {'name': 'Vihaan Mehta', 'initial': 'V', 'subtitle': 'INV-2025-1546 • 13 May 2025, 09:55 AM', 'amount': '2,500', 'mode': 'Card', 'modeBg': const Color(0xFFEFF6FF), 'modeColor': const Color(0xFF2563EB), 'avatarBg': const Color(0xFFEFF6FF), 'avatarColor': const Color(0xFF2563EB)},
  ];

  @override
  void dispose() {
    _receivedAmountController.dispose();
    _remarksController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKpiGrid(),
                  const SizedBox(height: 24),
                  _buildCollectPaymentCard(),
                  const SizedBox(height: 32),
                  _buildRecentCollectionsHeader(),
                  const SizedBox(height: 16),
                  _buildRecentCollectionsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
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
          const Text(
            'Quick Collection',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: constraints.maxWidth > 600 ? 1.5 : 1.4,
          children: [
            _buildKpiCard('Today\'s Collection', '₹ 28,450', '12 Payments', const Color(0xFF16A34A), const Color(0xFFF0FDF4), LucideIcons.wallet),
            _buildKpiCard('This Week', '₹ 1,25,600', '48 Payments', const Color(0xFF2563EB), const Color(0xFFEFF6FF), LucideIcons.calendar),
            _buildKpiCard('This Month', '₹ 4,86,250', '156 Payments', const Color(0xFF6C4CF1), const Color(0xFFF3F0FF), LucideIcons.shoppingBag),
            _buildKpiCard('Outstanding Amount', '₹ 3,24,800', '62 Children', const Color(0xFFF97316), const Color(0xFFFFF7ED), LucideIcons.users),
          ],
        );
      }
    );
  }

  Widget _buildKpiCard(String title, String amount, String subtitle, Color color, Color bgColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            amount,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.creditCard, color: Color(0xFF6C4CF1), size: 20),
                  const SizedBox(width: 12),
                  const Text('Collect Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                ],
              ),
              const Icon(LucideIcons.chevronUp, color: Color(0xFF6C4CF1), size: 20),
            ],
          ),
          const SizedBox(height: 24),
          
          _buildFieldLabel('Search Child / Invoice'),
          const SizedBox(height: 8),
          Autocomplete<Map<String, dynamic>>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<Map<String, dynamic>>.empty();
              }
              return _mockInvoices.where((Map<String, dynamic> option) {
                return option['name'].toString().toLowerCase().contains(textEditingValue.text.toLowerCase()) || 
                       option['id'].toString().toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
            displayStringForOption: (Map<String, dynamic> option) => option['name'],
            onSelected: (Map<String, dynamic> selection) {
              setState(() {
                _selectedInvoice = selection;
                _receivedAmountController.text = selection['due'].toString();
              });
            },
            fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
              return _buildTextField('Search by child name, invoice no. or pare...', suffixIcon: LucideIcons.search, controller: controller, focusNode: focusNode);
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 200, maxWidth: MediaQuery.of(context).size.width - 96),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          title: Text(option['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text(option['id'], style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Select Invoice'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Map<String, dynamic>>(
                          value: _selectedInvoice,
                          hint: const Text('Select invoice', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                          isExpanded: true,
                          icon: const Icon(LucideIcons.chevronDown, color: Color(0xFF64748B), size: 16),
                          items: _mockInvoices.map((invoice) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: invoice,
                              child: Text('${invoice['id']}', style: const TextStyle(fontSize: 13, color: Color(0xFF1E1E2D))),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedInvoice = val;
                              if (val != null) {
                                _receivedAmountController.text = val['due'].toString();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Due Amount'),
                    const SizedBox(height: 8),
                    _buildTextField(_selectedInvoice != null ? '₹ ${_selectedInvoice!['due']}' : '₹ 0', isReadOnly: true),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          _buildFieldLabel('Payment Mode'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildPaymentModeOption('Cash', LucideIcons.banknote)),
              const SizedBox(width: 8),
              Expanded(child: _buildPaymentModeOption('UPI', LucideIcons.smartphone)),
              const SizedBox(width: 8),
              Expanded(child: _buildPaymentModeOption('Card', LucideIcons.creditCard)),
              const SizedBox(width: 8),
              Expanded(child: _buildPaymentModeOption('Bank Transfer', LucideIcons.building)),
            ],
          ),
          
          const SizedBox(height: 20),
          _buildFieldLabel('Received Amount'),
          const SizedBox(height: 8),
          _buildTextField('₹ 2,500', controller: _receivedAmountController, keyboardType: TextInputType.number),
          
          const SizedBox(height: 20),
          _buildFieldLabel('Remarks (Optional)'),
          const SizedBox(height: 8),
          TextField(
            controller: _remarksController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add a note...',
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF6C4CF1))),
            ),
          ),
          
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedInvoice == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an invoice first.'), backgroundColor: Colors.red));
                      return;
                    }
                    
                    setState(() {
                      Color modeBg = const Color(0xFFF0FDF4);
                      Color modeColor = const Color(0xFF16A34A);
                      if (_selectedPaymentMode == 'UPI') {
                        modeBg = const Color(0xFFF3F0FF);
                        modeColor = const Color(0xFF6C4CF1);
                      } else if (_selectedPaymentMode == 'Card') {
                        modeBg = const Color(0xFFEFF6FF);
                        modeColor = const Color(0xFF2563EB);
                      } else if (_selectedPaymentMode == 'Bank Transfer') {
                        modeBg = const Color(0xFFFFF7ED);
                        modeColor = const Color(0xFFF97316);
                      }

                      _recentCollections.insert(0, {
                        'name': _selectedInvoice!['name'],
                        'initial': _selectedInvoice!['name'].toString().substring(0, 1),
                        'subtitle': '${_selectedInvoice!['id']} • Just now',
                        'amount': _receivedAmountController.text.isNotEmpty ? _receivedAmountController.text : _selectedInvoice!['due'].toString(),
                        'mode': _selectedPaymentMode,
                        'modeBg': modeBg,
                        'modeColor': modeColor,
                        'avatarBg': modeBg,
                        'avatarColor': modeColor,
                      });
                      
                      _mockInvoices.remove(_selectedInvoice);
                      _selectedInvoice = null;
                      _receivedAmountController.clear();
                      _remarksController.clear();
                      _searchController.clear();
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                            const Expanded(child: Text('Payment collected successfully!', style: TextStyle(fontWeight: FontWeight.bold))),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.upload, size: 18, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Collect Payment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                     if (_selectedInvoice == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an invoice first.'), backgroundColor: Colors.red));
                      return;
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFFE8E3F8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.eye, size: 18, color: Color(0xFF6C4CF1)),
                        SizedBox(width: 8),
                        Text('Receipt Preview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)));
  }

  Widget _buildTextField(String hint, {bool isReadOnly = false, IconData? suffixIcon, TextEditingController? controller, FocusNode? focusNode, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: isReadOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isReadOnly ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFF94A3B8), size: 18) : null,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF6C4CF1))),
      ),
    );
  }

  Widget _buildPaymentModeOption(String mode, IconData icon) {
    final isSelected = _selectedPaymentMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0FDF4) : Colors.white,
          border: Border.all(color: isSelected ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: isSelected ? const Color(0xFF16A34A) : const Color(0xFF64748B)),
            const SizedBox(width: 4),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(mode, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: isSelected ? const Color(0xFF16A34A) : const Color(0xFF1E1E2D))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentCollectionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Recent Collections', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
        const Text('View All', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
      ],
    );
  }

  Widget _buildRecentCollectionsList() {
    return Column(
      children: _recentCollections.map((col) => _buildRecentCollectionCard(col)).toList(),
    );
  }

  Widget _buildRecentCollectionCard(Map<String, dynamic> col) {
    return GestureDetector(
      onTap: () => _showInvoiceDetailsSheet(col),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: col['avatarBg'] as Color, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(col['initial'] as String, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: col['avatarColor'] as Color)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(col['name'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  const SizedBox(height: 4),
                  Text(col['subtitle'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹ ${col['amount']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF16A34A))),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: col['modeBg'] as Color, borderRadius: BorderRadius.circular(4)),
                  child: Text(col['mode'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: col['modeColor'] as Color)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInvoiceDetailsSheet(Map<String, dynamic> collection) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Collection Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
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
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: collection['avatarBg'] as Color, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(collection['initial'] as String, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: collection['avatarColor'] as Color)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(collection['name'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      const SizedBox(height: 4),
                      Text(collection['subtitle'] as String, style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Collected Amount', '₹ ${collection['amount']}'),
                  const Divider(height: 24, color: Color(0xFFE2E8F0)),
                  _buildDetailRow('Payment Mode', collection['mode'] as String),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Expanded(child: Text('Receipt downloaded for ${collection['name']}', style: const TextStyle(fontWeight: FontWeight.bold))),
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
                icon: const Icon(LucideIcons.download, size: 18, color: Colors.white),
                label: const Text('Download Receipt', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
      ],
    );
  }
}
