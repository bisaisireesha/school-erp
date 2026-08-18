import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TeacherTransportScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const TeacherTransportScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<TeacherTransportScreen> createState() => _TeacherTransportScreenState();
}

class _TeacherTransportScreenState extends State<TeacherTransportScreen> with SingleTickerProviderStateMixin {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  double _sheetPosition = 0.24;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(() {
      if (mounted) {
        setState(() {
          _sheetPosition = _sheetController.size;
        });
      }
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _callDriver(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.phoneCall, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('Calling driver ($phone)...'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _messageDriver(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.messageSquare, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('Message sent to $name'),
          ],
        ),
        backgroundColor: const Color(0xFF6C4CF1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transport = widget.data['transport'] as Map<String, dynamic>? ?? {};
    final String routeName = transport['routeName'] ?? 'Route 04 - East Campus Express';
    final String busNo = transport['busNo'] ?? 'BUS-04';
    final String driverName = transport['driverName'] ?? 'Rajesh Kumar';
    final String driverPhone = transport['driverPhone'] ?? '+1 (555) 789-0123';
    final String vehicleNo = transport['vehicleNumber'] ?? 'KA-04-EA-5921';
    final String driverRating = transport['driverRating'] ?? '4.9';

    final List<Map<String, dynamic>> stops = (transport['stops'] as List?)?.map((s) => Map<String, dynamic>.from(s)).toList() ?? [
      {
        'name': 'East Campus Depot',
        'time': '07:00 AM',
        'status': 'completed',
        'type': 'start',
      },
      {
        'name': 'Greenwood Crossing',
        'time': '07:15 AM',
        'status': 'completed',
        'type': 'stop',
      },
      {
        'name': 'Pinecrest Station (Your Stop)',
        'time': '07:28 AM',
        'status': 'current',
        'type': 'user_stop',
      },
      {
        'name': 'Oakridge Junction',
        'time': '07:42 AM',
        'status': 'upcoming',
        'type': 'stop',
      },
      {
        'name': 'Maple Avenue',
        'time': '07:55 AM',
        'status': 'upcoming',
        'type': 'stop',
      },
      {
        'name': 'Sunrise Campus Gate 2',
        'time': '08:10 AM',
        'status': 'upcoming',
        'type': 'destination',
      },
    ];

    // Dim factor for map when sheet is expanded
    final double dimOpacity = ((_sheetPosition - 0.24) / (0.88 - 0.24)).clamp(0.0, 0.45);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F0),
      body: Stack(
        children: [
          // ─── 1. FULL-SCREEN LIVE MAP LAYER ──────────────────────────────────
          Positioned.fill(
            child: CustomPaint(
              painter: _RealisticGpsMapPainter(),
              child: Stack(
                children: [
                  // Live Bus Pin on the Route
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.38,
                    left: MediaQuery.of(context).size.width * 0.48,
                    child: _buildLiveBusMarker(busNo),
                  ),

                  // User's Stop Pin Marker
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.48,
                    left: MediaQuery.of(context).size.width * 0.62,
                    child: _buildUserStopMarker(),
                  ),

                  // School Campus Pin Marker
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.18,
                    left: MediaQuery.of(context).size.width * 0.70,
                    child: _buildDestinationMarker(),
                  ),
                ],
              ),
            ),
          ),

          // ─── 2. MAP DIM OVERLAY (when bottom sheet expands) ─────────────────
          if (dimOpacity > 0.01)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black.withValues(alpha: dimOpacity),
                ),
              ),
            ),

          // ─── 3. FLOATING TOP CONTROLS (Back Button & LIVE Pill) ─────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button in clean glassmorphic container
                    if (widget.onBack != null)
                      GestureDetector(
                        onTap: widget.onBack,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1E1E2D).withValues(alpha: 0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Color(0xFF1E1E2D),
                              size: 18,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 42),

                    // Floating LIVE Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'LIVE GPS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── 4. RECENTER BUS BUTTON (Floating above peek sheet) ─────────────
          Positioned(
            right: 16,
            bottom: MediaQuery.of(context).size.height * _sheetPosition + 14,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Centered on Bus $busNo'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E1E2D).withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.locateFixed,
                  color: Color(0xFF6C4CF1),
                  size: 20,
                ),
              ),
            ),
          ),

          // ─── 5. DRAGGABLE BOTTOM SHEET (Peek ~180px → Near Full Screen) ─────
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _sheetPosition = notification.extent;
              });
              return true;
            },
            child: DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: 0.24,
              minChildSize: 0.24,
              maxChildSize: 0.88,
              snap: true,
              snapSizes: const [0.24, 0.88],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E1E2D).withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 40.0),
                    children: [
                      // Continuous Drag Handle Bar
                      Center(
                        child: Container(
                          width: 42,
                          height: 4.5,
                          margin: const EdgeInsets.only(bottom: 12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                        ),
                      ),

                      // ─── PEEK SUMMARY HEADER (Always Visible) ─────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  routeName,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E2D),
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Driver: $driverName • Bus $busNo',
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Arrival Alert Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFFDE68A)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🔔', style: TextStyle(fontSize: 12)),
                                SizedBox(width: 4),
                                Text(
                                  'Arriving in 2 min',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Quick ETA row in peek view
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7FC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEBE8F4)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(LucideIcons.clock, size: 16, color: Color(0xFF6C4CF1)),
                                SizedBox(width: 8),
                                Text(
                                  'Est. Arrival at Your Stop',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E1E2D),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '07:28 AM (8 min)',
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C4CF1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // ─── EXPANDED FULL DETAILS (Revealed on Swipe Up) ───────────
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF0EDF8)),
                      const SizedBox(height: 16),

                      // 1. ETA & Status Highlight Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE0D8FF)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C4CF1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(LucideIcons.bus, color: Colors.white, size: 24),
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
                                      const Text(
                                        'On Schedule',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          '2.4 km away',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF475569),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    'Approaching Pinecrest Station',
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2. Driver & Vehicle Card (Interactive Call & Message)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF0EDF8)),
                          boxShadow: AppShadows.soft,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: const Color(0xFFF3F0FF),
                              child: Text(
                                driverName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C4CF1),
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
                                    driverName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.5,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '★ $driverRating • Reg: $vehicleNo',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Call Driver Button
                            GestureDetector(
                              onTap: () => _callDriver(driverPhone),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF5),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFA7F3D0)),
                                ),
                                child: const Icon(LucideIcons.phoneCall, color: Color(0xFF10B981), size: 17),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Message Driver Button
                            GestureDetector(
                              onTap: () => _messageDriver(driverName),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F0FF),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFDDD6FE)),
                                ),
                                child: const Icon(LucideIcons.messageSquare, color: Color(0xFF6C4CF1), size: 17),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. Driver Updates Feed Card (Live Notifications from Driver)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Driver Updates',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                              letterSpacing: -0.2,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.radio, size: 13, color: Color(0xFF10B981)),
                              SizedBox(width: 4),
                              Text(
                                'Live Feed',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF0EDF8)),
                          boxShadow: AppShadows.soft,
                        ),
                        child: Column(
                          children: [
                            _buildDriverUpdateItem(
                              initials: 'RK',
                              message: 'Bus will arrive at Pinecrest Station within 10 mins',
                              time: '2 min ago',
                              isLatest: true,
                            ),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF5F4FA)),
                            _buildDriverUpdateItem(
                              initials: 'RK',
                              message: 'Running 5 mins late due to road construction at Sector 4',
                              time: '14 min ago',
                            ),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF5F4FA)),
                            _buildDriverUpdateItem(
                              initials: 'RK',
                              message: 'All students picked up from Greenwood Crossing',
                              time: '28 min ago',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 4. Route Stops Timeline Header
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Route Stops Timeline',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(
                            '6 Stops Total',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Timeline Items List
                      ...List.generate(stops.length, (index) {
                        final stop = stops[index];
                        final isLast = index == stops.length - 1;
                        return _buildStopTimelineTile(stop, isLast);
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── DRIVER UPDATE LIVE FEED ITEM ─────────────────────────────────────────
  Widget _buildDriverUpdateItem({
    required String initials,
    required String message,
    required String time,
    bool isLatest = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small Driver Avatar
          CircleAvatar(
            radius: 14,
            backgroundColor: isLatest ? const Color(0xFFF3F0FF) : const Color(0xFFF5F5F8),
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: isLatest ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Message & Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1E2D),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8E8EA8),
                  ),
                ),
              ],
            ),
          ),
          if (isLatest) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── STOP TIMELINE TILE COMPONENT ─────────────────────────────────────────
  Widget _buildStopTimelineTile(Map<String, dynamic> stop, bool isLast) {
    final String status = stop['status'] ?? 'upcoming';
    final bool isCompleted = status == 'completed';
    final bool isCurrent = status == 'current';
    final bool isUserStop = stop['type'] == 'user_stop';

    Color nodeColor = const Color(0xFFCBD5E1);
    IconData nodeIcon = LucideIcons.circle;
    if (isCompleted) {
      nodeColor = const Color(0xFF10B981);
      nodeIcon = LucideIcons.check;
    } else if (isCurrent) {
      nodeColor = const Color(0xFF6C4CF1);
      nodeIcon = LucideIcons.bus;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator line + icon node
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFF6C4CF1)
                        : isCompleted
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: nodeColor,
                      width: 2,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: const Color(0xFF6C4CF1).withValues(alpha: 0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Icon(
                      nodeIcon,
                      size: isCurrent ? 13 : 11,
                      color: isCurrent
                          ? Colors.white
                          : isCompleted
                              ? const Color(0xFF10B981)
                              : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: isCompleted ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Stop Name, Time & Status Tag
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                padding: isUserStop ? const EdgeInsets.all(10.0) : EdgeInsets.zero,
                decoration: isUserStop
                    ? BoxDecoration(
                        color: const Color(0xFFF8F7FC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE0D8FF)),
                      )
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stop['name'] ?? '',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: isCurrent || isUserStop ? FontWeight.bold : FontWeight.w600,
                              color: isCurrent || isUserStop ? const Color(0xFF1E1E2D) : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isCompleted
                                ? 'Departed ${stop['time']}'
                                : isCurrent
                                    ? 'Reaching in ~2 mins'
                                    : 'Scheduled for ${stop['time']}',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                              color: isCurrent
                                  ? const Color(0xFF6C4CF1)
                                  : isCompleted
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Next Stop',
                          style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                        ),
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

  // ─── LIVE MAP MARKERS ─────────────────────────────────────────────────────
  Widget _buildLiveBusMarker(String busNo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bus Number Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2D),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            busNo,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),

        // Pulsing Bus Pin
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF6C4CF1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C4CF1).withValues(alpha: 0.4),
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Center(
            child: Icon(LucideIcons.bus, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildUserStopMarker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Your Stop',
            style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF10B981), width: 3),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationMarker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Campus Gate 2',
            style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        const Icon(LucideIcons.mapPin, color: Color(0xFF3B82F6), size: 26),
      ],
    );
  }
}

