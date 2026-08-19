import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class HostelRoomsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const HostelRoomsScreen({super.key, this.onBack});

  @override
  State<HostelRoomsScreen> createState() => _HostelRoomsScreenState();
}

class _HostelRoomsScreenState extends State<HostelRoomsScreen> {
  String _searchQuery = '';
  final String _selectedBlock = 'Aryabhata (A)';
  int _selectedFilter = 0; // 0: All, 1: Allocated, 2: Pending, 3: Check Out

  List<Map<String, dynamic>> _rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    MainLayout.globalSearchQuery.addListener(_onGlobalSearchChanged);
    _searchQuery = MainLayout.globalSearchQuery.value;
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/hostel_rooms.json');
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _rooms = List<Map<String, dynamic>>.from(data);
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
    
    List<Map<String, dynamic>> blockRooms = _rooms;

    int totalRecords = blockRooms.length;
    int allocatedCount = 0;
    int pendingCount = 0;
    int checkOutCount = 0;

    for (var r in blockRooms) {
      for (var b in (r['beds'] as List)) {
        final status = b['status'];
        if (status == 'Allocated' || status == 'Checked In') {
          allocatedCount++;
        } else if (status == 'Pending') {
          pendingCount++;
        } else if (status == 'Checked Out' || status == 'Check Out') {
          checkOutCount++;
        }
      }
    }

