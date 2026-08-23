import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../main_layout.dart';

class EnquiriesScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const EnquiriesScreen({super.key, this.onBack});

  @override
  State<EnquiriesScreen> createState() => _EnquiriesScreenState();
}

class _EnquiriesScreenState extends State<EnquiriesScreen> {
  int _selectedFilter = 0; // 0: All, 1: Pending, 2: Converted, 3: Closed
  String _searchQuery = '';

  // Controllers for New/Edit Enquiry
  final _studentNameController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _gradeController = TextEditingController();
  final _sourceController = TextEditingController();
  final _followUpDateController = TextEditingController();
  final _notesController = TextEditingController();

  final List<Map<String, dynamic>> _enquiries = [
    {
      'id': 'ENQ-2026-001',
      'studentName': 'Aarav Patel',
      'parentName': 'Rakesh Patel',
      'phone': '+91 98765 43210',
      'email': 'rakesh.patel@gmail.com',
      'grade': 'Grade 5',
      'source': 'Walk-in',
      'date': '24 Aug 2026',
      'status': 'Pending',
      'nextFollowUp': '26 Aug 2026',
      'notes': 'Interested in school bus transport facility and robotics lab.',
    },
    {
      'id': 'ENQ-2026-002',
      'studentName': 'Priya Sharma',
      'parentName': 'Amit Sharma',
      'phone': '+91 91234 56789',
      'email': 'amit.sharma@outlook.com',
      'grade': 'Grade 1',
      'source': 'Online Portal',
      'date': '23 Aug 2026',
      'status': 'Converted',
      'nextFollowUp': 'Completed',
      'notes': 'Admission registration form submitted & token fee paid.',
    },
    {
      'id': 'ENQ-2026-003',
      'studentName': 'Ananya Desai',
      'parentName': 'Sanjay Desai',
      'phone': '+91 98220 12345',
      'email': 'sanjay.desai@yahoo.com',
      'grade': 'Grade 11 (Science)',
      'source': 'Phone Call',
      'date': '22 Aug 2026',
      'status': 'Pending',
      'nextFollowUp': '27 Aug 2026',
      'notes':
          'Inquired about Integrated JEE/NEET coaching batches and lab facilities.',
    },
    {
      'id': 'ENQ-2026-004',
      'studentName': 'Vihaan Mehta',
      'parentName': 'Neha Mehta',
      'phone': '+91 97654 32109',
      'email': 'neha.mehta@gmail.com',
      'grade': 'Kindergarten (KG-1)',
      'source': 'Walk-in',
      'date': '21 Aug 2026',
      'status': 'Pending',
      'nextFollowUp': '28 Aug 2026',
      'notes': 'Campus tour scheduled for Monday morning 10:30 AM.',
    },
    {
      'id': 'ENQ-2026-005',
      'studentName': 'Ishaan Gupta',
      'parentName': 'Rajesh Gupta',
      'phone': '+91 98111 22334',
      'email': 'rajesh.gupta@corp.com',
      'grade': 'Grade 9',
      'source': 'Referral',
      'date': '19 Aug 2026',
      'status': 'Converted',
      'nextFollowUp': 'Completed',
      'notes':
          'Entrance assessment cleared with Grade A. Enrolled successfully.',
    },
    {
      'id': 'ENQ-2026-006',
      'studentName': 'Rohan Singh',
      'parentName': 'Vikram Singh',
      'phone': '+91 99887 76655',
      'email': 'vikram.singh@gmail.com',
      'grade': 'Grade 8',
      'source': 'Social Media',
      'date': '18 Aug 2026',
      'status': 'Closed',
      'nextFollowUp': '--',
      'notes':
          'Decided to join another branch closer to their residential locality.',
    },
  ];

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
    _studentNameController.dispose();
    _parentNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _gradeController.dispose();
    _sourceController.dispose();
    _followUpDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter and search logic
    final filteredEnquiries = _enquiries.where((enq) {
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch =
          query.isEmpty ||
          enq['studentName'].toString().toLowerCase().contains(query) ||
          enq['parentName'].toString().toLowerCase().contains(query) ||
          enq['phone'].toString().contains(query) ||
          enq['grade'].toString().toLowerCase().contains(query) ||
          enq['id'].toString().toLowerCase().contains(query);

      if (!matchesSearch) return false;

      if (_selectedFilter == 1) return enq['status'] == 'Pending';
      if (_selectedFilter == 2) return enq['status'] == 'Converted';
      if (_selectedFilter == 3) return enq['status'] == 'Closed';
      return true;
    }).toList();

