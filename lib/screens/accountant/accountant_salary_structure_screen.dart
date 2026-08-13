import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountantSalaryStructureScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AccountantSalaryStructureScreen({super.key, required this.onBack});

  @override
  State<AccountantSalaryStructureScreen> createState() => _AccountantSalaryStructureScreenState();
}

class _AccountantSalaryStructureScreenState extends State<AccountantSalaryStructureScreen> {
  String _selectedRole = 'Teachers';
  final List<String> _roles = ['Teachers', 'Drivers', 'Admins', 'Support Staff'];

  final Map<String, Map<String, dynamic>> _salaryStructures = {
    'Teachers': {
      'base': 25000,
      'hra': 10000,
      'da': 5000,
      'medical': 2000,
      'pf': 1800,
      'pt': 200,
    },
    'Drivers': {
      'base': 12000,
      'hra': 4000,
      'da': 2000,
      'medical': 1000,
      'pf': 1200,
      'pt': 150,
    },
    'Admins': {
      'base': 20000,
      'hra': 8000,
      'da': 4000,
      'medical': 2000,
      'pf': 1800,
      'pt': 200,
    },
    'Support Staff': {
      'base': 10000,
      'hra': 3000,
      'da': 1500,
      'medical': 1000,
      'pf': 1000,
      'pt': 100,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF1E1E2D)),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Salary Structures',
          style: TextStyle(
            color: Color(0xFF1E1E2D),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus, color: Color(0xFF1E1E2D)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add new structure feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildRoleSelector(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildStructureDetails(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _roles.map((role) {
            final isSelected = _selectedRole == role;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedRole = role;
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
                    role,
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

  Widget _buildStructureDetails() {
    final structure = _salaryStructures[_selectedRole]!;
    final num totalEarnings = structure['base'] + structure['hra'] + structure['da'] + structure['medical'];
    final num totalDeductions = structure['pf'] + structure['pt'];
    final num netSalary = totalEarnings - totalDeductions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                color: const Color(0xFF6C4CF1).withOpacity(0.3),
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
                    'Net Salary (Monthly)',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${netSalary.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.banknote, color: Colors.white, size: 28),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Earnings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 12),
        _buildSectionCard([
          _buildDetailRow('Basic Salary', structure['base'], isEarning: true),
          _buildDetailRow('HRA (House Rent Allowance)', structure['hra'], isEarning: true),
          _buildDetailRow('DA (Dearness Allowance)', structure['da'], isEarning: true),
          _buildDetailRow('Medical Allowance', structure['medical'], isEarning: true),
          const Divider(height: 24),
          _buildDetailRow('Total Earnings', totalEarnings, isTotal: true, isEarning: true),
        ]),
        const SizedBox(height: 24),
        const Text(
          'Deductions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 12),
        _buildSectionCard([
          _buildDetailRow('Provident Fund (PF)', structure['pf'], isEarning: false),
          _buildDetailRow('Professional Tax (PT)', structure['pt'], isEarning: false),
          const Divider(height: 24),
          _buildDetailRow('Total Deductions', totalDeductions, isTotal: true, isEarning: false),
        ]),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit feature coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Edit Structure',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
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

  Widget _buildDetailRow(String label, dynamic amount, {bool isTotal = false, required bool isEarning}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? const Color(0xFF1E1E2D) : const Color(0xFF64748B),
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal 
                  ? (isEarning ? const Color(0xFF16A34A) : const Color(0xFFEF4444)) 
                  : const Color(0xFF1E1E2D),
            ),
          ),
        ],
      ),
    );
  }
}
