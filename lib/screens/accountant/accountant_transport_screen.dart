import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'accountant_quick_collection_screen.dart';

class AccountantTransportScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AccountantTransportScreen({super.key, required this.onBack});

  @override
  State<AccountantTransportScreen> createState() => _AccountantTransportScreenState();
}

class _AccountantTransportScreenState extends State<AccountantTransportScreen> {
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _routes = [
    {'route': 'Route 01 - Downtown', 'vehicle': 'Bus AP09-1234', 'collected': '₹4,50,000', 'pending': '₹1,20,000', 'students': 45},
    {'route': 'Route 02 - North Hill', 'vehicle': 'Van AP09-5678', 'collected': '₹3,20,000', 'pending': '₹45,000', 'students': 28},
    {'route': 'Route 03 - East End', 'vehicle': 'Bus AP09-9012', 'collected': '₹5,10,000', 'pending': '₹2,10,000', 'students': 52},
    {'route': 'Route 04 - West side', 'vehicle': 'Bus AP09-3456', 'collected': '₹3,80,000', 'pending': '₹90,000', 'students': 40},
    {'route': 'Route 05 - Suburbs', 'vehicle': 'Van AP09-7890', 'collected': '₹2,10,000', 'pending': '₹30,000', 'students': 22},
    {'route': 'Route 06 - South City', 'vehicle': 'Bus AP09-2345', 'collected': '₹4,90,000', 'pending': '₹1,50,000', 'students': 48},
  ];

