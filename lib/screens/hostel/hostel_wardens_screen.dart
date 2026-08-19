import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class HostelWardensScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const HostelWardensScreen({super.key, this.onBack});

  @override
  State<HostelWardensScreen> createState() => _HostelWardensScreenState();
}

class _HostelWardensScreenState extends State<HostelWardensScreen> {
  String _searchQuery = '';
  String _filterRole = 'All Roles'; // All Roles, Head Warden, Assistant Warden, Night Warden
  final String _filterStatus = 'All Status';

  List<Map<String, dynamic>> _wardens = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    MainLayout.globalSearchQuery.addListener(_onGlobalSearchChanged);
    _searchQuery = MainLayout.globalSearchQuery.value;
    _loadWardens();
  }

  Future<void> _loadWardens() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/hostel_wardens.json');
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _wardens = List<Map<String, dynamic>>.from(data);
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
        child: const Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
      );
    }
    int totalWardensCount = _wardens.length;
    int onDutyCount = _wardens.where((w) => w['status'] == 'On Duty').length;
    int offDutyCount = _wardens.where((w) => w['status'] == 'Off Duty').length;
    int onLeaveCount = _wardens.where((w) => w['status'] == 'On Leave').length;

    final displayedWardens = _wardens.where((w) {
      final name = (w['name'] as String).toLowerCase();
      final block = (w['block'] as String).toLowerCase();
      final email = (w['email'] as String).toLowerCase();
      final phone = (w['phone'] as String).toLowerCase();
      final role = (w['role'] as String);
      final status = (w['status'] as String);
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery = query.isEmpty ||
          name.contains(query) ||
          block.contains(query) ||
          email.contains(query) ||
          phone.contains(query);

      bool matchesRole = true;
      if (_filterRole == 'On Duty') {
        matchesRole = status == 'On Duty';
      } else if (_filterRole == 'Off Duty') {
        matchesRole = status == 'Off Duty';
      } else if (_filterRole == 'On Leave') {
        matchesRole = status == 'On Leave';
      } else if (_filterRole != 'All Roles') {
        matchesRole = role == _filterRole;
      }

      return matchesQuery && matchesRole;
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
                      child: Text('Hostel Wardens', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),

                    ElevatedButton.icon(
                      onPressed: _showAddWardenModal,
                      icon: const Icon(LucideIcons.userPlus, size: 16, color: Colors.white),
                      label: const Text('Add Warden', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
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
              // 4 KPI Summary Cards (2x2 Grid: Total Wardens, On Duty, Off Duty, On Leave)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard('Total Wardens', '$totalWardensCount', LucideIcons.shield, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF), () {
                            setState(() => _filterRole = 'All Roles');
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard('On Duty', '$onDutyCount', LucideIcons.userCheck, const Color(0xFF10B981), const Color(0xFFF0FDF4), () {
                            setState(() => _filterRole = 'On Duty');
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard('Off Duty', '$offDutyCount', LucideIcons.clock, const Color(0xFF3B82F6), const Color(0xFFEFF6FF), () {
                            setState(() => _filterRole = 'Off Duty');
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard('On Leave', '$onLeaveCount', LucideIcons.calendarOff, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), () {
                            setState(() => _filterRole = 'On Leave');
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar & Filter Options Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'Search warden by name, block, phone...',
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
                          color: _filterRole != 'All Roles' ? const Color(0xFF6C4CF1) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _filterRole != 'All Roles' ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                        ),
                        child: Icon(
                          LucideIcons.slidersHorizontal,
                          color: _filterRole != 'All Roles' ? Colors.white : const Color(0xFF6C4CF1),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Warden Cards List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: displayedWardens.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text('No wardens found', style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500)),
                        ),
                      )
                    : Column(
                        children: displayedWardens.map((warden) => _buildWardenCard(warden)).toList(),
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

  Widget _buildWardenCard(Map<String, dynamic> warden) {
    final status = (warden['status'] ?? 'On Duty').toString();
    Color statusBg = const Color(0xFFDCFCE7);
    Color statusTextColor = const Color(0xFF16A34A);
    if (status == 'Off Duty') {
      statusBg = const Color(0xFFEFF6FF);
      statusTextColor = const Color(0xFF2563EB);
    } else if (status == 'On Leave') {
      statusBg = const Color(0xFFFEF3C7);
      statusTextColor = const Color(0xFFD97706);
    }

    final isHead = warden['role'] == 'Head Warden';
    final roleBg = isHead ? const Color(0xFFF3F0FF) : const Color(0xFFEFF6FF);
    final roleColor = isHead ? const Color(0xFF6C4CF1) : const Color(0xFF2563EB);

    final gender = (warden['gender'] ?? 'Male').toString();
    final hostelType = gender == 'Female' ? 'Girls Hostel' : 'Boys Hostel';
    final hostelTypeBg = gender == 'Female' ? const Color(0xFFFDF2F8) : const Color(0xFFEFF6FF);
    final hostelTypeTextColor = gender == 'Female' ? const Color(0xFFDB2777) : const Color(0xFF2563EB);

    return GestureDetector(
      onTap: () {
        _showViewDetailsModal(warden);
      },
      child: Container(
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
          // Top Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _getColor(warden['bgColor']),
                child: Text(
                  '${warden['initials']}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _getColor(warden['color'])),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${warden['name']}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: roleBg, borderRadius: BorderRadius.circular(6)),
                          child: Text('${warden['role']}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: roleColor)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: hostelTypeBg, borderRadius: BorderRadius.circular(6)),
                          child: Text(hostelType, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: hostelTypeTextColor)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                          child: Text('${warden['status']}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusTextColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(LucideIcons.ellipsisVertical, size: 18, color: Color(0xFF64748B)),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                onSelected: (val) {
                  if (val == 'view') _showViewDetailsModal(warden);
                  if (val == 'edit') _showEditWardenModal(warden);
                  if (val == 'delete') _showDeleteConfirmationModal(warden);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(LucideIcons.eye, size: 16, color: Color(0xFF6C4CF1)),
                        SizedBox(width: 8),
                        Text('View Profile', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(LucideIcons.pencil, size: 16, color: Color(0xFF3B82F6)),
                        SizedBox(width: 8),
                        Text('Edit Warden', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(LucideIcons.trash2, size: 16, color: Color(0xFFE11D48)),
                        SizedBox(width: 8),
                        Text('Delete Warden', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFE11D48))),
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

          // Assigned Block & Code + Shift
          Row(
            children: [
              const Icon(LucideIcons.building, size: 15, color: Color(0xFF6C4CF1)),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1E1E2D)),
                    children: [
                      const TextSpan(text: 'Block: ', style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
                      TextSpan(text: '${warden['block']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (warden['blockCode'] != null && warden['blockCode'].toString().isNotEmpty)
                        TextSpan(text: ' (${warden['blockCode']})', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(LucideIcons.clock, size: 15, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text('Shift: ${warden['shift']}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Color(0xFF475569))),
            ],
          ),
          const SizedBox(height: 12),

          // Grid of Add Warden Fields: Phone, Email, Experience
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(LucideIcons.phone, size: 13, color: Color(0xFF10B981)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${warden['phone']}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(LucideIcons.award, size: 13, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Exp: ${warden['experience']}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(LucideIcons.mail, size: 13, color: Color(0xFF3B82F6)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${warden['email']}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void _showFilterBottomSheet() {
    String tempRole = _filterRole;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
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
                  const Text('Filter Wardens', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  TextButton(
                    onPressed: () => setModalState(() => tempRole = 'All Roles'),
                    child: const Text('Reset', style: TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('WARDEN ROLE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['All Roles', 'Head Warden', 'Assistant Warden', 'Night Warden'].map((role) {
                  final isSelected = tempRole == role;
                  return ChoiceChip(
                    label: Text(role),
                    selected: isSelected,
                    selectedColor: const Color(0xFFF3F0FF),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                    ),
                    onSelected: (selected) {
                      if (selected) setModalState(() => tempRole = role);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _filterRole = tempRole);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Apply Filter', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddWardenModal() {
    final nameCtrl = TextEditingController();
    final blockCtrl = TextEditingController();
    final blockCodeCtrl = TextEditingController();
    final expCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String selectedType = 'Boys';
    String selectedShift = 'Morning';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add New Warden', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          SizedBox(height: 4),
                          Text('Register a new hostel warden and assign them to a block.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 1. Full Name
                _buildInputField('Full Name', nameCtrl, 'e.g. Mr. R. Sharma'),
                const SizedBox(height: 16),

                // 2. Assigned Block & Block Code (2 Columns)
                Row(
                  children: [
                    Expanded(child: _buildInputField('Assigned Block', blockCtrl, 'e.g. Aryabhata Block')),
                    const SizedBox(width: 14),
                    Expanded(child: _buildInputField('Block Code', blockCodeCtrl, 'e.g. A')),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. Hostel Type & Shift (2 Columns)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Hostel Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedType,
                                isExpanded: true,
                                icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                                items: ['Boys', 'Girls', 'Co-ed'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                                onChanged: (val) {
                                  if (val != null) setModalState(() => selectedType = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Shift', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedShift,
                                isExpanded: true,
                                icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                                items: ['Morning', 'Evening', 'Night'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                onChanged: (val) {
                                  if (val != null) setModalState(() => selectedShift = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Experience (Years) & Phone Number (2 Columns)
                Row(
                  children: [
                    Expanded(child: _buildInputField('Experience (Years)', expCtrl, 'e.g. 5', isNum: true)),
                    const SizedBox(width: 14),
                    Expanded(child: _buildInputField('Phone Number', phoneCtrl, 'e.g. +91 98765 43210', isNum: true)),
                  ],
                ),
                const SizedBox(height: 16),

                // 5. Email Address
                _buildInputField('Email Address', emailCtrl, 'e.g. warden@school.edu'),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFF1F5F9), height: 1),
                const SizedBox(height: 16),

                // Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (nameCtrl.text.isNotEmpty || phoneCtrl.text.isNotEmpty) {
                          final name = nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : 'Mr. R. Sharma';
                          final code = blockCodeCtrl.text.trim().isNotEmpty ? blockCodeCtrl.text.trim().toUpperCase() : 'A';
                          final blockName = blockCtrl.text.trim().isNotEmpty ? blockCtrl.text.trim() : 'Aryabhata Block ($code)';
                          final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join('').toUpperCase();

                          setState(() {
                            _wardens.insert(0, {
                              'id': DateTime.now().millisecondsSinceEpoch.toString(),
                              'name': name,
                              'initials': initials.isNotEmpty ? initials : 'RS',
                              'role': 'Head Warden',
                              'block': blockName.contains('Block') ? blockName : '$blockName Block ($code)',
                              'blockCode': code,
                              'phone': phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : '+91 98765 43210',
                              'email': emailCtrl.text.trim().isNotEmpty ? emailCtrl.text.trim() : 'warden@school.edu',
                              'shift': '$selectedShift Shift',
                              'status': 'On Duty',
                              'experience': expCtrl.text.trim().isNotEmpty ? '${expCtrl.text.trim()} Years' : '5 Years',
                              'gender': selectedType == 'Girls' ? 'Female' : 'Male',
                              'assignedFloors': 'All Floors',
                              'emergencyContact': '+91 98765 00000',
                              'color': const Color(0xFF6C4CF1),
                              'bgColor': const Color(0xFFF3F0FF),
                            });
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text('Save Warden', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditWardenModal(Map<String, dynamic> warden) {
    final nameCtrl = TextEditingController(text: '${warden['name']}');
    final blockCtrl = TextEditingController(text: '${warden['block']}');
    final blockCodeCtrl = TextEditingController(text: '${warden['blockCode']}');
    final expCtrl = TextEditingController(text: '${warden['experience']}'.replaceAll(' Years', ''));
    final phoneCtrl = TextEditingController(text: '${warden['phone']}');
    final emailCtrl = TextEditingController(text: '${warden['email']}');
    String selectedType = warden['gender'] == 'Female' ? 'Girls' : 'Boys';
    String selectedShift = warden['shift'].toString().contains('Night')
        ? 'Night'
        : (warden['shift'].toString().contains('Evening') ? 'Evening' : 'Morning');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Edit Warden Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          SizedBox(height: 4),
                          Text('Update warden profile details and block assignment.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 1. Full Name
                _buildInputField('Full Name', nameCtrl, 'e.g. Mr. R. Sharma'),
                const SizedBox(height: 16),

                // 2. Assigned Block & Block Code (2 Columns)
                Row(
                  children: [
                    Expanded(child: _buildInputField('Assigned Block', blockCtrl, 'e.g. Aryabhata Block')),
                    const SizedBox(width: 14),
                    Expanded(child: _buildInputField('Block Code', blockCodeCtrl, 'e.g. A')),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. Hostel Type & Shift (2 Columns)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Hostel Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedType,
                                isExpanded: true,
                                icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                                items: ['Boys', 'Girls', 'Co-ed'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                                onChanged: (val) {
                                  if (val != null) setModalState(() => selectedType = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Shift', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedShift,
                                isExpanded: true,
                                icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                                items: ['Morning', 'Evening', 'Night'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                onChanged: (val) {
                                  if (val != null) setModalState(() => selectedShift = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Experience (Years) & Phone Number (2 Columns)
                Row(
                  children: [
                    Expanded(child: _buildInputField('Experience (Years)', expCtrl, 'e.g. 5', isNum: true)),
                    const SizedBox(width: 14),
                    Expanded(child: _buildInputField('Phone Number', phoneCtrl, 'e.g. +91 98765 43210', isNum: true)),
                  ],
                ),
                const SizedBox(height: 16),

                // 5. Email Address
                _buildInputField('Email Address', emailCtrl, 'e.g. warden@school.edu'),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFF1F5F9), height: 1),
                const SizedBox(height: 16),

                // Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          warden['name'] = nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : warden['name'];
                          warden['block'] = blockCtrl.text.trim().isNotEmpty ? blockCtrl.text.trim() : warden['block'];
                          warden['blockCode'] = blockCodeCtrl.text.trim().isNotEmpty ? blockCodeCtrl.text.trim() : warden['blockCode'];
                          warden['phone'] = phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : warden['phone'];
                          warden['email'] = emailCtrl.text.trim().isNotEmpty ? emailCtrl.text.trim() : warden['email'];
                          warden['shift'] = '$selectedShift Shift';
                          warden['experience'] = expCtrl.text.trim().isNotEmpty ? '${expCtrl.text.trim()} Years' : warden['experience'];
                          warden['gender'] = selectedType == 'Girls' ? 'Female' : 'Male';
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
    );
  }

  void _showViewDetailsModal(Map<String, dynamic> warden) {
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
                    const Text('Warden Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    IconButton(icon: const Icon(Icons.close, color: Color(0xFF6C4CF1), size: 20), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: _getColor(warden['bgColor'] as String),
                      child: Text('${warden['initials']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getColor(warden['color'] as String))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${warden['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 2),
                          Text('${warden['role']} • ${warden['status']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6C6C80))),
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
                    const Text('ASSIGNMENT & DUTY DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildDetailGridItem('HOSTEL BLOCK', '${warden['block']}')),
                        Expanded(child: _buildDetailGridItem('FLOORS IN-CHARGE', '${warden['assignedFloors']}')),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _buildDetailGridItem('SHIFT TIMING', '${warden['shift']}')),
                        Expanded(child: _buildDetailGridItem('EXPERIENCE', '${warden['experience']}')),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text('CONTACT & EMERGENCY DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildDetailGridItem('PHONE NUMBER', '${warden['phone']}')),
                        Expanded(child: _buildDetailGridItem('EMAIL ADDRESS', '${warden['email']}')),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _buildDetailGridItem('EMERGENCY CONTACT', '${warden['emergencyContact']}')),
                        Expanded(child: _buildDetailGridItem('GENDER', '${warden['gender']}')),
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

  void _showDeleteConfirmationModal(Map<String, dynamic> warden) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFFFFE4E6), shape: BoxShape.circle),
              child: const Icon(LucideIcons.trash2, color: Color(0xFFE11D48), size: 28),
            ),
            const SizedBox(height: 16),
            Text('Remove ${warden['name']}?', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            const SizedBox(height: 8),
            const Text('Are you sure you want to remove this warden from the system?', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _wardens.removeWhere((w) => w['id'] == warden['id']));
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE11D48), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                    child: const Text('Remove Warden', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController ctrl, String hint, {bool isNum = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailGridItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
      ],
    );
  }
}
