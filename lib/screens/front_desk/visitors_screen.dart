import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class VisitorsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const VisitorsScreen({super.key, this.onBack});

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  String _searchQuery = '';
  int _selectedFilter = 0; // 0: All, 1: Active, 2: Completed

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
    _nameController.dispose();
    _phoneController.dispose();
    _purposeController.dispose();
    _hostController.dispose();
    _idTypeController.dispose();
    _idNumberController.dispose();
    _inTimeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _idTypeController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _inTimeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> _visitors = [
    {
      'id': 'V-1001',
      'name': 'Rajesh Kumar',
      'purpose': 'Admission Enquiry',
      'host': 'Front Desk',
      'phone': '+91 9876543210',
      'timeIn': '10:15 AM',
      'timeOut': '',
      'status': 'Active',
    },
    {
      'id': 'V-1002',
      'name': 'Priya Singh',
      'purpose': 'Meet Principal',
      'host': 'Principal',
      'phone': '+91 9988776655',
      'timeIn': '11:30 AM',
      'timeOut': '',
      'status': 'Active',
    },
    {
      'id': 'V-1003',
      'name': 'Amit Sharma',
      'purpose': 'Fee Payment',
      'host': 'Accounts Office',
      'phone': '+91 9123456780',
      'timeIn': '12:00 PM',
      'timeOut': '12:45 PM',
      'status': 'Completed',
    },
    {
      'id': 'V-1004',
      'name': 'Neha Gupta',
      'purpose': 'Parent Teacher Meeting',
      'host': 'Mr. Verma (Science)',
      'phone': '+91 9876123450',
      'timeIn': '01:10 PM',
      'timeOut': '01:50 PM',
      'status': 'Completed',
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayedVisitors = _visitors.where((visitor) {
      // Apply status filter
      if (_selectedFilter == 1 && visitor['status'] != 'Active') return false;
      if (_selectedFilter == 2 && visitor['status'] != 'Completed') return false;

      // Apply search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return visitor['name'].toString().toLowerCase().contains(query) ||
               visitor['purpose'].toString().toLowerCase().contains(query) ||
               visitor['id'].toString().toLowerCase().contains(query) ||
               visitor['host'].toString().toLowerCase().contains(query);
      }
      return true;
    }).toList();

    return Container(
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    if (widget.onBack != null) ...[
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
                    ],
                    const Expanded(
                      child: Text('Visitor Log', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showVisitorModal(),
                      icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                      label: const Text('New Visitor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildStatsGrid(),
              const SizedBox(height: 24),
              _buildFilterChips(),
              const SizedBox(height: 16),
              if (displayedVisitors.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: Text('No visitors found.', style: TextStyle(color: Color(0xFF4A4A68), fontSize: 14)),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: displayedVisitors.length,
                  itemBuilder: (context, index) {
                    return _buildVisitorCard(displayedVisitors[index]);
                  },
                ),
              const SizedBox(height: 100), // padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    int totalVisitors = _visitors.length;
    int activeInside = _visitors.where((v) => v['status'] == 'Active').length;
    int expected = 8; // Mock data for expected
    int overstayed = 2; // Mock data for overstayed

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Total Visitors', '$totalVisitors', LucideIcons.users, const Color(0xFF6C4CF1)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Active Inside', '$activeInside', LucideIcons.userCheck, const Color(0xFF11B136)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Expected', '$expected', LucideIcons.clock, const Color(0xFFF59E0B)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Overstayed', '$overstayed', LucideIcons.alertTriangle, const Color(0xFFEF4444)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    Widget card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF8B8B8B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildChip('All Visitors', 0),
          const SizedBox(width: 8),
          _buildChip('Active In-Premise', 1),
          const SizedBox(width: 8),
          _buildChip('Completed', 2),
        ],
      ),
    );
  }

  Widget _buildChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF3EEFF),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFF6C4CF1).withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF4A4A68),
          ),
        ),
      ),
    );
  }

  Widget _buildVisitorCard(Map<String, dynamic> visitor) {
    final isActive = visitor['status'] == 'Active';

    return GestureDetector(
      onTap: () {
        _showVisitorDetails(visitor);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          // Header: Avatar, Name, Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F0FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    visitor['name'][0],
                    style: const TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            visitor['name'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            visitor['status'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isActive ? const Color(0xFF11B136) : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(LucideIcons.moreVertical, size: 18, color: Color(0xFF8B8B8B)),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          color: Colors.white,
                          elevation: 4,
                          onSelected: (value) {
                            if (value == 'delete') {
                              setState(() {
                                _visitors.removeWhere((v) => v['id'] == visitor['id']);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Visitor deleted')),
                              );
                            } else if (value == 'checkout') {
                              setState(() {
                                visitor['status'] = 'Completed';
                                visitor['timeOut'] = TimeOfDay.now().format(context);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Visitor Checked Out successfully!')),
                              );
                            } else if (value == 'View Details') {
                              _showVisitorDetails(visitor);
                            } else if (value == 'Edit') {
                              _showVisitorModal(visitor: visitor);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$value action selected for ${visitor['name']}')),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'View Details',
                              child: Row(
                                children: [
                                  Icon(LucideIcons.eye, size: 16, color: Color(0xFF4A4A68)),
                                  SizedBox(width: 12),
                                  Text('View Details', style: TextStyle(fontSize: 13, color: Color(0xFF1E1E2D))),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'Edit',
                              child: Row(
                                children: [
                                  Icon(LucideIcons.edit2, size: 16, color: Color(0xFF4A4A68)),
                                  SizedBox(width: 12),
                                  Text('Edit Visitor', style: TextStyle(fontSize: 13, color: Color(0xFF1E1E2D))),
                                ],
                              ),
                            ),
                            if (isActive)
                              const PopupMenuItem(
                                value: 'checkout',
                                child: Row(
                                  children: [
                                    Icon(LucideIcons.logOut, size: 16, color: Color(0xFFF59E0B)),
                                    SizedBox(width: 12),
                                    Text('Checkout', style: TextStyle(fontSize: 13, color: Color(0xFFF59E0B), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            const PopupMenuDivider(),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
                                  SizedBox(width: 12),
                                  Text('Delete', style: TextStyle(fontSize: 13, color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${visitor['phone']}  •  ID: ${visitor['id']}', style: const TextStyle(fontSize: 13, color: Color(0xFF8B8B8B), fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFF3EEFF), height: 1, thickness: 1.5),
          ),
          // Body: Purpose, Whom to meet, In/Out
          Row(
            children: [
              Expanded(
                child: _buildDetailColumn('Purpose', visitor['purpose']),
              ),
              Expanded(
                child: _buildDetailColumn('Whom to Meet', visitor['host']),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailColumn('In Time', visitor['timeIn']),
              ),
              Expanded(
                child: _buildDetailColumn('Out Time', isActive ? '-- : --' : visitor['timeOut']),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B8B8B))),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
      ],
    );
  }

  void _showVisitorModal({Map<String, dynamic>? visitor}) {
    final isEdit = visitor != null;

    // Clear previous input or fill with existing data
    if (isEdit) {
      _nameController.text = visitor['name'];
      _phoneController.text = visitor['phone'];
      _purposeController.text = visitor['purpose'];
      _hostController.text = visitor['host'];
      _idTypeController.text = 'ID Proof'; // Mock as we don't store it yet
      _idNumberController.text = visitor['id'];
      _inTimeController.text = visitor['timeIn'];
      _noteController.text = ''; // Mock
    } else {
      _nameController.clear();
      _phoneController.clear();
      _purposeController.clear();
      _hostController.clear();
      _idTypeController.clear();
      _idNumberController.clear();
      _noteController.clear();

      // Prefill time with current time
      final now = TimeOfDay.now();
      _inTimeController.text = now.format(context);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isEdit ? 'Edit Visitor' : 'Log New Visitor', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 4),
                          Text(isEdit ? 'Update visitor details' : 'Record a visitor check-in', style: const TextStyle(fontSize: 14, color: Color(0xFF8B8B8B))),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, color: Color(0xFF1E1E2D)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(child: _buildFormField('Visitor Name', 'e.g. Ramesh Kumar', controller: _nameController, isRequired: true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFormField('Phone', '+91 98765 43210', controller: _phoneController, isRequired: true)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildFormField('Purpose of Visit', 'e.g. Parent Meeting', controller: _purposeController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFormField('Whom to Meet', 'e.g. Mrs. Sharma (Grade 8-A)', controller: _hostController)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildFormField('ID Proof Type', 'e.g. Aadhaar', controller: _idTypeController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFormField('ID Number', 'XXXX-XXXX-XXXX', controller: _idNumberController)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildFormField('In Time', '14:21', controller: _inTimeController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFormField('Note', 'Optional remark', controller: _noteController)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: const BorderSide(color: Color(0xFFE8E3F8), width: 1.5),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_nameController.text.trim().isEmpty) return;

                            setState(() {
                              if (isEdit) {
                                visitor['name'] = _nameController.text.trim();
                                visitor['purpose'] = _purposeController.text.trim().isEmpty ? 'General Visit' : _purposeController.text.trim();
                                visitor['host'] = _hostController.text.trim().isEmpty ? 'Front Desk' : _hostController.text.trim();
                                visitor['phone'] = _phoneController.text.trim();
                                visitor['timeIn'] = _inTimeController.text.trim();
                              } else {
                                _visitors.insert(0, {
                                  'id': 'V-100${_visitors.length + 1}',
                                  'name': _nameController.text.trim(),
                                  'purpose': _purposeController.text.trim().isEmpty ? 'General Visit' : _purposeController.text.trim(),
                                  'host': _hostController.text.trim().isEmpty ? 'Front Desk' : _hostController.text.trim(),
                                  'phone': _phoneController.text.trim(),
                                  'timeIn': _inTimeController.text.trim(),
                                  'timeOut': '',
                                  'status': 'Active',
                                });
                              }
                            });
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            Navigator.pop(context);
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text(isEdit ? 'Visitor updated successfully!' : 'Visitor logged successfully!')),
                            );
                          },
                          icon: Icon(isEdit ? LucideIcons.save : LucideIcons.plus, size: 20, color: Colors.white),
                          label: Text(isEdit ? 'Save Changes' : 'Log Visitor', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C4CF1),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField(String label, String hint, {TextEditingController? controller, bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
            children: [
              if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Color(0xFFEF4444))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  void _showVisitorDetails(Map<String, dynamic> visitor) {
    final isActive = visitor['status'] == 'Active';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8E3F8),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            visitor['name'][0],
                            style: const TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.w900, fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              visitor['name'],
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                visitor['status'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isActive ? const Color(0xFF11B136) : const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(LucideIcons.x, color: Color(0xFF8B8B8B)),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildDetailRow(LucideIcons.phone, 'Phone Number', visitor['phone']),
                      const SizedBox(height: 16),
                      _buildDetailRow(LucideIcons.creditCard, 'ID Proof', visitor['id']),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(color: Color(0xFFF3EEFF), height: 1, thickness: 1.5),
                      ),
                      _buildDetailRow(LucideIcons.briefcase, 'Purpose', visitor['purpose']),
                      const SizedBox(height: 16),
                      _buildDetailRow(LucideIcons.user, 'Host (Whom to Meet)', visitor['host']),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(color: Color(0xFFF3EEFF), height: 1, thickness: 1.5),
                      ),
                      _buildDetailRow(LucideIcons.logIn, 'Time In', visitor['timeIn']),
                      if (!isActive) ...[
                        const SizedBox(height: 16),
                        _buildDetailRow(LucideIcons.logOut, 'Time Out', visitor['timeOut']),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF6C4CF1)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B8B8B))),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            ],
          ),
        ),
      ],
    );
  }
}
