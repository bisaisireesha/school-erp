import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:convert';

import '../theme/app_theme.dart';
import 'driver_portal/driver_gps_tracker_screen.dart';
import 'driver_portal/driver_bus_summary_screen.dart';
import 'driver_portal/driver_bus_details_screen.dart';
import 'driver_portal/driver_attendance_screen.dart';
import 'driver_portal/driver_payslip_screen.dart';
import 'driver_portal/driver_leave_request_screen.dart';
import 'driver_portal/driver_expense_screen.dart';
import 'driver_portal/driver_profile_screen.dart';
import 'driver_portal/driver_more_screen.dart';
import 'transport_portal/transport_messages_screen.dart';
import 'transport_portal/transport_calendar_screen.dart';

class DriverMainLayout extends StatefulWidget {
  const DriverMainLayout({super.key});

  static void pushSubScreen(BuildContext context, Widget screen) {
    context.findAncestorStateOfType<_DriverMainLayoutState>()?.pushSubScreen(screen);
  }

  static void popSubScreen(BuildContext context) {
    context.findAncestorStateOfType<_DriverMainLayoutState>()?.popSubScreen();
  }

  @override
  State<DriverMainLayout> createState() => _DriverMainLayoutState();
}

class _DriverMainLayoutState extends State<DriverMainLayout> {
  int _currentIndex = 0; // 0: Home (GPS Tracker), 1: Bus, 2: Messages, 3: More
  Widget? _subScreen;
  Map<String, dynamic> _transportData = {};
  bool _isLoading = true;

