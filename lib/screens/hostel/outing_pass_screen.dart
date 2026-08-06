import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class OutingPassScreen extends StatefulWidget {
  final VoidCallback onBack;

  const OutingPassScreen({super.key, required this.onBack});

  @override
  State<OutingPassScreen> createState() => _OutingPassScreenState();
}

class _OutingPassScreenState extends State<OutingPassScreen> {
  String _searchQuery = '';
  int _selectedFilter = 0; // 0: All, 1: Pending, 2: Approved, 3: Rejected

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

  final List<Map<String, dynamic>> _outingPasses = [
    {
      'id': 'OUT-2026-001',
      'studentName': 'Akshara',
      'roomInfo': 'Block B - Room 204',
      'reason': 'Weekend Home Visit',
      'destination': 'Springfield (Home)',
      'fromDate': '31 Jul, 2026 (09:00 AM)',
      'toDate': '02 Aug, 2026 (06:00 PM)',
      'parentApproval': 'Parent Approved',
      'status': 'Pending',
    },
    {
      'id': 'OUT-2026-002',
      'studentName': 'Rahul Sharma',
      'roomInfo': 'Block A - Room 102',
      'reason': 'Medical Checkup',
      'destination': 'City Hospital',
      'fromDate': '31 Jul, 2026 (10:00 AM)',
      'toDate': '31 Jul, 2026 (04:00 PM)',
      'parentApproval': 'Parent Approved',
      'status': 'Approved',
    },
    {
      'id': 'OUT-2026-003',
      'studentName': 'Priya Singh',
      'roomInfo': 'Block C - Room 305',
      'reason': 'Local Market Shopping',
      'destination': 'Downtown Mall',
      'fromDate': '01 Aug, 2026 (02:00 PM)',
      'toDate': '01 Aug, 2026 (07:00 PM)',
      'parentApproval': 'Parent Approved',
      'status': 'Approved',
    },
    {
      'id': 'OUT-2026-004',
      'studentName': 'Vivek Kumar',
      'roomInfo': 'Block B - Room 110',
      'reason': 'Unplanned Outing',
      'destination': 'Friend House',
      'fromDate': '29 Jul, 2026 (01:00 PM)',
      'toDate': '29 Jul, 2026 (08:00 PM)',
      'parentApproval': 'Not Approved',
      'status': 'Rejected',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = _outingPasses;
    if (_selectedFilter == 1) {
      filteredList = _outingPasses.where((p) => p['status'] == 'Pending').toList();
    } else if (_selectedFilter == 2) {
      filteredList = _outingPasses.where((p) => p['status'] == 'Approved').toList();
    } else if (_selectedFilter == 3) {
      filteredList = _outingPasses.where((p) => p['status'] == 'Rejected').toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredList = filteredList.where((p) => 
        p['studentName'].toString().toLowerCase().contains(query) ||
        p['reason'].toString().toLowerCase().contains(query) ||
        p['destination'].toString().toLowerCase().contains(query)
      ).toList();
    }

    int pendingCount = _outingPasses.where((p) => p['status'] == 'Pending').length;
    int approvedCount = _outingPasses.where((p) => p['status'] == 'Approved').length;
    int rejectedCount = _outingPasses.where((p) => p['status'] == 'Rejected').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
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
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('Hostel Outing Passes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showIssuePassModal,
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('Issue Pass', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // KPI Stats Grid (2 rows x 2 columns)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard('Total Outings', '${_outingPasses.length}', LucideIcons.fileText, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF), 0),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard('Pending', '$pendingCount', LucideIcons.clock, const Color(0xFFD97706), const Color(0xFFFEF3C7), 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard('Approved', '$approvedCount', LucideIcons.checkCircle2, const Color(0xFF16A34A), const Color(0xFFDCFCE7), 2),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard('Rejected', '$rejectedCount', LucideIcons.xCircle, const Color(0xFFE11D48), const Color(0xFFFFE4E6), 3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Filter Tabs (Segmented 4-Button Row)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _buildFilterChip('All', 0)),
                      Expanded(child: _buildFilterChip('Pending', 1)),
                      Expanded(child: _buildFilterChip('Approved', 2)),
                      Expanded(child: _buildFilterChip('Rejected', 3)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Outing Cards List
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                child: filteredList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text('No outing passes found', style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500)),
                        ),
                      )
                    : Column(
                        children: filteredList.map((pass) => _buildOutingPassCard(pass)).toList(),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF6C6C80),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutingPassCard(Map<String, dynamic> pass) {
    final status = pass['status'] as String;
    final isPending = status == 'Pending';
    final isApproved = status == 'Approved';
    final name = pass['studentName'] as String;

    String initials = 'ST';
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      initials = name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    }

    Color statusColor = isApproved ? const Color(0xFF16A34A) : (isPending ? const Color(0xFFD97706) : const Color(0xFFE11D48));
    Color statusBg = isApproved ? const Color(0xFFDCFCE7) : (isPending ? const Color(0xFFFEF3C7) : const Color(0xFFFFE4E6));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Avatar + Name + Status Pill)
          Row(
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
                    initials,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                        const SizedBox(width: 6),
                        const Icon(LucideIcons.shieldCheck, color: Color(0xFF16A34A), size: 16),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('${pass['roomInfo']} • ${pass['parentApproval']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(10)),
                child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Reason Pill Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.fileText, size: 13, color: Color(0xFF6C4CF1)),
                const SizedBox(width: 6),
                Text(pass['reason'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Date Range Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF3EEFF)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF6C4CF1)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${pass['fromDate']}  →  ${pass['toDate']}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          if (isPending) ...[
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _updatePassStatus(pass, 'Approved'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF16A34A).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.checkCircle2, size: 16, color: Colors.white),
                          SizedBox(width: 6),
                          Text('Approve', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _updatePassStatus(pass, 'Rejected'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE11D48).withOpacity(0.5), width: 1),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.xCircle, size: 16, color: Color(0xFFE11D48)),
                          SizedBox(width: 6),
                          Text('Reject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFE11D48))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _showGatePassModal(pass),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF6C4CF1).withOpacity(0.3), width: 1),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFF8F7FF),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.eye, size: 16, color: Color(0xFF6C4CF1)),
                          SizedBox(width: 8),
                          Text('View Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF6C4CF1))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6C4CF1)),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)), maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  void _updatePassStatus(Map<String, dynamic> pass, String newStatus) {
    setState(() {
      pass['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Outing Pass for ${pass['studentName']} set to $newStatus')),
    );
  }

  void _showIssuePassModal() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController blockController = TextEditingController();
    final TextEditingController roomController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();
    final TextEditingController emergencyController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Issue New Outpass',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF6C6C80)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Fill out the details below to manually issue an outpass.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6C6C80), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              // Student Name
              _buildFormLabel('Student Name'),
              const SizedBox(height: 6),
              _buildFormField(nameController, 'e.g. John Doe'),
              const SizedBox(height: 16),

              // Block & Room Number Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormLabel('Block'),
                        const SizedBox(height: 6),
                        _buildFormField(blockController, 'e.g. Boys A'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormLabel('Room Number'),
                        const SizedBox(height: 6),
                        _buildFormField(roomController, 'e.g. 104'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Reason for Leave
              _buildFormLabel('Reason for Leave'),
              const SizedBox(height: 6),
              _buildFormField(reasonController, 'e.g. Family Emergency'),
              const SizedBox(height: 16),

              // Description (Optional)
              _buildFormLabel('Description (Optional)'),
              const SizedBox(height: 6),
              _buildFormField(descController, 'Additional details...', maxLines: 3),
              const SizedBox(height: 16),

              // Start Date & End Date Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormLabel('Start Date'),
                        const SizedBox(height: 6),
                        _buildFormField(
                          startDateController,
                          'dd/mm/yyyy',
                          suffixIcon: Icons.calendar_today_outlined,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2026),
                              lastDate: DateTime(2027),
                            );
                            if (date != null) {
                              startDateController.text = "${date.day}/${date.month}/${date.year}";
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormLabel('End Date'),
                        const SizedBox(height: 6),
                        _buildFormField(
                          endDateController,
                          'dd/mm/yyyy',
                          suffixIcon: Icons.calendar_today_outlined,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(const Duration(days: 2)),
                              firstDate: DateTime(2026),
                              lastDate: DateTime(2027),
                            );
                            if (date != null) {
                              endDateController.text = "${date.day}/${date.month}/${date.year}";
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Emergency Contact
              _buildFormLabel('Emergency Contact'),
              const SizedBox(height: 6),
              _buildFormField(emergencyController, 'Name and Phone Number'),
              const SizedBox(height: 24),

              const Divider(color: Color(0xFFF1F5F9), height: 1),
              const SizedBox(height: 16),

              // Action Buttons (Cancel + Save Outpass)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1E1E2D),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isEmpty) return;

                      Navigator.pop(context);
                      setState(() {
                        _outingPasses.insert(0, {
                          'id': 'OUT-2026-${_outingPasses.length + 1}',
                          'studentName': name,
                          'roomInfo': '${blockController.text.trim().isNotEmpty ? blockController.text.trim() : "Block B"} - Room ${roomController.text.trim().isNotEmpty ? roomController.text.trim() : "204"}',
                          'reason': reasonController.text.trim().isNotEmpty ? reasonController.text.trim() : 'Personal Outing',
                          'destination': 'Home / Authorized Location',
                          'fromDate': startDateController.text.trim().isNotEmpty ? startDateController.text.trim() : '31 Jul, 2026',
                          'toDate': endDateController.text.trim().isNotEmpty ? endDateController.text.trim() : '02 Aug, 2026',
                          'parentApproval': 'Parent Approved',
                          'status': 'Approved',
                        });
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Outpass issued successfully for $name!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Outpass', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
    );
  }

  Widget _buildFormField(
    TextEditingController controller,
    String hintText, {
    int maxLines = 1,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: onTap != null,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13, fontWeight: FontWeight.w500),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFF6C6C80), size: 18) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
        ),
      ),
    );
  }

  void _showGatePassModal(Map<String, dynamic> pass) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Outing Pass Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF6C6C80)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Student Header Profile Card (Pure White with Slate Border)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF64748B).withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
                          pass['studentName'].toString().substring(0, 2).toUpperCase(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pass['studentName'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 4),
                          Text('${pass['roomInfo']} • ${pass['parentApproval']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Structured Details Card (Pure White with Slate Border)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF64748B).withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailRow(LucideIcons.fileText, 'Pass ID', pass['id']),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),
                    _buildDetailRow(LucideIcons.shieldCheck, 'Parent Status', pass['parentApproval']),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),
                    _buildDetailRow(LucideIcons.tag, 'Outing Reason', pass['reason']),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),
                    _buildDetailRow(LucideIcons.calendar, 'From Date', pass['fromDate']),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),
                    _buildDetailRow(LucideIcons.calendarCheck, 'To Date', pass['toDate']),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Close Details', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6C4CF1)),
        const SizedBox(width: 10),
        Text('$label: ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80))),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E1E2D)),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