// ─── HIGH-FIDELITY REALISTIC MAP PAINTER ────────────────────────────────────
class _RealisticGpsMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Base Map Color (Subtle warm parchment)
    final bgPaint = Paint()..color = const Color(0xFFF4F3F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Parks & Green Areas
    final parkPaint = Paint()..color = const Color(0xFFDCEAD8);
    final parkPath1 = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(24, 60, size.width * 0.38, 120),
        const Radius.circular(20),
      ));
    canvas.drawPath(parkPath1, parkPaint);

    final parkPath2 = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.52, size.width * 0.38, 140),
        const Radius.circular(24),
      ));
    canvas.drawPath(parkPath2, parkPaint);

    // 3. Water Body / River
    final waterPaint = Paint()..color = const Color(0xFFC9E2F8);
    final waterPath = Path();
    waterPath.moveTo(0, size.height * 0.28);
    waterPath.quadraticBezierTo(size.width * 0.25, size.height * 0.32, size.width * 0.45, size.height * 0.16);
    waterPath.quadraticBezierTo(size.width * 0.65, 0, size.width * 0.8, 0);
    waterPath.lineTo(0, 0);
    waterPath.close();
    canvas.drawPath(waterPath, waterPaint);

    // 4. Secondary Grid Streets
    final secondaryRoadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final streetGrid = Path();
    streetGrid.moveTo(0, size.height * 0.20); streetGrid.lineTo(size.width, size.height * 0.20);
    streetGrid.moveTo(0, size.height * 0.38); streetGrid.lineTo(size.width, size.height * 0.38);
    streetGrid.moveTo(0, size.height * 0.58); streetGrid.lineTo(size.width, size.height * 0.58);
    streetGrid.moveTo(size.width * 0.22, 0); streetGrid.lineTo(size.width * 0.22, size.height);
    streetGrid.moveTo(size.width * 0.78, 0); streetGrid.lineTo(size.width * 0.78, size.height);
    canvas.drawPath(streetGrid, secondaryRoadPaint);

    // 5. Main Highway Arterials (White with subtle border)
    final primaryHighwayOutline = Paint()
      ..color = const Color(0xFFDCD6CD)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final primaryHighwayFill = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final highwayPath = Path();
    highwayPath.moveTo(20, size.height * 0.75);
    highwayPath.lineTo(size.width * 0.35, size.height * 0.65);
    highwayPath.quadraticBezierTo(size.width * 0.50, size.height * 0.50, size.width * 0.55, size.height * 0.38);
    highwayPath.quadraticBezierTo(size.width * 0.65, size.height * 0.22, size.width * 0.75, size.height * 0.16);
    highwayPath.lineTo(size.width * 0.90, size.height * 0.10);

    canvas.drawPath(highwayPath, primaryHighwayOutline);
    canvas.drawPath(highwayPath, primaryHighwayFill);

    // 6. Active Live Bus Route Glow Path (Purple with cyan/violet gradient effect)
    final routeGlowPaint = Paint()
      ..color = const Color(0xFF6C4CF1).withValues(alpha: 0.25)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routePaint = Paint()
      ..color = const Color(0xFF6C4CF1)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final busRoute = Path();
    busRoute.moveTo(20, size.height * 0.75);
    busRoute.lineTo(size.width * 0.35, size.height * 0.65);
    busRoute.quadraticBezierTo(size.width * 0.50, size.height * 0.50, size.width * 0.55, size.height * 0.38);
    busRoute.quadraticBezierTo(size.width * 0.65, size.height * 0.22, size.width * 0.75, size.height * 0.16);

    canvas.drawPath(busRoute, routeGlowPaint);
    canvas.drawPath(busRoute, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
