import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class HostelVisitorsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const HostelVisitorsScreen({super.key, this.onBack});

  @override
  State<HostelVisitorsScreen> createState() => _HostelVisitorsScreenState();
}

class _HostelVisitorsScreenState extends State<HostelVisitorsScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  List<Map<String, dynamic>> _visitorsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    MainLayout.globalSearchQuery.addListener(_onGlobalSearchChanged);
    _searchQuery = MainLayout.globalSearchQuery.value;
    _loadVisitors();
  }

  Future<void> _loadVisitors() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/mock/hostel_visitors.json',
      );
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _visitorsList = List<Map<String, dynamic>>.from(data);
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
      return Container(
        color: Colors.transparent,
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF6C4CF1)),
        ),
      );
    }

    int totalVisitors = _visitorsList.length;
    int currentlyInsideCount = _visitorsList
        .where((v) => v['status'] == 'Currently Inside')
        .length;
    int pendingCount = _visitorsList
        .where((v) => v['status'] == 'Pending Approval')
        .length;
    int rejectedCount = _visitorsList
        .where((v) => v['status'] == 'Rejected')
        .length;

    final displayedVisitors = _visitorsList.where((item) {
      final name = (item['name'] as String).toLowerCase();
      final student = (item['studentName'] as String).toLowerCase();
      final rollNo = (item['rollNo'] as String).toLowerCase();
      final status = (item['status'] as String);
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery =
          query.isEmpty ||
          name.contains(query) ||
          student.contains(query) ||
          rollNo.contains(query);
      bool matchesStatus = _filterStatus == 'All' || status == _filterStatus;

      return matchesQuery && matchesStatus;
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
              // Top App Bar
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
                      child: Text(
                        'Hostel Visitors',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _showExportModal,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(
                          LucideIcons.download,
                          size: 18,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddVisitorModal,
                      icon: const Icon(
                        LucideIcons.userPlus,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Log Visitor',
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

              // 4 KPI Cards — 2 Rows x 2 Columns Grid (same as attendance screen)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            'Total Visitors Today',
                            '$totalVisitors',
                            LucideIcons.users,
                            const Color(0xFF6C4CF1),
                            const Color(0xFFF3F0FF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard(
                            'Currently Inside',
                            '$currentlyInsideCount',
                            LucideIcons.circleCheckBig,
                            const Color(0xFF10B981),
                            const Color(0xFFF0FDF4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            'Pending Approval',
                            '$pendingCount',
                            LucideIcons.clock,
                            const Color(0xFFF59E0B),
                            const Color(0xFFFEF3C7),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard(
                            'Rejected',
                            '$rejectedCount',
                            LucideIcons.circleX,
                            const Color(0xFFE11D48),
                            const Color(0xFFFEE2E2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar + Filter Icon Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'Search visitor, student, roll no...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            LucideIcons.search,
                            color: Color(0xFF6C4CF1),
                            size: 18,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF6C4CF1),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _showFilterBottomSheet,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _filterStatus != 'All'
                              ? const Color(0xFFF3F0FF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _filterStatus != 'All'
                                ? const Color(0xFF6C4CF1)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              LucideIcons.slidersHorizontal,
                              size: 20,
                              color: _filterStatus != 'All'
                                  ? const Color(0xFF6C4CF1)
                                  : const Color(0xFF64748B),
                            ),
                            if (_filterStatus != 'All')
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF6C4CF1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_filterStatus != 'All')
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.filter,
                          size: 12,
                          color: Color(0xFF6C4CF1),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _filterStatus,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C4CF1),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => setState(() => _filterStatus = 'All'),
                          child: const Icon(
                            LucideIcons.x,
                            size: 14,
                            color: Color(0xFF6C4CF1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Visitor Cards List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: displayedVisitors.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'No visitor records found',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: displayedVisitors
                            .map((visitor) => _buildVisitorCard(visitor))
                            .toList(),
                      ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final filters = [
          {
            'label': 'All Visitors',
            'value': 'All',
            'icon': LucideIcons.users,
            'color': const Color(0xFF6C4CF1),
          },
          {
            'label': 'Currently Inside',
            'value': 'Currently Inside',
            'icon': LucideIcons.circleCheckBig,
            'color': const Color(0xFF10B981),
          },
          {
            'label': 'Pending Approval',
            'value': 'Pending Approval',
            'icon': LucideIcons.clock,
            'color': const Color(0xFFF59E0B),
          },
          {
            'label': 'Checked Out',
            'value': 'Checked Out',
            'icon': LucideIcons.logOut,
            'color': const Color(0xFF3B82F6),
          },
          {
            'label': 'Rejected',
            'value': 'Rejected',
            'icon': LucideIcons.circleX,
            'color': const Color(0xFFE11D48),
          },
        ];

        return Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filter Visitors',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        LucideIcons.x,
                        color: Color(0xFF64748B),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Select a status to filter visitor list',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
              ...filters.map((f) {
                final isActive = _filterStatus == f['value'];
                return GestureDetector(
                  onTap: () {
                    setState(() => _filterStatus = f['value'] as String);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFF3F0FF) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFF6C4CF1)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          f['icon'] as IconData,
                          size: 18,
                          color: _getColor(f['color'] as String),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            f['label'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? const Color(0xFF6C4CF1)
                                  : const Color(0xFF1E1E2D),
                            ),
                          ),
                        ),
                        if (isActive)
                          const Icon(
                            LucideIcons.check,
                            size: 18,
                            color: Color(0xFF6C4CF1),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // KPI Card — 2x2 grid style matching attendance screen
  Widget _buildKpiCard(
    String label,
    String count,
    IconData icon,
    Color textColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 8,
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
            child: Icon(icon, color: textColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Visitor Card — all details, no action buttons, actions in 3-dots menu
  Widget _buildVisitorCard(Map<String, dynamic> visitor) {
    final status = visitor['status'] as String;
    Color statusBg;
    Color statusTextColor;

    switch (status) {
      case 'Currently Inside':
        statusBg = const Color(0xFFDCFCE7);
        statusTextColor = const Color(0xFF16A34A);
        break;
      case 'Pending Approval':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFD97706);
        break;
      case 'Rejected':
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFE11D48);
        break;
      case 'Checked Out':
        statusBg = const Color(0xFFEFF6FF);
        statusTextColor = const Color(0xFF2563EB);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusTextColor = const Color(0xFF64748B);
    }

    return GestureDetector(
      onTap: () {
        _showVisitorDetailsModal(visitor);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + Name + Status Badge + 3-dot menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFF3F0FF),
                  child: Text(
                    visitor['initials'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visitor['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    LucideIcons.ellipsisVertical,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  onSelected: (val) {
                    if (val == 'view') _showVisitorDetailsModal(visitor);
                    if (val == 'checkout') {
                      setState(() {
                        visitor['status'] = 'Checked Out';
                        final now = TimeOfDay.now();
                        final hour = now.hourOfPeriod == 0
                            ? 12
                            : now.hourOfPeriod;
                        final period = now.period == DayPeriod.am ? 'AM' : 'PM';
                        visitor['checkOut'] =
                            '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';
                      });
                    }
                    if (val == 'approve') {
                      setState(() {
                        visitor['status'] = 'Currently Inside';
                        final now = TimeOfDay.now();
                        final hour = now.hourOfPeriod == 0
                            ? 12
                            : now.hourOfPeriod;
                        final period = now.period == DayPeriod.am ? 'AM' : 'PM';
                        visitor['checkIn'] =
                            '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';
                      });
                    }
                    if (val == 'delete') {
                      setState(() {
                        _visitorsList.removeWhere(
                          (v) => v['id'] == visitor['id'],
                        );
                      });
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.eye,
                            size: 16,
                            color: Color(0xFF6C4CF1),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (status == 'Currently Inside')
                      const PopupMenuItem(
                        value: 'checkout',
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.logOut,
                              size: 16,
                              color: Color(0xFFF59E0B),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Mark Checked Out',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (status == 'Pending Approval')
                      const PopupMenuItem(
                        value: 'approve',
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.userCheck,
                              size: 16,
                              color: Color(0xFF10B981),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Approve & Check In',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.trash2,
                            size: 16,
                            color: Color(0xFFE11D48),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFE11D48),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 14),

            // Info Grid — showing all add visitor details
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                children: [
                  // Row 1: Phone + Relation
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          LucideIcons.phone,
                          'Phone',
                          visitor['phone'] as String,
                          const Color(0xFF10B981),
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          LucideIcons.heart,
                          'Relation',
                          visitor['relation'] as String,
                          const Color(0xFFE11D48),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Row 2: Purpose
                  _buildInfoItem(
                    LucideIcons.fileText,
                    'Purpose',
                    visitor['purpose'] as String,
                    const Color(0xFF6C4CF1),
                  ),
                  const SizedBox(height: 12),
                  // Row 3: Student Name + Roll No
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          LucideIcons.graduationCap,
                          'Student',
                          visitor['studentName'] as String,
                          const Color(0xFF3B82F6),
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          LucideIcons.hash,
                          'Roll No.',
                          visitor['rollNo'] as String,
                          const Color(0xFF8B5CF6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Row 4: Check-in + Check-out times
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          LucideIcons.logIn,
                          'Check-in',
                          visitor['checkIn'] as String,
                          const Color(0xFF10B981),
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          LucideIcons.logOut,
                          'Check-out',
                          visitor['checkOut'] as String,
                          const Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Add Visitor Modal matching image model exactly
  void _showAddVisitorModal() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final relationCtrl = TextEditingController();
    final purposeCtrl = TextEditingController();
    final studentCtrl = TextEditingController();
    final rollNoCtrl = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final hour = selectedTime.hourOfPeriod == 0
              ? 12
              : selectedTime.hourOfPeriod;
          final period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
          final timeStr =
              '${hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}  $period';

          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 24,
              right: 24,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Title + Subtitle + Close X
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Log New Visitor',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Record details for a new visitor entering the premises.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            LucideIcons.x,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Row 1: Visitor Name + Phone Number
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalField(
                          'Visitor Name',
                          nameCtrl,
                          'Enter name',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildModalField(
                          'Phone Number',
                          phoneCtrl,
                          'Enter phone',
                          isNum: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Row 2: Relation + Purpose of Visit
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalField(
                          'Relation',
                          relationCtrl,
                          'e.g. Father',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildModalField(
                          'Purpose of Visit',
                          purposeCtrl,
                          'e.g. Family Visit',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Row 3: Student Name + Student Roll No.
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalField(
                          'Student Name',
                          studentCtrl,
                          'Enter student name',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildModalField(
                          'Student Roll No.',
                          rollNoCtrl,
                          'e.g. CS-2024-102',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Check-in Time (real-time clock, white background)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Check-in Time',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFF6C4CF1),
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Color(0xFF1E1E2D),
                                    secondary: Color(0xFFF3F0FF),
                                    onSecondary: Color(0xFF6C4CF1),
                                  ),
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: Colors.white,
                                    hourMinuteColor: const Color(0xFFF3F0FF),
                                    hourMinuteTextColor: const Color(
                                      0xFF6C4CF1,
                                    ),
                                    dialBackgroundColor: const Color(
                                      0xFFF8F9FA,
                                    ),
                                    dialHandColor: const Color(0xFF6C4CF1),
                                    dialTextColor: const Color(0xFF1E1E2D),
                                    entryModeIconColor: const Color(0xFF6C4CF1),
                                    dayPeriodColor: const Color(0xFFF3F0FF),
                                    dayPeriodTextColor: const Color(0xFF6C4CF1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    helpTextStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6C4CF1),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setModalState(() => selectedTime = picked);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                timeStr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                LucideIcons.clock,
                                size: 18,
                                color: Color(0xFF64748B),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  const SizedBox(height: 16),

                  // Action Buttons: Cancel + Save Log
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final name = nameCtrl.text.trim().isNotEmpty
                                ? nameCtrl.text.trim()
                                : 'Mr. New Visitor';
                            final initials = name
                                .split(' ')
                                .where((w) => w.isNotEmpty)
                                .map((e) => e[0])
                                .take(2)
                                .join('')
                                .toUpperCase();

                            final h = selectedTime.hourOfPeriod == 0
                                ? 12
                                : selectedTime.hourOfPeriod;
                            final prd = selectedTime.period == DayPeriod.am
                                ? 'AM'
                                : 'PM';
                            final checkInTime =
                                '${h.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} $prd';

                            setState(() {
                              _visitorsList.insert(0, {
                                'id': DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                'name': name,
                                'phone': phoneCtrl.text.trim().isNotEmpty
                                    ? phoneCtrl.text.trim()
                                    : '+91 00000 00000',
                                'relation': relationCtrl.text.trim().isNotEmpty
                                    ? relationCtrl.text.trim()
                                    : 'Parent',
                                'purpose': purposeCtrl.text.trim().isNotEmpty
                                    ? purposeCtrl.text.trim()
                                    : 'Visit',
                                'studentName':
                                    studentCtrl.text.trim().isNotEmpty
                                    ? studentCtrl.text.trim()
                                    : 'Student',
                                'rollNo': rollNoCtrl.text.trim().isNotEmpty
                                    ? rollNoCtrl.text.trim()
                                    : 'N/A',
                                'checkIn': checkInTime,
                                'checkOut': '--',
                                'status': 'Currently Inside',
                                'initials': initials.isNotEmpty
                                    ? initials
                                    : 'NV',
                              });
                            });
                            final scaffoldMessenger = ScaffoldMessenger.of(
                              context,
                            );
                            Navigator.pop(context);
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Visitor $name logged successfully!',
                                ),
                                backgroundColor: const Color(0xFF10B981),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C4CF1),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Save Log',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
      ),
    );
  }

  Widget _buildModalField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isNum = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNum ? TextInputType.phone : TextInputType.text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1E2D),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
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

  // View Visitor Details Modal
  void _showVisitorDetailsModal(Map<String, dynamic> visitor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFF3F0FF),
                  child: Text(
                    visitor['initials'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visitor['name'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Status: ${visitor['status']}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    LucideIcons.x,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 16),

            _buildDetailRow('Phone Number', visitor['phone'] as String),
            _buildDetailRow('Relation', visitor['relation'] as String),
            _buildDetailRow('Purpose of Visit', visitor['purpose'] as String),
            _buildDetailRow('Student Name', visitor['studentName'] as String),
            _buildDetailRow('Student Roll No.', visitor['rollNo'] as String),
            _buildDetailRow('Check-in Time', visitor['checkIn'] as String),
            _buildDetailRow('Check-out Time', visitor['checkOut'] as String),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _showExportModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Export Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        LucideIcons.x,
                        color: Color(0xFF64748B),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose the format to export your records.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              _buildExportOption(
                'PDF Document',
                '.pdf',
                LucideIcons.fileText,
                const Color(0xFFE11D48),
                const Color(0xFFFEE2E2),
              ),
              const SizedBox(height: 12),
              _buildExportOption(
                'Excel Spreadsheet',
                '.xlsx',
                LucideIcons.table2,
                const Color(0xFF16A34A),
                const Color(0xFFDCFCE7),
              ),
              const SizedBox(height: 12),
              _buildExportOption(
                'CSV File',
                '.csv',
                LucideIcons.fileSpreadsheet,
                const Color(0xFF2563EB),
                const Color(0xFFEFF6FF),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExportOption(
    String title,
    String format,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return GestureDetector(
      onTap: () {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        Navigator.pop(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Exporting as $format...'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF1E1E2D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  Text(
                    'Export to $format format',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