  OverlayEntry? _notificationOverlayEntry;
  bool _isNotificationPopoverOpen = false;

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Speed Limit Warning',
      'message': 'Please keep speed under 50 km/h on Sector 4 road.',
      'time': '5m ago',
      'isUnread': true,
      'icon': LucideIcons.triangleAlert,
      'iconColor': const Color(0xFFF59E0B),
      'targetScreen': 'home',
    },
    {
      'id': '2',
      'title': 'Leave Request Approved',
      'message': 'Your Casual Leave application for 12 Aug is approved.',
      'time': '1h ago',
      'isUnread': true,
      'icon': LucideIcons.calendarCheck,
      'iconColor': const Color(0xFF10B981),
      'targetScreen': 'leave_request',
    },
    {
      'id': '3',
      'title': 'July Payslip Ready',
      'message': 'July 2026 salary credited to bank account.',
      'time': '1d ago',
      'isUnread': false,
      'icon': LucideIcons.wallet,
      'iconColor': const Color(0xFF6C4CF1),
      'targetScreen': 'payslips',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadTransportData();
  }

  @override
  void dispose() {
    _hideNotificationPopover();
    super.dispose();
  }

  Future<void> _loadTransportData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/mock/transport_portal_data.json');
      setState(() {
        _transportData = json.decode(jsonString);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void pushSubScreen(Widget screen) {
    _hideNotificationPopover();
    setState(() {
      _subScreen = screen;
    });
  }

  void popSubScreen() {
    _hideNotificationPopover();
    setState(() {
      _subScreen = null;
    });
  }

  void _navigateToScreen(String screenKey) {
    _hideNotificationPopover();
    setState(() {
      if (screenKey == 'home') {
        _currentIndex = 0;
        _subScreen = null;
      } else if (screenKey == 'bus') {
        _currentIndex = 1;
        _subScreen = null;
      } else if (screenKey == 'messages') {
        _currentIndex = 2;
        _subScreen = null;
      } else if (screenKey == 'more') {
        _currentIndex = 3;
        _subScreen = null;
      } else {
        _subScreen = _buildSubScreenWidget(screenKey);
      }
    });
  }

  void _hideNotificationPopover() {
    if (_notificationOverlayEntry != null) {
      _notificationOverlayEntry!.remove();
      _notificationOverlayEntry = null;
      if (mounted) {
        setState(() {
          _isNotificationPopoverOpen = false;
        });
      }
    }
  }

  void _toggleNotificationPopover() {
    if (_isNotificationPopoverOpen) {
      _hideNotificationPopover();
    } else {
      _showNotificationPopover();
    }
  }

  void _showNotificationPopover() {
    _notificationOverlayEntry = OverlayEntry(
      builder: (context) {
        final topOffset = MediaQuery.of(context).padding.top + AppSpacing.headerHeight + 4;

        return Stack(
          children: [
            // Full-Screen Dismiss Gesture on Tap Outside
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideNotificationPopover,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(),
              ),
            ),

            // Anchored Popover Container directly below bell icon
            Positioned(
              right: AppSpacing.screenPadding,
              top: topOffset,
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Top Pointer Arrow Notch
                    Positioned(
                      top: -5,
                      right: 48,
                      child: Transform.rotate(
                        angle: 0.785398, // 45 degrees
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x1A1E1E2D),
                                blurRadius: 4,
                                offset: Offset(-2, -2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Popover Card
                    Container(
                      width: 320,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E1E2D).withValues(alpha: 0.18),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Popover Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(LucideIcons.bell, size: 15, color: Color(0xFF6C4CF1)),
                                  SizedBox(width: 6),
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    for (var n in _notifications) {
                                      n['isUnread'] = false;
                                    }
                                  });
                                  _hideNotificationPopover();
                                },
                                child: const Text(
                                  'Mark all read',
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(height: 1, color: Color(0xFFF0EDF8)),
                          const SizedBox(height: 6),

                          // Notification Items List
                          ..._notifications.map((notif) {
                            final String title = notif['title'];
                            final String message = notif['message'];
                            final String time = notif['time'];
                            final bool isUnread = notif['isUnread'];
                            final IconData icon = notif['icon'];
                            final Color iconColor = notif['iconColor'];
                            final String targetScreen = notif['targetScreen'];

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  notif['isUnread'] = false;
                                });
                                _hideNotificationPopover();
                                _navigateToScreen(targetScreen);
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: iconColor.withValues(alpha: 0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(icon, size: 16, color: iconColor),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  title,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                                    color: const Color(0xFF1E1E2D),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                time,
                                                style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            message,
                                            style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.3),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isUnread) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        width: 7,
                                        height: 7,
                                        margin: const EdgeInsets.only(top: 4),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFF4B4B),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_notificationOverlayEntry!);
    setState(() {
      _isNotificationPopoverOpen = true;
    });
  }

  Widget _buildSubScreenWidget(String key) {
    switch (key) {
      case 'bus':
        return DriverBusDetailsScreen(data: _transportData, onBack: popSubScreen);
      case 'attendance':
        return DriverAttendanceScreen(data: _transportData, onBack: popSubScreen);
      case 'payslips':
      case 'payslip':
        return DriverPayslipScreen(data: _transportData, onBack: popSubScreen);
      case 'leave_request':
        return DriverLeaveRequestScreen(data: _transportData, onBack: popSubScreen);
      case 'expense':
      case 'expenses':
        return DriverExpenseScreen(data: _transportData, onBack: popSubScreen);
      case 'messages':
        return TransportMessagesScreen(data: _transportData, onBack: popSubScreen);
      case 'calendar':
        return TransportCalendarScreen(data: _transportData, onBack: popSubScreen);
      case 'profile':
        return DriverProfileScreen(data: _transportData, onBack: popSubScreen);
      default:
        return DriverGpsTrackerScreen(data: _transportData, onNavigate: _navigateToScreen);
    }
  }

  List<Widget> get _screens => [
    DriverGpsTrackerScreen(data: _transportData, onNavigate: _navigateToScreen),
    DriverBusSummaryScreen(
      data: _transportData,
      onPushSubScreen: pushSubScreen,
    ),
    TransportMessagesScreen(data: _transportData, onBack: () => setState(() => _currentIndex = 0)),
    DriverMoreScreen(data: _transportData, onNavigate: _navigateToScreen),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
      );
    }

    final int unreadNotifCount = _notifications.where((n) => n['isUnread'] == true).length;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Gradient Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 140,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 0.84, 1.0],
                  colors: [
                    const Color(0xFF995EFF).withValues(alpha: 0.35),
                    const Color(0xFFCCAEFF).withValues(alpha: 0.25),
                    const Color(0xFFFFFFFF).withValues(alpha: 0.15),
                    const Color(0xFFFFFFFF).withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),

          // Main Content Area
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                SizedBox(
                  height: AppSpacing.headerHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildShieldLogo(),
                        const SizedBox(width: AppSpacing.logoTextGap),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sunrise Academy',
                                style: AppTypography.schoolName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Driver Portal',
                                style: AppTypography.portalSubtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildIconButton(
                              icon: Icons.notifications_none_rounded,
                              badgeCount: unreadNotifCount,
                              badgeColor: const Color(0xFFFF4B4B),
                              onTap: _toggleNotificationPopover,
                            ),
                            const SizedBox(width: AppSpacing.actionIconGap),
                            _buildProfileAvatar(initials: 'DP'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Dynamic Scrollable Content Area
                Expanded(
                  child: _subScreen ?? _screens[_currentIndex],
                ),
              ],
            ),
          ),

          // Floating Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  // --- Header UI Methods ---
  Widget _buildShieldLogo() {
    return Container(
      width: AppSpacing.logoSize,
      height: AppSpacing.logoSize,
      alignment: Alignment.center,
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 2,
            child: Icon(Icons.shield, color: Color(0x336C4CF1), size: 38),
          ),
          Icon(Icons.shield, color: Color(0xFF6C4CF1), size: 38),
          Icon(Icons.shield, color: Colors.white, size: 32),
          Icon(Icons.shield, color: Color(0xFFFFB300), size: 26),
          Icon(Icons.directions_bus_rounded, color: Color(0xFF6C4CF1), size: 14),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required int badgeCount,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: AppSpacing.actionContainerSize,
            height: AppSpacing.actionContainerSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppShadows.soft,
            ),
            child: Icon(icon, color: const Color(0xFF1E1E2D), size: AppSpacing.headerIconSize),
          ),
          if (badgeCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: AppSpacing.badgeSize,
                height: AppSpacing.badgeSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF7F5FF), width: 1.5),
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar({required String initials}) {
    return GestureDetector(
      onTap: () => _navigateToScreen('profile'),
      child: Container(
        width: AppSpacing.actionContainerSize,
        height: AppSpacing.actionContainerSize,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F0FF),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFECE8F8), width: 2),
        ),
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              color: Color(0xFF6C4CF1),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // --- Bottom Navigation ---
  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Container(
        height: AppSpacing.bottomNavHeight,
        margin: const EdgeInsets.only(
          left: AppSpacing.screenPadding,
          right: AppSpacing.screenPadding,
          bottom: AppSpacing.lg,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E1E2D).withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildNavItem(
              activeIcon: Icons.home_rounded,
              inactiveIcon: Icons.home_outlined,
              label: 'Home',
              isActive: _currentIndex == 0 && _subScreen == null,
              index: 0,
              size: 26.5,
            ),
            _buildNavItem(
              activeIcon: Icons.directions_bus_rounded,
              inactiveIcon: Icons.directions_bus_outlined,
              label: 'Bus',
              isActive: _currentIndex == 1 && _subScreen == null,
              index: 1,
              size: 24.0,
            ),
            _buildNavItem(
              activeIcon: Icons.chat_bubble_rounded,
              inactiveIcon: Icons.chat_bubble_outline_rounded,
              label: 'Messages',
              isActive: _currentIndex == 2 && _subScreen == null,
              index: 2,
              size: 24.0,
            ),
            _buildNavItem(
              activeIcon: Icons.grid_view_rounded,
              inactiveIcon: Icons.grid_view_outlined,
              label: 'More',
              isActive: _currentIndex == 3,
              index: 3,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    required bool isActive,
    required int index,
    double size = 24.0,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
            _subScreen = null;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 26,
                height: 26,
                child: Center(
                  child: Icon(
                    isActive ? activeIcon : inactiveIcon,
                    color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
                    size: size,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
