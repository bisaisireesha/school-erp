import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TransportVehiclesScreen extends StatefulWidget {
  final VoidCallback onBack;
  const TransportVehiclesScreen({super.key, required this.onBack});

  @override
  State<TransportVehiclesScreen> createState() =>
      _TransportVehiclesScreenState();
}

class _TransportVehiclesScreenState extends State<TransportVehiclesScreen> {
  bool _isLoading = true;
  List<dynamic> _allVehicles = [];
  List<dynamic> _filteredVehicles = [];
  final String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Active', 'Idle', 'Maintenance'];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/mock/transport_vehicles.json',
      );
      final data = json.decode(response);

      if (mounted) {
        setState(() {
          _allVehicles = data['vehicles'] ?? [];
          _filteredVehicles = _allVehicles;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading vehicles mock data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterVehicles() {
    setState(() {
      _filteredVehicles = _allVehicles.where((vehicle) {
        // Filter by Status
        bool matchesFilter = true;
        if (_selectedFilter != 'All') {
          matchesFilter = vehicle['status'] == _selectedFilter;
        }

        // Filter by Search
        bool matchesSearch = true;
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          matchesSearch =
              vehicle['id'].toString().toLowerCase().contains(query) ||
              vehicle['driverName'].toString().toLowerCase().contains(query) ||
              vehicle['plateNumber'].toString().toLowerCase().contains(query);
        }

        return matchesFilter && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C4CF1)),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildFilterChips(),
                  _buildVehiclesList(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF1E1E2D),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Fleet Vehicles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              _showAddVehicleBottomSheet(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF6C4CF1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C4CF1).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.plus, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Add Vehicle',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVehicleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddVehicleBottomSheet(
        onSave: (Map<String, dynamic> newVehicle) {
          setState(() {
            _allVehicles.insert(0, newVehicle);
            _filterVehicles();
          });
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                  _filterVehicles();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6C4CF1)
                        : const Color(0xFFF3EEFF),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF6C6C80),
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehiclesList() {
    if (_filteredVehicles.isEmpty) {
      return const Center(
        child: Text(
          'No vehicles found.',
          style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      itemCount: _filteredVehicles.length,
      itemBuilder: (context, index) {
        final vehicle = _filteredVehicles[index];
        return _buildVehicleCard(vehicle);
      },
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    Color statusColor;
    Color statusBgColor;

    if (vehicle['statusColor'] == 'green') {
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFF0FDF4);
    } else if (vehicle['statusColor'] == 'orange') {
      statusColor = const Color(0xFFF59E0B);
      statusBgColor = const Color(0xFFFEF3C7);
    } else if (vehicle['statusColor'] == 'red') {
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEF2F2);
    } else {
      statusColor = const Color(0xFF6C4CF1);
      statusBgColor = const Color(0xFFF3F0FF);
    }

    final isBus = vehicle['type'].toString().toLowerCase() == 'bus';
    final icon = isBus ? LucideIcons.bus : LucideIcons.car;

    return GestureDetector(
      onTap: () => _showVehicleDetails(
        context,
        vehicle,
        icon,
        statusColor,
        statusBgColor,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF6C4CF1), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vehicle['id'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              vehicle['status'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vehicle['plateNumber'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6C6C80),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF3EEFF), height: 1, thickness: 1.5),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDetailItem(
                  LucideIcons.user,
                  'Driver',
                  vehicle['driverName'],
                ),
                Container(width: 1, height: 32, color: const Color(0xFFF3EEFF)),
                _buildDetailItem(
                  LucideIcons.users,
                  'Capacity',
                  vehicle['capacity'],
                ),
                Container(width: 1, height: 32, color: const Color(0xFFF3EEFF)),
                _buildDetailItem(
                  LucideIcons.map,
                  'Route',
                  vehicle['assignedRoute'].toString().split(' - ').first,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showViewLogsBottomSheet(context, vehicle);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'View Logs',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showAssignDriverBottomSheet(context, vehicle);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4CF1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Assign Driver',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C4CF1),
                          ),
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

  void _showVehicleDetails(
    BuildContext context,
    Map<String, dynamic> vehicle,
    IconData icon,
    Color statusColor,
    Color statusBgColor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F0FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            icon,
                            color: const Color(0xFF6C4CF1),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vehicle['id'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                vehicle['plateNumber'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6C6C80),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            vehicle['status'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFF3EEFF), thickness: 1.5),
                    const SizedBox(height: 24),

                    // Vehicle Info Section
                    const Text(
                      'Vehicle Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      LucideIcons.tag,
                      'Vehicle Type',
                      vehicle['type'] ?? 'N/A',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      LucideIcons.users,
                      'Capacity',
                      vehicle['capacity'] ?? 'N/A',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      LucideIcons.calendar,
                      'Last Inspected',
                      vehicle['lastInspected'] ?? 'Unknown',
                    ),
                    const SizedBox(height: 24),

                    // Driver Info Section
                    const Text(
                      'Driver Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      LucideIcons.user,
                      'Driver Name',
                      vehicle['driverName'] ?? 'Unassigned',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      LucideIcons.phone,
                      'Contact Number',
                      '+91 98765 43210',
                    ),
                    const SizedBox(height: 24),

                    // Route Info Section
                    const Text(
                      'Route Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      LucideIcons.map,
                      'Assigned Route',
                      vehicle['assignedRoute'] ?? 'Unassigned',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      LucideIcons.mapPin,
                      'Start Point',
                      'City Center',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      LucideIcons.navigation,
                      'End Point',
                      'Sunrise Academy',
                    ),
                    const SizedBox(height: 32),

                    // Logs Section
                    const Text(
                      'Recent Logs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLogEntry(
                      'Maintenance Completed',
                      'Oil change & tire rotation',
                      '20 Aug 2026',
                      true,
                    ),
                    _buildLogEntry(
                      'Trip Logged',
                      'Route completed successfully',
                      '19 Aug 2026',
                      false,
                    ),
                    _buildLogEntry(
                      'Trip Logged',
                      'Route completed successfully',
                      '18 Aug 2026',
                      false,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Action Buttons Fixed at Bottom
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          color: Color(0xFF1E1E2D),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditVehicleBottomSheet(context, vehicle);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Edit Vehicle',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6C6C80),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1E1E2D),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _showViewLogsBottomSheet(
    BuildContext context,
    Map<String, dynamic> vehicle,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Logs for ${vehicle['id']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1E2D),
              ),
            ),
            const SizedBox(height: 16),
            _buildLogEntry(
              'Maintenance Completed',
              'Oil change & tire rotation',
              '20 Aug 2026',
              true,
            ),
            _buildLogEntry(
              'Trip Logged',
              'Route 1 completed successfully',
              '19 Aug 2026',
              false,
            ),
            _buildLogEntry(
              'Trip Logged',
              'Route 1 completed successfully',
              '18 Aug 2026',
              false,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLogEntry(
    String title,
    String desc,
    String date,
    bool isMaintenance,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMaintenance
                  ? const Color(0xFFFEF2F2)
                  : const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isMaintenance ? LucideIcons.wrench : LucideIcons.mapPin,
              color: isMaintenance
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF6C4CF1),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6C6C80),
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignDriverBottomSheet(
    BuildContext context,
    Map<String, dynamic> vehicle,
  ) {
    String selectedDriver = vehicle['driverName'] ?? 'Unassigned';
    final List<String> availableDrivers = [
      'Unassigned',
      'Rajesh Kumar',
      'Suresh Singh',
      'Dinesh Patel',
      'Amit Sharma',
    ];
    if (!availableDrivers.contains(selectedDriver)) {
      availableDrivers.insert(1, selectedDriver);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Assign Driver to ${vehicle['id']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Select Driver',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedDriver,
                      icon: const Icon(
                        LucideIcons.chevronDown,
                        color: Color(0xFF9CA3AF),
                        size: 18,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1E1E2D),
                      ),
                      onChanged: (String? newValue) {
                        setModalState(() {
                          selectedDriver = newValue!;
                        });
                      },
                      items: availableDrivers.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        vehicle['driverName'] = selectedDriver;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Confirm Assignment',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: const Color(0xFF9E9E9E)),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1E2D),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showEditVehicleBottomSheet(
    BuildContext context,
    Map<String, dynamic> vehicle,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditVehicleBottomSheet(
        vehicle: vehicle,
        onSave: () {
          setState(() {
            _filterVehicles();
          });
        },
      ),
    );
  }
}

class _AddVehicleBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const _AddVehicleBottomSheet({required this.onSave});

  @override
  State<_AddVehicleBottomSheet> createState() => _AddVehicleBottomSheetState();
}

class _AddVehicleBottomSheetState extends State<_AddVehicleBottomSheet> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _driverController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();

  String _selectedType = 'Bus';
  String _selectedStatus = 'Active';
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _getFormattedDate() {
    if (_selectedDate == null) return 'DD MMM YYYY';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${_selectedDate!.day.toString().padLeft(2, '0')} ${months[_selectedDate!.month - 1]} ${_selectedDate!.year}';
  }

  void _handleSave() {
    String statusColor = 'purple';
    if (_selectedStatus == 'Active') statusColor = 'green';
    if (_selectedStatus == 'Idle') statusColor = 'orange';
    if (_selectedStatus == 'Maintenance') statusColor = 'red';

    final newVehicle = {
      "id": _idController.text.isNotEmpty ? _idController.text : "NEW-VEHICLE",
      "type": _selectedType,
      "capacity": _capacityController.text.isNotEmpty
          ? _capacityController.text
          : "N/A",
      "driverName": _driverController.text.isNotEmpty
          ? _driverController.text
          : "Unassigned",
      "assignedRoute": _routeController.text.isNotEmpty
          ? _routeController.text
          : "Unassigned",
      "status": _selectedStatus,
      "statusColor": statusColor,
      "lastInspected": _selectedDate != null ? _getFormattedDate() : "Unknown",
      "plateNumber": _plateController.text.isNotEmpty
          ? _plateController.text
          : "N/A",
    };

    widget.onSave(newVehicle);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Add New Vehicle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1E2D),
              ),
            ),
            const SizedBox(height: 24),

            // Vehicle ID
            _buildInputField(
              'Vehicle ID',
              'e.g. BUS-06',
              controller: _idController,
            ),
            const SizedBox(height: 16),

            // Plate Number
            _buildInputField(
              'Plate Number',
              'e.g. KA-01-AB-1234',
              controller: _plateController,
            ),
            const SizedBox(height: 16),

            // Capacity & Type row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'Capacity',
                    'e.g. 40 Seats',
                    controller: _capacityController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdownField(
                    'Type',
                    ['Bus', 'Van', 'Minibus'],
                    _selectedType,
                    (val) {
                      setState(() {
                        _selectedType = val!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Driver & Route row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'Driver Name',
                    'e.g. Rajesh Kumar',
                    controller: _driverController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    'Assigned Route',
                    'e.g. Route 1',
                    controller: _routeController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status & Last Inspected row
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    'Status',
                    ['Active', 'Idle', 'Maintenance'],
                    _selectedStatus,
                    (val) {
                      setState(() {
                        _selectedStatus = val!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    'Last Inspected',
                    _getFormattedDate(),
                    context,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Vehicle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: _selectedDate == null
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF1E1E2D),
                    fontSize: 14,
                  ),
                ),
                const Icon(
                  LucideIcons.calendar,
                  color: Color(0xFF9CA3AF),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String hint, {
    IconData? icon,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: icon != null
                  ? Icon(icon, color: const Color(0xFF9CA3AF), size: 18)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items,
    String selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              icon: const Icon(
                LucideIcons.chevronDown,
                color: Color(0xFF9CA3AF),
                size: 18,
              ),
              style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D)),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _EditVehicleBottomSheet extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  final VoidCallback onSave;

  const _EditVehicleBottomSheet({required this.vehicle, required this.onSave});

  @override
  State<_EditVehicleBottomSheet> createState() =>
      _EditVehicleBottomSheetState();
}

class _EditVehicleBottomSheetState extends State<_EditVehicleBottomSheet> {
  late TextEditingController _idController;
  late TextEditingController _plateController;
  late TextEditingController _capacityController;
  late TextEditingController _driverController;
  late TextEditingController _routeController;

  late String _selectedType;
  late String _selectedStatus;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.vehicle['id']);
    _plateController = TextEditingController(
      text: widget.vehicle['plateNumber'],
    );
    _capacityController = TextEditingController(
      text: widget.vehicle['capacity'],
    );
    _driverController = TextEditingController(
      text: widget.vehicle['driverName'],
    );
    _routeController = TextEditingController(
      text: widget.vehicle['assignedRoute'],
    );

    _selectedType = widget.vehicle['type'] ?? 'Bus';
    _selectedStatus = widget.vehicle['status'] ?? 'Active';
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _getFormattedDate() {
    if (_selectedDate == null) {
      return widget.vehicle['lastInspected'] ?? 'Unknown';
    }
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${_selectedDate!.day.toString().padLeft(2, '0')} ${months[_selectedDate!.month - 1]} ${_selectedDate!.year}';
  }

  void _handleSave() {
    String statusColor = 'purple';
    if (_selectedStatus == 'Active') statusColor = 'green';
    if (_selectedStatus == 'Idle') statusColor = 'orange';
    if (_selectedStatus == 'Maintenance') statusColor = 'red';

    widget.vehicle['id'] = _idController.text.isNotEmpty
        ? _idController.text
        : "NEW-VEHICLE";
    widget.vehicle['type'] = _selectedType;
    widget.vehicle['capacity'] = _capacityController.text.isNotEmpty
        ? _capacityController.text
        : "N/A";
    widget.vehicle['driverName'] = _driverController.text.isNotEmpty
        ? _driverController.text
        : "Unassigned";
    widget.vehicle['assignedRoute'] = _routeController.text.isNotEmpty
        ? _routeController.text
        : "Unassigned";
    widget.vehicle['status'] = _selectedStatus;
    widget.vehicle['statusColor'] = statusColor;
    widget.vehicle['lastInspected'] = _getFormattedDate();
    widget.vehicle['plateNumber'] = _plateController.text.isNotEmpty
        ? _plateController.text
        : "N/A";

    widget.onSave();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Edit Vehicle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1E2D),
              ),
            ),
            const SizedBox(height: 24),

            _buildInputField(
              'Vehicle ID',
              'e.g. BUS-06',
              controller: _idController,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              'Plate Number',
              'e.g. KA-01-AB-1234',
              controller: _plateController,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'Capacity',
                    'e.g. 40 Seats',
                    controller: _capacityController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdownField(
                    'Type',
                    ['Bus', 'Van', 'Minibus'],
                    _selectedType,
                    (val) {
                      setState(() {
                        _selectedType = val!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'Driver Name',
                    'e.g. Rajesh Kumar',
                    controller: _driverController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    'Assigned Route',
                    'e.g. Route 1',
                    controller: _routeController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    'Status',
                    ['Active', 'Idle', 'Maintenance'],
                    _selectedStatus,
                    (val) {
                      setState(() {
                        _selectedStatus = val!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    'Last Inspected',
                    _getFormattedDate(),
                    context,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1E1E2D),
                    fontSize: 14,
                  ),
                ),
                const Icon(
                  LucideIcons.calendar,
                  color: Color(0xFF9CA3AF),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String hint, {
    IconData? icon,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: icon != null
                  ? Icon(icon, color: const Color(0xFF9CA3AF), size: 18)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items,
    String selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    if (!items.contains(selectedValue)) {
      items.add(selectedValue);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              icon: const Icon(
                LucideIcons.chevronDown,
                color: Color(0xFF9CA3AF),
                size: 18,
              ),
              style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D)),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
