import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'transport_compliance_details_screen.dart';

class TransportComplianceScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const TransportComplianceScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  State<TransportComplianceScreen> createState() =>
      _TransportComplianceScreenState();
}

class _TransportComplianceScreenState
    extends State<TransportComplianceScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allRecords = [
    {
      'busNo': 'BUS-01',
      'item': 'Fitness Certificate',
      'authority': 'RTO Delhi',
      'expiry': '15 Aug 2026',
      'status': 'Warning',
      'daysLeft': 17,
      'alertType': 'Expiring Soon',
      'role': 'Vehicle',
    },
    {
      'busNo': 'BUS-03',
      'item': 'Vehicle Insurance',
      'authority': 'National Insurance Co.',
      'expiry': '10 Aug 2026',
      'status': 'Expired',
      'daysLeft': -2,
      'alertType': 'Expired',
      'role': 'Vehicle',
    },
    {
      'busNo': 'Rajesh Kumar',
      'item': 'Driving License',
      'authority': 'RTO North Delhi',
      'expiry': '20 Aug 2026',
      'status': 'Warning',
      'daysLeft': 22,
      'alertType': 'Expiring Soon',
      'role': 'Driver',
    },
    {
      'busNo': 'BUS-01',
      'item': 'PUC Certificate',
      'authority': 'Eco Check Center',
      'expiry': '10 Nov 2026',
      'status': 'Valid',
      'daysLeft': 104,
      'alertType': null,
      'role': 'Vehicle',
    },
    {
      'busNo': 'BUS-02',
      'item': 'Speed Governor',
      'authority': 'Govt Inspectorate',
      'expiry': '15 Dec 2026',
      'status': 'Valid',
      'daysLeft': 139,
      'alertType': null,
      'role': 'Vehicle',
    },
    {
      'busNo': 'Anil Verma',
      'item': 'Driving License',
      'authority': 'RTO East Delhi',
      'expiry': '05 Feb 2027',
      'status': 'Valid',
      'daysLeft': 191,
      'alertType': null,
      'role': 'Driver',
    },
    {
      'busNo': 'VAN-04',
      'item': 'Fitness Certificate',
      'authority': 'RTO South',
      'expiry': '18 Jan 2027',
      'status': 'Valid',
      'daysLeft': 173,
      'alertType': null,
      'role': 'Vehicle',
    },
    {
      'busNo': 'BUS-02',
      'item': 'Vehicle Insurance',
      'authority': 'HDFC Ergo',
      'expiry': '31 Mar 2027',
      'status': 'Valid',
      'daysLeft': 245,
      'alertType': null,
      'role': 'Vehicle',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    List<Map<String, dynamic>> list = _allRecords;

    switch (_selectedFilter) {
      case 'Needs Action':
        list = list
            .where((r) =>
                r['status'] == 'Warning' || r['status'] == 'Expired')
            .toList();
        break;
      case 'Compliant':
        list = list.where((r) => r['status'] == 'Valid').toList();
        break;
      case 'Expired':
        list = list.where((r) => r['status'] == 'Expired').toList();
        break;
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((r) =>
              (r['busNo'] as String).toLowerCase().contains(q) ||
              (r['item'] as String).toLowerCase().contains(q))
          .toList();
    }

    return list;
  }

  List<Map<String, dynamic>> get _actionRequired => _filtered
      .where((r) => r['status'] == 'Expired' || r['status'] == 'Warning')
      .toList();

  List<Map<String, dynamic>> get _complianceList =>
      _filtered.where((r) => r['status'] == 'Valid').toList();

  void _openDetails(Map<String, dynamic> record) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransportComplianceDetailsScreen(record: record),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actionItems = _actionRequired;
    final complianceItems = _complianceList;
    final bool isEmpty = actionItems.isEmpty && complianceItems.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: widget.onBack),
        title: const Text(
          'Compliance & Alerts',
          style: TextStyle(
            color: Color(0xFF1E1E2D),
            fontWeight: FontWeight.bold,
            fontSize: 18.5,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Segmented Filter ──
            _buildSegmentedFilter(),
            const SizedBox(height: 12),

            // ── Search Bar ──
            _buildSearchBar(),
            const SizedBox(height: 20),

            // ── Action Required ──
            if (actionItems.isNotEmpty) ...[
              _sectionHeading('Action Required'),
              const SizedBox(height: 10),
              ...actionItems.map((r) => _buildAlertCard(r)),
              const SizedBox(height: 24),
            ],

            // ── Compliance List ──
            if (complianceItems.isNotEmpty) ...[
              _sectionHeading('Compliance List'),
              const SizedBox(height: 10),
              ...complianceItems.map((r) => _buildComplianceCard(r)),
            ],

            // ── Empty State ──
            if (isEmpty) _buildEmptyState(),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────── Widgets ───────────────────────────

  Widget _buildSegmentedFilter() {
    final filters = ['All', 'Needs Action', 'Compliant', 'Expired'];
    return Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: filters.map((f) {
          final bool active = _selectedFilter == f;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: active ? AppShadows.soft : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  f,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight:
                        active ? FontWeight.bold : FontWeight.w600,
                    color: active
                        ? const Color(0xFF6C4CF1)
                        : const Color(0xFF7A7A9D),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDE8FF), width: 1.0),
        boxShadow: AppShadows.soft,
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          fontSize: 13.5,
          color: Color(0xFF1E1E2D),
          fontWeight: FontWeight.w500,
        ),
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: const InputDecoration(
          hintText: 'Search vehicle, driver or document...',
          hintStyle: TextStyle(
            color: Color(0xFFB0AABF),
            fontSize: 13.0,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon:
              Icon(Icons.search_rounded, color: Color(0xFF6C4CF1), size: 19),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          isDense: true,
        ),
      ),
    );
  }

  Widget _sectionHeading(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E1E2D),
        letterSpacing: -0.2,
      ),
    );
  }

  /// Alert card — for Expired / Warning items
  Widget _buildAlertCard(Map<String, dynamic> r) {
    final bool isExpired = r['status'] == 'Expired';

    final Color statusColor =
        isExpired ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);
    final Color statusBg =
        isExpired ? const Color(0xFFFEF2F2) : const Color(0xFFFFFBEB);
    final String statusLabel = isExpired ? 'Expired' : 'Expiring Soon';

    return GestureDetector(
      onTap: () => _openDetails(r),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + role pill
                  Row(
                    children: [
                      Text(
                        r['busNo'] as String,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(width: 7),
                      _rolePill(r['role'] as String),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Document name
                  Text(
                    r['item'] as String,
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Color(0xFF4A4A68),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Expiry date
                  Text(
                    'Expires ${r['expiry']}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Right: status badge + Review button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Single status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Review action
                GestureDetector(
                  onTap: () => _openDetails(r),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C4CF1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
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

  /// Clean row card — for Valid / Compliant items
  Widget _buildComplianceCard(Map<String, dynamic> r) {
    return GestureDetector(
      onTap: () => _openDetails(r),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + role pill
                  Row(
                    children: [
                      Text(
                        r['busNo'] as String,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(width: 7),
                      _rolePill(r['role'] as String),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Document name
                  Text(
                    r['item'] as String,
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Color(0xFF4A4A68),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Expiry date
                  Text(
                    'Expires ${r['expiry']}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF7A7A9D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Right: single status + View Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Single status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Text(
                    'Compliant',
                    style: TextStyle(
                      color: Color(0xFF16A34A),
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // View Details action
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'View Details',
                      style: TextStyle(
                        color: Color(0xFF6C4CF1),
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF6C4CF1),
                      size: 10,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rolePill(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEFF),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        role,
        style: const TextStyle(
          color: Color(0xFF6C4CF1),
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.shieldCheck,
                  color: Color(0xFF6C4CF1), size: 30),
            ),
            const SizedBox(height: 12),
            const Text(
              'No records found',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Try a different filter or search term.',
              style: TextStyle(fontSize: 12.5, color: Color(0xFF7A7A9D)),
            ),
          ],
        ),
      ),
    );
  }
}
