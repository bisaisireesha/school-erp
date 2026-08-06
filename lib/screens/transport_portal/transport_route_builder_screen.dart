import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

// ─── Route Details Page ───────────────────────────────────────────────────────

class _TransportRouteDetailsPage extends StatelessWidget {
  final Map<String, dynamic> route;

  const _TransportRouteDetailsPage({required this.route});

  @override
  Widget build(BuildContext context) {
    final String name = route['name'] ?? '';
    final String bus = route['bus'] ?? '—';
    final String morning = route['morningTime'] ?? '—';
    final String evening = route['eveningTime'] ?? '—';
    final int stops = route['stopsCount'] ?? 0;
    final String distance = route['distance'] ?? '—';
    final String status = route['status'] ?? 'Active';

    // Mock stop list
    final List<Map<String, dynamic>> stopList = List.generate(stops, (i) {
      final List<String> exampleStops = [
        'School Gate',
        'Green Glen Gate 2',
        'Oakridge Apartments',
        'Metro Pillar 104',
        'Sunrise Club House',
        'Royal Palms Gate 1',
        'City Mall Junction',
        'Lake View Park',
        'Heritage Colony',
        'Depot',
      ];
      final stopName = i < exampleStops.length ? exampleStops[i] : 'Stop ${i + 1}';
      final pickup = TimeOfDay(hour: 7 + i ~/ 4, minute: (i * 7) % 60);
      final drop = TimeOfDay(hour: 15 + i ~/ 4, minute: 30 + (i * 5) % 30);
      return {
        'name': stopName,
        'pickup': _fmt(pickup),
        'drop': _fmt(drop),
        'students': 3 + (i * 4) % 7,
      };
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: () => Navigator.pop(context)),
        title: Text(
          name,
          style: const TextStyle(
            color: Color(0xFF1E1E2D),
            fontWeight: FontWeight.bold,
            fontSize: 17.5,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Edit $name'),
                    backgroundColor: const Color(0xFF6C4CF1),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C4CF1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Edit Route',
                  style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route summary card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                children: [
                  _summaryRow('Assigned Vehicle', bus),
                  const Divider(height: 14, color: Color(0xFFF0EDF8)),
                  _summaryRow('Total Stops', '$stops stops'),
                  const Divider(height: 14, color: Color(0xFFF0EDF8)),
                  _summaryRow('Total Distance', distance),
                  const Divider(height: 14, color: Color(0xFFF0EDF8)),
                  _summaryRow('Status', status,
                      valueColor: status == 'Active' ? const Color(0xFF16A34A) : const Color(0xFF7A7A9D)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Timings
            const Text(
              'Timings',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _timingCard('Morning Pickup', morning, const Color(0xFFF59E0B), LucideIcons.sunrise)),
                const SizedBox(width: 10),
                Expanded(child: _timingCard('Evening Drop', evening, const Color(0xFF6366F1), LucideIcons.sunset)),
              ],
            ),
            const SizedBox(height: 20),

            // Stop list
            const Text(
              'Stops',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.2),
            ),
            const SizedBox(height: 8),
            ...stopList.asMap().entries.map((entry) {
              final i = entry.key;
              final s = entry.value;
              final bool isFirst = i == 0;
              final bool isLast = i == stopList.length - 1;
              return _buildStopRow(s, i + 1, isFirst, isLast);
            }),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  String _fmt(TimeOfDay t) {
    final h = t.hour > 12 ? t.hour - 12 : (t.hour == 0 ? 12 : t.hour);
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: valueColor ?? const Color(0xFF1E1E2D),
          ),
        ),
      ],
    );
  }

  Widget _timingCard(String label, String time, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.18), width: 1.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10.5, color: color, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(time, style: TextStyle(fontSize: 12.5, color: color, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopRow(Map<String, dynamic> s, int index, bool isFirst, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isFirst || isLast ? const Color(0xFF6C4CF1) : const Color(0xFFF3EEFF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isFirst || isLast ? const Color(0xFF6C4CF1) : const Color(0xFFD8D0F7),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: isFirst || isLast ? Colors.white : const Color(0xFF6C4CF1),
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(width: 1.5, height: 32, color: const Color(0xFFE0D8FF)),
          ],
        ),
        const SizedBox(width: 12),

        // Stop info
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s['name'] as String,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${s['students']} students',
                        style: const TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      s['pickup'] as String,
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFFF59E0B), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      s['drop'] as String,
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF6366F1), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Route Builder Main Screen ────────────────────────────────────────────────

class TransportRouteBuilderScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const TransportRouteBuilderScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  State<TransportRouteBuilderScreen> createState() =>
      _TransportRouteBuilderScreenState();
}

class _TransportRouteBuilderScreenState
    extends State<TransportRouteBuilderScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateRouteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return _CreateRouteBottomSheet(
          onSave: (newRoute) {
            setState(() {
              final list = widget.data['routes'] as List?;
              if (list != null) {
                list.add(newRoute);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${newRoute['name']} created successfully'),
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

  @override
  Widget build(BuildContext context) {
    final List routes = widget.data['routes'] as List? ?? [];

    final filtered = _searchQuery.isEmpty
        ? routes
        : routes.where((r) {
            final q = _searchQuery.toLowerCase();
            return (r['name'] as String).toLowerCase().contains(q) ||
                (r['bus'] as String).toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: widget.onBack),
        title: const Text(
          'Route Builder',
          style: TextStyle(
            color: Color(0xFF1E1E2D),
            fontWeight: FontWeight.bold,
            fontSize: 18.5,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: ElevatedButton.icon(
              onPressed: () => _showCreateRouteBottomSheet(context),
              icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
              label: const Text(
                'Add Route',
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
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
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
                  hintText: 'Search routes or vehicles...',
                  hintStyle: TextStyle(
                    color: Color(0xFFB0AABF),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6C4CF1), size: 19),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Route cards
            if (filtered.isEmpty)
              _buildEmptyState()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final r = filtered[index] as Map<String, dynamic>;
                  return _buildRouteCard(r);
                },
              ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> r) {
    final String name = r['name'] ?? 'Route';
    final String bus = r['bus'] ?? '—';
    final int stops = r['stopsCount'] ?? 0;
    final String morning = r['morningTime'] ?? '—';
    final String evening = r['eveningTime'] ?? '—';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => _TransportRouteDetailsPage(route: r),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Route name + stops badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEFF),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    '$stops Stops',
                    style: const TextStyle(
                      color: Color(0xFF6C4CF1),
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Row 2: Vehicle
            Text(
              bus,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF4A4A68),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Row 3: Timings + Edit Route
            Row(
              children: [
                // Morning time
                Expanded(
                  child: Row(
                    children: [
                      const Icon(LucideIcons.sunrise, size: 13, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 4),
                      Text(
                        morning,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF6E6E8D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Evening time
                Expanded(
                  child: Row(
                    children: [
                      const Icon(LucideIcons.sunset, size: 13, color: Color(0xFF6366F1)),
                      const SizedBox(width: 4),
                      Text(
                        evening,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF6E6E8D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit Route link
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _TransportRouteDetailsPage(route: r),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Edit Route',
                        style: TextStyle(
                          color: Color(0xFF6C4CF1),
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF6C4CF1), size: 10),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
              decoration: const BoxDecoration(color: Color(0xFFF3EEFF), shape: BoxShape.circle),
              child: const Icon(LucideIcons.mapPin, color: Color(0xFF6C4CF1), size: 30),
            ),
            const SizedBox(height: 12),
            const Text('No routes found', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            const SizedBox(height: 4),
            const Text('Try a different search term.', style: TextStyle(fontSize: 12.5, color: Color(0xFF7A7A9D))),
          ],
        ),
      ),
    );
  }
}

// ─── Native Bottom Sheet for Create New Route ─────────────────────────────────

class _CreateRouteBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic> route) onSave;

  const _CreateRouteBottomSheet({required this.onSave});

  @override
  State<_CreateRouteBottomSheet> createState() => _CreateRouteBottomSheetState();
}

class _CreateRouteBottomSheetState extends State<_CreateRouteBottomSheet> {
  final TextEditingController _routeNameController = TextEditingController(text: 'Route 5 - Oakridge Express');
  final TextEditingController _morningTimeController = TextEditingController(text: '07:15 AM - 08:05 AM');
  final TextEditingController _eveningTimeController = TextEditingController(text: '03:30 PM - 04:20 PM');

  String _selectedVehicle = 'BUS-01';
  final List<String> _vehicles = ['BUS-01', 'BUS-02', 'BUS-03', 'VAN-04', 'Unassigned'];

  final List<String> _stops = [
    'School Gate',
    'Green Glen Gate 2',
    'Oakridge Apartments',
    'Metro Pillar 104',
    'Sunrise Club House',
  ];

  final List<String> _popularStopSuggestions = [
    'Green Glen Gate 1',
    'Green Glen Gate 2',
    'Oakridge Apartments',
    'Sunrise Main Gate',
    'Sunrise Club House',
    'Metro Pillar 104',
    'Metro Circle',
    'City Station Square',
    'Royal Palms Gate 1',
    'Royal Palms Gate 2',
    'Palm Avenue Junction',
    'Whitefield Crossing',
    'Central Park Gate',
  ];

  @override
  void dispose() {
    _routeNameController.dispose();
    _morningTimeController.dispose();
    _eveningTimeController.dispose();
    super.dispose();
  }

  void _addStop() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SearchableAddStopModal(
          suggestions: _popularStopSuggestions,
          onStopAdded: (stopName) {
            if (stopName.trim().isNotEmpty) {
              setState(() {
                _stops.add(stopName.trim());
              });
            }
          },
        );
      },
    );
  }

  void _removeStop(int index) {
    setState(() {
      _stops.removeAt(index);
    });
  }

  void _handleSave() {
    final String name = _routeNameController.text.trim();
    if (name.isEmpty) return;

    final newRoute = {
      'id': 'R-05',
      'name': name,
      'stopsCount': _stops.length,
      'distance': '12.5 km',
      'bus': _selectedVehicle,
      'morningTime': _morningTimeController.text.trim().isEmpty ? '07:15 AM - 08:05 AM' : _morningTimeController.text.trim(),
      'eveningTime': _eveningTimeController.text.trim().isEmpty ? '03:30 PM - 04:20 PM' : _eveningTimeController.text.trim(),
      'status': 'Active',
    };

    widget.onSave(newRoute);
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
                  child: const Icon(LucideIcons.mapPin, color: Color(0xFF6C4CF1), size: 20),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create New Route',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Set up bus routes, timings and stop order',
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
                    // Section 1: Route Specifications
                    _buildSectionHeader('Route Specifications'),
                    const SizedBox(height: 8),

                    // 1. Route Name
                    _buildFieldLabel('Route Name'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _routeNameController,
                      hintText: 'e.g. Route 5 - Oakridge Express',
                    ),
                    const SizedBox(height: 12),

                    // 2. Assign Vehicle
                    _buildFieldLabel('Assign Vehicle'),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      value: _selectedVehicle,
                      items: _vehicles,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedVehicle = val);
                      },
                    ),
                    const SizedBox(height: 12),

                    // 3. Morning Pickup Time
                    _buildFieldLabel('Morning Pickup Time'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _morningTimeController,
                      hintText: 'e.g. 07:15 AM - 08:05 AM',
                    ),
                    const SizedBox(height: 12),

                    // 4. Evening Drop Time
                    _buildFieldLabel('Evening Drop Time'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _eveningTimeController,
                      hintText: 'e.g. 03:30 PM - 04:20 PM',
                    ),
                    const SizedBox(height: 18),

                    // Section 2: Route Stops & Sequence
                    _buildSectionHeader('Route Stops & Sequence'),
                    const SizedBox(height: 8),

                    // 5. Add Stop (Dynamic List with Drag to Reorder)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFieldLabel('Stops Sequence (${_stops.length})'),
                        GestureDetector(
                          onTap: _addStop,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3EEFF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.add_rounded, color: Color(0xFF6C4CF1), size: 16),
                                SizedBox(width: 2),
                                Text(
                                  'Add Stop',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6C4CF1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Reorderable Stop List Container
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                        boxShadow: AppShadows.soft,
                      ),
                      child: ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _stops.length,
                        onReorderItem: (oldIndex, newIndex) {
                          setState(() {
                            final item = _stops.removeAt(oldIndex);
                            _stops.insert(newIndex, item);
                          });
                        },
                        itemBuilder: (context, index) {
                          final stopName = _stops[index];
                          return Container(
                            key: ValueKey('$stopName-$index'),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFF0EDF8), width: 1.0),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.drag_handle_rounded, color: Color(0xFFB0AABF), size: 20),
                                const SizedBox(width: 10),
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3EEFF),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6C4CF1),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    stopName,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _removeStop(index),
                                  child: const Icon(LucideIcons.trash2, color: Color(0xFFEF4444), size: 16),
                                ),
                              ],
                            ),
                          );
                        },
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

                // Create Route (Primary)
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
                        'Create Route',
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
        style: const TextStyle(
          fontSize: 14.0,
          color: Color(0xFF1E1E2D),
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF9E9AB8),
            fontSize: 14.0,
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

