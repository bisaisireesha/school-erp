import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TransportScreen extends StatefulWidget {
  final VoidCallback onBack;

  const TransportScreen({super.key, required this.onBack});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  // Mock JSON Data for Transport
  final Map<String, dynamic> _mockTransportData = {
    'busNumber': '42',
    'route': 'Blue Route - Downtown',
    'driverName': 'Michael Chen',
    'driverPhone': '+1 (555) 123-4567',
    'vehiclePlate': 'ABC-1234',
    'status': 'In Transit',
    'currentStopIndex': 2,
    'stops': [
      {'name': 'Central Station', 'time': '07:15 AM', 'status': 'passed', 'details': 'Boarding point. Route starts via Main St.', 'distance': '0 km'},
      {'name': 'Oakwood Library', 'time': '07:25 AM', 'status': 'passed', 'details': 'Stop near the north gate. Traffic usually moderate.', 'distance': '2.4 km'},
      {'name': 'Main Street Corner', 'time': '07:35 AM', 'status': 'current', 'details': 'Approaching stop. Please prepare to board.', 'distance': '4.1 km'},
      {'name': 'Riverside Complex', 'time': '07:45 AM', 'status': 'upcoming', 'details': 'Scheduled stop. Wait near block B entrance.', 'distance': '6.8 km'},
      {'name': 'School Campus', 'time': '08:00 AM', 'status': 'upcoming', 'details': 'Final destination. Drop off at main portico.', 'distance': '10.5 km'},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
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
                        const Text('Transport', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const Spacer(),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F0FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(LucideIcons.bus, size: 20, color: Color(0xFF6C4CF1)),
                          ),
                      ],
                    ),
                  ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 900) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRouteHeaderCard(),
                                const SizedBox(height: 24),
                                _buildMapCard(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Route Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F0FF),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(_mockTransportData['route'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                _buildRouteTimeline(),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRouteHeaderCard(),
                          const SizedBox(height: 24),
                          _buildMapCard(),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Route Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F0FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(_mockTransportData['route'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildRouteTimeline(),
                        ],
                      );
                    }
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.5), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Map Background
          Container(
            height: 280, 
            decoration: const BoxDecoration(
              color: Color(0xFFF0F3F7),
            ),
            child: Stack(
              children: [
                // Stylized Map Background
                CustomPaint(
                  size: const Size(double.infinity, 280),
                  painter: _MapBackgroundPainter(),
                ),
                
                // Path painter
                CustomPaint(
                  size: const Size(double.infinity, 280),
                  painter: _CurvyRoutePainter(),
                ),
                
                // Location Target icon on top right
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    child: const Icon(LucideIcons.crosshair, color: Color(0xFF6C4CF1), size: 20),
                  ),
                ),
                
                // Start Pin
                Positioned(
                  left: 20,
                  top: 70, 
                  child: Column(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF22C55E), size: 36),
                      const SizedBox(height: 2),
                      const Text('Green Park,\nSector 45', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), textAlign: TextAlign.center),
                    ],
                  ),
                ),
                // End Pin
                Positioned(
                  right: 40,
                  top: 130, 
                  child: Column(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFE11D48), size: 36),
                      const SizedBox(height: 2),
                      const Text('Sunrise\nPublic School', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), textAlign: TextAlign.center),
                    ],
                  ),
                ),
                // Bus Icon 
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 40,
                  top: 100,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: const Color(0xFFF59E0B).withValues(alpha: 0.4), blurRadius: 8)],
                    ),
                    child: const Icon(LucideIcons.bus, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ),
          
          // White container overlapping the map
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4CF1).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.bus, color: Color(0xFF6C4CF1), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Bus is on the way', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                          const SizedBox(height: 4),
                          const Text('Near City Center Market', style: TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
                          const SizedBox(height: 2),
                          const Text('Updated at 07:18 AM', style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: const Color(0xFFDCD2F9),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('ETA to School', style: TextStyle(fontSize: 11, color: Color(0xFF6C6C80))),
                        const SizedBox(height: 4),
                        const Text('12 mins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.bus, color: Color(0xFF6C4CF1), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Route R-12', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F4EA),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Active', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF137333))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Green Park, Sector 45  →  Sunrise Public School', style: TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Pickup Time', style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                  SizedBox(height: 4),
                  Text('07:15 AM', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                ],
              ),
              const SizedBox(width: 24),
              Container(width: 1, height: 32, color: const Color(0xFFF3EEFF)),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Drop Time', style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                  SizedBox(height: 4),
                  Text('02:20 PM', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(24),
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Route Schedule', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(LucideIcons.x, size: 20, color: Color(0xFF1E1E2D)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Flexible(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: _buildRouteTimeline(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF6C4CF1), width: 1),
                  ),
                  child: const Text('View Stops', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bottom Sheet logic removed

  Widget _buildRouteTimeline() {
    List<dynamic> stops = _mockTransportData['stops'];

    if (stops.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text('No stops found', style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: stops.length,
      itemBuilder: (context, index) {
        final stop = stops[index];
        final isLast = index == stops.length - 1;
        
        Color dotColor = stop['status'] == 'passed' ? const Color(0xFF6C4CF1) : 
                         stop['status'] == 'current' ? const Color(0xFF10B981) : const Color(0xFFD1D5DB);
        Color lineColor = stop['status'] == 'passed' || (index < stops.length - 1 && stops[index+1]['status'] == 'current') 
            ? const Color(0xFF6C4CF1) : const Color(0xFFE8E3F8);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Column
              SizedBox(
                width: 65,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    stop['time'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: stop['status'] == 'current' ? FontWeight.bold : FontWeight.normal,
                      color: stop['status'] == 'current' ? const Color(0xFF10B981) : const Color(0xFF9E9E9E),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Timeline Graphics
              SizedBox(
                width: 24,
                child: Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: stop['status'] == 'current' ? Colors.white : dotColor,
                        shape: BoxShape.circle,
                        border: stop['status'] == 'current' ? Border.all(color: const Color(0xFF10B981), width: 5) : null,
                        boxShadow: stop['status'] == 'current' ? [const BoxShadow(color: Color(0xFF10B981), blurRadius: 8)] : null,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 3,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: lineColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Detail Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: stop['status'] == 'current' 
                          ? Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3), width: 1.5)
                          : Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: stop['status'] == 'current' ? const Color(0xFF10B981).withValues(alpha: 0.1) : const Color(0xFFE8E3F8).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                stop['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: stop['status'] == 'current' ? FontWeight.w900 : FontWeight.bold,
                                  color: const Color(0xFF1E1E2D),
                                ),
                              ),
                            ),
                            if (stop['status'] == 'passed')
                              const Icon(LucideIcons.checkCircle2, color: Color(0xFF6C4CF1), size: 18),
                          ],
                        ),
                        if (stop['status'] == 'current') ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.mapPin, size: 12, color: Color(0xFF10B981)),
                                SizedBox(width: 4),
                                Text('Bus is arriving here', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                              ],
                            ),
                          ),
                        ] else if (stop['status'] == 'upcoming') ...[
                          const SizedBox(height: 4),
                          Text('Scheduled', style: TextStyle(fontSize: 12, color: const Color(0xFF9E9E9E))),
                        ],
                      ],
                    ),
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

