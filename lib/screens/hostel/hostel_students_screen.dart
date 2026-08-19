import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class HostelStudentsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const HostelStudentsScreen({super.key, this.onBack});

  @override
  State<HostelStudentsScreen> createState() => _HostelStudentsScreenState();
}

class _HostelStudentsScreenState extends State<HostelStudentsScreen> {
  int _selectedFilter = 0; // 0: All, 1: Checked In, 2: Pending, 3: Checked Out
  String _searchQuery = '';
  String _filterBlock = 'All Blocks';

  String _filterRoom = 'All Rooms';
  String _filterClass = 'All Classes';
  String _filterStatus = 'All Status';

  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    MainLayout.globalSearchQuery.addListener(_onGlobalSearchChanged);
    _searchQuery = MainLayout.globalSearchQuery.value;
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/hostel_students.json');
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _students = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
        child: const Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
      );
    }
    int totalStudents = 250 + _students.length;
    int boysCount = 214 + _students.where((s) => s['type'] == 'Boys').length;
    int girlsCount = 34 + _students.where((s) => s['type'] == 'Girls').length;
    int newAdmissionsCount = 10 + _students.where((s) => s['joinedDate'] == 'Today' || s['joinedDate'] == '20 Jun 2025').length;

    bool isCustomFilterActive = _filterBlock != 'All Blocks' ||
        _filterRoom != 'All Rooms' ||
        _filterClass != 'All Classes' ||
        _filterStatus != 'All Status';

    List<Map<String, dynamic>> displayedStudents = _students.where((s) {
      final status = (s['status'] ?? '').toString();
      final name = (s['student'] ?? '').toString().toLowerCase();
      final rollNo = (s['rollNo'] ?? '').toString().toLowerCase();
      final adm = (s['admNo'] ?? '').toString().toLowerCase();
      final roomNo = (s['roomNo'] ?? '').toString().toLowerCase();
      final block = (s['block'] ?? '').toString().toLowerCase();
      final grade = (s['grade'] ?? '').toString().toLowerCase();
      final guardian = (s['guardianName'] ?? '').toString().toLowerCase();
      final contact = (s['contact'] ?? '').toString().toLowerCase();
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery = query.isEmpty ||
          name.contains(query) ||
          adm.contains(query) ||
          rollNo.contains(query) ||
          roomNo.contains(query) ||
          block.contains(query) ||
          grade.contains(query) ||
          guardian.contains(query) ||
          contact.contains(query) ||
          status.toLowerCase().contains(query);

      bool matchesBlock = _filterBlock == 'All Blocks' || block.contains(_filterBlock.split(' ')[0].toLowerCase());
      bool matchesRoom = _filterRoom == 'All Rooms' || roomNo == _filterRoom.replaceAll('Room ', '').toLowerCase();
      bool matchesClass = _filterClass == 'All Classes' || grade.contains(_filterClass.toLowerCase());

      bool matchesStatus = true;
      if (_filterStatus == 'Active') {
        matchesStatus = status == 'Checked In' || status == 'Allocated' || status == 'Active';
      } else if (_filterStatus == 'Pending') {
        matchesStatus = status == 'Pending';
      } else if (_filterStatus == 'Checked Out') {
        matchesStatus = status == 'Checked Out' || status == 'Check Out';
      } else if (_selectedFilter != 0) {
        if (_selectedFilter == 1) matchesStatus = status == 'Checked In' || status == 'Allocated' || status == 'Active';
        if (_selectedFilter == 2) matchesStatus = status == 'Pending';
        if (_selectedFilter == 3) matchesStatus = status == 'Checked Out' || status == 'Check Out';
      }

      return matchesQuery && matchesBlock && matchesRoom && matchesClass && matchesStatus;
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
              // Custom App Bar
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
                      child: Text('Hostel Students', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    // Export Button
                    GestureDetector(
                      onTap: _exportStudents,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(LucideIcons.download, size: 18, color: Color(0xFF6C4CF1)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Add Student Button
                    ElevatedButton.icon(
                      onPressed: _showAddStudentModal,
                      icon: const Icon(LucideIcons.userPlus, size: 16, color: Colors.white),
                      label: const Text('Add Student', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4 KPI Cards in 2 Rows x 2 Columns Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Row 1: Total Students & Boys
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard('Total Students', '$totalStudents', LucideIcons.users, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF), 0),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard('Boys', '$boysCount', LucideIcons.user, const Color(0xFF3B82F6), const Color(0xFFEFF6FF), 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Row 2: Girls & New Admissions
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard('Girls', '$girlsCount', LucideIcons.user, const Color(0xFFEC4899), const Color(0xFFFDF2F8), 2),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard('New Admissions', '$newAdmissionsCount', LucideIcons.userPlus, const Color(0xFF10B981), const Color(0xFFF0FDF4), 0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Search Bar & Filter Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'Search student, room, block...',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                          prefixIcon: const Icon(LucideIcons.search, color: Color(0xFF6C4CF1), size: 18),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _showFilterBottomSheet,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (_selectedFilter != 0 || _filterStatus != 'All Status' || _filterBlock != 'All Blocks' || _filterRoom != 'All Rooms' || _filterClass != 'All Classes') ? const Color(0xFFF3F0FF) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: (_selectedFilter != 0 || _filterStatus != 'All Status' || _filterBlock != 'All Blocks' || _filterRoom != 'All Rooms' || _filterClass != 'All Classes') ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                        ),
                        child: Stack(clipBehavior: Clip.none, children: [
                          Icon(
                            LucideIcons.slidersHorizontal,
                            size: 20,
                            color: (_selectedFilter != 0 || _filterStatus != 'All Status' || _filterBlock != 'All Blocks' || _filterRoom != 'All Rooms' || _filterClass != 'All Classes') ? const Color(0xFF6C4CF1) : const Color(0xFF64748B),
                          ),
                          if (_selectedFilter != 0 || _filterStatus != 'All Status' || _filterBlock != 'All Blocks' || _filterRoom != 'All Rooms' || _filterClass != 'All Classes')
                            Positioned(top: -4, right: -4, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF6C4CF1), shape: BoxShape.circle))),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Student List
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                child: displayedStudents.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text('No students found', style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500)),
                        ),
                      )
                    : Column(
                        children: displayedStudents.map((student) {
                          return _buildStudentCard(student);
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String count, IconData icon, Color textColor, Color bgColor, int filterIndex) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: textColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                  Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80)), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportStudents() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(LucideIcons.fileSpreadsheet, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Exporting Hostel Student records to CSV...'),
          ],
        ),
        backgroundColor: Color(0xFF6C4CF1),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFilterBottomSheet() {
    String tempBlock = _filterBlock;
    String tempRoom = _filterRoom;
    String tempClass = _filterClass;
    String tempStatus = _filterStatus;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 20,
            right: 20,
            top: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filter Students', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempBlock = 'All Blocks';
                            tempRoom = 'All Rooms';
                            tempClass = 'All Classes';
                            tempStatus = 'All Status';
                          });
                        },
                        child: const Text('Reset All', style: TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF64748B), size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // All 4 Filter Dropdown Pills in ONE Single Horizontal Line (Matching Mockup Image)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildSingleLineFilterPill(
                      value: tempBlock,
                      items: ['All Blocks', 'Aryabhata (A)', 'Eklavya (E)', 'Bhaskara (B)'],
                      onChanged: (val) {
                        if (val != null) setModalState(() => tempBlock = val);
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildSingleLineFilterPill(
                      value: tempRoom,
                      items: ['All Rooms', 'Room A-204', 'Room E-101', 'Room A-102', 'Room B-301', 'Room E-105'],
                      onChanged: (val) {
                        if (val != null) setModalState(() => tempRoom = val);
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildSingleLineFilterPill(
                      value: tempClass,
                      items: ['All Classes', 'Grade 9-A', 'Grade 10-B', 'Grade 11-A', 'Grade 8-B', 'Grade 12-A'],
                      onChanged: (val) {
                        if (val != null) setModalState(() => tempClass = val);
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildSingleLineFilterPill(
                      value: tempStatus,
                      items: ['All Status', 'Active', 'Pending', 'Checked Out'],
                      onChanged: (val) {
                        if (val != null) setModalState(() => tempStatus = val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Apply Filters Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _filterBlock = tempBlock;
                      _filterRoom = tempRoom;
                      _filterClass = tempClass;
                      _filterStatus = tempStatus;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Apply Filters', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleLineFilterPill({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final isSelected = value != items.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF3F0FF) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.white,
          value: value,
          icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final status = student['status'] as String;
    final isCheckedIn = status == 'Checked In' || status == 'Allocated' || status == 'Active';
    final isPending = status == 'Pending';
    final isCheckedOut = status == 'Checked Out' || status == 'Check Out';

    Color statusBg = const Color(0xFFF1F5F9);
    Color statusTextColor = const Color(0xFF64748B);
    String statusText = status;

    if (isCheckedIn) {
      statusBg = const Color(0xFFDCFCE7);
      statusTextColor = const Color(0xFF16A34A);
      statusText = 'Active';
    } else if (isPending) {
      statusBg = const Color(0xFFFEF3C7);
      statusTextColor = const Color(0xFFD97706);
      statusText = 'Pending';
    } else if (isCheckedOut) {
      statusBg = const Color(0xFFFFE4E6);
      statusTextColor = const Color(0xFFE11D48);
      statusText = 'Checked Out';
    }

    final name = student['student'] ?? 'Student';
    final rollNo = student['rollNo'] ?? 'HST-101';
    final admNo = student['admNo'] ?? 'ADM2024-101';
    final grade = student['grade'] ?? 'Grade 9-A';
    final initials = student['initials'] ?? 'AM';
    final block = student['block'] ?? 'Aryabhata (A)';
    final roomNo = student['roomNo'] ?? 'A-101';
    final bedNo = student['bedNo'] ?? 'Bed A';

    return GestureDetector(
      onTap: () {
        _showViewDetailsModal(student);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFEEF2FF),
                      child: Text(initials, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('$rollNo • $admNo • $grade', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6C6C80)), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                    child: Text(statusText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusTextColor)),
                  ),
                  PopupMenuButton<String>(
                    color: Colors.white,
                    icon: const Icon(LucideIcons.moreVertical, color: Color(0xFF6C6C80), size: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onSelected: (value) {
                      if (value == 'view') {
                        _showViewDetailsModal(student);
                      } else if (value == 'edit') {
                        _showEditStudentModal(student);
                      } else if (value == 'delete') {
                        _showDeleteStudentConfirmation(student);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(LucideIcons.eye, size: 18, color: Color(0xFF6C4CF1)),
                            SizedBox(width: 10),
                            Text('View Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(LucideIcons.pencil, size: 18, color: Color(0xFFD97706)),
                            SizedBox(width: 10),
                            Text('Edit Student', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(LucideIcons.trash2, size: 18, color: Color(0xFFE11D48)),
                            SizedBox(width: 10),
                            Text('Delete Student', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFE11D48))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Row(
              children: [
                const Icon(LucideIcons.building, size: 14, color: Color(0xFF6C4CF1)),
                const SizedBox(width: 6),
                Text('$block • Room $roomNo ($bedNo)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void _showViewDetailsModal(Map<String, dynamic> student) {
    final status = student['status'] as String;
    final isCheckedIn = status == 'Checked In' || status == 'Allocated' || status == 'Active';
    final isPending = status == 'Pending';
    final displayStatus = isCheckedIn ? 'Active' : (isPending ? 'Pending' : 'Checked Out');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Student Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    IconButton(icon: const Icon(Icons.close, color: Color(0xFF6C4CF1), size: 20), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFFEEF2FF),
                      child: Text('${student['initials'] ?? 'AM'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${student['student']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 2),
                          Text('Roll No: ${student['rollNo'] ?? 'HST-101'} • ${student['admNo']} • ${student['grade']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6C6C80))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFF1F5F9), height: 1),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('STUDENT & ACADEMIC DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildGridDetailItem('ROLL NUMBER', '${student['rollNo'] ?? 'HST-101'}')),
                        Expanded(child: _buildGridDetailItem('CLASS & SECTION', '${student['grade'] ?? 'Grade 9-A'}')),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _buildGridDetailItem('GENDER & AGE', '${student['type'] ?? 'Boys'} • ${student['age'] ?? '15'} Yrs')),
                        Expanded(child: _buildGridDetailItem('ADMISSION NO.', '${student['admNo'] ?? 'ADM2024-101'}')),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text('HOSTEL DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildGridDetailItem('BLOCK', '${student['block']}')),
                        Expanded(child: _buildGridDetailItem('ROOM NO.', '${student['roomNo']} (${student['bedNo'] ?? 'Bed A'})')),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _buildGridDetailItem('STATUS', displayStatus)),
                        Expanded(child: _buildGridDetailItem('CHECK IN DATE', '${student['joinedDate'] ?? '12 Jun 2025'}')),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text('PARENT & GUARDIAN DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildGridDetailItem('GUARDIAN NAME', '${student['guardianName'] ?? 'Ramesh Mehta'}')),
                        Expanded(child: _buildGridDetailItem('CONTACT NUMBER', '${student['contact'] ?? '+91 98765 43210'}')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: Color(0xFFF1F5F9), height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Close', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
      ],
    );
  }

  void _showEditStudentModal(Map<String, dynamic> student) {
    final TextEditingController nameController = TextEditingController(text: '${student['student']}');
    final TextEditingController rollNoController = TextEditingController(text: '${student['rollNo']}');
    final TextEditingController classController = TextEditingController(text: '${student['grade']}');
    final TextEditingController ageController = TextEditingController(text: '${student['age'] ?? '15'}');
    final TextEditingController roomNoController = TextEditingController(text: '${student['roomNo']}');
    final TextEditingController guardianNameController = TextEditingController(text: '${student['guardianName']}');
    final TextEditingController contactController = TextEditingController(text: '${student['contact']}');

    String selectedGender = student['type'] ?? 'Male';
    if (!['Boys', 'Girls', 'Male', 'Female'].contains(selectedGender)) selectedGender = 'Boys';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Edit Student Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      IconButton(icon: const Icon(Icons.close, color: Color(0xFF64748B), size: 20), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Modify information for ${student['student']}.', style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
                  const SizedBox(height: 20),

                  // STUDENT DETAILS
                  const Text('STUDENT DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Full Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ID / Roll No', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: rollNoController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Class & Section', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: classController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Age', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // HOSTEL DETAILS
                  const Text('HOSTEL & ROOM DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Room Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: roomNoController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Guardian Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: guardianNameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Contact Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: contactController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final newName = nameController.text.trim();
                          final newRoll = rollNoController.text.trim();
                          final newGrade = classController.text.trim();
                          final newAge = ageController.text.trim();
                          final newRoom = roomNoController.text.trim();
                          final newGuardian = guardianNameController.text.trim();
                          final newContact = contactController.text.trim();

                          final nameParts = newName.split(' ');
                          final newInitials = nameParts.length > 1 ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase() : newName.substring(0, newName.length >= 2 ? 2 : 1).toUpperCase();

                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          Navigator.pop(context);
                          setState(() {
                            if (newName.isNotEmpty) student['student'] = newName;
                            if (newInitials.isNotEmpty) student['initials'] = newInitials;
                            if (newRoll.isNotEmpty) student['rollNo'] = newRoll;
                            if (newGrade.isNotEmpty) student['grade'] = newGrade;
                            if (newAge.isNotEmpty) student['age'] = newAge;
                            if (newRoom.isNotEmpty) student['roomNo'] = newRoom;
                            if (newGuardian.isNotEmpty) student['guardianName'] = newGuardian;
                            if (newContact.isNotEmpty) student['contact'] = newContact;
                          });

                          scaffoldMessenger.showSnackBar(
                            SnackBar(content: Text('${student['student']} updated successfully!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Text('Save Changes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteStudentConfirmation(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFFFF1F2), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFECDD3))),
                child: const Icon(LucideIcons.trash2, color: Color(0xFFE11D48), size: 30),
              ),
              const SizedBox(height: 16),
              const Text('Delete Student', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              const SizedBox(height: 8),
              Text('Are you sure you want to delete ${student['student']} (${student['rollNo']}) from hostel records? This action cannot be undone.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80), height: 1.4)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), side: const BorderSide(color: Color(0xFFE2E8F0)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6C6C80), fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        Navigator.pop(context);
                        setState(() {
                          _students.removeWhere((s) => s['id'] == student['id']);
                        });
                        scaffoldMessenger.showSnackBar(SnackBar(content: Text('${student['student']} deleted successfully.')));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE11D48), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Delete Student', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddStudentModal() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController rollNoController = TextEditingController();
    final TextEditingController classController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController roomNoController = TextEditingController();
    final TextEditingController guardianNameController = TextEditingController();
    final TextEditingController contactController = TextEditingController();

    String selectedGender = 'Select Gender';
    String selectedBlock = 'Select Block';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Add New Student to Hostel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      IconButton(icon: const Icon(Icons.close, color: Color(0xFF64748B), size: 20), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Register a new student into the hostel system. Complete all mandatory fields below.', style: TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
                  const SizedBox(height: 20),

                  // STUDENT DETAILS Section
                  const Text('STUDENT DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                  const SizedBox(height: 12),

                  // Full Name & Roll Number
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Full Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter student name',
                                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Roll Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: rollNoController,
                              decoration: InputDecoration(
                                hintText: 'e.g. HST-1024',
                                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Class & Section & Gender
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Class & Section', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: classController,
                              decoration: InputDecoration(
                                hintText: 'e.g. Class X - A',
                                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Gender', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  value: selectedGender,
                                  items: ['Select Gender', 'Boys', 'Girls']
                                      .map((g) => DropdownMenuItem(value: g, child: Text(g, style: TextStyle(color: g == 'Select Gender' ? const Color(0xFF94A3B8) : const Color(0xFF1E1E2D), fontSize: 13))))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => selectedGender = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Age
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Age', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'e.g. 15',
                                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // HOSTEL DETAILS Section
                  const Text('HOSTEL DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                  const SizedBox(height: 12),

                  // Block & Room Number
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Block', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  value: selectedBlock,
                                  items: ['Select Block', 'Aryabhata (A)', 'Eklavya (E)', 'Bhaskara (B)']
                                      .map((b) => DropdownMenuItem(value: b, child: Text(b, style: TextStyle(color: b == 'Select Block' ? const Color(0xFF94A3B8) : const Color(0xFF1E1E2D), fontSize: 13))))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => selectedBlock = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Room Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: roomNoController,
                              decoration: InputDecoration(
                                hintText: 'e.g. A-101',
                                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // GUARDIAN DETAILS Section
                  const Text('GUARDIAN DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Guardian Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: guardianNameController,
                              decoration: InputDecoration(
                                hintText: 'e.g. Ramesh Mehta',
                                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Contact Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: contactController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: 'e.g. +91 98765 43210',
                                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  const SizedBox(height: 16),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final name = nameController.text.trim().isNotEmpty ? nameController.text.trim() : 'Aarav Mehta';
                          final roll = rollNoController.text.trim().isNotEmpty ? rollNoController.text.trim() : 'HST-1024';
                          final grade = classController.text.trim().isNotEmpty ? classController.text.trim() : 'Grade 9-A';
                          final gender = selectedGender != 'Select Gender' ? selectedGender : 'Boys';
                          final age = ageController.text.trim().isNotEmpty ? ageController.text.trim() : '15';
                          final block = selectedBlock != 'Select Block' ? selectedBlock : 'Aryabhata (A)';
                          final roomNo = roomNoController.text.trim().isNotEmpty ? roomNoController.text.trim() : 'A-101';
                          final guardian = guardianNameController.text.trim().isNotEmpty ? guardianNameController.text.trim() : 'Ramesh Mehta';
                          final phone = contactController.text.trim().isNotEmpty ? contactController.text.trim() : '+91 98765 43210';

                          final nameParts = name.split(' ');
                          final initials = nameParts.length > 1 ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase() : name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();

                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          Navigator.pop(context);
                          setState(() {
                            _students.insert(0, {
                              'id': DateTime.now().millisecondsSinceEpoch.toString(),
                              'student': name,
                              'initials': initials,
                              'rollNo': roll,
                              'admNo': 'ADM2024-${roll.replaceAll(RegExp(r'[^0-9]'), '')}',
                              'grade': grade,
                              'block': block,
                              'blockCode': block.contains('(') ? block.split('(')[1].replaceAll(')', '') : 'A',
                              'blockName': block.split(' ')[0],
                              'roomNo': roomNo,
                              'bedNo': 'Bed A',
                              'type': gender,
                              'age': age,
                              'status': 'Checked In',
                              'joinedDate': 'Today',
                              'guardianName': guardian,
                              'contact': phone
                            });
                          });

                          scaffoldMessenger.showSnackBar(
                            SnackBar(content: Text('$name added to Hostel Students successfully!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Text('Add Student', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
