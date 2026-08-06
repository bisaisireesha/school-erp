import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';

import '../theme/app_theme.dart';
import 'transport_portal/transport_dashboard_screen.dart';
import 'transport_portal/transport_vehicles_screen.dart';
import 'transport_portal/transport_fees_screen.dart';
import 'transport_portal/transport_more_screen.dart';
import 'transport_portal/transport_drivers_screen.dart';
import 'transport_portal/transport_compliance_screen.dart';
import 'transport_portal/transport_route_builder_screen.dart';
import 'transport_portal/transport_student_assignments_screen.dart';
import 'transport_portal/transport_messages_screen.dart';
import 'transport_portal/transport_calendar_screen.dart';

class TransportMainLayout extends StatefulWidget {
  const TransportMainLayout({super.key});

  static void pushSubScreen(BuildContext context, Widget screen) {
    context.findAncestorStateOfType<_TransportMainLayoutState>()?.pushSubScreen(screen);
  }

  static void popSubScreen(BuildContext context) {
    context.findAncestorStateOfType<_TransportMainLayoutState>()?.popSubScreen();
  }

  @override
  State<TransportMainLayout> createState() => _TransportMainLayoutState();
}

class _TransportMainLayoutState extends State<TransportMainLayout> {
  int _currentIndex = 0;
  Widget? _subScreen;
  Map<String, dynamic> _transportData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransportData();
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
    setState(() {
      _subScreen = screen;
    });
  }

  void popSubScreen() {
    setState(() {
      _subScreen = null;
    });
  }

  void _navigateToScreen(String screenKey) {
    setState(() {
      if (screenKey == 'vehicles') {
        _currentIndex = 1;
        _subScreen = null;
      } else if (screenKey == 'fees') {
        _currentIndex = 2;
        _subScreen = null;
      } else {
        _subScreen = _buildSubScreenWidget(screenKey);
      }
    });
  }

  Widget _buildSubScreenWidget(String key) {
    switch (key) {
      case 'vehicles':
        return TransportVehiclesScreen(data: _transportData, onBack: popSubScreen);
      case 'fees':
        return TransportFeesScreen(data: _transportData, onBack: popSubScreen);
      case 'drivers':
        return TransportDriversScreen(data: _transportData, onBack: popSubScreen);
      case 'compliance':
        return TransportComplianceScreen(data: _transportData, onBack: popSubScreen);
      case 'routes':
        return TransportRouteBuilderScreen(data: _transportData, onBack: popSubScreen);
      case 'assignments':
        return TransportStudentAssignmentsScreen(data: _transportData, onBack: popSubScreen);
      case 'messages':
        return TransportMessagesScreen(data: _transportData, onBack: popSubScreen);
      case 'events':
        return TransportCalendarScreen(data: _transportData, onBack: popSubScreen);
      default:
        return TransportDashboardScreen(data: _transportData, onNavigate: _navigateToScreen);
    }
  }

  List<Widget> get _screens => [
    TransportDashboardScreen(data: _transportData, onNavigate: _navigateToScreen),
    TransportVehiclesScreen(data: _transportData, onBack: () => setState(() => _currentIndex = 0)),
    TransportFeesScreen(data: _transportData, onBack: () => setState(() => _currentIndex = 0)),
    TransportMoreScreen(data: _transportData, onNavigate: _navigateToScreen),
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
          // Main Content
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
                                'Transport Portal',
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
                              icon: Icons.chat_bubble_outline_rounded,
                              badgeCount: 2,
                              badgeColor: const Color(0xFF6C4CF1),
                              onTap: () => _navigateToScreen('messages'),
                            ),
                            const SizedBox(width: AppSpacing.actionIconGap),
                            _buildIconButton(
                              icon: Icons.notifications_none_rounded,
                              badgeCount: 2,
                              badgeColor: const Color(0xFFFF4B4B),
                              onTap: () => _navigateToScreen('compliance'),
                            ),
                            const SizedBox(width: AppSpacing.actionIconGap),
                            _buildProfileAvatar(initials: 'TP'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Dynamic Scrollable Content Area
                Expanded(
                  child: _subScreen ?? _screens[_currentIndex],
                ),
              ],
            ),
          ),
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
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          authProvider.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Signed in as', style: TextStyle(fontSize: 11, color: Color(0xFF6E6E8D))),
              Text('Transport Portal', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ],
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
              label: 'Vehicles',
              isActive: _currentIndex == 1 && _subScreen == null,
              index: 1,
              size: 24.0,
            ),
            _buildNavItem(
              activeIcon: Icons.account_balance_wallet_rounded,
              inactiveIcon: Icons.account_balance_wallet_outlined,
              label: 'Fees',
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