class _CurvyRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6C4CF1) // Changed to purple to match mockup
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
      
    final path = Path();
    path.moveTo(38, 86);
    path.cubicTo(size.width * 0.3, 86, size.width * 0.35, 140, size.width * 0.5, 100);
    path.cubicTo(size.width * 0.65, 60, size.width * 0.7, 90, size.width * 0.8, 90);
    path.cubicTo(size.width * 0.85, 90, size.width * 0.85, 116, size.width - 38, 116);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw stylized vector map roads
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
      
    final minorRoadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path1 = Path()..moveTo(-20, 40)..quadraticBezierTo(100, 20, 200, 100)..quadraticBezierTo(300, 150, size.width + 20, 120);
    final path2 = Path()..moveTo(100, -20)..quadraticBezierTo(150, 80, 120, 260);
    final path3 = Path()..moveTo(250, -20)..quadraticBezierTo(200, 100, 300, 260);
    final path4 = Path()..moveTo(-20, 180)..quadraticBezierTo(150, 200, size.width + 20, 160);
    final path5 = Path()..moveTo(50, -20)..lineTo(80, 260);
    final path6 = Path()..moveTo(350, -20)..quadraticBezierTo(320, 150, 400, 260);
    
    canvas.drawPath(path5, minorRoadPaint);
    canvas.drawPath(path6, minorRoadPaint);
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