  final List<Map<String, dynamic>> _mockStudents = [
    {'name': 'Rohan Das', 'id': 'TR-1029', 'class': 'Class 5-A', 'stop': 'Central Station', 'progress': 1.0, 'progressText': '100%', 'paid': '₹12,000', 'pending': '₹0', 'status': 'Paid'},
    {'name': 'Priya Sharma', 'id': 'TR-1030', 'class': 'Class 6-B', 'stop': 'Main Street', 'progress': 0.8, 'progressText': '80%', 'paid': '₹9,600', 'pending': '₹2,400', 'status': 'Partial'},
    {'name': 'Aarav Gupta', 'id': 'TR-1031', 'class': 'Class 7-C', 'stop': 'North Plaza', 'progress': 0.5, 'progressText': '50%', 'paid': '₹6,000', 'pending': '₹6,000', 'status': 'Partial'},
    {'name': 'Sneha Kumar', 'id': 'TR-1032', 'class': 'Class 8-D', 'stop': 'Park Avenue', 'progress': 0.0, 'progressText': '0%', 'paid': '₹0', 'pending': '₹12,000', 'status': 'Pending'},
    {'name': 'Vikram Singh', 'id': 'TR-1033', 'class': 'Class 5-B', 'stop': 'City Center', 'progress': 1.0, 'progressText': '100%', 'paid': '₹12,000', 'pending': '₹0', 'status': 'Paid'},
    {'name': 'Neha Reddy', 'id': 'TR-1034', 'class': 'Class 6-A', 'stop': 'East Gate', 'progress': 0.9, 'progressText': '90%', 'paid': '₹10,800', 'pending': '₹1,200', 'status': 'Partial'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredRoutes = _routes.where((r) => 
      r['route'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
      r['vehicle'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildKPIs(),
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 900) {
                            return Wrap(
                              spacing: 16,
                              children: filteredRoutes.map((route) => SizedBox(
                                width: (constraints.maxWidth - 16) / 2,
                                child: _buildRouteCard(route),
                              )).toList(),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: filteredRoutes.length,
                            itemBuilder: (context, index) {
                              return _buildRouteCard(filteredRoutes[index]);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onBack,
                  child: const Icon(LucideIcons.arrowLeft, size: 24, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Transport Fee Collection',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountantQuickCollectionScreen(
                    onBack: () => Navigator.pop(context),
                  ),
                ),
              );
            },
            icon: const Icon(LucideIcons.zap, size: 16, color: Colors.white),
            label: const Text('Quick Collection', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildKPICard('Collected', '₹23,60,000', LucideIcons.indianRupee, const Color(0xFF16A34A), const Color(0xFFF0FDF4))),
              const SizedBox(width: 16),
              Expanded(child: _buildKPICard('Pending', '₹6,45,000', LucideIcons.alertTriangle, const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildKPICard('Active Routes', '18', LucideIcons.map, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
              const SizedBox(width: 16),
              Expanded(child: _buildKPICard('Riders', '842', LucideIcons.users, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search by route or vehicle...',
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          prefixIcon: const Icon(LucideIcons.search, color: Color(0xFF94A3B8), size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> route) {
    final routeName = route['route'].toString().split(' - ').length > 1 ? route['route'].toString().split(' - ')[1] : route['route'];
    
    return GestureDetector(
      onTap: () => _showRouteDetailsBottomSheet(route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE), // Light blue
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.bus, color: Color(0xFF0EA5E9), size: 20),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bus 01', // Matching the image exactly
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$routeName • ${route['students']} riders',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Healthy',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('PERIOD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 1.2)),
                const Text('Academic Year 2026-27', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Collected', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                Text(route['collected'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pending', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                Text(route['pending'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFFEF4444))),
              ],
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Container(
                  height: 6,
                  width: MediaQuery.of(context).size.width * 0.75, // Mocking progress
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('89% collected', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                const Text('₹1,11,000 total', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildGridItem('Route', routeName)),
                const SizedBox(width: 12),
                Expanded(child: _buildGridItem('Riders', route['students'].toString())),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildGridItem('Stops', '11')),
                const SizedBox(width: 12),
                Expanded(child: _buildGridItem('Pending', '5')),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag('Monthly'),
                    _buildTag('Route fee'),
                    _buildTag('Fuel adj.'),
                  ],
                ),
                Row(
                  children: const [
                    Text('View details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9))),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 14, color: Color(0xFF0EA5E9)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
    );
  }

  void _showRouteDetailsBottomSheet(Map<String, dynamic> route) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(color: const Color(0xFF6C4CF1), borderRadius: BorderRadius.circular(14)),
                                  child: const Center(child: Icon(LucideIcons.bus, color: Colors.white, size: 24)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        spacing: 12,
                                        runSpacing: 4,
                                        children: [
                                          Text('${route['route']} Roster', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                                          Text('${route['students']} STUDENTS', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                                            child: const Text('Healthy', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Vehicle: ${route['vehicle']} • Academic Year 2026-27 • Click a student to open analytics',
                                        style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.x, color: Color(0xFF94A3B8)),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildRosterStatCard('TOTAL EXPECTED', '₹8,50,000', const Color(0xFF6C4CF1))),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildRosterStatCard('PAID', route['collected'], const Color(0xFF16A34A))),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(child: _buildRosterStatCard('PENDING', route['pending'], const Color(0xFFEF4444))),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildRosterStatCard('AVG PROGRESS', '80%', const Color(0xFF0EA5E9))),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // List Section
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Student Payment List', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(6)),
                                      child: const Text('All students', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, color: Color(0xFFF1F5F9)),
                              // List items
                              ..._mockStudents.map((s) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: _buildStudentRosterRow(s),
                              )),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                      
                      // Bottom Footer
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('${route['route'].toString().toUpperCase()} • ACADEMIC YEAR 2026-27', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1.0)),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Roster exported!'), backgroundColor: Color(0xFF16A34A)));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E1E2D),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('EXPORT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildRosterStatCard(String title, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: valueColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: valueColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: valueColor.withValues(alpha: 0.8), letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildStudentRosterRow(Map<String, dynamic> s) {
    final bool isPaid = s['status'] == 'Paid';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                Center(child: Text(s['name'].toString().substring(0, 1), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))),
                CircularProgressIndicator(value: s['progress'], strokeWidth: 2, backgroundColor: const Color(0xFFF1F5F9), valueColor: AlwaysStoppedAnimation<Color>(isPaid ? const Color(0xFF16A34A) : (s['progress'] > 0 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(s['id'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8))),
                    const SizedBox(width: 8),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(4)), child: Text(s['stop'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)))),
                    const SizedBox(width: 6),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(4)), child: Text(s['class'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)))),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(s['paid'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF16A34A))),
              const SizedBox(height: 4),
              if (!isPaid) Text('Due: ${s['pending']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFEF4444))),
              if (isPaid) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)), child: const Text('Fully Paid', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)))),
            ],
          ),
        ],
      ),
    );
  }
}
