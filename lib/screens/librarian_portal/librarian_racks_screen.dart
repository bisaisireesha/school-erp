import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianRacksScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const LibrarianRacksScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<LibrarianRacksScreen> createState() => _LibrarianRacksScreenState();
}

class _LibrarianRacksScreenState extends State<LibrarianRacksScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _racks = [
    {
      'rackNo': 'Rack A-04',
      'aisle': 'Aisle A (Fiction & Literature)',
      'floor': 'Floor 2 - East Wing',
      'category': 'Fiction',
      'currentBooks': 185,
      'capacity': 200,
      'status': 'Optimal',
      'color': const Color(0xFF10B981),
      'bg': const Color(0xFFECFDF5),
    },
    {
      'rackNo': 'Rack S-12',
      'aisle': 'Aisle S (Science & Tech)',
      'floor': 'Floor 2 - West Wing',
      'category': 'Science',
      'currentBooks': 240,
      'capacity': 250,
      'status': 'Near Capacity',
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFFFBEB),
    },
    {
      'rackNo': 'Rack T-02',
      'aisle': 'Aisle T (Computer Science & AI)',
      'floor': 'Floor 3 - Technology Hub',
      'category': 'Technology',
      'currentBooks': 190,
      'capacity': 200,
      'status': 'Optimal',
      'color': const Color(0xFF10B981),
      'bg': const Color(0xFFECFDF5),
    },
    {
      'rackNo': 'Rack H-08',
      'aisle': 'Aisle H (History & World History)',
      'floor': 'Floor 1 - Main Library',
      'category': 'History',
      'currentBooks': 148,
      'capacity': 150,
      'status': 'Near Capacity',
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFFFBEB),
    },
    {
      'rackNo': 'Rack E-05',
      'aisle': 'Aisle E (Social Science & Econ)',
      'floor': 'Floor 1 - South Wing',
      'category': 'Social Science',
      'currentBooks': 180,
      'capacity': 180,
      'status': 'Full',
      'color': const Color(0xFFEF4444),
      'bg': const Color(0xFFFEF2F2),
    },
    {
      'rackNo': 'Rack R-01',
      'aisle': 'Aisle R (Reference & Research)',
      'floor': 'Floor 3 - Silent Study Room',
      'category': 'Reference',
      'currentBooks': 95,
      'capacity': 120,
      'status': 'Optimal',
      'color': const Color(0xFF10B981),
      'bg': const Color(0xFFECFDF5),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddRackModal() {
    final rackCtrl = TextEditingController();
    final aisleCtrl = TextEditingController();
    final floorCtrl = TextEditingController(text: 'Floor 2');
    final capCtrl = TextEditingController(text: '200');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(LucideIcons.boxes, color: Color(0xFFF59E0B), size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Add New Shelf / Rack',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: rackCtrl,
                decoration: InputDecoration(
                  labelText: 'Rack Identifier (e.g. Rack B-06)',
                  filled: true,
                  fillColor: const Color(0xFFF9F8FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: aisleCtrl,
                decoration: InputDecoration(
                  labelText: 'Aisle Location (e.g. Aisle B)',
                  filled: true,
                  fillColor: const Color(0xFFF9F8FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: floorCtrl,
                      decoration: InputDecoration(
                        labelText: 'Floor Location',
                        filled: true,
                        fillColor: const Color(0xFFF9F8FF),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 110,
                    child: TextField(
                      controller: capCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Max Capacity',
                        filled: true,
                        fillColor: const Color(0xFFF9F8FF),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final rack = rackCtrl.text.trim();
                    if (rack.isEmpty) return;
                    final aisle = aisleCtrl.text.trim().isEmpty ? 'Aisle B' : aisleCtrl.text.trim();
                    final int cap = int.tryParse(capCtrl.text.trim()) ?? 200;

                    setState(() {
                      _racks.insert(0, {
                        'rackNo': rack,
                        'aisle': aisle,
                        'floor': floorCtrl.text.trim().isEmpty ? 'Floor 2' : floorCtrl.text.trim(),
                        'category': 'General',
                        'currentBooks': 0,
                        'capacity': cap,
                        'status': 'Optimal',
                        'color': const Color(0xFF10B981),
                        'bg': const Color(0xFFECFDF5),
                      });
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Shelf "$rack" registered successfully!'),
                        backgroundColor: const Color(0xFFF59E0B),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Register Shelf', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _racks.where((r) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return r['rackNo'].toString().toLowerCase().contains(q) ||
          r['aisle'].toString().toLowerCase().contains(q) ||
          r['category'].toString().toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  if (widget.onBack != null)
                    AppBackButton(onPressed: widget.onBack!)
                  else
                    const SizedBox(width: 8),
                  const Text(
                    'Shelves & Rack Management',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(LucideIcons.plus, color: Color(0xFFF59E0B)),
                    onPressed: _showAddRackModal,
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: AppSpacing.searchBarHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEBE8FF)),
                  boxShadow: AppShadows.soft,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Search rack number, aisle or category...',
                    prefixIcon: Icon(LucideIcons.search, size: 18, color: Color(0xFF7A7A9D)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Racks List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF0EDF8)),
                          boxShadow: AppShadows.soft,
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.boxes, size: 36, color: Color(0xFFCDCBE0)),
                            SizedBox(height: 10),
                            Text(
                              'No matching shelves found',
                              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Try searching another rack number, aisle, or location.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final r = filtered[index];
                        final int current = r['currentBooks'] as int;
                        final int maxCap = r['capacity'] as int;
                        final double ratio = maxCap > 0 ? (current / maxCap) : 0.0;
                        final Color color = r['color'] as Color;
                        final Color bg = r['bg'] as Color;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF0EDF8)),
                            boxShadow: AppShadows.soft,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFBEB),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(LucideIcons.boxes, color: Color(0xFFF59E0B), size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r['rackNo'] as String,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E1E2D),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${r['aisle']} • ${r['floor']}',
                                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                    decoration: BoxDecoration(
                                      color: bg,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      r['status'] as String,
                                      style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Capacity Progress Bar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Occupancy: $current / $maxCap Books',
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                  ),
                                  Text(
                                    '${(ratio * 100).toStringAsFixed(1)}%',
                                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: color),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: ratio.clamp(0.0, 1.0),
                                  minHeight: 6,
                                  backgroundColor: const Color(0xFFF3F0FF),
                                  valueColor: AlwaysStoppedAnimation<Color>(color),
                                ),
                              ),
                            ],
                          ),
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
