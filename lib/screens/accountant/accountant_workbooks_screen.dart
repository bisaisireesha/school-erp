import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class AccountantWorkbooksScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AccountantWorkbooksScreen({super.key, required this.onBack});

  @override
  State<AccountantWorkbooksScreen> createState() => _AccountantWorkbooksScreenState();
}

class _AccountantWorkbooksScreenState extends State<AccountantWorkbooksScreen> {
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

  final List<Map<String, dynamic>> _workbooks = [
    {
      'title': 'Master Fee Collection 2024-25',
      'type': 'Excel (.xlsx)',
      'size': '2.4 MB',
      'lastModified': '2 days ago',
      'author': 'System Generated',
      'color': const Color(0xFF16A34A),
      'bg': const Color(0xFFF0FDF4),
      'icon': LucideIcons.fileSpreadsheet,
    },
    {
      'title': 'Annual Budget Planner',
      'type': 'Google Sheets',
      'size': 'Linked',
      'lastModified': 'Last week',
      'author': 'Finance Admin',
      'color': const Color(0xFF3B82F6),
      'bg': const Color(0xFFEFF6FF),
      'icon': LucideIcons.table2,
    },
    {
      'title': 'Staff Payroll Register - Q1',
      'type': 'CSV (.csv)',
      'size': '856 KB',
      'lastModified': 'Aug 1, 2025',
      'author': 'HR System',
      'color': const Color(0xFF8B5CF6),
      'bg': const Color(0xFFF5F3FF),
      'icon': LucideIcons.fileCode2,
    },
    {
      'title': 'Vendor Payment Logs',
      'type': 'Excel (.xlsx)',
      'size': '1.2 MB',
      'lastModified': 'Aug 5, 2025',
      'author': 'Accounts Dept',
      'color': const Color(0xFF16A34A),
      'bg': const Color(0xFFF0FDF4),
      'icon': LucideIcons.fileSpreadsheet,
    },
    {
      'title': 'Tax Deductions (TDS) Q2',
      'type': 'PDF Report',
      'size': '4.1 MB',
      'lastModified': 'Jul 15, 2025',
      'author': 'Compliance',
      'color': const Color(0xFFEF4444),
      'bg': const Color(0xFFFEF2F2),
      'icon': LucideIcons.fileText,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredWorkbooks = _workbooks.where((w) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final title = (w['title'] as String).toLowerCase();
      return title.contains(q);
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
                          Text('Workbooks', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                          Text('Manage financial spreadsheets', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showNewSheetDialog(context),
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
                  children: filteredWorkbooks.map((wb) => _buildWorkbookCard(wb)).toList(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkbookCard(Map<String, dynamic> workbook) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text('Opening ${workbook['title']}...', style: const TextStyle(fontWeight: FontWeight.bold))),
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: workbook['bg'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(workbook['icon'] as IconData, color: workbook['color'] as Color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workbook['title'] as String,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      workbook['type'] as String,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: workbook['color'] as Color),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFCBD5E1), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      workbook['size'] as String,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(LucideIcons.clock, size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      'Modified ${workbook['lastModified']}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.moreVertical, color: Color(0xFF64748B), size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Open', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9))),
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

  void _showNewSheetDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: 'Untitled Sheet');
    final TextEditingController shortNameController = TextEditingController(text: 'Untitled');
    final TextEditingController ownerController = TextEditingController(text: 'Accounts Desk');
    final TextEditingController cadenceController = TextEditingController(text: 'Manual');
    final TextEditingController statusController = TextEditingController(text: 'Ready');
    final TextEditingController tabsController = TextEditingController(text: 'Sheet1');
    final TextEditingController purposeController = TextEditingController(text: 'A clean blank spreadsheet with no pre-filled accounting rows.');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('New Sheet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Create a completely blank spreadsheet. No accounting headers, formulas, or sample rows will be added.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildFormField('SHEET NAME', nameController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormField('SHORT NAME', shortNameController)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildFormField('OWNER', ownerController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormField('CADENCE', cadenceController)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildFormField('STATUS', statusController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormField('STARTING TABS', tabsController)),
                ],
              ),
              const SizedBox(height: 16),
              _buildFormField('PURPOSE', purposeController, maxLines: 3),
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
                        _workbooks.insert(0, {
                          'title': nameController.text,
                          'type': 'Blank Sheet',
                          'size': '0 KB',
                          'lastModified': 'Just now',
                          'author': ownerController.text,
                          'color': const Color(0xFF6C4CF1),
                          'bg': const Color(0xFFF3F0FF),
                          'icon': LucideIcons.fileSpreadsheet,
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${nameController.text} created successfully!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Create Sheet', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
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