// ─── Searchable Add Stop Modal Component ─────────────────────────────────────

class _SearchableAddStopModal extends StatefulWidget {
  final List<String> suggestions;
  final ValueChanged<String> onStopAdded;

  const _SearchableAddStopModal({
    required this.suggestions,
    required this.onStopAdded,
  });

  @override
  State<_SearchableAddStopModal> createState() => _SearchableAddStopModalState();
}

class _SearchableAddStopModalState extends State<_SearchableAddStopModal> {
  final TextEditingController _stopNameController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _stopNameController.dispose();
    super.dispose();
  }

  void _submitStop(String name) {
    if (name.trim().isNotEmpty) {
      widget.onStopAdded(name.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final matchingSuggestions = widget.suggestions
        .where((s) => s.toLowerCase().contains(_query.toLowerCase().trim()))
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          const Text(
            'Add Route Stop',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: 2),
          const Text(
            'Type a custom stop name or choose a matching suggestion',
            style: TextStyle(fontSize: 12.0, color: Color(0xFF6E6E8D)),
          ),
          const SizedBox(height: 14),

          // Searchable Input Field
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: TextField(
              controller: _stopNameController,
              onChanged: (val) => setState(() => _query = val),
              style: const TextStyle(fontSize: 15.0, color: Color(0xFF1E1E2D), fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'Type stop name (e.g. Green Glen Gate 2)...',
                hintStyle: const TextStyle(color: Color(0xFF9E9AB8), fontSize: 13.5),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6C4CF1), size: 19),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF6C4CF1)),
                  onPressed: () => _submitStop(_stopNameController.text),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 14),

          const Text(
            'Matching Stop Suggestions',
            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Color(0xFF7A7A9D)),
          ),
          const SizedBox(height: 8),

          // Suggestion List
          Expanded(
            child: matchingSuggestions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.mapPin, color: Color(0xFFCDCBE0), size: 28),
                        const SizedBox(height: 8),
                        Text(
                          'No matching suggestions. Press checkmark to add "$_query"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF6E6E8D)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: matchingSuggestions.length,
                    itemBuilder: (context, index) {
                      final stop = matchingSuggestions[index];
                      return ListTile(
                        onTap: () => _submitStop(stop),
                        dense: true,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        leading: const Icon(LucideIcons.mapPin, size: 16, color: Color(0xFF6C4CF1)),
                        title: Text(
                          stop,
                          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                        ),
                        trailing: const Icon(Icons.add_rounded, size: 18, color: Color(0xFF6C4CF1)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
