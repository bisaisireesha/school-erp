import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class HostelMaintenanceScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const HostelMaintenanceScreen({super.key, this.onBack});

  @override
  State<HostelMaintenanceScreen> createState() => _HostelMaintenanceScreenState();
}

class _HostelMaintenanceScreenState extends State<HostelMaintenanceScreen> {
  String _selectedBlock = 'All Blocks';
  String _selectedCategory = 'All Categories';
  String _selectedStatus = 'All Status';
  String _searchQuery = '';

  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    MainLayout.globalSearchQuery.addListener(_onGlobalSearchChanged);
    _searchQuery = MainLayout.globalSearchQuery.value;
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/hostel_maintenance.json');
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _requests = List<Map<String, dynamic>>.from(data);
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
  
  bool get _isFiltered => _selectedBlock != 'All Blocks' || _selectedCategory != 'All Categories' || _selectedStatus != 'All Status';

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
      );
    }
    
    int total = _requests.length;
    int pending = _requests.where((r) => r['status'] == 'Pending').length;
    int inProgress = _requests.where((r) => r['status'] == 'In Progress').length;
    int resolved = _requests.where((r) => r['status'] == 'Resolved').length;

    final displayed = _requests.where((item) {
      final title = (item['title'] as String).toLowerCase();
      final room = (item['roomNo'] as String).toLowerCase();
      final cat = (item['category'] as String).toLowerCase();
      final status = item['status'] as String;
      final blockStr = item['block'] as String;
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery = query.isEmpty || title.contains(query) || room.contains(query) || cat.contains(query);
      bool matchesStatus = _selectedStatus == 'All Status' || status == _selectedStatus;
      bool matchesBlock = _selectedBlock == 'All Blocks' || blockStr.contains(_selectedBlock.split(' ').last);
      bool matchesCategory = _selectedCategory == 'All Categories' || (item['category'] as String) == _selectedCategory;
      return matchesQuery && matchesStatus && matchesBlock && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
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
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5)),
                          child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    const Expanded(child: Text('Maintenance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))),
                    GestureDetector(
                      onTap: _showExportModal,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: const Icon(LucideIcons.download, size: 18, color: Color(0xFF6C4CF1)),
                      ),
                    ),

                    ElevatedButton.icon(
                      onPressed: _showAddRequestModal,
                      icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                      label: const Text('New Request', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C4CF1), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // KPI Cards 2x2
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(children: [
                  Row(children: [
                    Expanded(child: _buildKpiCard('Total Requests', '$total', LucideIcons.wrench, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildKpiCard('Pending', '$pending', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFEF3C7))),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _buildKpiCard('In Progress', '$inProgress', LucideIcons.hammer, const Color(0xFF3B82F6), const Color(0xFFEFF6FF))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildKpiCard('Resolved', '$resolved', LucideIcons.circleCheckBig, const Color(0xFF10B981), const Color(0xFFF0FDF4))),
                  ]),
                ]),
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
                          hintText: 'Search requests...',
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
                      onTap: _showFilterSheet,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isFiltered ? const Color(0xFF6C4CF1) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _isFiltered ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                        ),
                        child: Stack(clipBehavior: Clip.none, children: [
                          Icon(
                            LucideIcons.slidersHorizontal,
                            color: _isFiltered ? Colors.white : const Color(0xFF6C4CF1),
                            size: 20,
                          ),
                          if (_isFiltered) Positioned(top: -4, right: -4, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF6C4CF1), width: 1.5)))),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Maintenance Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: displayed.isEmpty
                    ? Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Text('No maintenance requests found', style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500))))
                    : Column(children: displayed.map((r) => _buildRequestCard(r)).toList()),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String count, IconData icon, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0)), boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: textColor, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80)), maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
      ]),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> req) {
    final status = req['status'] as String;
    final priority = req['priority'] as String;
    Color statusBg, statusColor, priBg, priColor;

    switch (status) {
      case 'Pending': statusBg = const Color(0xFFFEF3C7); statusColor = const Color(0xFFD97706); break;
      case 'In Progress': statusBg = const Color(0xFFEFF6FF); statusColor = const Color(0xFF2563EB); break;
      case 'Resolved': statusBg = const Color(0xFFDCFCE7); statusColor = const Color(0xFF16A34A); break;
      default: statusBg = const Color(0xFFF1F5F9); statusColor = const Color(0xFF64748B);
    }
    switch (priority) {
      case 'High': priBg = const Color(0xFFFEE2E2); priColor = const Color(0xFFE11D48); break;
      case 'Medium': priBg = const Color(0xFFFEF3C7); priColor = const Color(0xFFD97706); break;
      case 'Low': priBg = const Color(0xFFDCFCE7); priColor = const Color(0xFF16A34A); break;
      default: priBg = const Color(0xFFF1F5F9); priColor = const Color(0xFF64748B);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0)), boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(radius: 22, backgroundColor: const Color(0xFFF3F0FF), child: Text(req['initials'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(req['title'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)), child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor))),
              const SizedBox(width: 6),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: priBg, borderRadius: BorderRadius.circular(6)), child: Text(priority, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: priColor))),
            ]),
          ])),
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.ellipsisVertical, size: 18, color: Color(0xFF64748B)), color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onSelected: (val) {
              if (val == 'view') _showDetailsModal(req);
              if (val == 'edit') _showEditRequestModal(req);
              if (val == 'progress') setState(() => req['status'] = 'In Progress');
              if (val == 'resolve') setState(() => req['status'] = 'Resolved');
              if (val == 'delete') setState(() => _requests.removeWhere((r) => r['id'] == req['id']));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'view', child: Row(children: [Icon(LucideIcons.eye, size: 16, color: Color(0xFF6C4CF1)), SizedBox(width: 8), Text('View Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))])),
              const PopupMenuItem(value: 'edit', child: Row(children: [Icon(LucideIcons.edit3, size: 16, color: Color(0xFF6C4CF1)), SizedBox(width: 8), Text('Edit Record', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6C4CF1)))])),
              if (status == 'Pending') const PopupMenuItem(value: 'progress', child: Row(children: [Icon(LucideIcons.hammer, size: 16, color: Color(0xFF3B82F6)), SizedBox(width: 8), Text('Mark In Progress', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))])),
              if (status != 'Resolved') const PopupMenuItem(value: 'resolve', child: Row(children: [Icon(LucideIcons.circleCheckBig, size: 16, color: Color(0xFF10B981)), SizedBox(width: 8), Text('Mark Resolved', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))])),
              const PopupMenuItem(value: 'delete', child: Row(children: [Icon(LucideIcons.trash2, size: 16, color: Color(0xFFE11D48)), SizedBox(width: 8), Text('Delete', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFE11D48)))])),
            ],
          ),
        ]),
        const SizedBox(height: 14),
        const Divider(color: Color(0xFFF1F5F9), height: 1),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF1F5F9))),
          child: Column(children: [
            _buildInfoItem(LucideIcons.tag, 'Category', req['category'] as String, const Color(0xFF6C4CF1)),
            const SizedBox(height: 10),
            _buildInfoItem(LucideIcons.alignLeft, 'Description', req['description'] as String, const Color(0xFF64748B)),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _buildInfoItem(LucideIcons.building, 'Location', '${req['roomNo']} (${req['block']})', const Color(0xFF3B82F6))),
              Expanded(child: _buildInfoItem(LucideIcons.calendar, 'Reported', req['reportedDate'] as String, const Color(0xFF8B5CF6))),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _buildInfoItem(LucideIcons.user, 'Reported By', req['reportedBy'] as String, const Color(0xFF10B981))),
              Expanded(child: _buildInfoItem(LucideIcons.hardHat, 'Assigned To', req['assignedTo'] as String, const Color(0xFFF59E0B))),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color iconColor) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 14, color: iconColor), const SizedBox(width: 6),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8))),
        const SizedBox(height: 1),
        Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF334155)), overflow: TextOverflow.ellipsis, maxLines: 2),
      ])),
    ]);
  }

  void _showFilterSheet() {
    showModalBottomSheet(context: context, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(padding: const EdgeInsets.fromLTRB(24, 20, 24, 24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Expanded(child: Text('Filter Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))), GestureDetector(onTap: () => Navigator.pop(context), child: const Padding(padding: EdgeInsets.all(4), child: Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20)))]),
            const SizedBox(height: 24),
            _buildSheetDropdown('Block', _selectedBlock, ['All Blocks', 'Block A', 'Block B', 'Block C'], (val) { if (val != null) { setModalState(() => _selectedBlock = val); setState(() {}); } }),
            const SizedBox(height: 16),
            _buildSheetDropdown('Category', _selectedCategory, ['All Categories', 'Electrical', 'Plumbing', 'Carpentry', 'Cleaning', 'Other'], (val) { if (val != null) { setModalState(() => _selectedCategory = val); setState(() {}); } }),
            const SizedBox(height: 16),
            _buildSheetDropdown('Status', _selectedStatus, ['All Status', 'Pending', 'In Progress', 'Resolved'], (val) { if (val != null) { setModalState(() => _selectedStatus = val); setState(() {}); } }),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () { setState(() { _selectedBlock = 'All Blocks'; _selectedCategory = 'All Categories'; _selectedStatus = 'All Status'; }); Navigator.pop(context); }, style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0)), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Reset', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))))),
              const SizedBox(width: 14),
              Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C4CF1), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0), child: const Text('Apply', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)))),
            ]),
          ]));
        }
      );
    });
  }

  Widget _buildSheetDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 6),
      Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true, icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)), items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: onChanged))),
    ]);
  }

  void _showEditRequestModal(Map<String, dynamic> req) {
    final roomCtrl = TextEditingController(text: req['roomNo'] as String);
    final reportedByCtrl = TextEditingController(text: req['reportedBy'] as String);
    final descCtrl = TextEditingController(text: req['description'] as String);
    String block = req['block'] as String;
    String category = req['category'] as String;

    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (context) => StatefulBuilder(builder: (context, setModalState) => Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 24, right: 24, top: 20),
      child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Edit Maintenance Request', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), SizedBox(height: 4), Text('Update the details of the maintenance issue.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))])),
          GestureDetector(onTap: () => Navigator.pop(context), child: const Padding(padding: EdgeInsets.all(4), child: Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20))),
        ]),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Block', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: ['Block A', 'Block B', 'Block C'].contains(block) ? block : 'Block A', isExpanded: true, icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)), items: ['Block A', 'Block B', 'Block C'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (val) { if (val != null) setModalState(() => block = val); }))),
          ])),
          const SizedBox(width: 14),
          Expanded(child: _buildField('Room Number', roomCtrl, ''))
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: ['Plumbing', 'Electrical', 'Carpentry', 'Cleaning', 'Other'].contains(category) ? category : 'Plumbing', isExpanded: true, icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)), items: ['Plumbing', 'Electrical', 'Carpentry', 'Cleaning', 'Other'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (val) { if (val != null) setModalState(() => category = val); }))),
          ])),
          const SizedBox(width: 14),
          Expanded(child: _buildField('Reported By', reportedByCtrl, ''))
        ]),
        const SizedBox(height: 16),
        _buildField('Issue Description', descCtrl, ''),
        const SizedBox(height: 24), const Divider(color: Color(0xFFF1F5F9), height: 1), const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0)), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: () {
            final title = '$category Issue in ${roomCtrl.text.trim().isNotEmpty ? roomCtrl.text.trim() : 'Room'}';
            final initials = category.substring(0, 2).toUpperCase();
            setState(() { 
              req['title'] = title;
              req['category'] = category;
              req['description'] = descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : 'No description';
              req['roomNo'] = roomCtrl.text.trim().isNotEmpty ? roomCtrl.text.trim() : 'N/A';
              req['block'] = block;
              req['reportedBy'] = reportedByCtrl.text.trim().isNotEmpty ? reportedByCtrl.text.trim() : 'Staff';
              req['initials'] = initials;
            });
            Navigator.pop(context);
          }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C4CF1), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0), child: const Text('Save Changes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
        ]),
      ])),
    )));
  }

  void _showAddRequestModal() {
    final roomCtrl = TextEditingController();
    final reportedByCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String block = 'Block A';
    String category = 'Plumbing';

    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (context) => StatefulBuilder(builder: (context, setModalState) => Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 24, right: 24, top: 20),
      child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Log Maintenance Request', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), SizedBox(height: 4), Text('Report a new maintenance issue in the hostel.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))])),
          GestureDetector(onTap: () => Navigator.pop(context), child: const Padding(padding: EdgeInsets.all(4), child: Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20))),
        ]),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Block', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: block, isExpanded: true, icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)), items: ['Block A', 'Block B', 'Block C'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (val) { if (val != null) setModalState(() => block = val); }))),
          ])),
          const SizedBox(width: 14),
          Expanded(child: _buildField('Room Number', roomCtrl, ''))
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: category, isExpanded: true, icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)), items: ['Plumbing', 'Electrical', 'Carpentry', 'Cleaning', 'Other'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (val) { if (val != null) setModalState(() => category = val); }))),
          ])),
          const SizedBox(width: 14),
          Expanded(child: _buildField('Reported By', reportedByCtrl, ''))
        ]),
        const SizedBox(height: 16),
        _buildField('Issue Description', descCtrl, ''),
        const SizedBox(height: 24), const Divider(color: Color(0xFFF1F5F9), height: 1), const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0)), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: () {
            final title = '$category Issue in ${roomCtrl.text.trim().isNotEmpty ? roomCtrl.text.trim() : 'Room'}';
            final initials = category.substring(0, 2).toUpperCase();
            setState(() { _requests.insert(0, { 'id': DateTime.now().millisecondsSinceEpoch.toString(), 'title': title, 'category': category, 'description': descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : 'No description', 'roomNo': roomCtrl.text.trim().isNotEmpty ? roomCtrl.text.trim() : 'N/A', 'block': block, 'reportedBy': reportedByCtrl.text.trim().isNotEmpty ? reportedByCtrl.text.trim() : 'Staff', 'rollNo': 'N/A', 'reportedDate': '03 Aug 2026', 'priority': 'Medium', 'status': 'Pending', 'assignedTo': 'Unassigned', 'initials': initials }); });
            Navigator.pop(context);
          }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C4CF1), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0), child: const Text('Save Request', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
        ]),
      ])),
    )));
  }

  Widget _buildField(String label, TextEditingController controller, String hint) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 6),
      TextField(controller: controller, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)), decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)))),
    ]);
  }

  void _showDetailsModal(Map<String, dynamic> req) {
    showModalBottomSheet(context: context, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (context) => Container(
      padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 22, backgroundColor: const Color(0xFFF3F0FF), child: Text(req['initials'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(req['title'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 2), Text('Status: ${req['status']}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)))])),
          IconButton(icon: const Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20), onPressed: () => Navigator.pop(context)),
        ]),
        const SizedBox(height: 16), const Divider(color: Color(0xFFF1F5F9), height: 1), const SizedBox(height: 16),
        _buildDetailRow('Block', req['block'] as String),
        _buildDetailRow('Room Number', req['roomNo'] as String),
        _buildDetailRow('Category', req['category'] as String),
        _buildDetailRow('Reported By', req['reportedBy'] as String),
        _buildDetailRow('Issue Description', req['description'] as String),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C4CF1), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0), child: const Text('Close', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
      ]),
    ));
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))), const SizedBox(width: 12),
      Flexible(child: Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), textAlign: TextAlign.end)),
    ]));
  }

  void _showExportModal() {
    showModalBottomSheet(context: context, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (context) {
      return Container(padding: const EdgeInsets.fromLTRB(24, 20, 24, 24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Expanded(child: Text('Export Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))), GestureDetector(onTap: () => Navigator.pop(context), child: const Padding(padding: EdgeInsets.all(4), child: Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20)))]),
        const SizedBox(height: 6), const Text('Choose the format to export your records.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))), const SizedBox(height: 20),
        _buildExportOption('PDF Document', '.pdf', LucideIcons.fileText, const Color(0xFFE11D48), const Color(0xFFFEE2E2)),
        const SizedBox(height: 12),
        _buildExportOption('Excel Spreadsheet', '.xlsx', LucideIcons.table2, const Color(0xFF16A34A), const Color(0xFFDCFCE7)),
        const SizedBox(height: 12),
        _buildExportOption('CSV File', '.csv', LucideIcons.fileSpreadsheet, const Color(0xFF2563EB), const Color(0xFFEFF6FF)),
      ]));
    });
  }

  Widget _buildExportOption(String title, String format, IconData icon, Color iconColor, Color bgColor) {
    return GestureDetector(
      onTap: () {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        Navigator.pop(context);
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('Exporting as $format...'), behavior: SnackBarBehavior.floating, backgroundColor: const Color(0xFF1E1E2D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), margin: const EdgeInsets.all(16)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 20, color: iconColor)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            Text('Export to $format format', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ])),
          const Icon(LucideIcons.chevronRight, size: 18, color: Color(0xFF94A3B8)),
        ]),
      ),
    );
  }
}
