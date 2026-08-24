import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TransportRoutesScreen extends StatefulWidget {
  final VoidCallback onBack;

  const TransportRoutesScreen({super.key, required this.onBack});

  @override
  State<TransportRoutesScreen> createState() => _TransportRoutesScreenState();
}

class _TransportRoutesScreenState extends State<TransportRoutesScreen> {
  bool _isLoading = true;
  List<dynamic> _allRoutes = [];
  List<dynamic> _filteredRoutes = [];
  final String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Active', 'Delayed', 'Pending'];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/transport_routes.json');
      final data = json.decode(response);

      if (mounted) {
        setState(() {
          _allRoutes = data ?? []; // it is a direct array
          _filteredRoutes = _allRoutes;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading routes mock data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterRoutes() {
    setState(() {
      _filteredRoutes = _allRoutes.where((route) {
        bool matchesFilter = true;
        if (_selectedFilter != 'All') {
          matchesFilter = route['status'] == _selectedFilter;
        }

        bool matchesSearch = true;
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          matchesSearch =
              route['name'].toString().toLowerCase().contains(query) ||
              route['id'].toString().toLowerCase().contains(query);
        }

        return matchesFilter && matchesSearch;
      }).toList();
    });
  }

  void _showAddRouteBottomSheet(BuildContext context, {Map<String, dynamic>? existingRoute}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddRouteBottomSheet(
        existingRoute: existingRoute,
        onSave: (Map<String, dynamic> newRoute) {
          setState(() {
            if (existingRoute != null) {
              final index = _allRoutes.indexWhere((r) => r['id'] == existingRoute['id']);
              if (index != -1) {
                // Merge old data to keep the mock stops list intact if it exists
                final mergedRoute = Map<String, dynamic>.from(existingRoute)..addAll(newRoute);
                _allRoutes[index] = mergedRoute;
              }
            } else {
              _allRoutes.insert(0, newRoute);
            }
            _filterRoutes();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1)))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildFilterChips(),
                  _buildRoutesList(),
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
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Manage Routes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
          const Spacer(),
          GestureDetector(
            onTap: () {
              _showAddRouteBottomSheet(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF6C4CF1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF6C4CF1).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.plus, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text('Add Route', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
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
                  _filterRoutes();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF3EEFF), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF6C6C80),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
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

  Widget _buildRoutesList() {
    if (_filteredRoutes.isEmpty) {
      return const Center(child: Text('No routes found.', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 16)));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      itemCount: _filteredRoutes.length,
      itemBuilder: (context, index) {
        final route = _filteredRoutes[index];
        return _buildRouteCard(route);
      },
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> route) {
    Color statusColor;
    Color statusBgColor;

    if (route['statusColor'] == 'green') {
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFF0FDF4);
    } else if (route['statusColor'] == 'orange') {
      statusColor = const Color(0xFFF59E0B);
      statusBgColor = const Color(0xFFFEF3C7);
    } else if (route['statusColor'] == 'purple') {
      statusColor = const Color(0xFF8B5CF6);
      statusBgColor = const Color(0xFFF5F3FF);
    } else if (route['statusColor'] == 'red') {
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEF2F2);
    } else {
      statusColor = const Color(0xFF6C4CF1);
      statusBgColor = const Color(0xFFF3F0FF);
    }

    return GestureDetector(
      onTap: () => _showRouteDetails(context, route, statusColor, statusBgColor),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.5), blurRadius: 15, offset: const Offset(0, 5)),
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
                decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(12)),
                child: const Icon(LucideIcons.map, color: Color(0xFF6C4CF1), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            route['name'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(6)),
                          child: Text(route['status'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('ID: ${route['id']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80))),
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
              _buildDetailItem(LucideIcons.bus, 'Vehicle', route['assignedVehicle']),
              Container(width: 1, height: 32, color: const Color(0xFFF3EEFF)),
              _buildDetailItem(LucideIcons.mapPin, 'Stops', '${route['stops']} stops'),
              Container(width: 1, height: 32, color: const Color(0xFFF3EEFF)),
              _buildDetailItem(LucideIcons.user, 'Driver', route['driverName']),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(LucideIcons.arrowRightCircle, color: Color(0xFF6C4CF1), size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('${route['startPoint']}  ➔  ${route['endPoint']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))),
              ],
            ),
          )
        ],
      ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF9CA3AF), size: 16),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Color(0xFF6C6C80), fontSize: 10, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Color(0xFF1E1E2D), fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
        ],
      ),
    );
  }



  void _showRouteDetails(BuildContext context, Map<String, dynamic> route, Color statusColor, Color statusBgColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            
            // Header matching the image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E1E2D), size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      route['name'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, 'edit');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Edit Route', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          _buildCardRow('Assigned Vehicle', route['assignedVehicle'] ?? 'BUS-01'),
                          const Divider(height: 1, color: Color(0xFFF3EEFF)),
                          _buildCardRow('Total Stops', '${route['stops']} stops'),
                          const Divider(height: 1, color: Color(0xFFF3EEFF)),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF))),
                                Text(route['status'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: statusColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Timings
                    const Text('Timings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTimingCard('Morning Pickup', route['morningPickup'] ?? '07:15 AM - 08:05 AM', LucideIcons.sunrise, const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTimingCard('Evening Drop', route['eveningDrop'] ?? '03:30 PM - 04:20 PM', LucideIcons.moon, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Stops Timeline
                    const Text('Stops', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 16),
                    _buildStopsList(route['stopsList'] ?? []),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF))),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
        ],
      ),
    );
  }

  Widget _buildTimingCard(String title, String time, IconData icon, Color primaryColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: primaryColor)),
                const SizedBox(height: 2),
                Text(time, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopsList(List<dynamic> stops) {
    if (stops.isEmpty) return const Text('No stops data available.');
    
    return Column(
      children: List.generate(stops.length, (index) {
        final stop = stops[index];
        final isFirst = index == 0;
        final isLast = index == stops.length - 1;
        
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline graphic
              SizedBox(
                width: 30,
                child: Column(
                  children: [
                    if (!isFirst) Container(width: 1, height: 12, color: const Color(0xFFD1D5DB)),
                    if (isFirst) const SizedBox(height: 12),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: (isFirst || isLast) ? const Color(0xFF6C4CF1) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF6C4CF1), width: (isFirst || isLast) ? 0 : 1.5),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: (isFirst || isLast) ? Colors.white : const Color(0xFF6C4CF1),
                          ),
                        ),
                      ),
                    ),
                    if (!isLast) Expanded(child: Container(width: 1, color: const Color(0xFFD1D5DB))),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              // Stop Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(stop['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                            const SizedBox(height: 4),
                            Text('${stop['students']} students', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(stop['morningTime'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
                          const SizedBox(height: 4),
                          Text(stop['eveningTime'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
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
    );
  }
}

class _AddRouteBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? existingRoute;

  const _AddRouteBottomSheet({required this.onSave, this.existingRoute});

  @override
  State<_AddRouteBottomSheet> createState() => _AddRouteBottomSheetState();
}

class _AddRouteBottomSheetState extends State<_AddRouteBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _morningTimeController = TextEditingController();
  final TextEditingController _eveningTimeController = TextEditingController();
  final List<TextEditingController> _disposedControllers = [];
  
  String _selectedVehicle = 'BUS-01';
  final List<TextEditingController> _stopControllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingRoute != null) {
      final route = widget.existingRoute!;
      _nameController.text = route['name'] ?? '';
      _morningTimeController.text = route['morningPickup'] ?? '';
      _eveningTimeController.text = route['eveningDrop'] ?? '';
      
      final assigned = route['assignedVehicle'] ?? 'BUS-01';
      if (['BUS-01', 'BUS-02', 'VAN-01', 'Unassigned'].contains(assigned)) {
        _selectedVehicle = assigned;
      }
      
      if (route.containsKey('stopsList')) {
        final stops = route['stopsList'] as List<dynamic>;
        for (var stop in stops) {
          _stopControllers.add(TextEditingController(text: stop['name'] ?? ''));
        }
      } else {
        final stopsCount = route['stops'] as int? ?? 0;
        for (int i = 0; i < stopsCount; i++) {
          _stopControllers.add(TextEditingController(text: i == 0 ? (route['startPoint'] ?? '') : (i == stopsCount - 1 ? (route['endPoint'] ?? '') : '')));
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _morningTimeController.dispose();
    _eveningTimeController.dispose();
    for (var controller in _stopControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickTimeRange(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 7, minute: 0),
      helpText: 'Select Start Time',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C4CF1),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E1E2D),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (startTime == null) return;

    if (!context.mounted) return;

    final TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: startTime.hour + 1, minute: startTime.minute),
      helpText: 'Select End Time',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C4CF1),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E1E2D),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (endTime == null) return;

    if (!mounted) return;
    final startStr = startTime.format(context);
    final endStr = endTime.format(context);
    
    setState(() {
      controller.text = '$startStr - $endStr';
    });
  }

  void _addStop() {
    setState(() {
      _stopControllers.add(TextEditingController());
    });
  }

  void _removeStop(int index) {
    setState(() {
      final controller = _stopControllers.removeAt(index);
      _disposedControllers.add(controller);
    });
  }

  void _handleSave() {
    List<Map<String, dynamic>> updatedStops = [];
    for (var i = 0; i < _stopControllers.length; i++) {
       String name = _stopControllers[i].text.isNotEmpty ? _stopControllers[i].text : 'Stop ${i+1}';
       if (widget.existingRoute != null && widget.existingRoute!.containsKey('stopsList') && i < (widget.existingRoute!['stopsList'] as List).length) {
         final oldStop = widget.existingRoute!['stopsList'][i];
         updatedStops.add({
           "name": name,
           "students": oldStop['students'],
           "morningTime": oldStop['morningTime'],
           "eveningTime": oldStop['eveningTime']
         });
       } else {
         updatedStops.add({
           "name": name,
           "students": 0,
           "morningTime": _morningTimeController.text,
           "eveningTime": _eveningTimeController.text
         });
       }
    }

    final newRoute = {
      "id": widget.existingRoute != null ? widget.existingRoute!['id'] : "RT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
      "name": _nameController.text.isNotEmpty ? _nameController.text : "Unnamed Route",
      "startPoint": _stopControllers.isNotEmpty ? _stopControllers.first.text : "Unknown",
      "endPoint": _stopControllers.length > 1 ? _stopControllers.last.text : (_stopControllers.isNotEmpty ? _stopControllers.first.text : "Unknown"),
      "stops": _stopControllers.length,
      "assignedVehicle": _selectedVehicle,
      "driverName": widget.existingRoute != null ? widget.existingRoute!['driverName'] : "Unassigned",
      "status": widget.existingRoute != null ? widget.existingRoute!['status'] : "Active",
      "statusColor": widget.existingRoute != null ? widget.existingRoute!['statusColor'] : "green",
      "morningPickup": _morningTimeController.text,
      "eveningDrop": _eveningTimeController.text,
      "stopsList": updatedStops,
    };

    widget.onSave(newRoute);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Route saved successfully!'), backgroundColor: Color(0xFF10B981)),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header (fixed at top)
          _buildHeader(),
          
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Route Specifications', style: TextStyle(color: Color(0xFF6C4CF1), fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  _buildInputField('Route Name', controller: _nameController, hint: 'e.g. Route 5 - Oakridge Express'),
                  const SizedBox(height: 16),
                  
                  _buildDropdownField('Assign Vehicle', ['BUS-01', 'BUS-02', 'VAN-01', 'Unassigned'], _selectedVehicle, (val) {
                    setState(() { _selectedVehicle = val!; });
                  }),
                  const SizedBox(height: 16),
                  
                  _buildInputField(
                    'Morning Pickup Time',
                    controller: _morningTimeController,
                    hint: 'e.g. 07:15 AM - 08:05 AM',
                    readOnly: true,
                    onTap: () => _pickTimeRange(context, _morningTimeController),
                    suffixIcon: const Icon(LucideIcons.clock, color: Color(0xFF6C4CF1), size: 20),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInputField(
                    'Evening Drop Time',
                    controller: _eveningTimeController,
                    hint: 'e.g. 03:30 PM - 04:20 PM',
                    readOnly: true,
                    onTap: () => _pickTimeRange(context, _eveningTimeController),
                    suffixIcon: const Icon(LucideIcons.clock, color: Color(0xFF6C4CF1), size: 20),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildStopsHeader(),
                  const SizedBox(height: 16),
                  
                  _buildStopsList(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Footer Buttons (fixed at bottom)
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3EEFF), width: 1.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(12)),
            child: const Icon(LucideIcons.mapPin, color: Color(0xFF6C4CF1), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.existingRoute != null ? 'Edit Route' : 'Create New Route', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 4),
                Text(widget.existingRoute != null ? 'Modify bus route details and stops' : 'Set up bus routes, timings and stop order', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6C6C80))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Route Stops & Sequence', style: TextStyle(color: Color(0xFF6C4CF1), fontSize: 16, fontWeight: FontWeight.bold)),
        // The image shows "Stops Sequence (5)" below this header or integrated.
        // Actually, the image has:
        // Route Stops & Sequence (purple header)
        // Stops Sequence (5)  [+ Add Stop]
      ],
    );
  }

  Widget _buildStopsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Stops Sequence (${_stopControllers.length})', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
            GestureDetector(
              onTap: _addStop,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Icon(LucideIcons.plus, color: Color(0xFF6C4CF1), size: 14),
                    SizedBox(width: 4),
                    Text('Add Stop', style: TextStyle(color: Color(0xFF6C4CF1), fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_stopControllers.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stopControllers.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = _stopControllers.removeAt(oldIndex);
                  _stopControllers.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                return _buildStopItem(index, key: ValueKey(controllerId(index)));
              },
            ),
          ),
      ],
    );
  }
  
  // Create a unique key for each controller so ReorderableListView works
  int controllerId(int index) => _stopControllers[index].hashCode;

  Widget _buildStopItem(int index, {required Key key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: index < _stopControllers.length - 1 ? const Border(bottom: BorderSide(color: Color(0xFFF3EEFF))) : null,
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.gripVertical, color: Color(0xFFD1D5DB), size: 20),
          const SizedBox(width: 12),
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(color: Color(0xFFF3F0FF), shape: BoxShape.circle),
            child: Center(child: Text('${index + 1}', style: const TextStyle(color: Color(0xFF6C4CF1), fontSize: 12, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _stopControllers[index],
              decoration: const InputDecoration(
                hintText: 'Enter stop name',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E1E2D)),
            ),
          ),
          GestureDetector(
            onTap: () => _removeStop(index),
            child: const Icon(LucideIcons.trash2, color: Color(0xFFEF4444), size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF6C4CF1), fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(widget.existingRoute != null ? 'Save Changes' : 'Create Route', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, {required TextEditingController controller, required String hint, bool readOnly = false, VoidCallback? onTap, Widget? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFF3EEFF), width: 1.5)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFF3EEFF), width: 1.5)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1))),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> options, String selectedValue, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF6C4CF1)),
              items: options.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D))));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
