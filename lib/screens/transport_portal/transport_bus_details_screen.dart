import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TransportBusDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> vehicleData;
  final VoidCallback? onBack;

  const TransportBusDetailsScreen({
    super.key,
    required this.vehicleData,
    this.onBack,
  });

  @override
  State<TransportBusDetailsScreen> createState() => _TransportBusDetailsScreenState();
}

class _TransportBusDetailsScreenState extends State<TransportBusDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _studentSearchQuery = '';
  final TextEditingController _studentSearchController = TextEditingController();

  // Mock list of assigned students
  final List<Map<String, dynamic>> _studentsList = [
    {
      'name': 'Aarav Sharma',
      'class': 'Class 8-A',
      'stop': 'Green Glen Layout Stop 3',
      'status': 'Boarded',
      'avatarColor': const Color(0xFF6C4CF1),
      'initials': 'AS',
      'photoUrl': 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=150&auto=format&fit=crop&q=80',
      'time': '07:35 AM',
    },
    {
      'name': 'Ananya Verma',
      'class': 'Class 6-B',
      'stop': 'Green Glen Layout Stop 3',
      'status': 'Boarded',
      'avatarColor': const Color(0xFF10B981),
      'initials': 'AV',
      'photoUrl': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&auto=format&fit=crop&q=80',
      'time': '07:36 AM',
    },
    {
      'name': 'Rohan Gupta',
      'class': 'Class 9-C',
      'stop': 'Sunrise Apartments Gate 2',
      'status': 'Pending',
      'avatarColor': const Color(0xFFF59E0B),
      'initials': 'RG',
      'photoUrl': 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150&auto=format&fit=crop&q=80',
      'time': 'ETA 07:48 AM',
    },
    {
      'name': 'Diya Patel',
      'class': 'Class 7-A',
      'stop': 'Sunrise Apartments Gate 2',
      'status': 'Pending',
      'avatarColor': const Color(0xFFEC4899),
      'initials': 'DP',
      'photoUrl': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=150&auto=format&fit=crop&q=80',
      'time': 'ETA 07:49 AM',
    },
    {
      'name': 'Karan Singh',
      'class': 'Class 10-B',
      'stop': 'Bellandur Flyover Stop',
      'status': 'Absent',
      'avatarColor': const Color(0xFFEF4444),
      'initials': 'KS',
      'photoUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
      'time': 'Notified 07:10 AM',
    },
    {
      'name': 'Meera Nair',
      'class': 'Class 5-C',
      'stop': 'Eco Space Tech Park Gate 1',
      'status': 'Pending',
      'avatarColor': const Color(0xFF8B5CF6),
      'initials': 'MN',
      'photoUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      'time': 'ETA 08:02 AM',
    },
    {
      'name': 'Vivian Joseph',
      'class': 'Class 11-A',
      'stop': 'Eco Space Tech Park Gate 1',
      'status': 'Pending',
      'avatarColor': const Color(0xFF3B82F6),
      'initials': 'VJ',
      'photoUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80',
      'time': 'ETA 08:03 AM',
    },
  ];

  // Mock list of assigned staff
  final List<Map<String, dynamic>> _staffList = [
    {
      'name': 'Rajesh Kumar',
      'designation': 'Senior Bus Driver',
      'role': 'Driver',
      'stop': 'Depot Main Gate',
      'status': 'On Duty',
      'phone': '+91 98765 43210',
      'initials': 'RK',
      'avatarColor': const Color(0xFF6C4CF1),
    },
    {
      'name': 'Sunita Sunita',
      'designation': 'Transport Escort / Attendant',
      'role': 'Attendant',
      'stop': 'Depot Main Gate',
      'status': 'Boarded',
      'phone': '+91 98112 33445',
      'initials': 'SS',
      'avatarColor': const Color(0xFF10B981),
    },
    {
      'name': 'Vikram Rathore',
      'designation': 'Fleet Safety Officer',
      'role': 'Supervisor',
      'stop': 'Central Transport Hub',
      'status': 'Standby',
      'phone': '+91 97722 11004',
      'initials': 'VR',
      'avatarColor': const Color(0xFF3B82F6),
    },
  ];

  // Mock Route stops list
  final List<Map<String, dynamic>> _routeStops = [
    {
      'stopNo': 1,
      'name': 'Central Bus Depot',
      'time': '07:15 AM',
      'actualTime': '07:15 AM',
      'status': 'Completed',
      'studentsCount': 0,
      'address': 'Depot Yard Sector 4, Outer Ring Rd',
    },
    {
      'stopNo': 2,
      'name': 'Green Glen Layout Stop 3',
      'time': '07:35 AM',
      'actualTime': '07:36 AM',
      'status': 'Completed',
      'studentsCount': 12,
      'address': 'Opposite Lotus Supermarket, Green Glen',
    },
    {
      'stopNo': 3,
      'name': 'Sunrise Apartments Gate 2',
      'time': '07:48 AM',
      'actualTime': 'In Progress',
      'status': 'Current',
      'studentsCount': 10,
      'address': 'Main Entrance, Sunrise Complex',
    },
    {
      'stopNo': 4,
      'name': 'Bellandur Flyover Junction',
      'time': '07:55 AM',
      'actualTime': 'Scheduled',
      'status': 'Upcoming',
      'studentsCount': 8,
      'address': 'Service Road Bus Shelter',
    },
    {
      'stopNo': 5,
      'name': 'Eco Space Tech Park Gate 1',
      'time': '08:05 AM',
      'actualTime': 'Scheduled',
      'status': 'Upcoming',
      'studentsCount': 8,
      'address': 'Gate 1 Visitor Canopy',
    },
    {
      'stopNo': 6,
      'name': 'Greenwood High Campus Main Gate',
      'time': '08:20 AM',
      'actualTime': 'Destination',
      'status': 'Destination',
      'studentsCount': 38,
      'address': 'School Transport Terminal',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _studentSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String busNo = widget.vehicleData['busNo'] as String? ?? 'BUS-01';
    final String model = widget.vehicleData['model'] as String? ?? 'Tata Starbus 40-Seater';
    final String regNo = widget.vehicleData['regNo'] as String? ?? widget.vehicleData['registrationNo'] as String? ?? 'KA-01-EQ-4582';
    final String rawStatus = widget.vehicleData['status'] as String? ?? 'On Route';
    final String status = rawStatus.contains('Route')
        ? 'On Route'
        : (rawStatus.contains('Maintenance') ? 'Maintenance' : 'Idle');

    Color statusColor;
    Color statusBg;
    if (status == 'On Route') {
      statusColor = const Color(0xFF16A34A);
      statusBg = const Color(0xFFF0FDF4);
    } else if (status == 'Maintenance') {
      statusColor = const Color(0xFFEF4444);
      statusBg = const Color(0xFFFEF2F2);
    } else {
      statusColor = const Color(0xFFD97706);
      statusBg = const Color(0xFFFFFBEB);
    }

    final String driverName = widget.vehicleData['driver'] as String? ?? 'Rajesh Kumar';
    final String routeName = widget.vehicleData['route'] as String? ?? 'Route 1 - Green Glen';
    final int capacity = (widget.vehicleData['capacity'] as num?)?.toInt() ?? 40;
    final int occupied = (widget.vehicleData['occupied'] as num?)?.toInt() ?? 38;
    final String fuel = widget.vehicleData['fuel'] as String? ?? '82%';
    final String speed = widget.vehicleData['speed'] as String? ?? '34 km/h';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              // AppBar
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      AppBackButton(
                        onPressed: () {
                          if (widget.onBack != null) {
                            widget.onBack!();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              busNo,
                              style: const TextStyle(
                                fontSize: 18.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              routeName,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF7A7A9D),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bus Top Summary Section
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Column(
                    children: [
                      // Header Card Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C4CF1), Color(0xFF4F46E5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          boxShadow: AppShadows.soft,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Bus Icon Container
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                  ),
                                  child: const Center(
                                    child: Icon(LucideIcons.bus, color: Colors.white, size: 28),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            busNo,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              regNo,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        model,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white.withValues(alpha: 0.9),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Driver: $driverName',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withValues(alpha: 0.75),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const Divider(color: Colors.white24, height: 1),
                            const SizedBox(height: 12),
                            // Quick Specs Grid inside Header Banner
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildHeaderMetric(LucideIcons.users, '$occupied / $capacity', 'Occupancy'),
                                Container(width: 1, height: 24, color: Colors.white24),
                                _buildHeaderMetric(LucideIcons.fuel, fuel, 'Fuel Level'),
                                Container(width: 1, height: 24, color: Colors.white24),
                                _buildHeaderMetric(LucideIcons.gauge, speed, 'Live Speed'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sticky Horizontally Scrollable Tab Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: const Color(0xFF6C4CF1),
                        unselectedLabelColor: const Color(0xFF64748B),
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        indicatorColor: const Color(0xFF6C4CF1),
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        tabs: const [
                          Tab(text: 'Vehicle Details'),
                          Tab(text: 'Students'),
                          Tab(text: 'Staff'),
                          Tab(text: 'Route'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },

          // TabBar Content Views
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildVehicleDetailsTab(busNo, regNo, model, capacity, occupied, routeName, status, fuel, speed),
              _buildStudentsTab(),
              _buildStaffTab(),
              _buildRouteTab(routeName),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderMetric(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // TAB 1: VEHICLE DETAILS
  Widget _buildVehicleDetailsTab(
    String busNo,
    String regNo,
    String model,
    int capacity,
    int occupied,
    String routeName,
    String status,
    String fuel,
    String speed,
  ) {
    final double occupancyPercentage = (occupied / capacity * 100).clamp(0, 100);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Overview Summary
          const Text(
            'Vehicle Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              children: [
                _buildDetailGridItem(LucideIcons.bus, 'Vehicle Number', busNo),
                const Divider(height: 20, color: Color(0xFFF0EDF8)),
                _buildDetailGridItem(LucideIcons.fileText, 'Registration Number', regNo),
                const Divider(height: 20, color: Color(0xFFF0EDF8)),
                _buildDetailGridItem(LucideIcons.truck, 'Vehicle Model', model),
                const Divider(height: 20, color: Color(0xFFF0EDF8)),
                _buildDetailGridItem(LucideIcons.calendar, 'Manufacturing Year', '2022'),
                const Divider(height: 20, color: Color(0xFFF0EDF8)),
                _buildDetailGridItem(LucideIcons.mapPin, 'Assigned Route', routeName),
                const Divider(height: 20, color: Color(0xFFF0EDF8)),
                _buildDetailGridItem(LucideIcons.activity, 'Operational Status', status),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section 2: Occupancy & Capacity Metrics
          const Text(
            'Capacity & Occupancy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3EEFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(LucideIcons.users, color: Color(0xFF6C4CF1), size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Seating Occupancy',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E2D),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '$occupied of $capacity seats occupied',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF7A7A9D),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${occupancyPercentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: occupancyPercentage / 100,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C4CF1)),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FD),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Capacity', style: TextStyle(fontSize: 11, color: Color(0xFF7A7A9D))),
                            const SizedBox(height: 2),
                            Text('$capacity Seats', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FD),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Available Seats', style: TextStyle(fontSize: 11, color: Color(0xFF7A7A9D))),
                            const SizedBox(height: 2),
                            Text('${capacity - occupied} Seats', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section 3: Compliance & Documents
          const Text(
            'Compliance & Safety Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              children: [
                _buildComplianceItem('RTO Fitness Certificate', 'Valid till 14 Nov 2026', 'Valid', const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
                const Divider(height: 20, color: Color(0xFFF0EDF8)),
                _buildComplianceItem('Vehicle Insurance', 'Valid till 28 Dec 2026', 'Valid', const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
                const Divider(height: 20, color: Color(0xFFF0EDF8)),
                _buildComplianceItem('Speed Governor Audit', 'Certified at 50 km/h limit', 'Valid', const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
                const Divider(height: 20, color: Color(0xFFF0EDF8)),
                _buildComplianceItem('Pollution Check (PUC)', 'Renewal Due in 5 Days', 'Renewal Due', const Color(0xFFD97706), const Color(0xFFFFFBEB)),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDetailGridItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EEFF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF6C4CF1), size: 16),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF7A7A9D),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComplianceItem(String title, String subtitle, String status, Color statusColor, Color statusBg) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF7A7A9D),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusBg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // TAB 2: STUDENTS
  Widget _buildStudentsTab() {
    final filteredList = _studentsList.where((student) {
      final q = _studentSearchQuery.toLowerCase();
      final name = (student['name'] as String).toLowerCase();
      final cls = (student['class'] as String).toLowerCase();
      final stop = (student['stop'] as String).toLowerCase();
      return name.contains(q) || cls.contains(q) || stop.contains(q);
    }).toList();

    return Column(
      children: [
        // Search Bar Top Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(22),
            ),
            child: TextField(
              controller: _studentSearchController,
              onChanged: (val) {
                setState(() {
                  _studentSearchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search students by name, class or stop...',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(LucideIcons.search, size: 18, color: Color(0xFF64748B)),
                suffixIcon: _studentSearchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18, color: Color(0xFF64748B)),
                        onPressed: () {
                          _studentSearchController.clear();
                          setState(() {
                            _studentSearchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),

        // Count Banner
        Container(
          width: double.infinity,
          color: const Color(0xFFF8F9FD),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing ${filteredList.length} of ${_studentsList.length} Assigned Students',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              Row(
                children: [
                  _buildMiniDot(const Color(0xFF10B981), 'Boarded'),
                  const SizedBox(width: 8),
                  _buildMiniDot(const Color(0xFFF59E0B), 'Pending'),
                  const SizedBox(width: 8),
                  _buildMiniDot(const Color(0xFFEF4444), 'Absent'),
                ],
              ),
            ],
          ),
        ),

        // Students ListView
        Expanded(
          child: filteredList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.userX, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text(
                        'No matching students found',
                        style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    final String name = item['name'];
                    final String cls = item['class'];
                    final String stop = item['stop'];
                    final String status = item['status'];
                    final String initials = item['initials'];
                    final Color avatarColor = item['avatarColor'];
                    final String time = item['time'];

                    Color statusBg;
                    Color statusColor;
                    if (status == 'Boarded') {
                      statusBg = const Color(0xFFD1FAE5);
                      statusColor = const Color(0xFF065F46);
                    } else if (status == 'Pending') {
                      statusBg = const Color(0xFFFEF3C7);
                      statusColor = const Color(0xFF92400E);
                    } else {
                      statusBg = const Color(0xFFFEE2E2);
                      statusColor = const Color(0xFF991B1B);
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Row(
                        children: [
                          // Student Avatar / Photo
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: avatarColor.withValues(alpha: 0.15),
                            child: Text(
                              initials,
                              style: TextStyle(
                                color: avatarColor,
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
                                Row(
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E1E2D),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        cls,
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(LucideIcons.mapPin, size: 12, color: Color(0xFF7A7A9D)),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        stop,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF7A7A9D),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
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

  Widget _buildMiniDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  // TAB 3: STAFF
  Widget _buildStaffTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assigned Fleet Crew & Staff',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Licensed driver and assigned transport attendant for this vehicle',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF7A7A9D),
            ),
          ),
          const SizedBox(height: 14),

          ..._staffList.map((staff) {
            final String name = staff['name'];
            final String designation = staff['designation'];
            final String role = staff['role'];
            final String stop = staff['stop'];
            final String status = staff['status'];
            final String phone = staff['phone'];
            final String initials = staff['initials'];
            final Color avatarColor = staff['avatarColor'];

            Color statusBg;
            Color statusColor;
            if (status == 'On Duty' || status == 'Boarded') {
              statusBg = const Color(0xFFD1FAE5);
              statusColor = const Color(0xFF065F46);
            } else {
              statusBg = const Color(0xFFE0F2FE);
              statusColor = const Color(0xFF0369A1);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: const Color(0xFFF0EDF8)),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: avatarColor.withValues(alpha: 0.15),
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: avatarColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E2D),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3EEFF),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    role,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6C4CF1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              designation,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF7A7A9D),
                                fontWeight: FontWeight.w500,
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
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFF0EDF8)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, size: 14, color: Color(0xFF7A7A9D)),
                      const SizedBox(width: 6),
                      Text(
                        'Duty Location: $stop',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(LucideIcons.phoneCall, size: 14, color: Color(0xFF6C4CF1)),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            phone,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // TAB 4: ROUTE
  Widget _buildRouteTab(String routeName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route Header Overview Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(LucideIcons.navigation, color: Color(0xFF6C4CF1), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            routeName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Morning Pickup Schedule • 6 Scheduled Stops',
                            style: TextStyle(fontSize: 12, color: Color(0xFF7A7A9D)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFF0EDF8)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRouteStat('18.4 km', 'Total Distance'),
                    Container(width: 1, height: 20, color: const Color(0xFFF0EDF8)),
                    _buildRouteStat('45 Mins', 'Est. Duration'),
                    Container(width: 1, height: 20, color: const Color(0xFFF0EDF8)),
                    _buildRouteStat('Stop 3 of 6', 'Current Progress'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Route Stops Progress Timeline',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),

          // Vertical Stepper Timeline
          ...List.generate(_routeStops.length, (index) {
            final stop = _routeStops[index];
            final bool isLast = index == _routeStops.length - 1;
            final String status = stop['status'];
            final String name = stop['name'];
            final String scheduledTime = stop['time'];
            final String actualTime = stop['actualTime'];
            final int students = stop['studentsCount'];
            final String address = stop['address'];

            Widget iconWidget;
            Color lineDecorationColor = const Color(0xFFE2E8F0);

            if (status == 'Completed') {
              lineDecorationColor = const Color(0xFF10B981);
              iconWidget = Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.check, color: Colors.white, size: 15),
              );
            } else if (status == 'Current') {
              lineDecorationColor = const Color(0xFF6C4CF1);
              iconWidget = Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C4CF1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C4CF1).withValues(alpha: 0.35),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(LucideIcons.mapPin, color: Colors.white, size: 15),
                ),
              );
            } else if (status == 'Destination') {
              iconWidget = Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E2D),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.flag, color: Colors.white, size: 13),
              );
            } else {
              iconWidget = Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF94A3B8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline Stepper Line & Dot
                  SizedBox(
                    width: 32,
                    child: Column(
                      children: [
                        iconWidget,
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 3,
                              color: lineDecorationColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Stop Detail Card
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: status == 'Current' ? const Color(0xFFF5F3FF) : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(
                          color: status == 'Current'
                              ? const Color(0xFF6C4CF1)
                              : const Color(0xFFF0EDF8),
                          width: status == 'Current' ? 1.5 : 1.0,
                        ),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: status == 'Current'
                                        ? const Color(0xFF6C4CF1)
                                        : const Color(0xFF1E1E2D),
                                  ),
                                ),
                              ),
                              if (status == 'Current')
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6C4CF1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'LIVE NOW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            address,
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(LucideIcons.clock, size: 12, color: Color(0xFF64748B)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Sched: $scheduledTime',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '• $actualTime',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: status == 'Completed'
                                          ? const Color(0xFF10B981)
                                          : (status == 'Current' ? const Color(0xFF6C4CF1) : const Color(0xFF94A3B8)),
                                    ),
                                  ),
                                ],
                              ),
                              if (students > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '$students Students',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRouteStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A9D)),
        ),
      ],
    );
  }
}

// Delegate for Sticky TabBar in NestedScrollView
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) {
    return false;
  }
}
