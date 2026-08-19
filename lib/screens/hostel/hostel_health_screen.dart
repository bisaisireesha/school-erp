import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class HostelHealthScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const HostelHealthScreen({super.key, this.onBack});

  @override
  State<HostelHealthScreen> createState() => _HostelHealthScreenState();
}

class _HostelHealthScreenState extends State<HostelHealthScreen> {
  String _filterStatus = 'All';
  String _searchQuery = '';

  List<Map<String, dynamic>> _healthRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    MainLayout.globalSearchQuery.addListener(_onGlobalSearchChanged);
    _searchQuery = MainLayout.globalSearchQuery.value;
    _loadHealthRecords();
  }

  Future<void> _loadHealthRecords() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/hostel_health.json');
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _healthRecords = List<Map<String, dynamic>>.from(data);
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
    
    int totalCasesToday = _healthRecords.length;
    int severe = _healthRecords.where((r) => r['severity'] == 'High').length;
    int onMedication = _healthRecords.where((r) => r['status'] == 'On Medication').length;
    int recoveredWeek = _healthRecords.where((r) => r['status'] == 'Recovered').length;

    final displayed = _healthRecords.where((item) {
      final name = (item['studentName'] as String).toLowerCase();
      final roll = (item['rollNo'] as String).toLowerCase();
      final issue = (item['issue'] as String).toLowerCase();
      final status = item['status'] as String;
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery = query.isEmpty || name.contains(query) || roll.contains(query) || issue.contains(query);
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
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5)),
                          child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    const Expanded(child: Text('Health & Medical', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))),
                    GestureDetector(
                      onTap: _showExportModal,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: const Icon(LucideIcons.download, size: 18, color: Color(0xFF6C4CF1)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddHealthRecordModal,
                      icon: const Icon(LucideIcons.filePlus, size: 16, color: Colors.white),
                      label: const Text('Log Record', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C4CF1), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // KPI Cards 2x2
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(child: _buildKpiCard('Total Cases Today', '$totalCasesToday', LucideIcons.stethoscope, const Color(0xFF3B82F6), const Color(0xFFEFF6FF))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildKpiCard('Severe / Emergencies', '$severe', LucideIcons.triangleAlert, const Color(0xFFE11D48), const Color(0xFFFEE2E2))),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: _buildKpiCard('On Medication', '$onMedication', LucideIcons.pill, const Color(0xFFF97316), const Color(0xFFFFF7ED))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildKpiCard('Recovered (Week)', '$recoveredWeek', LucideIcons.checkCircle2, const Color(0xFF10B981), const Color(0xFFF0FDF4))),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search + Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'Search student, issue, roll no...', hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                          prefixIcon: const Icon(LucideIcons.search, color: Color(0xFF6C4CF1), size: 18), filled: true, fillColor: Colors.white,
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
                          color: _filterStatus != 'All' ? const Color(0xFFF3F0FF) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _filterStatus != 'All' ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                        ),
                        child: Stack(clipBehavior: Clip.none, children: [
                          Icon(LucideIcons.slidersHorizontal, size: 20, color: _filterStatus != 'All' ? const Color(0xFF6C4CF1) : const Color(0xFF64748B)),
                          if (_filterStatus != 'All') Positioned(top: -4, right: -4, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF6C4CF1), shape: BoxShape.circle))),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              if (_filterStatus != 'All')
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(LucideIcons.filter, size: 12, color: Color(0xFF6C4CF1)),
                      const SizedBox(width: 6),
                      Text(_filterStatus, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                      const SizedBox(width: 6),
                      GestureDetector(onTap: () => setState(() => _filterStatus = 'All'), child: const Icon(LucideIcons.x, size: 14, color: Color(0xFF6C4CF1))),
                    ]),
                  ),
                ),
              const SizedBox(height: 16),

              // Health Records Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: displayed.isEmpty
                    ? Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Text('No health records found', style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500))))
                    : Column(children: displayed.map((r) => _buildHealthCard(r)).toList()),
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

  Widget _buildHealthCard(Map<String, dynamic> record) {
    final status = record['status'] as String;
    final severity = record['severity'] as String;
    Color statusBg, statusColor;
    Color sevBg, sevColor;

    switch (status) {
      case 'On Medication': statusBg = const Color(0xFFFFF7ED); statusColor = const Color(0xFFD97706); break;
      case 'Under Observation': statusBg = const Color(0xFFEFF6FF); statusColor = const Color(0xFF3B82F6); break;
      case 'Referred to Hospital': statusBg = const Color(0xFFFEE2E2); statusColor = const Color(0xFFE11D48); break;
      case 'Recovered': statusBg = const Color(0xFFDCFCE7); statusColor = const Color(0xFF16A34A); break;
      default: statusBg = const Color(0xFFF1F5F9); statusColor = const Color(0xFF64748B);
    }
    switch (severity) {
      case 'High': sevBg = const Color(0xFFFEE2E2); sevColor = const Color(0xFFE11D48); break;
      case 'Moderate': sevBg = const Color(0xFFFEF3C7); sevColor = const Color(0xFFD97706); break;
      case 'Low': sevBg = const Color(0xFFDCFCE7); sevColor = const Color(0xFF16A34A); break;
      default: sevBg = const Color(0xFFF1F5F9); sevColor = const Color(0xFF64748B);
    }

    return GestureDetector(
      onTap: () {
        _showDetailsModal(record);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0)), boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(radius: 22, backgroundColor: const Color(0xFFF3F0FF), child: Text(record['initials'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(record['studentName'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            const SizedBox(height: 4),
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)), child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor))),
              const SizedBox(width: 6),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: sevBg, borderRadius: BorderRadius.circular(6)), child: Text(severity, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: sevColor))),
            ]),
          ])),
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.ellipsisVertical, size: 18, color: Color(0xFF64748B)), color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onSelected: (val) {
              if (val == 'view') _showDetailsModal(record);
              if (val == 'edit') _showEditModal(record);
              if (val == 'recover') setState(() => record['status'] = 'Recovered');
              if (val == 'admit') setState(() => record['status'] = 'Under Observation');
              if (val == 'refer') setState(() => record['status'] = 'Referred to Hospital');
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'view', child: Text('View Details', style: TextStyle(fontSize: 14, color: Color(0xFF1E1E2D)))),
              const PopupMenuItem(value: 'edit', child: Text('Edit Record', style: TextStyle(fontSize: 14, color: Color(0xFF3B2A82)))),
              if (status != 'Recovered') const PopupMenuItem(value: 'recover', child: Text('Mark Recovered', style: TextStyle(fontSize: 14, color: Color(0xFF1E1E2D)))),
              const PopupMenuItem(value: 'admit', child: Text('Admit to Infirmary', style: TextStyle(fontSize: 14, color: Color(0xFF1E1E2D)))),
              const PopupMenuItem(value: 'refer', child: Text('Refer to Hospital', style: TextStyle(fontSize: 14, color: Color(0xFFE11D48)))),
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
            _buildInfoItem(LucideIcons.heartPulse, 'Complaint', record['issue'] as String, const Color(0xFFE11D48)),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _buildInfoItem(LucideIcons.hash, 'Roll No.', record['rollNo'] as String, const Color(0xFF8B5CF6))),
              Expanded(child: _buildInfoItem(LucideIcons.user, 'Gender', record['gender'] as String, const Color(0xFF3B82F6))),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _buildInfoItem(LucideIcons.calendar, 'Age', record['age'] as String, const Color(0xFF10B981))),
              Expanded(child: _buildInfoItem(LucideIcons.clock, 'Date', record['reportedDate'] as String, const Color(0xFF6C4CF1))),
            ]),
            const SizedBox(height: 10),
            _buildInfoItem(LucideIcons.pill, 'Treatment', record['medication'] as String, const Color(0xFFF59E0B)),
          ]),
        ),
      ]),
    ));
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
    final filters = [
      {'label': 'All Cases', 'value': 'All', 'icon': LucideIcons.heartPulse, 'color': const Color(0xFF6C4CF1)},
      {'label': 'On Medication', 'value': 'On Medication', 'icon': LucideIcons.pill, 'color': const Color(0xFFF97316)},
      {'label': 'Under Observation', 'value': 'Under Observation', 'icon': LucideIcons.stethoscope, 'color': const Color(0xFF3B82F6)},
      {'label': 'Referred to Hospital', 'value': 'Referred to Hospital', 'icon': LucideIcons.ambulance, 'color': const Color(0xFFE11D48)},
      {'label': 'Recovered', 'value': 'Recovered', 'icon': LucideIcons.circleCheckBig, 'color': const Color(0xFF10B981)},
    ];
    showModalBottomSheet(context: context, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (context) {
      return Container(padding: const EdgeInsets.fromLTRB(24, 20, 24, 24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Expanded(child: Text('Filter Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))), GestureDetector(onTap: () => Navigator.pop(context), child: const Padding(padding: EdgeInsets.all(4), child: Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20)))]),
        const SizedBox(height: 6), const Text('Select a status to filter', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))), const SizedBox(height: 18),
        ...filters.map((f) {
          final isActive = _filterStatus == f['value'];
          return GestureDetector(onTap: () { setState(() => _filterStatus = f['value'] as String); Navigator.pop(context); }, child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), decoration: BoxDecoration(color: isActive ? const Color(0xFFF3F0FF) : Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0))), child: Row(children: [Icon(f['icon'] as IconData, size: 18, color: _getColor(f['color'] as String)), const SizedBox(width: 12), Expanded(child: Text(f['label'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D)))), if (isActive) const Icon(LucideIcons.check, size: 18, color: Color(0xFF6C4CF1))])));
        }),
      ]));
    });
  }

  void _showEditModal(Map<String, dynamic> record) {
    final studentCtrl = TextEditingController(text: record['studentName'] as String);
    final rollCtrl = TextEditingController(text: record['rollNo'] as String);
    final ageCtrl = TextEditingController(text: record['age'] as String);
    final complaintCtrl = TextEditingController(text: record['issue'] as String);
    final treatmentCtrl = TextEditingController(text: record['medication'] as String);
    String gender = record['gender'] as String;
    String status = record['status'] as String;

    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (context) => StatefulBuilder(builder: (context, setModalState) => Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 24, right: 24, top: 20),
      child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Edit Medical Record', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), SizedBox(height: 4), Text('Update the details of the medical issue.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))])),
          GestureDetector(onTap: () => Navigator.pop(context), child: const Padding(padding: EdgeInsets.all(4), child: Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20))),
        ]),
        const SizedBox(height: 24),
        Row(children: [Expanded(child: _buildField('Student Name', studentCtrl, '')), const SizedBox(width: 14), Expanded(child: _buildField('Student Roll No.', rollCtrl, ''))]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Gender', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: ['Male', 'Female', 'Other'].contains(gender) ? gender : 'Male', isExpanded: true, icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)), items: ['Male', 'Female', 'Other'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (val) { if (val != null) setModalState(() => gender = val); }))),
          ])),
          const SizedBox(width: 14), 
          Expanded(child: _buildField('Age', ageCtrl, ''))
        ]),
        const SizedBox(height: 16),
        _buildField('Complaint', complaintCtrl, ''),
        const SizedBox(height: 16),
        _buildField('Treatment', treatmentCtrl, ''),
        const SizedBox(height: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 6),
          Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: ['On Medication', 'Under Observation', 'Referred to Hospital', 'Recovered'].contains(status) ? status : 'On Medication', isExpanded: true, icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)), items: ['On Medication', 'Under Observation', 'Referred to Hospital', 'Recovered'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (val) { if (val != null) setModalState(() => status = val); }))),
        ]),
        const SizedBox(height: 24), const Divider(color: Color(0xFFF1F5F9), height: 1), const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0)), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: () {
            final name = studentCtrl.text.trim().isNotEmpty ? studentCtrl.text.trim() : 'Student';
            final initials = name.split(' ').where((w) => w.isNotEmpty).map((e) => e[0]).take(2).join('').toUpperCase();
            setState(() { 
              record['studentName'] = name;
              record['rollNo'] = rollCtrl.text.trim().isNotEmpty ? rollCtrl.text.trim() : 'N/A';
              record['age'] = ageCtrl.text.trim();
              record['gender'] = gender;
              record['issue'] = complaintCtrl.text.trim().isNotEmpty ? complaintCtrl.text.trim() : 'General Checkup';
              record['medication'] = treatmentCtrl.text.trim().isNotEmpty ? treatmentCtrl.text.trim() : 'N/A';
              record['status'] = status;
              record['initials'] = initials.isNotEmpty ? initials : 'S';
            });
            Navigator.pop(context);
          }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C4CF1), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0), child: const Text('Save Changes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
        ]),
      ])),
    )));
  }

  void _showAddHealthRecordModal() {
    final studentCtrl = TextEditingController();
    final rollCtrl = TextEditingController();
    final ageCtrl = TextEditingController(text: '15');
    final complaintCtrl = TextEditingController();
    final treatmentCtrl = TextEditingController();
    String gender = 'Male';
    String status = 'On Medication';

    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (context) => StatefulBuilder(builder: (context, setModalState) => Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 24, right: 24, top: 20),
      child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Log Medical Record', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), SizedBox(height: 4), Text('Record a new infirmary visit or medical issue.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))])),
          GestureDetector(onTap: () => Navigator.pop(context), child: const Padding(padding: EdgeInsets.all(4), child: Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20))),
        ]),
        const SizedBox(height: 24),
        Row(children: [Expanded(child: _buildField('Student Name', studentCtrl, '')), const SizedBox(width: 14), Expanded(child: _buildField('Student Roll No.', rollCtrl, ''))]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Gender', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: gender, isExpanded: true, icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)), items: ['Male', 'Female', 'Other'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (val) { if (val != null) setModalState(() => gender = val); }))),
          ])),
          const SizedBox(width: 14), 
          Expanded(child: _buildField('Age', ageCtrl, ''))
        ]),
        const SizedBox(height: 16),
        _buildField('Complaint', complaintCtrl, ''),
        const SizedBox(height: 16),
        _buildField('Treatment', treatmentCtrl, ''),
        const SizedBox(height: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 6),
          Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: status, isExpanded: true, icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)), items: ['On Medication', 'Under Observation', 'Referred to Hospital', 'Recovered'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (val) { if (val != null) setModalState(() => status = val); }))),
        ]),
        const SizedBox(height: 24), const Divider(color: Color(0xFFF1F5F9), height: 1), const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0)), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: () {
            final name = studentCtrl.text.trim().isNotEmpty ? studentCtrl.text.trim() : 'Student';
            final initials = name.split(' ').where((w) => w.isNotEmpty).map((e) => e[0]).take(2).join('').toUpperCase();
            setState(() { _healthRecords.insert(0, { 'id': DateTime.now().millisecondsSinceEpoch.toString(), 'studentName': name, 'rollNo': rollCtrl.text.trim().isNotEmpty ? rollCtrl.text.trim() : 'N/A', 'roomNo': 'N/A', 'block': 'N/A', 'issue': complaintCtrl.text.trim().isNotEmpty ? complaintCtrl.text.trim() : 'General Checkup', 'severity': 'Low', 'reportedDate': '03 Aug 2026', 'reportedTime': '${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}', 'status': status, 'medication': treatmentCtrl.text.trim().isNotEmpty ? treatmentCtrl.text.trim() : 'N/A', 'doctor': 'N/A', 'notes': '', 'initials': initials.isNotEmpty ? initials : 'S' }); });
            Navigator.pop(context);
          }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C4CF1), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0), child: const Text('Save Record', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
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

  void _showDetailsModal(Map<String, dynamic> record) {
    showModalBottomSheet(context: context, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (context) => Container(
      padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 22, backgroundColor: const Color(0xFFF3F0FF), child: Text(record['initials'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(record['studentName'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))), const SizedBox(height: 2), Text('Status: ${record['status']}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)))])),
          IconButton(icon: const Icon(LucideIcons.x, color: Color(0xFF64748B), size: 20), onPressed: () => Navigator.pop(context)),
        ]),
        const SizedBox(height: 16), const Divider(color: Color(0xFFF1F5F9), height: 1), const SizedBox(height: 16),
        _buildDetailRow('Roll No.', record['rollNo'] as String),
        _buildDetailRow('Gender', record['gender'] as String),
        _buildDetailRow('Age', record['age'] as String),
        _buildDetailRow('Complaint', record['issue'] as String),
        _buildDetailRow('Treatment', record['medication'] as String),
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
