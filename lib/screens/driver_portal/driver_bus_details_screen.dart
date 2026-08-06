import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class DriverBusDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const DriverBusDetailsScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<DriverBusDetailsScreen> createState() => _DriverBusDetailsScreenState();
}

class _DriverBusDetailsScreenState extends State<DriverBusDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _studentFilter = 'All';

  final Map<String, dynamic> _vehicle = {
    "busNo": "BUS-01",
    "type": "School Bus",
    "model": "Tata Starbus 40-Seater",
    "registration": "KA-05-EX-4029",
    "capacity": 40,
    "occupied": 38,
    "fuel": "82%",
    "speed": "28 km/h",
    "status": "On Route",
    "compliance": "Valid (Inspected Jul 2026)",
    "gpsStatus": "Live Signal",
  };

  final List<Map<String, dynamic>> _students = [
    {"name": "Aarav Sharma", "grade": "Class 5-A", "stop": "Oakwood Gardens", "status": "Boarded", "parentPhone": "+91 98765 11111"},
    {"name": "Ananya Verma", "grade": "Class 3-B", "stop": "Oakwood Gardens", "status": "Boarded", "parentPhone": "+91 98765 22222"},
    {"name": "Rohan Gupta", "grade": "Class 7-C", "stop": "Pine Crest Apts", "status": "Boarded", "parentPhone": "+91 98765 33333"},
    {"name": "Diya Patel", "grade": "Class 4-A", "stop": "Pine Crest Apts", "status": "Boarded", "parentPhone": "+91 98765 44444"},
    {"name": "Kabir Mehta", "grade": "Class 6-B", "stop": "Green Glen Complex", "status": "Pending", "parentPhone": "+91 98765 55555"},
    {"name": "Sanya Reddy", "grade": "Class 2-A", "stop": "Green Glen Complex", "status": "Pending", "parentPhone": "+91 98765 66666"},
    {"name": "Vihaan Joshi", "grade": "Class 8-A", "stop": "Sunrise Club House", "status": "Pending", "parentPhone": "+91 98765 77777"},
    {"name": "Isha Malhotra", "grade": "Class 1-B", "stop": "City Metro Crossing", "status": "Pending", "parentPhone": "+91 98765 88888"},
  ];

  final Map<String, dynamic> _staff = {
    "attendantName": "Ramesh Chandra",
    "attendantId": "EMP-ATT-409",
    "attendantPhone": "+91 98765 00011",
    "status": "On Duty",
    "experience": "5 Years",
    "assignedBus": "BUS-01 (KA-05-EX-4029)",
  };

  final List<Map<String, dynamic>> _stops = [
    {"stopNo": "1", "location": "Oakwood Gardens Gate 1", "time": "07:15 AM", "students": 6, "status": "Visited"},
    {"stopNo": "2", "location": "Pine Crest Apartments", "time": "07:25 AM", "students": 8, "status": "Visited"},
    {"stopNo": "3", "location": "Green Glen Complex", "time": "07:35 AM", "students": 12, "status": "Arriving"},
    {"stopNo": "4", "location": "Sunrise Club House", "time": "07:45 AM", "students": 5, "status": "Pending"},
    {"stopNo": "5", "location": "City Metro Crossing", "time": "07:55 AM", "students": 7, "status": "Pending"},
    {"stopNo": "6", "location": "Sunrise Academy Campus", "time": "08:10 AM", "students": 0, "status": "Pending"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleStudentStatus(int index) {
    setState(() {
      final current = _students[index]['status'];
      if (current == 'Pending') {
        _students[index]['status'] = 'Boarded';
      } else if (current == 'Boarded') {
        _students[index]['status'] = 'Dropped Off';
      } else {
        _students[index]['status'] = 'Pending';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              // Top Bar & Header Summary Card
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Back Button Header Bar
                      if (widget.onBack != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          child: Row(
                            children: [
                              AppBackButton(onPressed: widget.onBack!),
                              const SizedBox(width: 8),
                              const Text(
                                'Bus Details',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E2D),
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Minimal Clean Summary Header Card
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FD),
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: const Color(0xFFEBE8F6)),
                        ),
                        child: Row(
                          children: [
                            // Bus Avatar Icon
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C4CF1).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(LucideIcons.bus, color: Color(0xFF6C4CF1), size: 24),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _vehicle['busNo'],
                                        style: const TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E1E2D),
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      // Status Chip
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFECFDF5),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          _vehicle['status'],
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF10B981),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${_vehicle['model']} • ${_vehicle['registration']}',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xFF7A7A9D),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sticky Horizontally Scrollable Tab Navigation
              SliverPersistentHeader(
                pinned: true,
                delegate: _DriverStickyTabBarDelegate(
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: const Color(0xFF6C4CF1),
                        unselectedLabelColor: const Color(0xFF64748B),
                        indicatorColor: const Color(0xFF6C4CF1),
                        indicatorWeight: 3.0,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        tabs: const [
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.bus, size: 16),
                                SizedBox(width: 8),
                                Text('Vehicle Details'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.users, size: 16),
                                SizedBox(width: 8),
                                Text('Students'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.userCheck, size: 16),
                                SizedBox(width: 8),
                                Text('Staff'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.mapPin, size: 16),
                                SizedBox(width: 8),
                                Text('Route'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildVehicleDetailsTab(),
              _buildStudentsTab(),
              _buildStaffTab(),
              _buildRouteTab(),
            ],
          ),
        ),
      ),
    );
  }

  // --- 1. VEHICLE DETAILS TAB ---
  Widget _buildVehicleDetailsTab() {
    final int capacity = _vehicle['capacity'] as int;
    final int occupied = _vehicle['occupied'] as int;
    final double occupancyRatio = (occupied / capacity).clamp(0.0, 1.0);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Specifications Card with clean label-value rows
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCleanLabelValueRow('Registration Number', _vehicle['registration']),
                const Divider(height: 24, color: Color(0xFFF0EDF8)),
                _buildCleanLabelValueRow('Category & Model', '${_vehicle['type']} • ${_vehicle['model']}'),
                const Divider(height: 24, color: Color(0xFFF0EDF8)),
                // Occupancy with progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Seating Occupancy',
                          style: TextStyle(fontSize: 13.0, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '$occupied / $capacity Seats',
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: occupancyRatio,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C4CF1)),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, color: Color(0xFFF0EDF8)),
                _buildCleanLabelValueRow('Fuel Tank Level', _vehicle['fuel']),
                const Divider(height: 24, color: Color(0xFFF0EDF8)),
                _buildCleanLabelValueRow('Live Telematics Speed', _vehicle['speed']),
                const Divider(height: 24, color: Color(0xFFF0EDF8)),
                _buildCleanLabelValueRow('Safety Compliance', _vehicle['compliance']),
                const Divider(height: 24, color: Color(0xFFF0EDF8)),
                _buildCleanLabelValueRow('GPS Hardware', _vehicle['gpsStatus']),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCleanLabelValueRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.0,
            color: Color(0xFF7A7A9D),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // --- 2. STUDENTS TAB ---
  Widget _buildStudentsTab() {
    final filtered = _students.where((s) {
      if (_studentFilter == 'All') return true;
      return s['status'] == _studentFilter;
    }).toList();

    return Column(
      children: [
        // Minimal Filter Chips Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: ['All', 'Boarded', 'Pending', 'Dropped Off'].map((filter) {
                final isSel = _studentFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _studentFilter = filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFF6C4CF1) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSel ? Colors.white : const Color(0xFF475569),
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Students List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            physics: const BouncingScrollPhysics(),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final student = filtered[index];
              final origIndex = _students.indexOf(student);

              Color statusBg;
              Color statusColor;
              if (student['status'] == 'Boarded') {
                statusBg = const Color(0xFFECFDF5);
                statusColor = const Color(0xFF10B981);
              } else if (student['status'] == 'Dropped Off') {
                statusBg = const Color(0xFFEFF6FF);
                statusColor = const Color(0xFF3B82F6);
              } else {
                statusBg = const Color(0xFFFFFBEB);
                statusColor = const Color(0xFFD97706);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                  boxShadow: AppShadows.soft,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF6C4CF1).withValues(alpha: 0.12),
                      child: Text(
                        student['name'].substring(0, 1),
                        style: const TextStyle(
                          color: Color(0xFF6C4CF1),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student['name'],
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${student['grade']} • ${student['stop']}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF7A7A9D),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.phone, color: Color(0xFF6C4CF1), size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Calling parent of ${student['name']} (${student['parentPhone']})...'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF6C4CF1),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _toggleStudentStatus(origIndex),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          student['status'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- 3. STAFF TAB ---
  Widget _buildStaffTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF6C4CF1).withValues(alpha: 0.12),
                      child: const Text(
                        'RC',
                        style: TextStyle(
                          color: Color(0xFF6C4CF1),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _staff['attendantName'],
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Bus Attendant / Conductor',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF7A7A9D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _staff['status'],
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF0EDF8)),
                const SizedBox(height: 14),
                _buildCleanLabelValueRow('Employee ID', _staff['attendantId']),
                const SizedBox(height: 12),
                _buildCleanLabelValueRow('Experience', _staff['experience']),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Contact Phone',
                      style: TextStyle(fontSize: 13.0, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        const Icon(LucideIcons.phone, size: 14, color: Color(0xFF6C4CF1)),
                        const SizedBox(width: 6),
                        Text(
                          _staff['attendantPhone'],
                          style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 4. ROUTE TAB ---
  Widget _buildRouteTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      physics: const BouncingScrollPhysics(),
      itemCount: _stops.length,
      itemBuilder: (context, index) {
        final stop = _stops[index];

        Color statusBg;
        Color statusColor;
        if (stop['status'] == 'Visited') {
          statusBg = const Color(0xFFECFDF5);
          statusColor = const Color(0xFF10B981);
        } else if (stop['status'] == 'Arriving') {
          statusBg = const Color(0xFFF3F0FF);
          statusColor = const Color(0xFF6C4CF1);
        } else {
          statusBg = const Color(0xFFF8F9FD);
          statusColor = const Color(0xFF7A7A9D);
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: const Color(0xFFF0EDF8)),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C4CF1).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${stop['stopNo']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop['location'],
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${stop['time']} • ${stop['students']} Students',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF7A7A9D),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  stop['status'],
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DriverStickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _DriverStickyTabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 46.0;

  @override
  double get minExtent => 46.0;

  @override
  bool shouldRebuild(covariant _DriverStickyTabBarDelegate oldDelegate) {
    return false;
  }
}
