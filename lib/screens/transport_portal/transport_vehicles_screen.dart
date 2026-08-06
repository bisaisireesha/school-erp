import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'transport_bus_details_screen.dart';

class TransportVehiclesScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const TransportVehiclesScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  State<TransportVehiclesScreen> createState() => _TransportVehiclesScreenState();
}

class _TransportVehiclesScreenState extends State<TransportVehiclesScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddVehicleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return _AddVehicleBottomSheet(
          onSave: (newVehicle) {
            setState(() {
              final list = widget.data['vehicles'] as List?;
              if (list != null) {
                list.add(newVehicle);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${newVehicle['busNo']} added successfully'),
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

  void _showVehicleDetailsBottomSheet(BuildContext context, Map<String, dynamic> v) {
    final String busNo = v['busNo'] ?? 'BUS-01';
    final String rawStatus = v['status'] ?? 'Idle';
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

    final String driver = v['driver'] ?? 'Unassigned';
    final String route = v['route'] ?? 'No Route';
    final int capacity = v['capacity'] ?? 40;
    final int occupied = v['occupied'] ?? (v['assignedStudents'] ?? 35);
    final String model = v['model'] ?? 'Tata Starbus 40-Seater';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle at top
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

                  // Header: Icon + Bus No + Model + Status Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EEFF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(LucideIcons.bus, color: Color(0xFF6C4CF1), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              busNo,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              model,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF6E6E8D),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Specifications List
                  const Text(
                    'Vehicle Details',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(LucideIcons.user, 'Driver Name', driver),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDetailRow(LucideIcons.mapPin, 'Assigned Route', route),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDetailRow(LucideIcons.users, 'Capacity & Occupancy', '$occupied / $capacity Seats'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Documents List
                  const Text(
                    'Compliance Documents',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Column(
                      children: [
                        _buildDocRow('RTO Fitness Certificate', 'Valid till 14 Nov 2026', 'Valid', const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDocRow('Vehicle Insurance', 'Valid till 28 Dec 2026', 'Valid', const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDocRow('Pollution Check (PUC)', 'Renewal Due (5 Days)', 'Warning', const Color(0xFFD97706), const Color(0xFFFFFBEB)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Actions Row
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context,
                          'Full Details',
                          LucideIcons.bus,
                          const Color(0xFF6C4CF1),
                          () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TransportBusDetailsScreen(vehicleData: v),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          context,
                          'Assign Driver',
                          LucideIcons.userPlus,
                          const Color(0xFF10B981),
                          () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Assign driver for $busNo'),
                                backgroundColor: const Color(0xFF10B981),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          context,
                          'View Route',
                          LucideIcons.mapPin,
                          const Color(0xFF3B82F6),
                          () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TransportBusDetailsScreen(vehicleData: v),
                              ),
                            );
                          },
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF6C4CF1)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 13.0, color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDocRow(String title, String subtitle, String status, Color statusColor, Color statusBg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          const Icon(LucideIcons.fileText, size: 15, color: Color(0xFF6C4CF1)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 10.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.16), width: 1.0),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 17),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = widget.data['vehicles'] as List? ?? [];

    final filtered = _searchQuery.isEmpty
        ? vehicles
        : vehicles.where((v) {
            final q = _searchQuery.toLowerCase();
            return (v['busNo'] as String? ?? '').toLowerCase().contains(q) ||
                (v['driver'] as String? ?? '').toLowerCase().contains(q) ||
                (v['route'] as String? ?? '').toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Fleet Vehicles',
          style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 18.5, letterSpacing: -0.3),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: ElevatedButton.icon(
              onPressed: () => _showAddVehicleBottomSheet(context),
              icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
              label: const Text(
                'Add Vehicle',
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
            // Search Bar directly below Fleet Vehicles header & Add Vehicle button
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.0),
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
                  hintText: 'Search fleet vehicles by bus no, driver or route...',
                  hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13.0, fontWeight: FontWeight.w500),
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6C4CF1), size: 19),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              '${filtered.length} Registered Fleet Vehicles',
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // Fleet Vehicles List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final v = filtered[index];
                final String busNo = v['busNo'] ?? 'BUS-01';
                final String rawStatus = v['status'] ?? 'Idle';
                final String status = rawStatus.contains('Route')
                    ? 'On Route'
                    : (rawStatus.contains('Maintenance') ? 'Maintenance' : 'Idle');

                Color statusColor;
                Color statusBg;
                if (status == 'On Route') {
                  statusColor = const Color(0xFF10B981);
                  statusBg = const Color(0xFF10B981).withValues(alpha: 0.12);
                } else if (status == 'Maintenance') {
                  statusColor = const Color(0xFFEF4444);
                  statusBg = const Color(0xFFEF4444).withValues(alpha: 0.12);
                } else {
                  statusColor = const Color(0xFFD97706);
                  statusBg = const Color(0xFFF59E0B).withValues(alpha: 0.12);
                }

                final String driver = v['driver'] ?? 'Unassigned';
                final String route = v['route'] ?? 'No Route';

                return GestureDetector(
                  onTap: () => _showVehicleDetailsBottomSheet(context, v),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF3EEFF), width: 1.0),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: Vehicle Icon + Vehicle Number & Status Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6C4CF1).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(LucideIcons.bus, color: Color(0xFF6C4CF1), size: 16),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      busNo,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E1E2D),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
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
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Driver Name
                        Row(
                          children: [
                            const Icon(LucideIcons.user, size: 13, color: Color(0xFF7A7A9D)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Driver: $driver',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4A4A68),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Route Name
                        Row(
                          children: [
                            const Icon(LucideIcons.mapPin, size: 13, color: Color(0xFF7A7A9D)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Route: $route',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6E6E8D),
                                ),
                              ),
                            ),
                          ],
                        ),
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

// ─── Native Bottom Sheet for Adding a New Vehicle ───────────────────────────

class _AddVehicleBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic> vehicle) onSave;

  const _AddVehicleBottomSheet({required this.onSave});

  @override
  State<_AddVehicleBottomSheet> createState() => _AddVehicleBottomSheetState();
}

class _AddVehicleBottomSheetState extends State<_AddVehicleBottomSheet> {
  final TextEditingController _busNoController = TextEditingController(text: 'BUS-05');
  final TextEditingController _regNoController = TextEditingController(text: 'KA-01-EA-1234');
  final TextEditingController _modelController = TextEditingController(text: 'Tata Starbus 40-Seater');
  final TextEditingController _capacityController = TextEditingController(text: '40');

  String _selectedDriver = 'Rajesh Kumar';
  String _selectedRoute = 'Route 1 - Green Glen';

  final List<String> _drivers = [
    'Rajesh Kumar',
    'Suresh Patel',
    'Vikram Singh',
    'Anil Verma',
    'Unassigned',
  ];

  final List<String> _routes = [
    'Route 1 - Green Glen',
    'Route 2 - Sunrise Hills',
    'Route 3 - Metro Square',
    'Route 4 - Royal Palms',
    'Unassigned',
  ];

  @override
  void dispose() {
    _busNoController.dispose();
    _regNoController.dispose();
    _modelController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final String busNo = _busNoController.text.trim();
    if (busNo.isEmpty) return;

    final newVehicle = {
      'busNo': busNo,
      'regNo': _regNoController.text.trim(),
      'type': 'Bus',
      'model': _modelController.text.trim().isEmpty ? 'Tata Starbus' : _modelController.text.trim(),
      'driver': _selectedDriver,
      'capacity': int.tryParse(_capacityController.text) ?? 40,
      'occupied': 0,
      'route': _selectedRoute,
      'status': 'Idle',
      'fuel': '100%',
      'gpsStatus': 'In Depot',
      'speed': '0 km/h',
      'compliance': 'Valid',
    };

    widget.onSave(newVehicle);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
                  child: const Icon(LucideIcons.bus, color: Color(0xFF6C4CF1), size: 20),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Vehicle',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Enter required vehicle details to register',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF6E6E8D),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
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
                    // Section 1: Vehicle Specifications
                    _buildSectionHeader('Vehicle Specifications'),
                    const SizedBox(height: 8),

                    // 1. Vehicle Number
                    _buildFieldLabel('Vehicle Number'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _busNoController,
                      hintText: 'e.g. BUS-05',
                    ),
                    const SizedBox(height: 12),

                    // 2. Registration Number
                    _buildFieldLabel('Registration Number'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _regNoController,
                      hintText: 'e.g. KA-01-EA-1234',
                    ),
                    const SizedBox(height: 12),

                    // 3. Make & Model
                    _buildFieldLabel('Make & Model'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _modelController,
                      hintText: 'e.g. Tata Starbus 40-Seater',
                    ),
                    const SizedBox(height: 12),

                    // 3. Seating Capacity
                    _buildFieldLabel('Seating Capacity'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _capacityController,
                      hintText: 'e.g. 40',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Operations & Crew Assignment
                    _buildSectionHeader('Operations & Crew Assignment'),
                    const SizedBox(height: 8),

                    // 4. Assigned Driver
                    _buildFieldLabel('Assigned Driver'),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      value: _selectedDriver,
                      items: _drivers,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedDriver = val);
                      },
                    ),
                    const SizedBox(height: 12),

                    // 5. Assigned Route
                    _buildFieldLabel('Assigned Route'),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      value: _selectedRoute,
                      items: _routes,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedRoute = val);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Action Buttons
            Row(
              children: [
                // Cancel (Outlined)
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

                // Save Vehicle (Primary)
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
                        'Save Vehicle',
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6C4CF1),
        letterSpacing: -0.2,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
        boxShadow: AppShadows.soft,
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14.0,
          color: Color(0xFF1E1E2D),
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF9E9AB8),
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
        boxShadow: AppShadows.soft,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6C4CF1), size: 22),
          isExpanded: true,
          style: const TextStyle(
            fontSize: 14.0,
            color: Color(0xFF1E1E2D),
            fontWeight: FontWeight.w400,
          ),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
