import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountantQuickCollectionScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AccountantQuickCollectionScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  State<AccountantQuickCollectionScreen> createState() => _AccountantQuickCollectionScreenState();
}

class _AccountantQuickCollectionScreenState extends State<AccountantQuickCollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 850) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: _buildLeftPanel()),
                          const SizedBox(width: 24),
                          Expanded(flex: 6, child: _buildRightPanel()),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildLeftPanel(),
                          const SizedBox(height: 24),
                          _buildRightPanel(),
                        ],
                      );
                    }
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack,
            child: const Icon(LucideIcons.arrowLeft, size: 24, color: Color(0xFF111827)),
          ),
          const SizedBox(width: 16),
          const Text(
            'Quick Collection',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
                child: const Icon(LucideIcons.indianRupee, color: Color(0xFF6366F1), size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Quick Collection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  SizedBox(height: 4),
                  Text('Mock search and payment entry', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          _buildOutlinedTextField('Search student / roll no / receipt number', true),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(child: _buildOutlinedTextField('Aarav Gupta', false)),
              const SizedBox(width: 16),
              Expanded(child: _buildOutlinedTextField('Grade 10-A', false)),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(child: _buildOutlinedTextField('12500', false)),
              const SizedBox(width: 16),
              Expanded(child: _buildOutlinedTextField('UPI', false)),
            ],
          ),
          const SizedBox(height: 24),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildSimpleChip('Partial payment'),
              _buildSimpleChip('Auto receipt'),
              _buildSimpleChip('Ledger update'),
            ],
          ),
          
          const SizedBox(height: 32),
          
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment recorded!')));
                },
                icon: const Icon(LucideIcons.creditCard, size: 18, color: Colors.white),
                label: const Text('Record Payment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.checkCircle, size: 18, color: Color(0xFF374151)),
                label: const Text('Verify', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  backgroundColor: const Color(0xFFF9FAFB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedTextField(String hint, bool isFullWidth) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 14, fontWeight: FontWeight.w500),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF6366F1))),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildSimpleChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF374151)),
      ),
    );
  }

  Widget _buildRightPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recent Receipts Card
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Recent Receipts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      SizedBox(height: 4),
                      Text('Most recent fee collections', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(LucideIcons.fileText, color: Color(0xFF6366F1), size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // List Rows
              _buildListRow('RCPT-2026-041', 'Aarav Gupta', 'Grade 10-A', 'UPI', '₹12,500', LucideIcons.smartphone),
              _buildListRow('RCPT-2026-042', 'Priya Sharma', 'Grade 8-B', 'Cash', '₹8,200', LucideIcons.banknote),
              _buildListRow('RCPT-2026-043', 'Rohan Patel', 'Grade 12-A', 'Bank Transfer', '₹15,000', LucideIcons.building),
              _buildListRow('RCPT-2026-044', 'Sneha Kumar', 'Grade 6-C', 'Card', '₹6,500', LucideIcons.creditCard),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Today's Collection Target Card
        Container(
          padding: const EdgeInsets.all(28),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Today\'s collection target', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
              SizedBox(height: 16),
              Text('₹1,20,000', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF111827), letterSpacing: -0.5)),
              SizedBox(height: 12),
              Text('68% achieved from a mock target of 12 morning collections.', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListRow(String rcpt, String name, String grade, String mode, String amount, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text('$rcpt • $grade', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF10B981))),
              const SizedBox(height: 2),
              Text(mode, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))),
            ],
          ),
        ],
      ),
    );
  }
}
