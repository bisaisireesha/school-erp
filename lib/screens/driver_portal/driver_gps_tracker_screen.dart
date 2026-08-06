import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class DriverGpsTrackerScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(String screenKey)? onNavigate;

  const DriverGpsTrackerScreen({
    super.key,
    required this.data,
    this.onNavigate,
  });

  @override
  State<DriverGpsTrackerScreen> createState() => _DriverGpsTrackerScreenState();
}

class _DriverGpsTrackerScreenState extends State<DriverGpsTrackerScreen>
    with SingleTickerProviderStateMixin {
  bool _isGpsTrackingOn = true; // Default ON
  int _currentStopIndex = 2; // Stop 3
  bool _isMapExpanded = false;

  // Real-time GPS Geofence & Proximity Logic State
  bool _isWithinGeofence = false; // Disabled until driver enters <=50m geofence
  bool _hasSentProximityNotification = false; // Tracks 5-10 min ETA notification
  int _distanceMeters = 240; // Current distance to current stop
  int _etaMinutes = 7; // Current ETA in minutes

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> _stops = [
    {"name": "Stop 1: Oakwood Gardens", "status": "Visited"},
    {"name": "Stop 2: Pine Crest Apts", "status": "Visited"},
    {"name": "Stop 3: Green Glen Complex", "status": "Arriving"},
    {"name": "Stop 4: Sunrise Club House", "status": "Pending"},
    {"name": "Stop 5: City Metro Crossing", "status": "Pending"},
    {"name": "Destination: Sunrise Campus", "status": "Pending"},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Automatically check 5-10 min proximity notification on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkProximityNotifications();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _checkProximityNotifications() {
    if (_etaMinutes >= 5 && _etaMinutes <= 10 && !_hasSentProximityNotification && _isGpsTrackingOn) {
      _hasSentProximityNotification = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF3B82F6),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              const Icon(LucideIcons.bell, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Automated GPS Alert (Parents, Students & Admin)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white70),
                    ),
                    Text(
                      'Your bus will arrive in approximately $_etaMinutes minutes at ${_stops[_currentStopIndex]['name']}.',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _simulateEnterGeofence() {
    setState(() {
      _isWithinGeofence = true;
      _distanceMeters = 25;
      _etaMinutes = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(LucideIcons.mapPin, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '📍 Bus entered Stop Geofence (25m)! "Arrived" button is now ENABLED.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleGpsTracking(bool value) {
    setState(() {
      _isGpsTrackingOn = value;
      if (value) {
        _checkProximityNotifications();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF6C4CF1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(
              _isGpsTrackingOn ? LucideIcons.radio : LucideIcons.radioReceiver,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _isGpsTrackingOn
                    ? 'GPS Tracking ON: Sharing live location with parents & school admin.'
                    : 'GPS Tracking OFF: Location sharing paused.',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markCurrentStopArrived() {
    if (!_isWithinGeofence) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Row(
            children: [
              Icon(LucideIcons.lock, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Cannot mark Arrived! Bus must be within the configured stop geofence (<=50m).',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    final arrivedStopName = _stops[_currentStopIndex]['name']!;

    setState(() {
      if (_currentStopIndex < _stops.length - 1) {
        _stops[_currentStopIndex]['status'] = 'Visited';
        _currentStopIndex++;
        if (_currentStopIndex < _stops.length - 1) {
          _stops[_currentStopIndex]['status'] = 'Arriving';
        } else {
          _stops[_currentStopIndex]['status'] = 'Reached Destination';
        }
      }
      // Reset geofence state for the next stop
      _isWithinGeofence = false;
      _hasSentProximityNotification = false;
      _distanceMeters = 350;
      _etaMinutes = 8;
    });

    // Check proximity notification for new stop
    _checkProximityNotifications();

    // Trigger arrival notification to assigned parents, students, and admin
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Automated Notification Sent (Parents, Students & Admin)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white70),
                  ),
                  Text(
                    'Bus has arrived at $arrivedStopName.',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStopName = _stops[_currentStopIndex]['name']!;
    final nextStopName = (_currentStopIndex < _stops.length - 1)
        ? _stops[_currentStopIndex + 1]['name']!
        : 'Destination Reached';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 0,
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        bottom: 90,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Warm Welcoming Hero Greeting Card with Subtle Morning Graphic
          _buildHeroGreetingCard(),

          const SizedBox(height: 16),

          // 2. Compact GPS Live Tracking Card (Directly below Greeting)
          _buildCompactGpsTrackingCard(),

          const SizedBox(height: 16),

          // 3. Single Clean Route Summary Card (Current Trip Focus)
          _buildSingleRouteSummaryCard(currentStopName, nextStopName),

          const SizedBox(height: 16),

          // 4. Live Route Map Section (Google Maps Preview)
          _buildRealisticLiveGpsMap(),
        ],
      ),
    );
  }

  // --- 1. WARM WELCOMING HERO GREETING CARD ---
  Widget _buildHeroGreetingCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF3EEFF), Color(0xFFFAFAFF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: AppShadows.soft,
        border: Border.all(color: const Color(0xFFECE8F8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Column: Date/Shift Badge + Large Greeting + Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C4CF1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.sun, size: 12, color: Color(0xFF6C4CF1)),
                      SizedBox(width: 4),
                      Text(
                        'Sun, 02 Aug • Shift 1 Active',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hello, Rajesh 👋',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Let\'s start your day! • Ready for today\'s route?',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF7A7A9D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Right Side: Subtle Low-Opacity Morning Sun & Bus Graphic
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFF6C4CF1).withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF6C4CF1).withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  LucideIcons.sun,
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                  size: 40,
                ),
                const Icon(
                  LucideIcons.bus,
                  color: Color(0xFF6C4CF1),
                  size: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. SINGLE CLEAN ROUTE SUMMARY CARD (Current Trip Focus) ---
  Widget _buildSingleRouteSummaryCard(String currentStop, String nextStop) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: AppShadows.soft,
        border: Border.all(color: const Color(0xFFECE8F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header Row: Route Name & On Duty Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Route 1 - Green Glen Express',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'BUS-01 • KA-05-EX-4029',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(LucideIcons.shieldCheck, size: 13, color: Color(0xFF10B981)),
                    SizedBox(width: 4),
                    Text(
                      'ON DUTY',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF0EDF8)),
          const SizedBox(height: 14),

          // Current Trip Info & ETA Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EEFF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Morning Pickup',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.clock, size: 12, color: Color(0xFF6C4CF1)),
                    const SizedBox(width: 4),
                    Text(
                      'ETA: $_etaMinutes mins',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Current Stop Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CURRENT STOP',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A7A9D),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                currentStop,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Real-time GPS Geofence Proximity Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: _isWithinGeofence
                  ? const Color(0xFFECFDF5)
                  : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isWithinGeofence
                    ? const Color(0xFFA7F3D0)
                    : const Color(0xFFFDE68A),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        _isWithinGeofence ? LucideIcons.checkCircle2 : LucideIcons.mapPin,
                        size: 14,
                        color: _isWithinGeofence ? const Color(0xFF10B981) : const Color(0xFFD97706),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _isWithinGeofence
                              ? 'Inside Geofence ($_distanceMeters m) • Stop Reached'
                              : 'Approaching Stop ($_distanceMeters m) • Outside Geofence',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _isWithinGeofence ? const Color(0xFF047857) : const Color(0xFFB45309),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!_isWithinGeofence)
                  GestureDetector(
                    onTap: _simulateEnterGeofence,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4CF1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Simulate Enter (25m)',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Next Stop & Geofence-Gated Arrived Button Row
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.arrowRight, size: 14, color: Color(0xFF7A7A9D)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Next: $nextStop',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7A7A9D),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Arrived Action CTA Button (Geofence Gated)
              Tooltip(
                message: _isWithinGeofence
                    ? 'Mark Stop as Completed'
                    : 'Must be within geofence (<=50m) to mark arrived',
                child: ElevatedButton.icon(
                  onPressed: _isWithinGeofence ? _markCurrentStopArrived : null,
                  icon: Icon(
                    _isWithinGeofence ? LucideIcons.checkCircle : LucideIcons.lock,
                    size: 14,
                    color: _isWithinGeofence ? Colors.white : const Color(0xFF94A3B8),
                  ),
                  label: Text(
                    'Arrived',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _isWithinGeofence ? Colors.white : const Color(0xFF94A3B8),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isWithinGeofence ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0),
                    disabledBackgroundColor: const Color(0xFFE2E8F0),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 3. COMPACT GPS LIVE TRACKING CARD ---
  Widget _buildCompactGpsTrackingCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: AppShadows.soft,
        border: Border.all(color: const Color(0xFFECE8F8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isGpsTrackingOn
                      ? const Color(0xFF6C4CF1).withValues(alpha: 0.12)
                      : const Color(0xFFF5F5F7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isGpsTrackingOn ? LucideIcons.radio : LucideIcons.radioReceiver,
                  color: _isGpsTrackingOn ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'GPS Live Tracking',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: _isGpsTrackingOn
                              ? const Color(0xFFECFDF5)
                              : const Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _isGpsTrackingOn ? 'LIVE' : 'OFF',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: _isGpsTrackingOn ? const Color(0xFF10B981) : const Color(0xFF7A7A9D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _isGpsTrackingOn
                        ? 'Broadcasting live to parents & admin'
                        : 'Tracking paused',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7A7A9D),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch.adaptive(
            value: _isGpsTrackingOn,
            activeThumbColor: const Color(0xFF6C4CF1),
            activeTrackColor: const Color(0xFF6C4CF1).withValues(alpha: 0.3),
            onChanged: _toggleGpsTracking,
          ),
        ],
      ),
    );
  }

  // --- 4. REALISTIC GOOGLE / APPLE MAPS STYLE LIVE GPS MAP ---
  Widget _buildRealisticLiveGpsMap() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isMapExpanded ? 500 : 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECE9),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFD8DCE5), width: 1.2),
        boxShadow: AppShadows.soft,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: CustomPaint(
                painter: _RealisticGpsMapPainter(
                  isGpsActive: _isGpsTrackingOn,
                  currentStopIndex: _currentStopIndex,
                ),
              ),
            ),
          ),
          Positioned(
            left: 175,
            top: 160,
            child: ScaleTransition(
              scale: _isGpsTrackingOn ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isGpsTrackingOn ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C4CF1).withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.bus,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Column(
              children: [
                _buildMapCircleButton(
                  icon: _isMapExpanded ? LucideIcons.minimize2 : LucideIcons.maximize2,
                  onTap: () {
                    setState(() {
                      _isMapExpanded = !_isMapExpanded;
                    });
                  },
                ),
                const SizedBox(height: 8),
                _buildMapCircleButton(
                  icon: LucideIcons.crosshair,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Map recentered to live Bus position'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isGpsTrackingOn ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isGpsTrackingOn ? 'Google Maps Live Engine' : 'GPS Signal Paused',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
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

  Widget _buildMapCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: AppShadows.soft,
        ),
        child: Icon(icon, color: const Color(0xFF1E1E2D), size: 16),
      ),
    );
  }
}

class _RealisticGpsMapPainter extends CustomPainter {
  final bool isGpsActive;
  final int currentStopIndex;

  _RealisticGpsMapPainter({required this.isGpsActive, required this.currentStopIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF4F3F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final parkPaint = Paint()..color = const Color(0xFFD8E8D8);
    final parkPath1 = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 20, size.width * 0.35, 90),
        const Radius.circular(16),
      ));
    canvas.drawPath(parkPath1, parkPaint);

    final parkPath2 = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.65, size.width * 0.38, 110),
        const Radius.circular(20),
      ));
    canvas.drawPath(parkPath2, parkPaint);

    final waterPaint = Paint()..color = const Color(0xFFC5E0F6);
    final waterPath = Path();
    waterPath.moveTo(0, size.height * 0.15);
    waterPath.quadraticBezierTo(size.width * 0.25, size.height * 0.18, size.width * 0.4, 0);
    waterPath.lineTo(0, 0);
    waterPath.close();
    canvas.drawPath(waterPath, waterPaint);

    final secondaryRoadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final primaryHighwayOutline = Paint()
      ..color = const Color(0xFFDCD6CD)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final primaryHighwayFill = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final streetGrid = Path();
    streetGrid.moveTo(0, 100); streetGrid.lineTo(size.width, 100);
    streetGrid.moveTo(0, 220); streetGrid.lineTo(size.width, 220);
    streetGrid.moveTo(0, 320); streetGrid.lineTo(size.width, 320);
    streetGrid.moveTo(size.width * 0.25, 0); streetGrid.lineTo(size.width * 0.25, size.height);
    streetGrid.moveTo(size.width * 0.75, 0); streetGrid.lineTo(size.width * 0.75, size.height);
    canvas.drawPath(streetGrid, secondaryRoadPaint);

    final highwayPath = Path();
    highwayPath.moveTo(35, size.height * 0.85);
    highwayPath.lineTo(35, size.height * 0.6);
    highwayPath.quadraticBezierTo(40, size.height * 0.45, 120, size.height * 0.45);
    highwayPath.lineTo(size.width * 0.52, size.height * 0.45);
    highwayPath.quadraticBezierTo(size.width * 0.72, size.height * 0.45, size.width * 0.72, size.height * 0.28);
    highwayPath.lineTo(size.width * 0.72, 45);

    canvas.drawPath(highwayPath, primaryHighwayOutline);
    canvas.drawPath(highwayPath, primaryHighwayFill);

    final polylineGlow = Paint()
      ..color = const Color(0xFF6C4CF1).withValues(alpha: 0.25)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final polylinePath = Paint()
      ..color = isGpsActive ? const Color(0xFF6C4CF1) : const Color(0xFF94A3B8)
      ..strokeWidth = 6.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(highwayPath, polylineGlow);
    canvas.drawPath(highwayPath, polylinePath);

    _drawVisitedStopPin(canvas, const Offset(35, 340));
    _drawTextBadge(canvas, "Stop 1", const Offset(48, 332), const Color(0xFF10B981));

    _drawVisitedStopPin(canvas, const Offset(35, 240));
    _drawTextBadge(canvas, "Stop 2", const Offset(48, 232), const Color(0xFF10B981));

    _drawTargetStopPin(canvas, const Offset(195, 190));
    _drawTextBadge(canvas, "Stop 3 (Arriving)", const Offset(140, 155), const Color(0xFF6C4CF1));

    _drawPendingStopPin(canvas, Offset(size.width * 0.72, 170));
    _drawTextBadge(canvas, "Stop 4", Offset(size.width * 0.72 + 14, 162), const Color(0xFF7A7A9D));

    _drawDestinationPin(canvas, Offset(size.width * 0.72, 45));
    _drawTextBadge(canvas, "Sunrise Academy Campus 🏫", Offset(size.width * 0.72 - 70, 18), const Color(0xFF6C4CF1));
  }

  void _drawVisitedStopPin(Canvas canvas, Offset pos) {
    final fill = Paint()..color = const Color(0xFF10B981);
    final border = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(pos, 8, fill);
    canvas.drawCircle(pos, 8, border);
    canvas.drawCircle(pos, 3, Paint()..color = Colors.white);
  }

  void _drawTargetStopPin(Canvas canvas, Offset pos) {
    final ring = Paint()
      ..color = const Color(0xFF6C4CF1).withValues(alpha: 0.3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final fill = Paint()..color = const Color(0xFF6C4CF1);
    final border = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(pos, 14, ring);
    canvas.drawCircle(pos, 9, fill);
    canvas.drawCircle(pos, 9, border);
  }

  void _drawPendingStopPin(Canvas canvas, Offset pos) {
    final fill = Paint()..color = const Color(0xFF94A3B8);
    final border = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(pos, 7, fill);
    canvas.drawCircle(pos, 7, border);
  }

  void _drawDestinationPin(Canvas canvas, Offset pos) {
    final fill = Paint()..color = const Color(0xFF6C4CF1);
    final border = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(pos, 11, fill);
    canvas.drawCircle(pos, 11, border);
  }

  void _drawTextBadge(Canvas canvas, String text, Offset pos, Color color) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 10.5,
        fontWeight: FontWeight.bold,
        backgroundColor: Colors.white.withValues(alpha: 0.9),
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant _RealisticGpsMapPainter oldDelegate) {
    return oldDelegate.isGpsActive != isGpsActive || oldDelegate.currentStopIndex != currentStopIndex;
  }
}
