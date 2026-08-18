import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TransportStudentAssignmentsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const TransportStudentAssignmentsScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  State<TransportStudentAssignmentsScreen> createState() =>
      _TransportStudentAssignmentsScreenState();
}

class _TransportStudentAssignmentsScreenState
    extends State<TransportStudentAssignmentsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAssignStudentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return _AssignStudentBottomSheet(
          onSave: (newAssignment) {
            setState(() {
              final list = widget.data['studentAssignments'] as List?;
              if (list != null) {
                list.add(newAssignment);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${newAssignment['name']} assigned to ${newAssignment['route']}'),
                backgroundColor: const Color(0xFF6C4CF1),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
        );
      },
    );
  }

  void _showStudentProfileBottomSheet(BuildContext context, Map<String, dynamic> s) {
    final String name = s['name'] as String? ?? 'Student';
    final String grade = s['grade'] as String? ?? '10-A';
    final String route = s['route'] as String? ?? 'Route 1';
    final String stop = s['stop'] as String? ?? 'Main Stop';
    final String busNo = s['busNo'] as String? ?? 'BUS-01';
    final String pickTime = s['pickTime'] as String? ?? '07:25 AM';
    final String feeStatus = s['feeStatus'] as String? ?? 'Paid';
    final String startDate = s['startDate'] as String? ?? '01 Jul 2026';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0DDF0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header Profile Card
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFFF3EEFF),
                        child: const Icon(LucideIcons.userCheck, color: Color(0xFF6C4CF1), size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E2D),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6C4CF1).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Grade $grade',
                                    style: const TextStyle(
                                      color: Color(0xFF6C4CF1),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Assigned to $route • $busNo',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF6E6E8D),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Detailed Assignment Specifications Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(LucideIcons.mapPin, 'Assigned Route', route),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDetailRow(LucideIcons.navigation, 'Pickup Stop', stop),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDetailRow(LucideIcons.bus, 'Assigned Vehicle', busNo),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDetailRow(LucideIcons.clock, 'Morning Pickup Time', pickTime),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDetailRow(LucideIcons.calendar, 'Assignment Start Date', startDate),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDetailRow(LucideIcons.wallet, 'Transport Fee Status', feeStatus, isStatus: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(LucideIcons.phone, size: 16, color: Color(0xFF6C4CF1)),
                            label: const Text('Call Parent', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF6C4CF1), width: 1.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(LucideIcons.check, size: 16, color: Colors.white),
                            label: const Text('Close Profile', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4CF1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6C4CF1)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 13.0, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          if (isStatus) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
              decoration: BoxDecoration(
                color: value == 'Paid' ? const Color(0xFF10B981).withValues(alpha: 0.12) : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: value == 'Paid' ? const Color(0xFF10B981) : const Color(0xFFD97706),
                  fontSize: 11.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.data['studentAssignments'] as List? ?? [];

    final filtered = _searchQuery.isEmpty
        ? list
        : list.where((s) {
            final q = _searchQuery.toLowerCase();
            return (s['name'] as String? ?? '').toLowerCase().contains(q) ||
                (s['grade'] as String? ?? '').toLowerCase().contains(q) ||
                (s['route'] as String? ?? '').toLowerCase().contains(q) ||
                (s['stop'] as String? ?? '').toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: widget.onBack),
        title: const Text(
          'Student Assignment',
          style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 18.5, letterSpacing: -0.3),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: ElevatedButton.icon(
              onPressed: () => _showAssignStudentBottomSheet(context),
              icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
              label: const Text(
                'Assign Student',
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                boxShadow: AppShadows.soft,
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E1E2D), fontWeight: FontWeight.w500),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search students by name, grade, route or stop...',
                  hintStyle: TextStyle(color: Color(0xFF9E9AB8), fontSize: 13.0, fontWeight: FontWeight.w500),
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6C4CF1), size: 19),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              '${filtered.length} Students Assigned to Active Bus Routes',
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // Student Roster List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final s = filtered[index];
                return GestureDetector(
                  onTap: () => _showStudentProfileBottomSheet(context, s),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFF3EEFF),
                          child: Icon(LucideIcons.userCheck, color: Color(0xFF6C4CF1), size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${s['name']} (${s['grade']})',
                                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${s['route']} • Bus: ${s['busNo']}',
                                style: const TextStyle(fontSize: 12.0, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Stop: ${s['stop']} • Pick: ${s['pickTime']}',
                                style: const TextStyle(fontSize: 12.0, color: Color(0xFF4A4A68), fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: s['feeStatus'] == 'Paid'
                                ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            s['feeStatus'] ?? 'Assigned',
                            style: TextStyle(
                              color: s['feeStatus'] == 'Paid' ? const Color(0xFF10B981) : const Color(0xFFD97706),
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded, color: Color(0xFFCDCBE0), size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

// ─── Native Bottom Sheet for Assigning Student to Route (Searchable Dropdowns) ──

class _AssignStudentBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic> assignment) onSave;

  const _AssignStudentBottomSheet({required this.onSave});

  @override
  State<_AssignStudentBottomSheet> createState() => _AssignStudentBottomSheetState();
}

class _AssignStudentBottomSheetState extends State<_AssignStudentBottomSheet> {
  String _selectedStudent = 'Kavya Reddy (7-A)';
  String _selectedRoute = 'Route 1 - Green Glen';
  late String _selectedStop;
  DateTime _startDate = DateTime.now();

  final List<String> _students = [
    'Kavya Reddy (7-A)',
    'Aditya Nair (12-B)',
    'Priya Singh (6-C)',
    'Aarav Sharma (10-A)',
    'Ananya Verma (8-B)',
    'Rohan Gupta (9-C)',
    'Diya Patel (11-A)',
    'Manish Kumar (5-B)',
    'Siddhi Patel (8-A)',
  ];

  final List<String> _routes = [
    'Route 1 - Green Glen',
    'Route 2 - Sunrise Hills',
    'Route 3 - Metro Square',
    'Route 4 - Royal Palms',
  ];

  final Map<String, List<String>> _routeStops = {
    'Route 1 - Green Glen': ['Green Glen Gate 2', 'Oakridge Apartments', 'Green Glen Club'],
    'Route 2 - Sunrise Hills': ['Sunrise Club House', 'Sunrise Main Gate', 'Sunrise Park'],
    'Route 3 - Metro Square': ['Metro Pillar 104', 'Metro Circle', 'City Station'],
    'Route 4 - Royal Palms': ['Royal Palms Gate 1', 'Palm Avenue', 'Royal Square'],
  };

  final Map<String, String> _routeVehicles = {
    'Route 1 - Green Glen': 'BUS-01',
    'Route 2 - Sunrise Hills': 'BUS-02',
    'Route 3 - Metro Square': 'BUS-03',
    'Route 4 - Royal Palms': 'VAN-04',
  };

  @override
  void initState() {
    super.initState();
    _selectedStop = _routeStops[_selectedRoute]!.first;
  }

  void _handleSave() {
    final parts = _selectedStudent.split('(');
    final String name = parts[0].trim();
    final String grade = parts.length > 1 ? parts[1].replaceAll(')', '').trim() : '10-A';
    final String busNo = _routeVehicles[_selectedRoute] ?? 'BUS-01';

    final String dayStr = _startDate.day.toString().padLeft(2, '0');
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final String monthStr = months[_startDate.month - 1];

    final newAssignment = {
      'name': name,
      'grade': grade,
      'route': _selectedRoute.split('-')[0].trim(),
      'stop': _selectedStop,
      'busNo': busNo,
      'pickTime': '07:25 AM',
      'feeStatus': 'Paid',
      'startDate': '$dayStr $monthStr ${_startDate.year}',
    };

    widget.onSave(newAssignment);
    Navigator.pop(context);
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2027, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C4CF1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1E2D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _openSearchableSelectionModal({
    required String title,
    required List<String> items,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SearchableDropdownModal(
          title: title,
          items: items,
          currentValue: currentValue,
          onSelected: onSelected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final List<String> availableStops = _routeStops[_selectedRoute] ?? ['Default Stop'];

    final String dayStr = _startDate.day.toString().padLeft(2, '0');
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final String monthStr = months[_startDate.month - 1];
    final String dateDisplay = '$dayStr $monthStr ${_startDate.year}';

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle at top
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0DDF0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header Title & Subtitle
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.userCheck, color: Color(0xFF6C4CF1), size: 20),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assign Student to Route',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E1E2D),
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Assign student to bus route and pickup stop',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF6E6E8D),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Form Fields List (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Student (Searchable Dropdown)
                    _buildFieldLabel('Student'),
                    const SizedBox(height: 6),
                    _buildSearchableSelectTile(
                      value: _selectedStudent,
                      onTap: () {
                        _openSearchableSelectionModal(
                          title: 'Select Student',
                          items: _students,
                          currentValue: _selectedStudent,
                          onSelected: (val) {
                            setState(() => _selectedStudent = val);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // 2. Route (Searchable Dropdown)
                    _buildFieldLabel('Route'),
                    const SizedBox(height: 6),
                    _buildSearchableSelectTile(
                      value: _selectedRoute,
                      onTap: () {
                        _openSearchableSelectionModal(
                          title: 'Select Bus Route',
                          items: _routes,
                          currentValue: _selectedRoute,
                          onSelected: (val) {
                            setState(() {
                              _selectedRoute = val;
                              _selectedStop = _routeStops[val]!.first;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // 3. Pickup Stop (Searchable Dropdown - dynamic based on selected route)
                    _buildFieldLabel('Pickup Stop'),
                    const SizedBox(height: 6),
                    _buildSearchableSelectTile(
                      value: _selectedStop,
                      onTap: () {
                        _openSearchableSelectionModal(
                          title: 'Select Pickup Stop',
                          items: availableStops,
                          currentValue: _selectedStop,
                          onSelected: (val) {
                            setState(() => _selectedStop = val);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // 4. Start Date (Date Picker)
                    _buildFieldLabel('Start Date'),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _selectStartDate,
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                          boxShadow: AppShadows.soft,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dateDisplay,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF1E1E2D),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(LucideIcons.calendar, color: Color(0xFF6C4CF1), size: 19),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF6C4CF1), width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Assign Student',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
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
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1E1E2D),
        letterSpacing: -0.1,
      ),
    );
  }

  Widget _buildSearchableSelectTile({
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFF1E1E2D),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Icon(Icons.search_rounded, color: Color(0xFF6C4CF1), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Searchable Selection Modal Component ─────────────────────────────────────

class _SearchableDropdownModal extends StatefulWidget {
  final String title;
  final List<String> items;
  final String currentValue;
  final ValueChanged<String> onSelected;

  const _SearchableDropdownModal({
    required this.title,
    required this.items,
    required this.currentValue,
    required this.onSelected,
  });

  @override
  State<_SearchableDropdownModal> createState() => _SearchableDropdownModalState();
}

class _SearchableDropdownModalState extends State<_SearchableDropdownModal> {
  String _query = '';
  final TextEditingController _modalSearchCtrl = TextEditingController();

  @override
  void dispose() {
    _modalSearchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.items
        .where((item) => item.toLowerCase().contains(_query.toLowerCase().trim()))
        .toList();

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 16),
      child: SafeArea(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFE0DDF0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            widget.title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: 12),

          // Search Field
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: TextField(
              controller: _modalSearchCtrl,
              onChanged: (val) => setState(() => _query = val),
              style: const TextStyle(fontSize: 14.5, color: Color(0xFF1E1E2D)),
              decoration: const InputDecoration(
                hintText: 'Type to filter suggestions...',
                hintStyle: TextStyle(color: Color(0xFF9E9AB8), fontSize: 13.5),
                prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6C4CF1), size: 19),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Suggestion Items List
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No matching items', style: TextStyle(color: Color(0xFF7A7A9D))))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final bool isSelected = item == widget.currentValue;

                      return ListTile(
                        onTap: () {
                          widget.onSelected(item);
                          Navigator.pop(context);
                        },
                        dense: true,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        tileColor: isSelected ? const Color(0xFFF3EEFF) : null,
                        title: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D),
                          ),
                        ),
                        trailing: isSelected ? const Icon(Icons.check_rounded, color: Color(0xFF6C4CF1), size: 18) : null,
                      );
                    },
                  ),
          ),
        ],
      ),
      ),
    );
  }
}
