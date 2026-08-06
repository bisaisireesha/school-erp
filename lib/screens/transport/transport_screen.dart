import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TransportScreen extends StatefulWidget {
  final VoidCallback onBack;

  const TransportScreen({super.key, required this.onBack});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  Map<String, dynamic>? _transportData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransportData();
  }

  Future<void> _loadTransportData() async {
    final String response = await rootBundle.loadString('assets/mock/transport.json');
    final data = json.decode(response);
    setState(() {
      _transportData = data;
      _isLoading = false;
    });
  }

  void _showCallDialog(String name, String phone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Row(
          children: [
            const Icon(LucideIcons.phoneCall, color: Color(0xFF6C4CF1)),
            const SizedBox(width: 10),
            Text('Call $name', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Calling $phone...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF7A7A9D))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling $phone...'), backgroundColor: const Color(0xFF22C55E)),
              );
            },
            child: const Text('Call Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showMessageDialog(String name, String phone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Row(
          children: [
            const Icon(LucideIcons.messageSquare, color: Color(0xFF6C4CF1)),
            const SizedBox(width: 10),
            Text('Message $name', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SMS to $phone', style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A9D))),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF7A7A9D))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message sent successfully!'), backgroundColor: Color(0xFF6C4CF1)),
              );
            },
            child: const Text('Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final overview = _transportData!['routeOverview'];
    final emergency = _transportData!['emergency'];
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          // 1. TOP LIVE MAP (Occupies 50% Screen Height as Primary Focus)
          SizedBox(
            height: screenHeight * 0.50,
            width: double.infinity,
            child: Stack(
              children: [
                _buildFullWidthLiveMap(),

                // Header Overlay
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      children: [
                        AppBackButton(onPressed: widget.onBack),
                        const SizedBox(width: AppSpacing.md),
                        const Expanded(
                          child: Text(
                            'Live Bus Tracking',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1E2D),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.radio, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text(
                                'LIVE GPS',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating Compact Schedule Bar at bottom of map
                Positioned(
                  bottom: 12,
                  left: AppSpacing.screenPadding,
                  right: AppSpacing.screenPadding,
                  child: _buildCompactScheduleBar(),
                ),
              ],
            ),
          ),

          // 2. BOTTOM SCROLLABLE DETAILS AREA (Remaining 50%)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.md,
              ),
              child: Column(
                children: [
                  _buildArrivalDetailsCard(overview),
                  const SizedBox(height: AppSpacing.md),
                  _buildDriverCard(overview),
                  const SizedBox(height: AppSpacing.md),
                  _buildEmergencyOfficeCard(emergency),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Full-Width Live Map Background Widget ---
  Widget _buildFullWidthLiveMap() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFE8E5F8),
      child: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: MapRoadPainter(),
          ),

          // Start Stop Pin (School)
          Positioned(
            top: 90,
            left: 40,
            child: _buildMapPin(
              icon: LucideIcons.building,
              color: const Color(0xFF3B82F6),
              label: 'Sunrise Academy',
            ),
          ),

          // Live School Bus Marker
          Positioned(
            top: 150,
            left: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2D),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: AppShadows.soft,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.navigation, color: Color(0xFF22C55E), size: 10),
                      SizedBox(width: 4),
                      Text(
                        '28 km/h · Bus 12',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB300),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFB300).withValues(alpha: 0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(LucideIcons.bus, color: Color(0xFF1E1E2D), size: 18),
                ),
              ],
            ),
          ),

          // Destination Pin (Home)
          Positioned(
            top: 210,
            right: 40,
            child: _buildMapPin(
              icon: LucideIcons.home,
              color: const Color(0xFF6C4CF1),
              label: 'Jubilee Hills (Home)',
              isHome: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin({required IconData icon, required Color color, required String label, bool isHome = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: AppShadows.soft,
          ),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: isHome ? Border.all(color: const Color(0xFF6C4CF1), width: 1.5) : null,
            boxShadow: AppShadows.card,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: isHome ? FontWeight.w900 : FontWeight.bold,
              color: isHome ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D),
            ),
          ),
        ),
      ],
    );
  }

  // --- Compact Floating Schedule Bar ---
  Widget _buildCompactScheduleBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E2D).withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProgressDot('Visited', 'School\n07:15'),
          Expanded(child: Container(height: 2, color: const Color(0xFF22C55E))),
          _buildProgressDot('Current', 'MG Rd\n07:42'),
          Expanded(child: Container(height: 2, color: const Color(0xFF6C4CF1))),
          _buildProgressDot('Upcoming', 'Home\n07:55', isNext: true),
        ],
      ),
    );
  }

  Widget _buildProgressDot(String status, String label, {bool isNext = false}) {
    Color color = status == 'Visited' ? const Color(0xFF22C55E) : (status == 'Current' ? const Color(0xFF6C4CF1) : const Color(0xFF94A3B8));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isNext ? 16 : 12,
          height: isNext ? 16 : 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isNext ? FontWeight.w900 : FontWeight.bold,
            color: isNext ? const Color(0xFF6C4CF1) : const Color(0xFF4A4A68),
            height: 1.1,
          ),
        ),
      ],
    );
  }

  // --- Arrival Details Card Widget ---
  Widget _buildArrivalDetailsCard(Map<String, dynamic> overview) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.clock, color: Color(0xFF6C4CF1), size: 16),
                  SizedBox(width: 6),
                  Text('Arrival Estimate', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  overview['status'],
                  style: const TextStyle(color: Color(0xFF15803D), fontSize: 11, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F5FF),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('ESTIMATED ARRIVAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF7A7A9D))),
                      SizedBox(height: 2),
                      Text('12 Mins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF6C4CF1))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F5FF),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('DISTANCE TO PICKUP', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF7A7A9D))),
                      SizedBox(height: 2),
                      Text('2.4 km', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Driver Details Card Widget ---
  Widget _buildDriverCard(Map<String, dynamic> overview) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF6C4CF1), width: 1.5),
                ),
                child: const Center(
                  child: Text(
                    'RK',
                    style: TextStyle(color: Color(0xFF6C4CF1), fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      overview['driverName'],
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bus: ${overview['busNumber']} · Attendant: ${overview['attendantName']}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () => _showCallDialog(overview['driverName'], overview['driverPhone']),
                    icon: const Icon(LucideIcons.phone, size: 14, color: Colors.white),
                    label: const Text('Call Driver', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton.icon(
                    onPressed: () => _showMessageDialog(overview['driverName'], overview['driverPhone']),
                    icon: const Icon(LucideIcons.messageSquare, size: 14, color: Color(0xFF6C4CF1)),
                    label: const Text('Message', style: TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Emergency Transport Office Contact Card Widget ---
  Widget _buildEmergencyOfficeCard(Map<String, dynamic> emergency) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F0),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: const Color(0xFFFFE4CC), width: 1.5),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF0E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.phoneCall, color: Color(0xFFF97316), size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emergency['officeName'],
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  emergency['phone'],
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFF97316)),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                icon: const Icon(LucideIcons.phone, color: Color(0xFF22C55E), size: 18),
                onPressed: () => _showCallDialog(emergency['officeName'], emergency['phone']),
              ),
              IconButton(
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                icon: const Icon(LucideIcons.messageSquare, color: Color(0xFF6C4CF1), size: 18),
                onPressed: () => _showMessageDialog(emergency['officeName'], emergency['phone']),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom Map Painter for Live Bus Tracking Route Path
class MapRoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintRoute = Paint()
      ..color = const Color(0xFF6C4CF1).withValues(alpha: 0.85)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(40, 90);
    path.quadraticBezierTo(size.width * 0.4, 120, 150, 150);
    path.quadraticBezierTo(size.width * 0.7, 180, size.width - 40, 210);

    canvas.drawPath(path, paintRoad);
    canvas.drawPath(path, paintRoute);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