    List<Map<String, dynamic>> displayedBeds = [];
    for (var room in blockRooms) {
      for (var bed in (room['beds'] as List)) {
        final status = bed['status'];
        bool matches = false;
        if (_selectedFilter == 0) {
          matches = true;
        } else if (_selectedFilter == 1 && (status == 'Allocated' || status == 'Checked In')) {
          matches = true;
        } else if (_selectedFilter == 2 && status == 'Pending') {
          matches = true;
        } else if (_selectedFilter == 3 && (status == 'Checked Out' || status == 'Check Out')) {
          matches = true;
        }

        if (matches) {
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            final matchesQuery = (bed['student']?.toString().toLowerCase().contains(query) ?? false) ||
                                 (bed['rollNo']?.toString().toLowerCase().contains(query) ?? false) ||
                                 (room['roomNo']?.toString().toLowerCase().contains(query) ?? false);
            if (!matchesQuery) matches = false;
          }
        }

        if (matches) {
          displayedBeds.add({'room': room, 'bed': bed});
        }
      }
    }

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
                      child: Text('Room Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showNewAllocationModal,
                      icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                      label: const Text('New Allocation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard('Total Rooms', '$totalRecords', LucideIcons.building, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF), 0),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard('Allocated', '$allocatedCount', LucideIcons.userCheck, const Color(0xFF16A34A), const Color(0xFFDCFCE7), 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard('Pending', '$pendingCount', LucideIcons.clock, const Color(0xFFD97706), const Color(0xFFFEF3C7), 2),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard('Check Out', '$checkOutCount', LucideIcons.logOut, const Color(0xFFE11D48), const Color(0xFFFFE4E6), 3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All Rooms', 0),
                      const SizedBox(width: 8),
                      _buildFilterChip('Allocated', 1),
                      const SizedBox(width: 8),
                      _buildFilterChip('Pending', 2),
                      const SizedBox(width: 8),
                      _buildFilterChip('Check Out', 3),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                child: displayedBeds.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text('No records found in $_selectedBlock', style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500)),
                        ),
                      )
                    : Column(
                        children: displayedBeds.map((item) {
                          return _buildStudentCard(item['room'], item['bed']);
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

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : const Color(0xFF6C6C80))),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> room, Map<String, dynamic> bed) {
    final status = bed['status'] as String;
    final isAllocated = status == 'Allocated' || status == 'Checked In';
    final isPending = status == 'Pending';
    final isCheckedOut = status == 'Checked Out' || status == 'Check Out';

    Color statusBg = const Color(0xFFF1F5F9);
    Color statusTextColor = const Color(0xFF64748B);
    String statusText = status;

    if (isAllocated) {
      statusBg = const Color(0xFFDCFCE7);
      statusTextColor = const Color(0xFF16A34A);
      statusText = 'Allocated';
    } else if (isPending) {
      statusBg = const Color(0xFFFEF3C7);
      statusTextColor = const Color(0xFFD97706);
      statusText = 'Pending';
    } else if (isCheckedOut) {
      statusBg = const Color(0xFFFFE4E6);
      statusTextColor = const Color(0xFFE11D48);
      statusText = 'Checked Out';
    }

    final studentName = bed['student'] ?? 'Vacant Bed';
    final admNo = bed['admNo'] ?? 'ADM2024-101';
    final grade = bed['grade'] ?? 'Grade 9-A';
    final initials = bed['initials'] ?? 'AM';

    return GestureDetector(
      onTap: () {
        _showStudentDetailsModal(room, bed);
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
                          Text(studentName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('$admNo • $grade', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6C6C80))),
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
                        _showStudentDetailsModal(room, bed);
                      } else if (value == 'transfer') {
                        _showTransferRoomModal(room, bed);
                      } else if (value == 'checkout') {
                        _showCheckOutModal(room, bed);
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
                        value: 'transfer',
                        child: Row(
                          children: [
                            Icon(LucideIcons.arrowLeftRight, size: 18, color: Color(0xFFD97706)),
                            SizedBox(width: 10),
                            Text('Transfer Room', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'checkout',
                        child: Row(
                          children: [
                            Icon(LucideIcons.logOut, size: 18, color: Color(0xFFE11D48)),
                            SizedBox(width: 10),
                            Text('Check Out', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Row(
              children: [
                const Icon(LucideIcons.building, size: 14, color: Color(0xFF6C4CF1)),
                const SizedBox(width: 6),
                Text('${room['block']} • Room ${room['roomNo']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void _showStudentDetailsModal(Map<String, dynamic> room, Map<String, dynamic> bed) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Student Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Color(0xFF64748B), size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFEEF2FF),
                  child: Text(
                    '${bed['initials'] ?? 'AM'}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${bed['student']}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${bed['admNo'] ?? 'ADM2024-101'} • ${bed['grade'] ?? 'Grade 9-A'}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6C6C80)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildGridDetailItem('BLOCK', '${room['block']}')),
                Expanded(child: _buildGridDetailItem('ROOM', '${room['roomNo']}')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildGridDetailItem('TYPE', '${room['type'] ?? 'Boys'}')),
                Expanded(child: _buildGridDetailItem('CHECK IN', '${bed['joinedDate'] ?? '12 Jun 2025'}')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildGridDetailItem('STATUS', '${bed['status']}')),
                Expanded(child: _buildGridDetailItem('CONTACT', '${bed['contact'] ?? '+91 98765 43210'}')),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Close', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              ),
            ),
          ],
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

  void _showTransferRoomModal(Map<String, dynamic> currentRoom, Map<String, dynamic> bed) {
    final TextEditingController blockCodeController = TextEditingController(text: '${currentRoom['blockCode'] ?? 'E'}');
    final TextEditingController blockNameController = TextEditingController(text: '${currentRoom['blockName'] ?? 'Eklavya'}');
    final TextEditingController roomNoController = TextEditingController(text: '${currentRoom['roomNo'] ?? '—'}');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Transfer Room', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Color(0xFF64748B), size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Transfer ${bed['student']} to a different room or block.', style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CURRENT ROOM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                    const SizedBox(height: 6),
                    Text(
                      'Block: ${currentRoom['block']} • Room: ${currentRoom['roomNo']} (${bed['bedNo'] ?? 'Bed A'})',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('New Block Code', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: blockCodeController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
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
                        const Text('New Block Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: blockNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('New Room No.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: roomNoController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
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
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        Navigator.pop(context);
                        setState(() => bed['status'] = 'Allocated');
                        scaffoldMessenger.showSnackBar(SnackBar(content: Text('${bed['student']} transferred successfully!')));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Confirm Transfer', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
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

  void _showCheckOutModal(Map<String, dynamic> room, Map<String, dynamic> bed) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFECDD3)),
              ),
              child: const Icon(LucideIcons.logOut, color: Color(0xFFE11D48), size: 30),
            ),
            const SizedBox(height: 16),
            const Text('Check Out Student', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to check out ${bed['student']} from ${room['block']} • Room ${room['roomNo']}?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80), height: 1.4),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6C6C80), fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      Navigator.pop(context);
                      setState(() => bed['status'] = 'Checked Out');
                      scaffoldMessenger.showSnackBar(SnackBar(content: Text('${bed['student']} has been checked out successfully.')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE11D48),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Confirm Check Out', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNewAllocationModal() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController admNoController = TextEditingController();
    final TextEditingController classController = TextEditingController();
    final TextEditingController blockCodeController = TextEditingController();
    final TextEditingController blockNameController = TextEditingController();
    final TextEditingController roomNoController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('New Room Allocation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Color(0xFF64748B), size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text('Allocate a room to a student in the hostel.', style: TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
              const SizedBox(height: 20),
              const Text('Student Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Aarav Mehta',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Admission No.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: admNoController,
                          decoration: InputDecoration(
                            hintText: 'e.g. ADM2024-101',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
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
                        const Text('Class', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: classController,
                          decoration: InputDecoration(
                            hintText: 'e.g. Grade 9-A',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Block Code', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: blockCodeController,
                          decoration: InputDecoration(
                            hintText: 'e.g. A',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
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
                        const Text('Block Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: blockNameController,
                          decoration: InputDecoration(
                            hintText: 'e.g. Aryabhata',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Room No.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: roomNoController,
                          decoration: InputDecoration(
                            hintText: 'e.g. A-204',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
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
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim().isNotEmpty ? nameController.text.trim() : 'Aarav Mehta';
                        final admNo = admNoController.text.trim().isNotEmpty ? admNoController.text.trim() : 'ADM2024-101';
                        final grade = classController.text.trim().isNotEmpty ? classController.text.trim() : 'Grade 9-A';
                        final bCode = blockCodeController.text.trim().isNotEmpty ? blockCodeController.text.trim() : 'A';
                        final bName = blockNameController.text.trim().isNotEmpty ? blockNameController.text.trim() : 'Aryabhata';
                        final roomNo = roomNoController.text.trim().isNotEmpty ? roomNoController.text.trim() : 'A-204';

                        final nameParts = name.split(' ');
                        final initials = nameParts.length > 1 ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase() : name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();

                        Navigator.pop(context);
                        setState(() {
                          _rooms.insert(0, {
                            'roomNo': roomNo,
                            'block': '$bName ($bCode)',
                            'blockCode': bCode,
                            'blockName': bName,
                            'floor': '1st Floor',
                            'type': 'Boys',
                            'capacity': 2,
                            'beds': [
                              {
                                'bedNo': 'Bed A',
                                'student': name,
                                'initials': initials,
                                'rollNo': '110',
                                'admNo': admNo,
                                'grade': grade,
                                'status': 'Allocated',
                                'joinedDate': 'Today',
                                'contact': '+91 98765 43210'
                              }
                            ],
                          });
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$name allocated to Room $roomNo successfully!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Allocate Room', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
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
}