    int totalCount = _enquiries.length;
    int pendingCount = _enquiries.where((e) => e['status'] == 'Pending').length;
    int convertedCount = _enquiries
        .where((e) => e['status'] == 'Converted')
        .length;
    int closedCount = _enquiries.where((e) => e['status'] == 'Closed').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Bar
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
                            border: Border.all(
                              color: const Color(0xFFF3EEFF),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF1E1E2D),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enquiries',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Student & Admission Enquiries',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8B8B8B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showEnquiryModal(),
                      icon: const Icon(
                        LucideIcons.plus,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'New Enquiry',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // KPI Stats Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            'Total',
                            '$totalCount',
                            LucideIcons.files,
                            const Color(0xFF6C4CF1),
                            const Color(0xFFF3F0FF),
                            isActive: _selectedFilter == 0,
                            onTap: () => setState(() => _selectedFilter = 0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard(
                            'Pending',
                            '$pendingCount',
                            LucideIcons.clock,
                            const Color(0xFFF59E0B),
                            const Color(0xFFFEF3C7),
                            isActive: _selectedFilter == 1,
                            onTap: () => setState(() => _selectedFilter = 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            'Converted',
                            '$convertedCount',
                            LucideIcons.checkCircle2,
                            const Color(0xFF10B981),
                            const Color(0xFFD1FAE5),
                            isActive: _selectedFilter == 2,
                            onTap: () => setState(() => _selectedFilter = 2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard(
                            'Closed',
                            '$closedCount',
                            LucideIcons.xCircle,
                            const Color(0xFFEF4444),
                            const Color(0xFFFEE2E2),
                            isActive: _selectedFilter == 3,
                            onTap: () => setState(() => _selectedFilter = 3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFF3EEFF),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search student, parent, phone, grade...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF8B8B8B),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        LucideIcons.search,
                        color: Color(0xFF6C4CF1),
                        size: 18,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                LucideIcons.x,
                                size: 16,
                                color: Color(0xFF8B8B8B),
                              ),
                              onPressed: () =>
                                  setState(() => _searchQuery = ''),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              _buildFilterChips(),
              const SizedBox(height: 16),

              // Enquiries List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: filteredEnquiries.isEmpty
                    ? _buildEmptyState()
                    : Column(
                        children: filteredEnquiries
                            .map((enquiry) => _buildEnquiryCard(enquiry))
                            .toList(),
                      ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(
    String label,
    String count,
    IconData icon,
    Color color,
    Color bgColor, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? color : const Color(0xFFF3EEFF),
            width: isActive ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? color.withValues(alpha: 0.18)
                  : const Color(0xFFE8E3F8).withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                      color: isActive ? color : const Color(0xFF8B8B8B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildChip('All Enquiries', 0),
          const SizedBox(width: 8),
          _buildChip('Pending', 1),
          const SizedBox(width: 8),
          _buildChip('Converted', 2),
          const SizedBox(width: 8),
          _buildChip('Closed', 3),
        ],
      ),
    );
  }

  Widget _buildChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C4CF1)
                : const Color(0xFFF3EEFF),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6C4CF1).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF4A4A68),
          ),
        ),
      ),
    );
  }

  Widget _buildEnquiryCard(Map<String, dynamic> enquiry) {
    final status = enquiry['status'] as String;
    Color statusColor;
    Color statusBgColor;

    if (status == 'Pending') {
      statusColor = const Color(0xFFF59E0B);
      statusBgColor = const Color(0xFFFEF3C7);
    } else if (status == 'Converted') {
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFD1FAE5);
    } else {
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEE2E2);
    }

    return GestureDetector(
      onTap: () => _showEnquiryDetails(enquiry),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
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
            // Top Row: Avatar, Student Name, Status, 3-dots Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      enquiry['studentName'][0],
                      style: const TextStyle(
                        color: Color(0xFF6C4CF1),
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enquiry['studentName'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1E2D),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Parent: ${enquiry['parentName']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(
                    LucideIcons.ellipsisVertical,
                    size: 18,
                    color: Color(0xFF8B8B8B),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 6,
                  onSelected: (value) {
                    if (value == 'View') {
                      _showEnquiryDetails(enquiry);
                    } else if (value == 'Edit') {
                      _showEnquiryModal(enquiry: enquiry);
                    } else if (value == 'Convert') {
                      setState(() {
                        enquiry['status'] = 'Converted';
                        enquiry['nextFollowUp'] = 'Completed';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enquiry marked as Converted!'),
                        ),
                      );
                    } else if (value == 'Close') {
                      setState(() {
                        enquiry['status'] = 'Closed';
                        enquiry['nextFollowUp'] = '--';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enquiry marked as Closed.'),
                        ),
                      );
                    } else if (value == 'Delete') {
                      setState(() {
                        _enquiries.removeWhere((e) => e['id'] == enquiry['id']);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enquiry removed')),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'View',
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.eye,
                            size: 16,
                            color: Color(0xFF4A4A68),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Edit',
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.fileEdit,
                            size: 16,
                            color: Color(0xFF4A4A68),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Edit Enquiry',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (status == 'Pending') ...[
                      const PopupMenuItem(
                        value: 'Convert',
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.checkCircle2,
                              size: 16,
                              color: Color(0xFF10B981),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Mark as Converted',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Close',
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.xCircle,
                              size: 16,
                              color: Color(0xFFEF4444),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Mark as Closed',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'Delete',
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.trash2,
                            size: 16,
                            color: Color(0xFFEF4444),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Info Pill Row (ID, Source, Grade)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildInfoBadge(
                  LucideIcons.tag,
                  enquiry['id'],
                  const Color(0xFF6C4CF1),
                  const Color(0xFFF3F0FF),
                ),
                _buildInfoBadge(
                  LucideIcons.graduationCap,
                  enquiry['grade'],
                  const Color(0xFF0EA5E9),
                  const Color(0xFFE0F2FE),
                ),
                _buildInfoBadge(
                  LucideIcons.mapPin,
                  enquiry['source'] ?? 'Walk-in',
                  const Color(0xFF8B5CF6),
                  const Color(0xFFF5F3FF),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                color: Color(0xFFF3EEFF),
                height: 1,
                thickness: 1.2,
              ),
            ),

            // Key Details Grid
            Row(
              children: [
                Expanded(
                  child: _buildDetailCell(
                    LucideIcons.phone,
                    'Phone',
                    enquiry['phone'],
                  ),
                ),
                Expanded(
                  child: _buildDetailCell(
                    LucideIcons.calendar,
                    'Enquiry Date',
                    enquiry['date'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildDetailCell(
                    LucideIcons.clock,
                    'Next Follow-up',
                    enquiry['nextFollowUp'],
                  ),
                ),
                Expanded(
                  child: _buildDetailCell(
                    LucideIcons.fileText,
                    'Notes',
                    (enquiry['notes'] as String).isEmpty
                        ? '--'
                        : enquiry['notes'],
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String label, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCell(
    IconData icon,
    String label,
    String value, {
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF8B8B8B)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8B8B8B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F0FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.files,
              size: 36,
              color: Color(0xFF6C4CF1),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Enquiries Found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try adjusting your search query or filter tags.',
            style: TextStyle(fontSize: 12, color: Color(0xFF8B8B8B)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showEnquiryModal(),
            icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
            label: const Text(
              'Add New Enquiry',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  void _showEnquiryModal({Map<String, dynamic>? enquiry}) {
    final isEdit = enquiry != null;

    if (isEdit) {
      _studentNameController.text = enquiry['studentName'] ?? '';
      _parentNameController.text = enquiry['parentName'] ?? '';
      _phoneController.text = enquiry['phone'] ?? '';
      _emailController.text = enquiry['email'] ?? '';
      _gradeController.text = enquiry['grade'] ?? '';
      _sourceController.text = enquiry['source'] ?? 'Walk-in';
      _followUpDateController.text = enquiry['nextFollowUp'] ?? '';
      _notesController.text = enquiry['notes'] ?? '';
    } else {
      _studentNameController.clear();
      _parentNameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _gradeController.clear();
      _sourceController.text = 'Walk-in';
      _followUpDateController.text = DateFormat(
        'dd MMM yyyy',
      ).format(DateTime.now().add(const Duration(days: 3)));
      _notesController.clear();
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
            padding: const EdgeInsets.all(24),
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
                        Text(
                          isEdit ? 'Edit Enquiry' : 'New Admission Enquiry',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEdit
                              ? 'Update existing prospect information'
                              : 'Record a new student prospect details',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8B8B8B),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        LucideIcons.x,
                        color: Color(0xFF1E1E2D),
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F0FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        'Student Name',
                        'e.g. Aarav Patel',
                        controller: _studentNameController,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFormField(
                        'Parent Name',
                        'e.g. Rakesh Patel',
                        controller: _parentNameController,
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        'Phone Number',
                        '+91 98765 43210',
                        controller: _phoneController,
                        isRequired: true,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFormField(
                        'Grade Interested',
                        'e.g. Grade 5',
                        controller: _gradeController,
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        'Email Address',
                        'parent@example.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFormField(
                        'Enquiry Source',
                        'Walk-in / Online / Referral',
                        controller: _sourceController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildFormField(
                  'Follow-up Date',
                  'e.g. 28 Aug 2026',
                  controller: _followUpDateController,
                ),
                const SizedBox(height: 14),
                _buildFormField(
                  'Notes & Remarks',
                  'Enter specific requests or requirements...',
                  controller: _notesController,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(
                            color: Color(0xFFE8E3F8),
                            width: 1.5,
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF1E1E2D),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_studentNameController.text.trim().isEmpty ||
                              _phoneController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please fill in Student Name and Phone Number',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            if (isEdit) {
                              enquiry['studentName'] = _studentNameController
                                  .text
                                  .trim();
                              enquiry['parentName'] = _parentNameController.text
                                  .trim();
                              enquiry['phone'] = _phoneController.text.trim();
                              enquiry['email'] = _emailController.text.trim();
                              enquiry['grade'] = _gradeController.text.trim();
                              enquiry['source'] = _sourceController.text.trim();
                              enquiry['nextFollowUp'] = _followUpDateController
                                  .text
                                  .trim();
                              enquiry['notes'] = _notesController.text.trim();
                            } else {
                              final now = DateTime.now();
                              final dateStr = DateFormat(
                                'dd MMM yyyy',
                              ).format(now);

                              _enquiries.insert(0, {
                                'id':
                                    'ENQ-2026-${(_enquiries.length + 1).toString().padLeft(3, '0')}',
                                'studentName': _studentNameController.text
                                    .trim(),
                                'parentName':
                                    _parentNameController.text.trim().isEmpty
                                    ? 'Parent'
                                    : _parentNameController.text.trim(),
                                'phone': _phoneController.text.trim(),
                                'email': _emailController.text.trim(),
                                'grade': _gradeController.text.trim().isEmpty
                                    ? 'General'
                                    : _gradeController.text.trim(),
                                'source': _sourceController.text.trim().isEmpty
                                    ? 'Walk-in'
                                    : _sourceController.text.trim(),
                                'date': dateStr,
                                'status': 'Pending',
                                'nextFollowUp':
                                    _followUpDateController.text.trim().isEmpty
                                    ? dateStr
                                    : _followUpDateController.text.trim(),
                                'notes': _notesController.text.trim(),
                              });
                            }
                          });
                          final scaffoldMessenger = ScaffoldMessenger.of(
                            context,
                          );
                          Navigator.pop(context);
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                isEdit
                                    ? 'Enquiry updated successfully!'
                                    : 'New enquiry added successfully!',
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          isEdit ? LucideIcons.save : LucideIcons.plus,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          isEdit ? 'Save Changes' : 'Add Enquiry',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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

  Widget _buildFormField(
    String label,
    String hint, {
    TextEditingController? controller,
    bool isRequired = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1E1E2D),
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF8B8B8B), fontSize: 12),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF3EEFF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF3EEFF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF6C4CF1),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEnquiryDetails(Map<String, dynamic> enquiry) {
    final status = enquiry['status'] as String;
    Color statusColor;
    Color statusBgColor;

    if (status == 'Pending') {
      statusColor = const Color(0xFFF59E0B);
      statusBgColor = const Color(0xFFFEF3C7);
    } else if (status == 'Converted') {
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFD1FAE5);
    } else {
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEE2E2);
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            enquiry['studentName'][0],
                            style: const TextStyle(
                              color: Color(0xFF6C4CF1),
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              enquiry['studentName'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusBgColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  enquiry['id'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF8B8B8B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          LucideIcons.x,
                          color: Color(0xFF1E1E2D),
                          size: 20,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Details Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        LucideIcons.user,
                        'Parent / Guardian',
                        enquiry['parentName'],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        LucideIcons.phone,
                        'Phone Number',
                        enquiry['phone'],
                      ),
                      if ((enquiry['email'] ?? '').toString().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          LucideIcons.mail,
                          'Email Address',
                          enquiry['email'],
                        ),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          color: Color(0xFFF3EEFF),
                          height: 1,
                          thickness: 1.2,
                        ),
                      ),
                      _buildDetailRow(
                        LucideIcons.graduationCap,
                        'Grade / Class Interested',
                        enquiry['grade'],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        LucideIcons.compass,
                        'Enquiry Source',
                        enquiry['source'] ?? 'Walk-in',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        LucideIcons.calendar,
                        'Enquiry Date',
                        enquiry['date'],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        LucideIcons.clock,
                        'Next Follow-up',
                        enquiry['nextFollowUp'],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          color: Color(0xFFF3EEFF),
                          height: 1,
                          thickness: 1.2,
                        ),
                      ),
                      _buildDetailRow(
                        LucideIcons.fileText,
                        'Notes & Remarks',
                        (enquiry['notes'] as String).isEmpty
                            ? 'No notes added.'
                            : enquiry['notes'],
                      ),
                      const SizedBox(height: 24),

                      // Action Button in Bottom Sheet
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );
                                Navigator.pop(context);
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Calling ${enquiry['phone']}...',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                LucideIcons.phoneCall,
                                size: 16,
                                color: Color(0xFF6C4CF1),
                              ),
                              label: const Text(
                                'Call Parent',
                                style: TextStyle(
                                  color: Color(0xFF6C4CF1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFF6C4CF1),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _showEnquiryModal(enquiry: enquiry);
                              },
                              icon: const Icon(
                                LucideIcons.fileEdit,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Edit Enquiry',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6C4CF1),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF6C4CF1)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B8B8B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
