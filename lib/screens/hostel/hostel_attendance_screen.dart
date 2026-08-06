import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class HostelAttendanceScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const HostelAttendanceScreen({super.key, this.onBack});

  @override
  State<HostelAttendanceScreen> createState() => _HostelAttendanceScreenState();
}

class _HostelAttendanceScreenState extends State<HostelAttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedSession = 'Night Roll Call (09:30 PM)';
  String _filterStatus = 'All Status'; // All Status, Present, Absent, On Leave
  String _searchQuery = '';
  String _markSearchQuery = '';

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

  // Active view: null means Main Block Overview screen; non-null block means Detailed Roll Call view for that block.
  Map<String, dynamic>? _activeRollCallBlock;

  final List<Map<String, dynamic>> _blocksAttendance = [
    {
      'id': '1',
      'name': 'Aryabhata Block (A)',
      'code': 'A',
      'type': 'Boys',
      'warden': 'Mr. Rajesh Sharma',
      'totalStudents': 6,
      'presentCount': 6,
      'absentCount': 0,
      'outingCount': 0,
      'status': 'Submitted',
      'submittedAt': '09:15 PM',
      'color': const Color(0xFF6C4CF1),
      'bgColor': const Color(0xFFF3F0FF),
    },
    {
      'id': '2',
      'name': 'Bhaskara Block (B)',
      'code': 'B',
      'type': 'Girls',
      'warden': 'Mrs. Sunita Verma',
      'totalStudents': 5,
      'presentCount': 4,
      'absentCount': 1,
      'outingCount': 0,
      'status': 'Submitted',
      'submittedAt': '09:05 PM',
      'color': const Color(0xFFEC4899),
      'bgColor': const Color(0xFFFDF2F8),
    },
    {
      'id': '3',
      'name': 'Eklavya Block (E)',
      'code': 'E',
      'type': 'Boys',
      'warden': 'Mr. Vikram Singh',
      'totalStudents': 4,
      'presentCount': 0,
      'absentCount': 0,
      'outingCount': 1,
      'status': 'Pending',
      'submittedAt': '-- : --',
      'color': const Color(0xFF3B82F6),
      'bgColor': const Color(0xFFEFF6FF),
    },
    {
      'id': '4',
      'name': 'Kalam Block (K)',
      'code': 'K',
      'type': 'Girls',
      'warden': 'Mrs. Anjali Roy',
      'totalStudents': 5,
      'presentCount': 0,
      'absentCount': 0,
      'outingCount': 0,
      'status': 'Pending',
      'submittedAt': '-- : --',
      'color': const Color(0xFF10B981),
      'bgColor': const Color(0xFFF0FDF4),
    },
  ];

  final List<Map<String, dynamic>> _studentsAttendance = [
    {
      'id': '1',
      'name': 'Aarav Sharma',
      'rollNo': 'HST-101',
      'roomNo': 'A-101',
      'block': 'Aryabhata Block (A)',
      'status': 'Present',
    },
    {
      'id': '2',
      'name': 'Diya Verma',
      'rollNo': 'HST-102',
      'roomNo': 'A-102',
      'block': 'Aryabhata Block (A)',
      'status': 'Present',
    },
    {
      'id': '3',
      'name': 'Vihaan Iyer',
      'rollNo': 'HST-103',
      'roomNo': 'A-103',
      'block': 'Aryabhata Block (A)',
      'status': 'Present',
    },
    {
      'id': '4',
      'name': 'Saanvi Nair',
      'rollNo': 'HST-104',
      'roomNo': 'A-104',
      'block': 'Aryabhata Block (A)',
      'status': 'Present',
    },
    {
      'id': '5',
      'name': 'Rohan Verma',
      'rollNo': 'HST-105',
      'roomNo': 'A-105',
      'block': 'Aryabhata Block (A)',
      'status': 'Present',
    },
    {
      'id': '6',
      'name': 'Kabir Das',
      'rollNo': 'HST-106',
      'roomNo': 'A-106',
      'block': 'Aryabhata Block (A)',
      'status': 'Present',
    },
    {
      'id': '7',
      'name': 'Ananya Roy',
      'rollNo': 'HST-201',
      'roomNo': 'B-201',
      'block': 'Bhaskara Block (B)',
      'status': 'Present',
    },
    {
      'id': '8',
      'name': 'Priya Singh',
      'rollNo': 'HST-205',
      'roomNo': 'B-205',
      'block': 'Bhaskara Block (B)',
      'status': 'Absent',
    },
    {
      'id': '9',
      'name': 'Aditya Patel',
      'rollNo': 'HST-302',
      'roomNo': 'E-302',
      'block': 'Eklavya Block (E)',
      'status': 'Leave',
    },
    {
      'id': '10',
      'name': 'Divya Joshi',
      'rollNo': 'HST-401',
      'roomNo': 'K-401',
      'block': 'Kalam Block (K)',
      'status': 'Present',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_activeRollCallBlock != null) {
      return _buildDetailedRollCallView(_activeRollCallBlock!);
    }

    int totalBlocksCount = _blocksAttendance.length;
    int submittedCount = _blocksAttendance.where((b) => b['status'] == 'Submitted').length;
    int pendingCount = _blocksAttendance.where((b) => b['status'] == 'Pending').length;
    int totalStudentsCount = _blocksAttendance.fold(0, (sum, b) => sum + (b['totalStudents'] as int));

    final displayedBlocks = _blocksAttendance.where((b) {
      final name = (b['name'] as String).toLowerCase();
      final code = (b['code'] as String).toLowerCase();
      final warden = (b['warden'] as String).toLowerCase();
      final status = (b['status'] as String);
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery = query.isEmpty || name.contains(query) || code.contains(query) || warden.contains(query);
      bool matchesStatus = _filterStatus == 'All' || status == _filterStatus;

      return matchesQuery && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Top App Bar
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
                      child: Text('Hostel Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        final pendingBlock = _blocksAttendance.firstWhere(
                          (b) => b['status'] == 'Pending',
                          orElse: () => _blocksAttendance.first,
                        );
                        setState(() => _activeRollCallBlock = pendingBlock);
                      },
                      icon: const Icon(LucideIcons.userCheck, size: 16, color: Colors.white),
                      label: const Text('Mark Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4 KPI Summary Cards (2x2 Grid)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard('Total Blocks', '$totalBlocksCount', LucideIcons.building2, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF), () {
                            setState(() => _filterStatus = 'All');
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard('Submitted', '$submittedCount', LucideIcons.checkCircle2, const Color(0xFF10B981), const Color(0xFFF0FDF4), () {
                            setState(() => _filterStatus = 'Submitted');
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard('Pending', '$pendingCount', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), () {
                            setState(() => _filterStatus = 'Pending');
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard('Total Students', '$totalStudentsCount', LucideIcons.users, const Color(0xFF3B82F6), const Color(0xFFEFF6FF), () {
                            setState(() => _filterStatus = 'All');
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Date & Session Selector Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2025),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) setState(() => _selectedDate = picked);
                            },
                            child: Row(
                              children: [
                                const Icon(LucideIcons.calendar, size: 18, color: Color(0xFF6C4CF1)),
                                const SizedBox(width: 8),
                                Text(
                                  '${_selectedDate.day.toString().padLeft(2, '0')} Aug ${_selectedDate.year}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                ),
                                const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(20)),
                            child: const Text('Live Status', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: ['Night Roll Call (09:30 PM)', 'Morning Roll Call (07:00 AM)'].map((session) {
                          final isSelected = _selectedSession == session;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedSession = session),
                              child: Container(
                                margin: EdgeInsets.only(right: session.contains('Night') ? 8 : 0),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    session.contains('Night') ? 'Night Roll Call' : 'Morning Roll Call',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips Row: All, Submitted, Pending
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: ['All', 'Submitted', 'Pending'].map((st) {
                    final isSelected = _filterStatus == st;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(st),
                        selected: isSelected,
                        selectedColor: const Color(0xFFF3F0FF),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _filterStatus = st);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Block Attendance Cards List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: displayedBlocks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text('No blocks found', style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500)),
                        ),
                      )
                    : Column(
                        children: displayedBlocks.map((block) => _buildBlockOverviewCard(block)).toList(),
                      ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String count, IconData icon, Color textColor, Color bgColor, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
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

  Widget _buildBlockOverviewCard(Map<String, dynamic> block) {
    final isSubmitted = block['status'] == 'Submitted';
    final statusBg = isSubmitted ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);
    final statusTextColor = isSubmitted ? const Color(0xFF16A34A) : const Color(0xFFD97706);
    final statusText = isSubmitted ? 'Submitted (${block['submittedAt']})' : 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: block['bgColor'] as Color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '${block['code']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: block['color'] as Color),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${block['name']}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                          child: Text(statusText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusTextColor)),
                        ),
                        const SizedBox(width: 8),
                        Text('${block['totalStudents']} Students', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6C6C80))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(LucideIcons.userCheck, size: 15, color: Color(0xFF6C4CF1)),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Warden: ${block['warden']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Button on Card
          SizedBox(
            width: double.infinity,
            child: isSubmitted
                ? OutlinedButton.icon(
                    onPressed: () => setState(() => _activeRollCallBlock = block),
                    icon: const Icon(LucideIcons.eye, size: 16, color: Color(0xFF6C4CF1)),
                    label: const Text('View / Edit Attendance', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6C4CF1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: () => setState(() => _activeRollCallBlock = block),
                    icon: const Icon(LucideIcons.userCheck, size: 16, color: Colors.white),
                    label: const Text('Mark Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _saveBlockAttendance(Map<String, dynamic> block, List<Map<String, dynamic>> blockStudents, String blockCode) {
    final timeNow = '${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')} PM';
    final updatedPresent = blockStudents.where((s) => s['status'] == 'Present').length;
    final updatedAbsent = blockStudents.where((s) => s['status'] == 'Absent').length;
    final updatedLeave = blockStudents.where((s) => s['status'] == 'Leave' || s['status'] == 'On Outing').length;

    setState(() {
      block['status'] = 'Submitted';
      block['submittedAt'] = timeNow;
      block['presentCount'] = updatedPresent;
      block['absentCount'] = updatedAbsent;
      block['outingCount'] = updatedLeave;
      _activeRollCallBlock = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attendance saved successfully for Block $blockCode!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  // Detailed Roll Call View for a specific Block matching the mockup image design exactly
  Widget _buildDetailedRollCallView(Map<String, dynamic> block) {
    final blockName = block['name'] as String;
    final blockCode = block['code'] as String;
    final blockStudents = _studentsAttendance.where((s) => (s['block'] as String).contains('Block ($blockCode)') || (s['block'] as String) == blockName).toList();

    final filteredStudents = blockStudents.where((s) {
      final query = _markSearchQuery.trim().toLowerCase();
      if (query.isEmpty) return true;
      final name = (s['name'] as String).toLowerCase();
      final room = (s['roomNo'] as String).toLowerCase();
      return name.contains(query) || room.contains(query);
    }).toList();

    int totalCount = blockStudents.length;
    int presentCount = blockStudents.where((s) => s['status'] == 'Present').length;
    int absentCount = blockStudents.where((s) => s['status'] == 'Absent').length;
    int leaveCount = blockStudents.where((s) => s['status'] == 'Leave' || s['status'] == 'On Outing').length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Header Row with Save Attendance Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Mark Attendance — Block $blockCode', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _saveBlockAttendance(block, blockStudents, blockCode),
                    icon: const Icon(LucideIcons.save, size: 15, color: Colors.white),
                    label: const Text('Save Attendance', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => _activeRollCallBlock = null),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 4 KPI Cards (2 Rows x 2 Columns Grid)
                    Row(
                      children: [
                        Expanded(child: _buildMarkKpiCard('Total', '$totalCount', LucideIcons.users, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
                        const SizedBox(width: 10),
                        Expanded(child: _buildMarkKpiCard('Present', '$presentCount', LucideIcons.userCheck, const Color(0xFF137333), const Color(0xFFE6F4EA))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildMarkKpiCard('Absent', '$absentCount', LucideIcons.userX, const Color(0xFFC5221F), const Color(0xFFFCE8E6))),
                        const SizedBox(width: 10),
                        Expanded(child: _buildMarkKpiCard('Leave', '$leaveCount', LucideIcons.planeTakeoff, const Color(0xFF1A73E8), const Color(0xFFE8F0FE))),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search Bar & Mark All Present Row
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (val) => setState(() => _markSearchQuery = val),
                            decoration: InputDecoration(
                              hintText: 'Search student name or room no',
                              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                              prefixIcon: const Icon(LucideIcons.search, color: Color(0xFF94A3B8), size: 18),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              for (var s in blockStudents) {
                                s['status'] = 'Present';
                              }
                            });
                          },
                          icon: const Icon(LucideIcons.userCheck, size: 16, color: Color(0xFF1E1E2D)),
                          label: const Text('Mark All Present', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Attendance Table Header Row
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        border: Border(
                          top: BorderSide(color: Color(0xFFE2E8F0)),
                          left: BorderSide(color: Color(0xFFE2E8F0)),
                          right: BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 70, child: Text('ROOM NO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                          Expanded(child: Text('STUDENT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                          SizedBox(width: 90, child: Text('STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                          SizedBox(width: 90, child: Align(alignment: Alignment.centerRight, child: Text('MARK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))))),
                        ],
                      ),
                    ),

                    // Attendance Table Student Rows
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: filteredStudents.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Center(child: Text('No students found', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13))),
                            )
                          : Column(
                              children: filteredStudents.asMap().entries.map((entry) {
                                final index = entry.key;
                                final student = entry.value;
                                final isLast = index == filteredStudents.length - 1;
                                return _buildTableRowItem(student, showDivider: !isLast);
                              }).toList(),
                            ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkKpiCard(String label, String count, IconData icon, Color textColor, Color bgColor) {
    return Container(
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
    );
  }

  Widget _buildTableRowItem(Map<String, dynamic> student, {required bool showDivider}) {
    final status = student['status'] as String;

    Color badgeBg = const Color(0xFFE6F4EA);
    Color badgeTextColor = const Color(0xFF137333);
    String statusLabel = '• Present';

    if (status == 'Absent') {
      badgeBg = const Color(0xFFFCE8E6);
      badgeTextColor = const Color(0xFFC5221F);
      statusLabel = '• Absent';
    } else if (status == 'Leave' || status == 'On Outing') {
      badgeBg = const Color(0xFFE8F0FE);
      badgeTextColor = const Color(0xFF1A73E8);
      statusLabel = '• Leave';
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Room No Column
              SizedBox(
                width: 70,
                child: Text('${student['roomNo']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              ),

              // Student Column
              Expanded(
                child: Text('${student['name']}', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
              ),

              // Status Badge Column
              SizedBox(
                width: 90,
                child: UnconstrainedBox(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(6)),
                    child: Text(statusLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeTextColor)),
                  ),
                ),
              ),

              // Mark Toggle Column (P / A / L)
              SizedBox(
                width: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildMarkOptionBtn('P', status == 'Present', const Color(0xFF10B981), () {
                      setState(() => student['status'] = 'Present');
                    }),
                    const SizedBox(width: 4),
                    _buildMarkOptionBtn('A', status == 'Absent', const Color(0xFFE11D48), () {
                      setState(() => student['status'] = 'Absent');
                    }),
                    const SizedBox(width: 4),
                    _buildMarkOptionBtn('L', status == 'Leave' || status == 'On Outing', const Color(0xFF3B82F6), () {
                      setState(() => student['status'] = 'Leave');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(color: Color(0xFFF1F5F9), height: 1),
      ],
    );
  }

  Widget _buildMarkOptionBtn(String label, bool isSelected, Color activeColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? activeColor : const Color(0xFFE2E8F0)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}
